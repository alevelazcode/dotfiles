# =============================================================================
# Rust Development Configuration
# =============================================================================

export CARGO_HOME="$HOME/.cargo"
# Note: $CARGO_HOME/bin is added early in core/path.zsh (needed before prompt)

# Cargo aliases
alias cgb="cargo build"
alias cgr="cargo run"
alias cgt="cargo test"
alias cgc="cargo check"
alias cgf="cargo fmt"
