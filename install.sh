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
