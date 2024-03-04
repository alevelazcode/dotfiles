
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case $ID in
        debian|ubuntu|*mint*)
            echo "Estás en una distro basada en Debian/Ubuntu que utiliza apt."
            ;;
        arch|manjaro|*arch*)
            echo "Estás en una distro basada en Arch que utiliza pacman."
            ;;
        fedora|centos|rhel)
            if command -v dnf &> /dev/null; then
                echo "Estás en una distro basada en Red Hat que utiliza dnf."
            elif command -v yum &> /dev/null; then
                echo "Estás en una distro basada en Red Hat que utiliza yum."
            else
                echo "Estás en una distro basada en Red Hat, pero no se pudo determinar el sistema de gestión de paquetes."
            fi
            ;;
        *)
            echo "No se pudo determinar la distro o el sistema de gestión de paquetes basándose en el archivo /etc/os-release."
            ;;
    esac
else
    echo "El archivo /etc/os-release no existe en este sistema. No se pudo determinar la distro."
fi

# Check if Mac OS is running
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Are you running Mac OS"
    chmod +x ./macos/install.sh
fi

# Run VSCode installation

chmod +x ./vscode/install.sh
./vscode/install.sh
