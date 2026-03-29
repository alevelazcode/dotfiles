# =============================================================================
# Android Development Configuration
# =============================================================================

# Java (JDK 17 required by React Native / Expo)
if [[ "$OSTYPE" == darwin* ]]; then
    local _java_dir="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
    export ANDROID_HOME="$HOME/Library/Android/sdk"
else
    # Linux / WSL2 — check common JDK 17 paths across distros
    local _java_dir=""
    local -a _jdk_candidates=(
        /usr/lib/jvm/java-17-openjdk-amd64   # Debian/Ubuntu
        /usr/lib/jvm/java-17-openjdk          # Arch/Fedora
        /usr/lib/jvm/java-17                  # Generic
    )
    for _d in $_jdk_candidates; do
        [[ -d "$_d" ]] && { _java_dir="$_d"; break; }
    done
    export ANDROID_HOME="$HOME/Android/Sdk"
fi

if [[ -d "$_java_dir" ]]; then
    export JAVA_HOME="$_java_dir"
    path_prepend "$JAVA_HOME/bin"
fi

path_append "$ANDROID_HOME/emulator"
path_append "$ANDROID_HOME/platform-tools"
path_append "$ANDROID_HOME/cmdline-tools/latest/bin"

# -----------------------------------------------------------------------------
# WSL2: use Windows-side adb.exe so it talks to the same ADB server as the
# Windows emulator. Wrapper scripts in ~/.local/bin/ (not aliases) so
# Expo/React Native subprocesses can find them.
# -----------------------------------------------------------------------------
if [[ -f /proc/version ]] && [[ "$(</proc/version)" == *[Mm]icrosoft* ]]; then
    # Capture into non-local vars so android-emu() can read them at call time
    _android_win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
    _android_win_sdk="/mnt/c/Users/${_android_win_user}/AppData/Local/Android/Sdk"
    local _wrapper_dir="$HOME/.local/bin"

    if [[ -n "$_android_win_user" && -f "$_android_win_sdk/platform-tools/adb.exe" ]]; then
        mkdir -p "$_wrapper_dir"

        # adb wrapper — bake the resolved path into the script
        if [[ ! -f "$_wrapper_dir/adb" ]] || ! grep -q "adb.exe" "$_wrapper_dir/adb" 2>/dev/null; then
            cat > "$_wrapper_dir/adb" <<WRAP
#!/bin/sh
exec "${_android_win_sdk}/platform-tools/adb.exe" "\$@"
WRAP
            chmod +x "$_wrapper_dir/adb"
        fi

        # emulator wrapper (must run via cmd.exe for native Windows CWD)
        if [[ ! -f "$_wrapper_dir/emulator" ]] || ! grep -q "emulator.exe" "$_wrapper_dir/emulator" 2>/dev/null; then
            cat > "$_wrapper_dir/emulator" <<WRAP
#!/bin/sh
WIN_EMU=\$(wslpath -w "${_android_win_sdk}/emulator/emulator.exe" 2>/dev/null)
cmd.exe /c "cd C:\\\\ && start \\\"\\\" \\\"\\\$WIN_EMU\\\" \\\$@" 2>/dev/null
WRAP
            chmod +x "$_wrapper_dir/emulator"
        fi
    fi

    android-emu() {
        local avd="${1:-}"
        local emu_exe="$_android_win_sdk/emulator/emulator.exe"
        local win_emu
        win_emu=$(wslpath -w "$emu_exe" 2>/dev/null)

        if [[ -z "$avd" ]]; then
            avd=$("$emu_exe" -list-avds 2>/dev/null | head -1)
            [[ -z "$avd" ]] && { echo "No AVDs found. Create one in Android Studio." >&2; return 1; }
        fi

        echo "Starting emulator: $avd"

        # Clean stale locks
        rm -rf "/mnt/c/Users/${_android_win_user}/.android/avd"/*.avd/*.lock 2>/dev/null

        # Launch via cmd.exe with native Windows CWD
        cmd.exe /c "cd C:\\ && start \"\" \"$win_emu\" -avd $avd" 2>/dev/null

        echo "Waiting for device..."
        local tries=0
        while (( tries < 30 )); do
            if adb devices 2>/dev/null | grep -q "emulator\|device$"; then
                echo "Device connected!"
                adb devices -l
                return 0
            fi
            sleep 3
            (( tries++ ))
        done
        echo "Timeout: emulator started but ADB didn't detect it." >&2
        echo "Try: android-adb-restart" >&2
        return 1
    }

    # Restart ADB server (kills Windows-side server, restarts, lists devices)
    android-adb-restart() {
        echo "Restarting ADB server..."
        adb kill-server 2>/dev/null
        sleep 1
        adb start-server 2>/dev/null
        sleep 1
        adb devices -l
    }

    # Quick status: show connected devices and available AVDs
    android-status() {
        echo "=== ADB Devices ==="
        adb devices -l 2>/dev/null
        echo ""
        echo "=== Available AVDs ==="
        "$_android_win_sdk/emulator/emulator.exe" -list-avds 2>/dev/null
    }
fi
