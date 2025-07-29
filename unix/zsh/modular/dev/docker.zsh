# =============================================================================
# Docker Development Configuration
# =============================================================================

# =============================================================================
# Docker Environment Variables
# =============================================================================

# Docker configuration
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# =============================================================================
# Docker Aliases
# =============================================================================

# Docker basic aliases
alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dstop="docker stop"
alias dstart="docker start"
alias dlogs="docker logs"
alias dexec="docker exec -it"

# Docker Compose aliases
alias dc="docker compose"
alias dcd="docker compose down"
alias dcdv="docker compose down -v"
alias dcr="docker compose restart"
alias dcu="docker compose up -d"
alias dcb="docker compose build"
alias dcl="docker compose logs"
alias dce="docker compose exec"

# Docker system aliases
alias dsys="docker system"
alias dsys-prune="docker system prune"
alias dsys-df="docker system df"
alias dvol="docker volume"
alias dnet="docker network"

# =============================================================================
# Docker Functions
# =============================================================================

# Function to clean Docker system
clean-docker() {
    echo "Cleaning Docker system..."
    docker system prune -f
    docker volume prune -f
    docker network prune -f
    echo "Docker system cleaned!"
}

# Function to remove all stopped containers
remove-stopped-containers() {
    echo "Removing stopped containers..."
    docker container prune -f
    echo "Stopped containers removed!"
}

# Function to remove all unused images
remove-unused-images() {
    echo "Removing unused images..."
    docker image prune -a -f
    echo "Unused images removed!"
}

# Function to remove all unused volumes
remove-unused-volumes() {
    echo "Removing unused volumes..."
    docker volume prune -f
    echo "Unused volumes removed!"
}

# Function to show Docker disk usage
docker-disk-usage() {
    echo "=== Docker Disk Usage ==="
    docker system df
}

# Function to run interactive shell in container
docker-shell() {
    local container="$1"
    local shell="${2:-/bin/bash}"
    
    if [[ -z "$container" ]]; then
        echo "Usage: docker-shell <container> [shell]"
        return 1
    fi
    
    docker exec -it "$container" "$shell"
}

# Function to copy files from/to container
docker-cp() {
    local source="$1"
    local destination="$2"
    
    if [[ -z "$source" || -z "$destination" ]]; then
        echo "Usage: docker-cp <source> <destination>"
        echo "Examples:"
        echo "  docker-cp container:/path/to/file ./local/path"
        echo "  docker-cp ./local/file container:/path/to/destination"
        return 1
    fi
    
    docker cp "$source" "$destination"
}

# Function to build and run Docker image
docker-build-run() {
    local image_name="$1"
    local container_name="$2"
    
    if [[ -z "$image_name" ]]; then
        echo "Usage: docker-build-run <image_name> [container_name]"
        return 1
    fi
    
    if [[ -z "$container_name" ]]; then
        container_name="$image_name"
    fi
    
    echo "Building image: $image_name"
    docker build -t "$image_name" .
    
    echo "Running container: $container_name"
    docker run -d --name "$container_name" "$image_name"
}

# Function to show container logs with follow
docker-logs-follow() {
    local container="$1"
    
    if [[ -z "$container" ]]; then
        echo "Usage: docker-logs-follow <container>"
        return 1
    fi
    
    docker logs -f "$container"
}

# Function to restart Docker service
restart-docker() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        osascript -e 'quit app "Docker"'
        open -a Docker
        echo "Docker restarted on macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo systemctl restart docker
        echo "Docker service restarted on Linux"
    else
        echo "Unsupported operating system for Docker restart"
        return 1
    fi
}

# Function to check Docker environment
check-docker-env() {
    echo "=== Docker Environment Check ==="
    
    if command -v docker &> /dev/null; then
        echo "✅ Docker is installed: $(docker --version)"
    else
        echo "❌ Docker is not installed"
    fi
    
    if command -v docker-compose &> /dev/null; then
        echo "✅ Docker Compose is installed: $(docker-compose --version)"
    else
        echo "ℹ️  Docker Compose is not installed"
    fi
    
    if docker info &> /dev/null; then
        echo "✅ Docker daemon is running"
    else
        echo "❌ Docker daemon is not running"
    fi
    
    if [[ -f "docker-compose.yml" || -f "compose.yml" ]]; then
        echo "✅ Docker Compose file found"
    else
        echo "ℹ️  No Docker Compose file found"
    fi
} 