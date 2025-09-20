# Aliases Configuration

# System
alias os-release="sw_vers"
alias c="clear"

# Editor
alias vim="nvim"

# Python
alias py="python3"
alias ipy="ipython3"

# Git
alias g="git"
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

# Blog sync
# alias syncblog='rsync -av --delete "/Users/kanishkpachauri/kanishkvault/blog/" "/Users/kanishkpachauri/Documents/kanishkblog/content/posts/"'
# alias syncimage="python3 /Users/kanishkpachauri/Documents/kanishkblog/scripts/images.py"

# File operations
alias ls='gls --color -h --group-directories-first -F'
alias cat='bat --paging never --decorations never --plain'

# Utilities
alias afk='pmset displaysleepnow'
alias pubkey="cat ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy | echo '=> Copied to pasteboard.'"
alias crontabguru="open -a 'Google Chrome' 'https://crontab.guru/'"
alias upgbrew="brew update && brew upgrade"
