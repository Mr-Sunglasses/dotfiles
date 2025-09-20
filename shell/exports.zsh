# Environment Variables and PATH Configuration

# Oh My Zsh configuration
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"

# Path configurations
#export PATH="$PATH:/Users/kanishkpachauri/Library/Python/3.9/bin"
export PATH="$PATH:/Users/kanishkpachauri/.local/bin"
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
# export PATH=/Users/kanishkpachauri/.opencode/bin:$PATH

# Terminal and shell settings
export GPG_TTY=$(tty)
export TERM="xterm-256color"

. "$HOME/.local/bin/env"

# Load cargo environment
. "$HOME/.cargo/env"

# Load atuin environment
. "$HOME/.atuin/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

