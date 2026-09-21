#!/bin/zsh

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
	echo "Homebrew not found. Installing..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Homebrew installation complete."
else
	echo "Homebrew is already installed."
fi

# Put brew on PATH for the rest of the install (fresh installs aren't on PATH yet)
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi
