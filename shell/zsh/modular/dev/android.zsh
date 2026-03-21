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
    path=("$JAVA_HOME/bin" $path)
fi

export ANDROID_SDK_ROOT="$ANDROID_HOME"

[[ -d "$ANDROID_HOME/emulator" ]]                 && path+=("$ANDROID_HOME/emulator")
[[ -d "$ANDROID_HOME/platform-tools" ]]           && path+=("$ANDROID_HOME/platform-tools")
[[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ]]  && path+=("$ANDROID_HOME/cmdline-tools/latest/bin")
