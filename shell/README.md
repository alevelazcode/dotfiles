# ZSH Modular Configuration - Cross Platform

Una configuración modular de ZSH que funciona tanto en **macOS ARM M1** como en **WSL2/Ubuntu Linux**.

## 🚀 Características

- ✅ **Configuración modular** - Fácil de mantener y personalizar
- ✅ **Multiplataforma** - Funciona en macOS y Linux/WSL2
- ✅ **Detección automática de OS** - Carga la configuración apropiada automáticamente
- ✅ **Herramientas modernas** - Integración con herramientas Rust (eza, bat, fd, etc.)
- ✅ **Desarrollo optimizado** - Configuraciones para Node.js, Python, Rust, Docker
- ✅ **Backup automático** - Respaldos de configuración existente

## 📁 Estructura del Proyecto

```
unix/
├── .zshrc                    # Archivo principal de configuración
├── install.sh                # Script de instalación automática
├── setup.sh                  # Script de configuración manual
├── .ripgreprc               # Configuración de Ripgrep
└── zsh/
    └── modular/             # Sistema modular
        ├── core/            # Configuración base
        │   ├── env.zsh      # Variables de entorno
        │   ├── path.zsh     # Gestión de PATH
        │   ├── options.zsh  # Opciones de ZSH
        │   └── keybindings.zsh # Atajos de teclado
        ├── os/              # Configuración específica por OS
        │   ├── macos.zsh    # Configuración para macOS
        │   ├── linux.zsh    # Configuración para Linux
        │   └── wsl.zsh      # Configuración para WSL2
        ├── modules/         # Módulos de funcionalidad
        │   ├── aliases.zsh  # Alias del sistema
        │   ├── functions.zsh # Funciones personalizadas
        │   ├── plugins.zsh  # Configuración de plugins
        │   ├── completion.zsh # Autocompletado
        │   └── prompt.zsh   # Configuración del prompt
        └── dev/             # Herramientas de desarrollo
            ├── node.zsh     # Configuración de Node.js
            ├── python.zsh   # Configuración de Python
            ├── rust.zsh     # Configuración de Rust
            └── docker.zsh   # Configuración de Docker
```

## 🛠️ Instalación

### Instalación Automática (Recomendada)

```bash
# Clona tu repositorio de dotfiles
git clone <tu-repositorio> ~/dotfiles

# Navega al directorio
cd ~/dotfiles/unix

# Ejecuta el script de instalación
chmod +x install.sh
./install.sh
```

**¡El script instalará automáticamente todas las herramientas recomendadas!**

### Instalación Manual

```bash
# Crea los directorios necesarios
mkdir -p ~/.config/zsh

# Copia la configuración modular
cp -r ~/dotfiles/unix/zsh/modular/* ~/.config/zsh/

# Copia el archivo principal
cp ~/dotfiles/unix/.zshrc ~/.zshrc

# Recarga la configuración
source ~/.zshrc
```

## 🔧 Configuración

### Variables de Entorno

La configuración se carga automáticamente según tu sistema operativo:

- **macOS**: Carga `os/macos.zsh`
- **Linux**: Carga `os/linux.zsh`
- **WSL2**: Carga `os/wsl.zsh`

### Personalización

Para configuraciones específicas de tu máquina, crea el archivo:

```bash
~/.config/zsh/local.zsh
```

Este archivo se cargará automáticamente y no se sobrescribirá durante las actualizaciones.

## 🎯 Herramientas Instaladas Automáticamente

El script de instalación detecta automáticamente tu sistema operativo e instala las herramientas apropiadas:

### 🦀 Herramientas Rust
- **Rust** - Lenguaje de programación
- **eza** - Mejor alternativa a `ls`
- **bat** - Mejor alternativa a `cat`
- **fd** - Mejor alternativa a `find`
- **ripgrep** - Mejor alternativa a `grep`
- **bottom** - Mejor alternativa a `htop`

### 🟢 Herramientas Node.js
- **pnpm** - Gestor de paquetes rápido

### 🐍 Herramientas Python
- **Jupyter** - Entorno de desarrollo interactivo

### 🐚 Plugins ZSH
- **zsh-autosuggestions** - Autocompletado inteligente
- **zsh-syntax-highlighting** - Resaltado de sintaxis

### 🖥️ Herramientas del Sistema
- **macOS**: Homebrew, Starship
- **Linux/WSL**: curl, git, wget, unzip, build-essential, Starship

### Instalación Manual (Si es necesario)

Si prefieres instalar las herramientas manualmente:

```bash
# Herramientas Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install eza bat fd ripgrep bottom

# Node.js y pnpm
npm install -g pnpm

# Python y Jupyter
pip install jupyter

# ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

## 🔄 Actualización

Para actualizar tu configuración:

```bash
# Actualiza tu repositorio
cd ~/dotfiles
git pull

# Reinstala la configuración (incluye nuevas herramientas)
cd unix
./install.sh
```

**Nota**: El script de actualización también verificará e instalará cualquier nueva herramienta recomendada.

## 🐛 Solución de Problemas

### Problema: Errores de keybindings

Si ves errores como `no such keymap 'menuselect'`:

```bash
# Ejecuta el script de prueba para diagnosticar
./test-config.sh

# O recarga la configuración manualmente
source ~/.zshrc
```

### Problema: "Command not found"

Si encuentras comandos no encontrados, verifica que las herramientas estén instaladas:

```bash
# Verifica qué OS está detectando
echo $OSTYPE

# Verifica las variables de entorno
env | grep PATH

# Lista las herramientas instaladas
list-plugins
```

### Problema: Plugins no funcionan

Asegúrate de que los plugins estén instalados:

```bash
# Verifica si los plugins están en el PATH
ls ~/.zsh/zsh-autosuggestions
ls ~/.zsh/zsh-syntax-highlighting

# O reinstala los plugins
./install.sh
```

### Problema: Colores no se muestran

Verifica que tu terminal soporte colores:

```bash
# Verifica el tipo de terminal
echo $TERM

# Debería mostrar algo como: xterm-256color
```

### Problema: Caracteres %{%} en el prompt

Si ves caracteres extraños como `%{%}` en el prompt:

```bash
# Solución rápida - recarga la configuración
source ~/.zshrc

# Si persiste, ejecuta el script de limpieza
./fix-prompt.sh

# O reinstala completamente
./install.sh
```

### Problema: Funciones duplicadas

Si ves errores de funciones duplicadas:

```bash
# Limpia la configuración y reinstala
rm -rf ~/.config/zsh
./install.sh
```

### Problema: FZF no funciona

Si FZF no está funcionando:

```bash
# Verifica si FZF está instalado
command -v fzf

# Si no está instalado, reinstala las herramientas
./install.sh
```

## 📝 Comandos Útiles

### macOS
- `showfiles` / `hidefiles` - Mostrar/ocultar archivos ocultos
- `cleanup` - Eliminar archivos .DS_Store
- `flushdns` - Limpiar caché DNS
- `macos-info` - Información del sistema

### Linux/WSL
- `update` - Actualizar paquetes del sistema
- `install <paquete>` - Instalar paquete
- `remove <paquete>` - Remover paquete
- `linux-info` / `wsl-info` - Información del sistema

### Generales
- `ls` / `ll` / `la` - Listar archivos (usando eza)
- `cat` - Ver archivos (usando bat)
- `find` - Buscar archivos (usando fd)
- `grep` - Buscar texto (usando ripgrep)
- `htop` - Monitor de procesos (usando bottom)

## 🤝 Contribución

Para contribuir a esta configuración:

1. Haz un fork del repositorio
2. Crea una rama para tu feature
3. Haz tus cambios
4. Prueba en ambos sistemas operativos
5. Envía un pull request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo LICENSE para más detalles.

## 🙏 Agradecimientos

- [Oh My Zsh](https://ohmyz.sh/) por la inspiración
- [Starship](https://starship.rs/) por el prompt
- La comunidad de ZSH por las mejores prácticas 