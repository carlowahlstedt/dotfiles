# Claude Code config

Run `./install.sh` on a new machine (requires `jq`).

| File | What it is |
|---|---|
| `settings.shared.json` | Model, statusline, plugin marketplaces, and enabled plugins. Merged into `~/.claude/settings.json`. Machine-specific/private settings (autoMode, hooks, permissions) stay out of this public repo. |
| `statusline.sh` | Custom status line. Symlinked to `~/.claude/statusline.sh`. |
| `skills/` | Personal and third-party skills. Each folder is symlinked into `~/.claude/skills/`. |

## Adding things

- **Plugin:** after `/plugin install x@marketplace`, add `"x@marketplace": true` to `enabledPlugins` here.
- **Standalone skill:** put the folder in `skills/` and re-run `./install.sh`. Record where it came from below.

## Skill sources

| Skill | Source |
|---|---|
| pyramid-principle-memo | https://github.com/ai-champions-hub/skills/tree/main/skills/pyramid-principle-memo |

Not tracked here (restored automatically): `anthropic-skills:*` and other skills synced from the claude.ai account, and built-in skills like `/code-review`.
