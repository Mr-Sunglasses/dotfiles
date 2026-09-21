#!/bin/zsh
#
# Fix ownership and permissions of ~/.ssh after copying it from another Mac.
# ssh refuses to use private keys that other users can read.
#
#   ./require/fix_ssh_permissions.sh

SSH_DIR="$HOME/.ssh"
[ -d "$SSH_DIR" ] || { echo "No $SSH_DIR to fix."; return 0 2>/dev/null || exit 0 }

# Files copied via AirDrop / downloads belong to you but may carry the quarantine flag
chown -R "$(id -un):staff" "$SSH_DIR"
xattr -dr com.apple.quarantine "$SSH_DIR" 2>/dev/null

# Directories (~/.ssh itself and subfolders like pems/): owner only
find "$SSH_DIR" -type d -exec chmod 700 {} +

# Everything else defaults to owner-only read/write...
find "$SSH_DIR" -type f -exec chmod 600 {} +

# ...except files that are meant to be public
find "$SSH_DIR" -type f \( -name '*.pub' -o -name 'known_hosts*' \) -exec chmod 644 {} +

echo "Fixed permissions in $SSH_DIR:"
ls -la "$SSH_DIR"

# Load private keys into the agent and store their passphrases in the macOS keychain
for key in "$SSH_DIR"/*(N.); do
    head -1 "$key" 2>/dev/null | grep -q 'PRIVATE KEY' && ssh-add --apple-use-keychain "$key"
done
