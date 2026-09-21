# Environment Variables and PATH Configuration

# Directory to store zinit plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Terminal and shell settings
export TERM="xterm-256color"
export EDITOR="zed --wait"

# Load uv, cargo and atuin environments
[ -s "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -s "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

export NVM_DIR="$HOME/.nvm"
# Load the default NVM version during startup so its global binaries are
# available without needing to run `npm` or `node` first.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
  nvm use --silent default >/dev/null 2>&1
fi

# bun
export BUN_INSTALL="$HOME/.bun"

# ruby, llvm, openjdk (homebrew)
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/opt/llvm/bin:/opt/homebrew/opt/openjdk/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include -I/opt/homebrew/opt/ruby/include"

# User tool bins: local, bun, opencode, grok, LM Studio
export PATH="$HOME/.local/bin:$BUN_INSTALL/bin:$HOME/.opencode/bin:$HOME/.grok/bin:$PATH:$HOME/.lmstudio/bin"

# Drop duplicate PATH entries
typeset -U path PATH
