# Greet with fortune inside cowsay
if [ -x /opt/homebrew/bin/cowsay -a -x /opt/homebrew/bin/fortune ]; then
    # Get all available cow files dynamically
    cow_dir="/opt/homebrew/share/cowsay/cows"
    if [ -d "$cow_dir" ]; then
        # Get random cow from available files
        random_cow=$(find "$cow_dir" -name "*.cow" | shuf -n 1 | xargs basename -s .cow)
        fortune -s | cowsay -f "$random_cow" | lolcat
    else
        # Fallback to default cow
        fortune -s | cowsay | lolcat
    fi
fi

# Homebrew setup for macOS

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
