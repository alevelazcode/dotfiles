# Python Setup Documentation

This document explains how Python packages are installed in your dotfiles setup to handle externally managed environments.

## The Problem

Modern Python installations (especially on macOS) use "externally managed environments" which prevent global package installation to avoid conflicts with system packages.

## The Solution

We use a two-pronged approach:

1. **pipx** for Python applications (CLI tools)
2. **Virtual environments** for development packages

## pipx for Applications

[pipx](https://pypa.github.io/pipx/) installs Python applications in isolated environments, making them available globally without affecting the system Python.

### Installed Applications

- **black** - Code formatter
- **flake8** - Linter
- **mypy** - Type checker
- **pytest** - Testing framework
- **ipython** - Enhanced Python shell
- **jupyterlab** - Jupyter Lab (modern notebook interface)

### Usage

```bash
# Use installed applications directly
black myfile.py
flake8 myfile.py
mypy myfile.py
pytest
ipython
jupyter lab
```

### Managing pipx Applications

```bash
# List installed applications
pipx list

# Update all applications
pipx upgrade-all

# Uninstall an application
pipx uninstall black
```

## Virtual Environment for Development

A development virtual environment is created at `~/.venv/dev` for project-specific packages.

### Activating the Environment

```bash
# Activate the development environment
source ~/.venv/dev/bin/activate

# Your prompt will change to show (dev)
(dev) user@hostname:~$

# Install additional packages
pip install pandas numpy matplotlib

# Deactivate when done
deactivate
```

### Using the Environment

```bash
# Activate and run Python
source ~/.venv/dev/bin/activate
python my_script.py

# Or run directly
~/.venv/dev/bin/python my_script.py
```

## Project-Specific Virtual Environments

For individual projects, create separate virtual environments:

```bash
# Create a new virtual environment for a project
python3 -m venv myproject
cd myproject
source bin/activate

# Install project dependencies
pip install -r requirements.txt
```

## Best Practices

1. **Use pipx for CLI tools** that you want available globally
2. **Use virtual environments for project dependencies**
3. **Keep the dev environment for general development tools**
4. **Use requirements.txt for project-specific dependencies**

## Troubleshooting

### pipx Not Found

```bash
# Install pipx manually
pip3 install --user pipx
```

### Virtual Environment Issues

```bash
# Recreate the development environment
rm -rf ~/.venv/dev
python3 -m venv ~/.venv/dev
source ~/.venv/dev/bin/activate
pip install --upgrade pip
```

### Permission Issues

```bash
# Fix pipx permissions
pipx ensurepath
```

## Configuration

### pipx Configuration

pipx stores applications in `~/.local/bin`. The setup scripts automatically run `pipx ensurepath` to add this to your PATH.

If you need to manually configure it:

```bash
# Add to your shell profile if not already there
export PATH="$HOME/.local/bin:$PATH"

# Or use pipx to configure it automatically
pipx ensurepath
```

### Virtual Environment Configuration

The development environment is automatically created and managed by the setup scripts.
