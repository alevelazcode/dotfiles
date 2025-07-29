# =============================================================================
# Python Development Configuration
# =============================================================================

# =============================================================================
# Python Environment Variables
# =============================================================================

# Python configuration
export PYTHONPATH="$HOME/.local/lib/python3.*/site-packages:$PYTHONPATH"
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# pip configuration
export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_NO_CACHE_DIR=1

# =============================================================================
# Python Version Managers
# =============================================================================

# pyenv configuration
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    path_prepend "$PYENV_ROOT/bin"
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
fi

# conda configuration
if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
    eval "$($HOME/miniconda3/bin/conda 'shell.zsh' 'hook')"
fi

# =============================================================================
# Python Aliases
# =============================================================================

# Python version aliases
alias python='python3'
alias pip='pip3'
alias py='python3'

# pip aliases
alias pip-install="pip install"
alias pip-uninstall="pip uninstall"
alias pip-list="pip list"
alias pip-freeze="pip freeze"
alias pip-upgrade="pip install --upgrade"
alias pip-clean="pip cache purge"

# Virtual environment aliases
alias venv="python3 -m venv"
alias activate="source venv/bin/activate"

# Jupyter aliases
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"
alias jupyter-lab="jupyter lab --no-browser"

# =============================================================================
# Python Functions
# =============================================================================

# Function to create and activate virtual environment
create-venv() {
    local venv_name="${1:-venv}"
    
    if [[ -d "$venv_name" ]]; then
        echo "Virtual environment '$venv_name' already exists"
        return 1
    fi
    
    python3 -m venv "$venv_name"
    echo "Virtual environment '$venv_name' created"
    echo "To activate: source $venv_name/bin/activate"
}

# Function to activate virtual environment
activate-venv() {
    local venv_name="${1:-venv}"
    
    if [[ -f "$venv_name/bin/activate" ]]; then
        source "$venv_name/bin/activate"
        echo "Activated virtual environment: $venv_name"
    else
        echo "Virtual environment '$venv_name' not found"
        return 1
    fi
}

# Function to install requirements
install-requirements() {
    local requirements_file="${1:-requirements.txt}"
    
    if [[ -f "$requirements_file" ]]; then
        pip install -r "$requirements_file"
    else
        echo "Requirements file '$requirements_file' not found"
        return 1
    fi
}

# Function to create requirements file
create-requirements() {
    local requirements_file="${1:-requirements.txt}"
    
    pip freeze > "$requirements_file"
    echo "Requirements saved to '$requirements_file'"
}

# Function to clean Python cache
clean-python-cache() {
    echo "Cleaning Python cache..."
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
    find . -name "*.pyc" -delete 2>/dev/null
    find . -name "*.pyo" -delete 2>/dev/null
    echo "Python cache cleaned!"
}

# Function to run Python server
python-server() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Function to check Python environment
check-python-env() {
    echo "=== Python Environment Check ==="
    
    if command -v python3 &> /dev/null; then
        echo "✅ Python3 is installed: $(python3 --version)"
    else
        echo "❌ Python3 is not installed"
    fi
    
    if command -v pip3 &> /dev/null; then
        echo "✅ pip3 is installed: $(pip3 --version)"
    else
        echo "❌ pip3 is not installed"
    fi
    
    if command -v pyenv &> /dev/null; then
        echo "✅ pyenv is installed"
    else
        echo "ℹ️  pyenv is not installed"
    fi
    
    if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
        echo "✅ conda is installed"
    else
        echo "ℹ️  conda is not installed"
    fi
    
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "✅ Virtual environment active: $VIRTUAL_ENV"
    else
        echo "ℹ️  No virtual environment active"
    fi
} 