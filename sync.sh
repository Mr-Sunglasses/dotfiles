#!/bin/zsh
#
# Sync the dotfiles on this Mac into the repo and push them upstream.
#
#   ./sync.sh              copy configs + Brewfile into the repo, review, commit, push
#   ./sync.sh --dry-run    show what would change, then put the repo back as it was
#   ./sync.sh -y           don't ask before committing and pushing
#   ./sync.sh -m "msg"     use a custom commit message
#
# Which files are synced is defined in ./manifest.txt (shared with install.sh).

DOTFILES="${0:A:h}"
cd "$DOTFILES" || exit 1

DRY_RUN=false
ASSUME_YES=false
MESSAGE=""
while (( $# )); do
    case "$1" in
        -n|--dry-run) DRY_RUN=true ;;
        -y|--yes)     ASSUME_YES=true ;;
        -m)           MESSAGE="$2"; shift ;;
        -h|--help)    sed -n '3,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)            echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

bold() { print -P "%B$1%b" }
red()  { print -P "%F{red}$1%f" }

# Only files this script writes may have uncommitted changes, so nothing
# unrelated gets swept into the sync commit.
if [[ -n "$(git status --porcelain)" ]]; then
    red "The repo has uncommitted changes. Commit or stash them first:"
    git status --short
    exit 1
fi

if ! $DRY_RUN; then
    bold "Pulling latest from upstream..."
    git pull --rebase --quiet || { red "git pull failed, fix that first."; exit 1 }
fi

[ -f manifest.txt ] || { red "manifest.txt not found in $DOTFILES"; exit 1 }

bold "Copying configs from this Mac..."
missing=()
while read -r repo_path home_path; do
    home_path="${home_path/#\~/$HOME}"
    if [ ! -e "$home_path" ]; then
        missing+=("$home_path")
        continue
    fi
    mkdir -p "$(dirname "${repo_path%/}")"
    if [[ "$repo_path" == */ ]]; then
        # Directories are mirrored, so deleted files are deleted in the repo too
        rsync -a --delete --exclude '.DS_Store' --exclude '*.bak' --exclude '*.backup*' \
            "$home_path" "$repo_path"
    else
        cp "$home_path" "$repo_path"
    fi
done < <(grep -vE '^\s*(#|$)' manifest.txt)

# App settings that aren't plain files
source ./require/tinycast.sh && tinycast_export "$DOTFILES"

(( ${#missing} )) && { echo "Not found on this Mac (skipped):"; printf '  %s\n' "${missing[@]}" }

if command -v brew >/dev/null 2>&1; then
    bold "Updating Brewfile..."
    brew bundle dump --force --file=Brewfile 2>/dev/null
fi

git add -A

if git diff --cached --quiet; then
    bold "Everything is already in sync. ✨"
    exit 0
fi

bold "Changes:"
git diff --cached --stat

# Brewfile package changes, in a readable form
brew_changes=$(git diff --cached -U0 Brewfile | grep -E '^[+-](brew|cask|tap|mas|vscode|uv|cargo|go|npm) ' | sed -E 's/^([+-])([a-z]+) "([^"]+)".*/\1 \2 \3/')
[[ -n "$brew_changes" ]] && { bold "Brewfile:"; echo "$brew_changes" }

# Look for secrets in the lines being added, before anything goes to a public repo
bold "Checking for secrets..."
secret_pattern='(api[_-]?key|secret|token|passw(or)?d|bearer)["'"'"']?\s*[:=]\s*["'"'"']?[A-Za-z0-9_\-\/+=]{16,}|gh[pousr]_[A-Za-z0-9]{30,}|sk-[A-Za-z0-9_\-]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[abpr]-[A-Za-z0-9-]{10,}'
secrets=$(git diff --cached -U0 | grep -E '^\+[^+]' | grep -iE "$secret_pattern")
if command -v gitleaks >/dev/null 2>&1 && ! gitleaks git --staged --no-banner --redact >/dev/null 2>&1; then
    secrets+=$'\n(gitleaks also flagged something: run `gitleaks git --staged` to see it)'
fi
if [[ -n "$secrets" ]]; then
    red "Possible secrets in the changes, NOT committing:"
    echo "$secrets" | cut -c1-160
    git reset --quiet
    git checkout --quiet -- .
    git clean -fdq -- config shell
    echo "Repo restored. Remove the secret from the file on your Mac (or from the manifest) and re-run."
    exit 1
fi
echo "None found."

# Hardcoded home paths break on another machine
hardcoded=$(git diff --cached -U0 -- . ':!Brewfile' | grep -E '^\+[^+]' | grep -E "$HOME|/Users/$USER" | grep -vE '^\+\s*#')
if [[ -n "$hardcoded" ]]; then
    red "Warning: hardcoded home paths (use \$HOME instead):"
    echo "$hardcoded" | cut -c1-160
fi

if $DRY_RUN; then
    git reset --quiet
    git checkout --quiet -- .
    git clean -fdq -- config shell
    bold "Dry run: repo restored, nothing committed."
    exit 0
fi

if ! $ASSUME_YES; then
    echo
    read -r "reply?Commit and push these changes? [y/N/d(iff)] "
    if [[ "$reply" == [dD]* ]]; then
        git diff --cached
        read -r "reply?Commit and push these changes? [y/N] "
    fi
    if [[ "$reply" != [yY]* ]]; then
        git reset --quiet
        echo "Not committed. The copied changes are left in the repo for you to review."
        exit 0
    fi
fi

if [[ -z "$MESSAGE" ]]; then
    changed=$(git diff --cached --name-only | sed -E 's#^(config|shell)/##; s#/.*##; s#^zshrc$#zsh#' | sort -u | tr '\n' ' ')
    MESSAGE="chore: sync ${changed% }"
fi

git commit --quiet -m "$MESSAGE" && git push --quiet && bold "Synced and pushed: $(git log -1 --format='%h %s')"
