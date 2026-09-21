# dotfiles
My happiness lies here 😀

# Steps to install dotfiles
- Clone the repo: `git clone https://github.com/Mr-Sunglasses/dotfiles.git`
- Run the install script: `cd dotfiles && ./install.sh`
- Restart your terminal or source your shell configuration file: `source ~/.zshrc`
- Enjoy your customized environment!

`./install.sh` installs Homebrew and everything in the `Brewfile`, the toolchains (Rust, uv, nvm + Node 22, Atuin),
the Neovim config, and then copies every config in this repo into place. Any file it would overwrite is backed up to
`~/.dotfiles-backup/<timestamp>/`. It is safe to re-run.

Use `./install.sh --configs-only` to only copy the config files.

# Syncing this Mac back to the repo
Run `dotsync` (or `./sync.sh`) whenever you've changed a config or installed something with Homebrew. It:

1. pulls the latest from GitHub
2. copies every file listed in `manifest.txt` from this Mac into the repo, and regenerates the `Brewfile`
3. shows what changed, including added/removed Homebrew packages
4. refuses to commit if the changes contain something that looks like a secret (API keys, tokens, private keys),
   and warns about hardcoded `/Users/...` paths
5. asks before committing and pushing (`d` shows the full diff)

Options: `--dry-run` to only preview, `-y` to skip the question, `-m "message"` for a custom commit message.

To track a new file, add a line to `manifest.txt` (`<repo path> <path on this Mac>`, trailing `/` for a directory).
`install.sh` reads the same list, so it will install it on the next Mac too.

# Things the script can't do
- **GPG signing key**: `gpg --export-secret-keys --armor <key id> > key.asc` on the old Mac, `gpg --import key.asc` on the new one.
- **SSH keys / hosts**: copy `~/.ssh` over manually (host entries are kept out of this public repo), then fix its permissions (see below).
- **GitHub CLI**: `gh auth login`
- **Atuin history**: `atuin login`
- **Karabiner-Elements**: grant its permissions in System Settings → Privacy & Security.
- **Tinycast snippets**: see below.

# Moving ~/.ssh to a new Mac
ssh refuses to use private keys that other users can read, and copying files (AirDrop, USB, zip) often
changes their permissions. After copying:

1. Copy the folder from the old Mac, e.g. zip `~/.ssh`, AirDrop it, and unzip it to `~/.ssh` on the new Mac.
2. Fix the permissions:
   ```sh
   ./require/fix_ssh_permissions.sh
   ```
   or by hand:
   ```sh
   chown -R "$(id -un):staff" ~/.ssh                          # you own everything
   xattr -dr com.apple.quarantine ~/.ssh                        # drop the AirDrop/download quarantine flag
   find ~/.ssh -type d -exec chmod 700 {} +                     # folders: only you
   find ~/.ssh -type f -exec chmod 600 {} +                     # keys, config, pems: only you
   find ~/.ssh -type f \( -name '*.pub' -o -name 'known_hosts*' \) -exec chmod 644 {} +   # public files
   ```
3. Add your key to the agent and save its passphrase in the keychain:
   ```sh
   ssh-add --apple-use-keychain ~/.ssh/id_rsa
   ```
4. Test it: `ssh -T git@github.com` should greet you by username.

| Path | Permission |
| --- | --- |
| `~/.ssh` and subfolders | `700` (`drwx------`) |
| private keys (`id_rsa`, `*.pem`), `config`, `authorized_keys` | `600` (`-rw-------`) |
| public keys (`*.pub`), `known_hosts` | `644` (`-rw-r--r--`) |

`install.sh` runs the fix automatically if `~/.ssh` already exists.

# Tinycast
Tinycast's settings (hotkeys, app bindings, toggles) live in macOS preferences and its quicklinks in a SQLite
database, so `sync.sh` exports them to text files in `config/tinycast/` and `install.sh` imports them back
(see `require/tinycast.sh`). Tinycast is quit during the import and reopened afterwards.

Snippets are **not** synced because they contain personal data and this repo is public. Copy
`~/Library/Application Support/com.tinycast.app/Snippets` to the new Mac manually.

# Note
Feel free to modify the configurations as per your requirements. If you encounter any issues, please open an issue on the GitHub repository.
