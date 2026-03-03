# =============================================================================
# Rust Development Configuration
# =============================================================================

export CARGO_HOME="$HOME/.cargo"
[[ -d "$CARGO_HOME/bin" ]] && path_append "$CARGO_HOME/bin"

# Cargo aliases
alias cgb="cargo build"
alias cgr="cargo run"
alias cgt="cargo test"
alias cgc="cargo check"
alias cgf="cargo fmt"
