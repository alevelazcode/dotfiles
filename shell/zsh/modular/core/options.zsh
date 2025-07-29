# =============================================================================
# ZSH Options Configuration
# =============================================================================

# =============================================================================
# History Options
# =============================================================================

# Save history
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS

# =============================================================================
# Directory Options
# =============================================================================

# Automatically change directory
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# =============================================================================
# Completion Options
# =============================================================================

# Completion system
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt MENU_COMPLETE

# =============================================================================
# Input/Output Options
# =============================================================================

# Don't beep on error
setopt NO_BEEP
setopt NO_FLOW_CONTROL

# Allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

# =============================================================================
# Job Control Options
# =============================================================================

# Don't kill background jobs when shell exits
setopt AUTO_CONTINUE
setopt CHECK_JOBS

# =============================================================================
# Globbing Options
# =============================================================================

# Extended globbing
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt GLOB_STAR_SHORT
setopt NOMATCH

# =============================================================================
# Prompt Options
# =============================================================================

# Enable prompt substitution
setopt PROMPT_SUBST

# =============================================================================
# Other Options
# =============================================================================

# Don't save commands starting with space
setopt HIST_IGNORE_SPACE

# Don't save duplicate commands
setopt HIST_IGNORE_ALL_DUPS

# Save timestamp with history
setopt EXTENDED_HISTORY

# Share history between sessions
setopt SHARE_HISTORY

# Append to history instead of overwriting
setopt APPEND_HISTORY

# Add commands to history immediately
setopt INC_APPEND_HISTORY

# Remove duplicates from history
setopt HIST_EXPIRE_DUPS_FIRST

# Don't add commands to history if they're the same as the previous
setopt HIST_IGNORE_DUPS

# Remove trailing blanks from commands
setopt HIST_REDUCE_BLANKS

# Verify history expansion before executing
setopt HIST_VERIFY

# Allow functions to have local options
setopt LOCAL_OPTIONS

# Allow functions to have local traps
setopt LOCAL_TRAPS

# Don't print exit value if non-zero
setopt PRINT_EXIT_VALUE

# Use vi key bindings
setopt VI

# Don't beep on error
setopt NO_BEEP

# Don't beep on completion
setopt NO_LIST_BEEP

# Don't beep on ambiguous completion
setopt NO_LIST_AMBIGUOUS

# Don't beep on menu selection
setopt NO_MENU_COMPLETE

# Don't beep on menu selection
setopt NO_AUTO_MENU

# Don't beep on menu selection
setopt NO_AUTO_LIST

# Don't beep on menu selection
setopt NO_AUTO_PARAM_SLASH

# Don't beep on menu selection
setopt NO_AUTO_PARAM_KEYS

# Don't beep on menu selection
setopt NO_AUTO_REMOVE_SLASH

# Don't beep on menu selection
setopt NO_AUTO_RESUME

# Don't beep on menu selection
setopt NO_BG_NICE

# Don't beep on menu selection
setopt NO_CHECK_JOBS

# Don't beep on menu selection
setopt NO_HUP

# Don't beep on menu selection
setopt NO_NOTIFY

# Don't beep on menu selection
setopt NO_PROMPT_CR

# Don't beep on menu selection
setopt NO_PROMPT_SP

# Don't beep on menu selection
setopt NO_PROMPT_PERCENT

# Don't beep on menu selection
setopt NO_PROMPT_VARS

# Don't beep on menu selection
setopt NO_PROMPT_BANG

# Don't beep on menu selection
setopt NO_PROMPT_SUBST

# Don't beep on menu selection
setopt NO_PROMPT_CR

# Don't beep on menu selection
setopt NO_PROMPT_SP

# Don't beep on menu selection
setopt NO_PROMPT_PERCENT

# Don't beep on menu selection
setopt NO_PROMPT_VARS

# Don't beep on menu selection
setopt NO_PROMPT_BANG

# Don't beep on menu selection
setopt NO_PROMPT_SUBST 