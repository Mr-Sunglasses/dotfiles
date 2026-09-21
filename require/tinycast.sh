#!/bin/zsh
#
# Tinycast keeps its settings in macOS preferences (hotkeys, toggles) and its
# quicklinks in a SQLite database, so they can't be copied like plain files.
# These helpers turn them into text files in config/tinycast/ and back.
#
# Snippets are NOT synced: they hold personal data (emails, phone numbers)
# and this repo is public. Copy ~/Library/Application Support/com.tinycast.app/Snippets
# over manually.

TINYCAST_DOMAIN="com.tinycast.app"
TINYCAST_DATA="$HOME/Library/Application Support/com.tinycast.app"

# Preference keys that only make sense on the current machine
# (window positions, file dialog state, menu bar item positions).
TINYCAST_SKIP_KEYS='^(NS|Apple)'

# usage: tinycast_export <repo dir>
tinycast_export() {
    local out="$1/config/tinycast"
    defaults read "$TINYCAST_DOMAIN" >/dev/null 2>&1 || return 0
    mkdir -p "$out"

    defaults export "$TINYCAST_DOMAIN" - | python3 -c '
import plistlib, re, sys
prefs = plistlib.loads(sys.stdin.buffer.read())
prefs = {k: v for k, v in prefs.items() if not re.match(sys.argv[1], k)}
plistlib.dump(prefs, sys.stdout.buffer, sort_keys=True)
' "$TINYCAST_SKIP_KEYS" > "$out/settings.plist"

    if [ -f "$TINYCAST_DATA/quicklinks.sqlite3" ]; then
        # Idempotent SQL: safe to replay into an existing database
        sqlite3 -readonly "$TINYCAST_DATA/quicklinks.sqlite3" '.dump quicklinks' \
            | sed -E 's/^CREATE TABLE /CREATE TABLE IF NOT EXISTS /; s/^CREATE INDEX /CREATE INDEX IF NOT EXISTS /; s/^INSERT INTO /INSERT OR IGNORE INTO /' \
            > "$out/quicklinks.sql"
    fi
}

# usage: tinycast_import <repo dir> [backup dir]
tinycast_import() {
    local src="$1/config/tinycast" backup="$2"
    [ -d "$src" ] || return 0

    # Tinycast would overwrite the imported prefs with its in-memory ones on quit
    local was_running=false
    if pgrep -xq Tinycast; then
        was_running=true
        osascript -e 'quit app "Tinycast"'
        sleep 1
    fi

    if [ -f "$src/settings.plist" ]; then
        if [ -n "$backup" ] && defaults read "$TINYCAST_DOMAIN" >/dev/null 2>&1; then
            mkdir -p "$backup"
            defaults export "$TINYCAST_DOMAIN" "$backup/tinycast-settings.plist"
        fi
        # Merge key by key, so machine-specific prefs already on this Mac are kept
        { defaults export "$TINYCAST_DOMAIN" - 2>/dev/null || echo '<plist version="1.0"><dict/></plist>'; } \
            | python3 -c '
import plistlib, sys
current = plistlib.loads(sys.stdin.buffer.read())
current.update(plistlib.load(open(sys.argv[1], "rb")))
plistlib.dump(current, sys.stdout.buffer)
' "$src/settings.plist" \
            | defaults import "$TINYCAST_DOMAIN" -
        echo "  ✓ Tinycast settings"
    fi

    if [ -f "$src/quicklinks.sql" ]; then
        mkdir -p "$TINYCAST_DATA"
        if [ -n "$backup" ] && [ -f "$TINYCAST_DATA/quicklinks.sqlite3" ]; then
            mkdir -p "$backup"
            sqlite3 "$TINYCAST_DATA/quicklinks.sqlite3" ".backup '$backup/tinycast-quicklinks.sqlite3'"
        fi
        sqlite3 "$TINYCAST_DATA/quicklinks.sqlite3" < "$src/quicklinks.sql"
        echo "  ✓ Tinycast quicklinks"
    fi

    $was_running && open -a Tinycast
}
