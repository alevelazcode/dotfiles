# =============================================================================
# Android Development Configuration
# =============================================================================

# Java (JDK 17 required by React Native / Expo)
if [[ "$OSTYPE" == darwin* ]]; then
    local _java_dir="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
    export ANDROID_HOME="$HOME/Library/Android/sdk"
else
    # Linux / WSL2
    local _java_dir="/usr/lib/jvm/java-17-openjdk-amd64"
    export ANDROID_HOME="$HOME/Android/Sdk"
fi

# Only set JAVA_HOME if the JDK is actually installed
if [[ -d "$_java_dir" ]]; then
    export JAVA_HOME="$_java_dir"
    path_prepend "$JAVA_HOME/bin"
fi

path_append "$ANDROID_HOME/emulator"
path_append "$ANDROID_HOME/platform-tools"
path_append "$ANDROID_HOME/cmdline-tools/latest/bin"

# -----------------------------------------------------------------------------
# WSL2: use Windows-side adb.exe so it talks to the same ADB server as the
# Windows emulator. A Linux-native adb would start its own server and never
# see devices running on the host.
#
# We create wrapper SCRIPTS in ~/.local/bin/ instead of shell aliases because
# Expo/React Native spawn adb as a subprocess — aliases are invisible there.
# -----------------------------------------------------------------------------
if [[ -f /proc/version ]] && [[ "$(</proc/version)" == *[Mm]icrosoft* ]]; then
    local _win_user
    _win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
    local _win_sdk="/mnt/c/Users/${_win_user}/AppData/Local/Android/Sdk"
    local _wrapper_dir="$HOME/.local/bin"

    if [[ -n "$_win_user" && -f "$_win_sdk/platform-tools/adb.exe" ]]; then
        mkdir -p "$_wrapper_dir"

        # adb wrapper — delegates to Windows adb.exe
        if [[ ! -f "$_wrapper_dir/adb" ]] || ! grep -q "adb.exe" "$_wrapper_dir/adb" 2>/dev/null; then
            cat > "$_wrapper_dir/adb" <<WRAP
#!/bin/sh
exec "$_win_sdk/platform-tools/adb.exe" "\$@"
WRAP
            chmod +x "$_wrapper_dir/adb"
        fi

        # emulator wrapper — launches emulator on Windows side properly.
        # Must use cmd.exe /c start to ensure the emulator runs in a native
        # Windows context (not inheriting WSL's UNC cwd which breaks it).
        if [[ ! -f "$_wrapper_dir/emulator" ]] || ! grep -q "emulator.exe" "$_wrapper_dir/emulator" 2>/dev/null; then
            cat > "$_wrapper_dir/emulator" <<WRAP
#!/bin/sh
# Run emulator.exe via cmd.exe so it gets a native Windows CWD and
# environment — launching directly from WSL causes ADB port binding issues.
WIN_EMU=\$(wslpath -w "$_win_sdk/emulator/emulator.exe" 2>/dev/null)
cmd.exe /c "cd C:\\ && start \"\" \"\$WIN_EMU\" \$@" 2>/dev/null
WRAP
            chmod +x "$_wrapper_dir/emulator"
        fi
    fi

    # -------------------------------------------------------------------------
    # android-emu: start the Windows emulator + wait for ADB to see it.
    # Usage: android-emu [avd-name]   (defaults to first available AVD)
    # -------------------------------------------------------------------------
    android-emu() {
        local avd="${1:-}"
        local emu_exe="$_win_sdk/emulator/emulator.exe"
        local win_emu
        win_emu=$(wslpath -w "$emu_exe" 2>/dev/null)

        if [[ -z "$avd" ]]; then
            avd=$("$emu_exe" -list-avds 2>/dev/null | head -1)
            [[ -z "$avd" ]] && { echo "No AVDs found. Create one in Android Studio." >&2; return 1; }
        fi

        echo "Starting emulator: $avd"

        # Clean stale locks
        local avd_dir="/mnt/c/Users/${_win_user}/.android/avd"
        rm -rf "$avd_dir"/*.avd/*.lock 2>/dev/null

        # Launch via cmd.exe with native Windows CWD
        cmd.exe /c "cd C:\\ && start \"\" \"$win_emu\" -avd $avd" 2>/dev/null

        # Wait for ADB to detect the device
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
        echo "Try: adb kill-server && adb start-server && adb devices" >&2
        return 1
    }
fi
