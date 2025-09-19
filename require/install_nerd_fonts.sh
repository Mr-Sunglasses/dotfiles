#!/bin/zsh

# Install FiraCode Nerd Font using Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Please install Homebrew first."
  exit 1
fi

# Tap the Homebrew fonts cask if not already tapped
if ! brew tap | grep -q "homebrew/cask-fonts"; then
  echo "Tapping homebrew/cask-fonts..."
  brew tap homebrew/cask-fonts
fi

# Install FiraCode Nerd Font
brew install --cask font-firacode-nerd-font

echo "FiraCode Nerd Font installation complete."
