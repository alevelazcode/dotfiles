if grep -qi Microsoft /proc/version; then
  export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
  export ADB_SERVER_SOCKET="tcp:$WSL_HOST:5037"
else
  # Config to pure Linux distribution running in a partition or virtual machine
  # (You can add your Linux-specific configuration here)
fi

# Environment variables for Java and Android SDK
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export ANDROID_HOME="$HOME/Android"
export ANDROID_SDK_ROOT="$HOME/Android"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
