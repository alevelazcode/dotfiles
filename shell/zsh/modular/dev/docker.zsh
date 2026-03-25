# =============================================================================
# Docker Configuration
# =============================================================================

clean-docker() {
    docker system prune -f
    docker volume prune -f
    echo "Docker cleaned"
}
