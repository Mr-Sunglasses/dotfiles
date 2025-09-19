#!/bin/zsh

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
	echo "Homebrew not found. Installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Homebrew installation complete."
else
	echo "Homebrew is already installed."
fi
