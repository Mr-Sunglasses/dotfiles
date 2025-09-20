#!/bin/zsh

# Source all zsh configuration files in order
source ./require/install_brew.sh

# Install nerd fonts
source ./require/install_nerd_fonts.sh

# Install homebrew packages with Brewfile
if [ -f ./Brewfile ]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file=./Brewfile
else
    echo "No Brewfile found. Skipping package installation."
fi 

# Copy zsh configuration files to home directory
echo "Copying zsh configuration files to home directory..."
cp ./config/zshrc ~/.zshrc

# Download atuin.sh
echo "Downloading and installing Atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
echo "Atuin installation complete."

# Install rust via rustup
if ! command -v rustc >/dev/null 2>&1; then
    echo "Rust not found. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    echo "Rust installation complete."
else
    echo "Rust is already installed."
fi

# Install uv
if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "uv installation complete."
else
    echo "uv is already installed."
fi

# Install node via nvm
if [ ! -d "$HOME/.nvm" ]; then
    echo "nvm not found. Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    echo "nvm installation complete."
    echo "Installing latest Node.js via nvm..."
    
    \. "$HOME/.nvm/nvm.sh"

    # Download and install Node.js:
    nvm install 22

    # Verify the Node.js version:
    node -v # Should print "v22.19.0".

    # Verify npm version:
    npm -v # Should print "10.9.3".
    echo "Node.js installation complete."
else
    echo "nvm is already installed."
fi 

# copy all shell files in config/shell to home directory
mkdir -p ~/.config/zsh
echo "Copying shell configuration files to ~/.config/zsh/..."
for file in ./shell/*; do
    cp "$file" ~/.config/zsh/
done
echo "Shell configuration files copied."

# copy ghostty config
mkdir -p ~/.config/ghostty
echo "Copying ghostty configuration file to ~/.config/ghostty/..."
cp ./config/ghostty/* ~/.config/ghostty/
echo "Ghostty configuration file copied."

# Configure neovim
echo "Configuring Neovim..."
mkdir -p ~/.config/nvim
git clone --depth 1 https://github.com/Mr-Sunglasses/vimconfig.git ~/.config/nvim
echo "Neovim configuration complete."

echo "Installation and configuration complete. Please restart your terminal."
