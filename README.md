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
- **SSH keys / hosts**: copy `~/.ssh` over manually (host entries are kept out of this public repo).
- **GitHub CLI**: `gh auth login`
- **Atuin history**: `atuin login`
- **Karabiner-Elements**: grant its permissions in System Settings → Privacy & Security.
- **Raycast**: see below.

# Raycast
Raycast settings live in its own encrypted database, not in plain files, so they are not stored in this repo.

- **Cloud Sync (Raycast Pro)**: sign in on the new Mac and everything syncs.
- **Without Pro**: on the old Mac run `Export Settings & Data` in Raycast, set a passphrase, and save the `.rayconfig` file.
  On the new Mac, open Raycast and run `Import Settings & Data` (or double-click the file) and pick the categories to import.
- **Keep a backup automatically**: in Raycast Settings → Advanced, point the scheduled backup location at iCloud Drive
  (or Dropbox), so there is always a recent encrypted `.rayconfig` to import.

# Note
Feel free to modify the configurations as per your requirements. If you encounter any issues, please open an issue on the GitHub repository.
