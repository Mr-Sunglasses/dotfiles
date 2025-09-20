# Environment Variables and PATH Configuration

# Path configurations
export PATH="$PATH:/Users/kanishkpachauri/.local/bin"

# Terminal and shell settings
export TERM="xterm-256color"

. "$HOME/.local/bin/env"

# Load cargo environment
. "$HOME/.cargo/env"

# Load atuin environment
. "$HOME/.atuin/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

