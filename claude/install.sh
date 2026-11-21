#!/bin/bash
# Restore Claude Code config from this repo.
# - Merges settings.shared.json into ~/.claude/settings.json (existing keys elsewhere are kept)
# - Symlinks statusline.sh and every skill in ./skills into ~/.claude
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR/skills"

command -v jq >/dev/null || { echo "jq is required (brew install jq)"; exit 1; }

# Settings: shared keys win, everything else in the local file is preserved
SETTINGS="$CLAUDE_DIR/settings.json"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
cp "$SETTINGS" "$SETTINGS.bak-$(date +%Y%m%d-%H%M%S)"
shared=$(sed "s|__HOME__|$HOME|g" "$HERE/settings.shared.json")
jq --argjson shared "$shared" '. * $shared' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
echo "Merged settings into $SETTINGS"

# Statusline
ln -sfn "$HERE/statusline.sh" "$CLAUDE_DIR/statusline.sh"
chmod +x "$HERE/statusline.sh"
echo "Linked statusline.sh"

# Personal / third-party skills
for skill in "$HERE"/skills/*/; do
  name=$(basename "$skill")
  ln -sfn "${skill%/}" "$CLAUDE_DIR/skills/$name"
  echo "Linked skill: $name"
done

echo
echo "Done. Start 'claude' and log in. Account skills sync automatically."
echo "If plugins aren't installed yet, run /plugin and install each one in enabledPlugins."
