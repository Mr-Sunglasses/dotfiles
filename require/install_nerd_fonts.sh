#!/bin/zsh

# Install FiraCode Nerd Font (font casks live in homebrew/cask now, no tap needed)
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Skipping nerd font installation."
  return 1 2>/dev/null || exit 1
fi

if brew list --cask font-fira-code-nerd-font >/dev/null 2>&1 || ls ~/Library/Fonts/FiraCodeNerdFont* >/dev/null 2>&1; then
  echo "FiraCode Nerd Font is already installed."
else
  brew install --cask font-fira-code-nerd-font
  echo "FiraCode Nerd Font installation complete."
fi
