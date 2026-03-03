# =============================================================================
# Docker Configuration
# =============================================================================

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Docker aliases are defined in modules/aliases.zsh

# Clean all Docker resources
clean-docker() {
    docker system prune -f
    docker volume prune -f
    echo "Docker cleaned"
}
