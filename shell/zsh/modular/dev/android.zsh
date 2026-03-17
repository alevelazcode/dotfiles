# =============================================================================
# Android Development Configuration
# =============================================================================

# Java (JDK 17 required by React Native / Expo)
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
path=("$JAVA_HOME/bin" $path)

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

path+=(
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
)
