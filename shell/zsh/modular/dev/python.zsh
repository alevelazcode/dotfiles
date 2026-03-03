# =============================================================================
# Python Development Configuration
# =============================================================================

export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export PIP_DISABLE_PIP_VERSION_CHECK=1

# pyenv - Add shims to PATH directly (NO eval, NO rehash = instant)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/shims" ]] && path_prepend "$PYENV_ROOT/shims"
[[ -d "$PYENV_ROOT/bin" ]] && path_prepend "$PYENV_ROOT/bin"

# Aliases
alias python='python3'
alias pip='pip3'
alias py='python3'
alias venv="python3 -m venv"
alias activate="source venv/bin/activate"

# Functions
create-venv() {
    local name="${1:-venv}"
    [[ -d "$name" ]] && { echo "venv '$name' already exists"; return 1; }
    python3 -m venv "$name" && echo "Created venv '$name'. Activate: source $name/bin/activate"
}

clean-python-cache() {
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
    find . -name "*.pyc" -delete 2>/dev/null
    echo "Python cache cleaned"
} 
