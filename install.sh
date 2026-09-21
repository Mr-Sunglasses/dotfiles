#!/bin/zsh
#
# Set up a new Mac with these dotfiles.
#
#   ./install.sh                 install everything (tools + configs)
#   ./install.sh --configs-only  only copy config files (no installs)
#
# Existing files that would be overwritten are backed up to
# ~/.dotfiles-backup/<timestamp>/ first.

DOTFILES="${0:A:h}"
cd "$DOTFILES" || exit 1

CONFIGS_ONLY=false
[[ "$1" == "--configs-only" ]] && CONFIGS_ONLY=true

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
FAILED=()

# Copy a file or directory from the repo to $HOME, backing up whatever was there.
# usage: install_config <repo path> <destination>
install_config() {
    local src="$DOTFILES/$1" dest="$2"
    if [ ! -e "$src" ]; then
        echo "  ! missing in repo: $1"
        FAILED+=("$1")
        return
    fi
    if [ -e "$dest" ] && ! diff -rq "$src" "$dest" >/dev/null 2>&1; then
        mkdir -p "$BACKUP_DIR/$(dirname "${dest#$HOME/}")"
        cp -R "$dest" "$BACKUP_DIR/${dest#$HOME/}"
    fi
    mkdir -p "$(dirname "$dest")"
    if [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -R "$src/." "$dest/"
    else
        cp "$src" "$dest"
    fi
    echo "  ✓ $dest"
}

install_tools() {
    # Homebrew, then everything in the Brewfile
    source ./require/install_brew.sh

    echo "Installing packages from Brewfile..."
    brew bundle --file=./Brewfile || FAILED+=("brew bundle (re-run: brew bundle --file=$DOTFILES/Brewfile)")

    # Apps installed from their own sites on the current machine, not tracked by `brew bundle dump`
    local -A apps=(kitty kitty zed Zed karabiner-elements Karabiner-Elements raycast Raycast)
    for cask app in ${(kv)apps}; do
        if [ -d "/Applications/$app.app" ]; then
            echo "$app is already installed."
        else
            brew install --cask "$cask" || FAILED+=("cask $cask")
        fi
    done

    source ./require/install_nerd_fonts.sh || FAILED+=("nerd fonts")

    # The installers below would edit ~/.zshrc / ~/.bashrc; tell them not to,
    # since our configs already load them.

    if ! command -v atuin >/dev/null 2>&1 && [ ! -x "$HOME/.atuin/bin/atuin" ]; then
        echo "Installing Atuin..."
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh || FAILED+=("atuin")
    else
        echo "Atuin is already installed."
    fi

    if ! command -v rustup >/dev/null 2>&1 && [ ! -x "$HOME/.cargo/bin/rustup" ]; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path || FAILED+=("rust")
    else
        echo "Rust is already installed."
    fi

    if ! command -v uv >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/uv" ]; then
        echo "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh || FAILED+=("uv")
    else
        echo "uv is already installed."
    fi

    if [ ! -d "$HOME/.nvm" ]; then
        echo "Installing nvm and Node.js 22..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash || FAILED+=("nvm")
        export NVM_DIR="$HOME/.nvm"
        if [ -s "$NVM_DIR/nvm.sh" ]; then
            \. "$NVM_DIR/nvm.sh"
            nvm install 22 && nvm alias default 22 || FAILED+=("node 22")
        fi
    else
        echo "nvm is already installed."
    fi

    # Neovim config lives in its own repo
    if [ -d "$HOME/.config/nvim/.git" ]; then
        echo "Updating Neovim config..."
        git -C "$HOME/.config/nvim" pull --ff-only || FAILED+=("nvim config pull")
    else
        [ -e "$HOME/.config/nvim" ] && mkdir -p "$BACKUP_DIR/.config" && mv "$HOME/.config/nvim" "$BACKUP_DIR/.config/nvim"
        echo "Cloning Neovim config..."
        git clone https://github.com/Mr-Sunglasses/vimconfig.git "$HOME/.config/nvim" || FAILED+=("nvim config clone")
    fi
}

install_configs() {
    echo "Copying config files..."

    mkdir -p ~/.gnupg && chmod 700 ~/.gnupg

    local repo_path home_path
    while read -r repo_path home_path; do
        install_config "${repo_path%/}" "${${home_path/#\~/$HOME}%/}"
    done < <(grep -vE '^\s*(#|$)' manifest.txt)

    # SSH: only seed a config if there isn't one; never overwrite host entries
    if [ ! -e ~/.ssh/config ]; then
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        install_config config/ssh_config ~/.ssh/config
    fi
}

$CONFIGS_ONLY || install_tools
install_configs   # last, so no installer can overwrite our configs

# Pick up the new gpg-agent.conf (pinentry-mac)
command -v gpgconf >/dev/null 2>&1 && gpgconf --kill gpg-agent

echo
[ -d "$BACKUP_DIR" ] && echo "Previous versions of overwritten files: $BACKUP_DIR"
if (( ${#FAILED} )); then
    echo "Finished with problems in:"
    printf '  - %s\n' "${FAILED[@]}"
else
    echo "Installation and configuration complete."
fi
cat <<'EOF'

Manual steps left:
  - Import your GPG signing key:   gpg --import private-key.asc
  - Log in to GitHub CLI:          gh auth login
  - Copy or create SSH keys in ~/.ssh
  - Atuin history sync:            atuin login
  - Raycast: Settings → Advanced → Import (see README)
  - Grant Karabiner-Elements its permissions in System Settings → Privacy & Security
Then restart your terminal.
EOF
