# Greet with fortune inside cowsay
# Greet with fortune inside cowsay
if [ -x /opt/homebrew/bin/cowsay -a -x /opt/homebrew/bin/fortune ]; then
    # Get all available cow files dynamically
    cow_dir="/opt/homebrew/share/cowsay/cows"
    if [ -d "$cow_dir" ]; then
        # Get random cow from available files
        random_cow=$(find "$cow_dir" -name "*.cow" | shuf -n 1 | xargs basename -s .cow)
        fortune -s | cowsay -f "$random_cow" | lolcat -a -d 1 -s 50
    else
        # Fallback to default cow
        fortune -s | cowsay | lolcat -a -d 1 -s 50
    fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew setup for macOS
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
