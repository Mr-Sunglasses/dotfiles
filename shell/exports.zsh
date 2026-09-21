# Environment Variables and PATH Configuration

# Directory to store zinit plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

export PATH="$PATH:/Users/kanishkpachauri/.local/bin"

# Terminal and shell settings
export TERM="xterm-256color"

. "$HOME/.local/bin/env"

# Load cargo environment
. "$HOME/.cargo/env"

# Load atuin environment
. "$HOME/.atuin/bin/env"

export NVM_DIR="$HOME/.nvm"
# Load the default NVM version during startup so its global binaries are
# available without needing to run `npm` or `node` first.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
  nvm use --silent default >/dev/null 2>&1
fi


# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# llvm
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# compiler flags for ruby
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# opencode
export EDITOR="zed --wait"
