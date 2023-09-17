
if grep -qi Microsoft /proc/version
    set -x WSL_HOST (tail -1 /etc/resolv.conf | cut -d' ' -f2)
    set -x ADB_SERVER_SOCKET tcp:$WSL_HOST:5037
else
    # Config to pure linux distrution running in a partition or virtual machine
end


set --export JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64


set --export ANDROID_HOME $HOME/Android
set --export ANDROID_SDK_ROOT $HOME/Android
