#!/usr/bin/env bash
#
# bootstrap-claude-skills.sh
# Reconstructs my Claude Code skill setup on a fresh machine or cloud sandbox.
#
# A Claude Code on the web session starts from a clean clone and does NOT see
# ~/.claude/ from my own machine, so this script rebuilds it:
#   1. the 13 marketplace plugins (from anthropics/claude-plugins-official)
#   2. the personal skills in ./skills/ that aren't in any marketplace
#
# Usage:
#   - Cloud: paste this into your Claude Code web environment's setup/init step,
#     and set SKILLS_TOKEN there (a fine-grained GitHub PAT with Contents:read on
#     the skills repo) so the private clone can authenticate non-interactively.
#   - Local: SKILLS_TOKEN=github_pat_xxx \
#       SKILLS_REPO=https://github.com/neily21/claude-skills.git ./bootstrap-claude-skills.sh
#
set -euo pipefail

# This repo's URL, once pushed to GitHub. Override via env or edit this line.
SKILLS_REPO="${SKILLS_REPO:-https://github.com/neily21/claude-skills.git}"

echo "==> Adding the official plugin marketplace"
claude plugin marketplace add anthropics/claude-plugins-official || true

echo "==> Installing plugins (user scope)"
PLUGINS=(
  frontend-design github playwright code-review feature-dev
  code-simplifier ralph-loop security-guidance superpowers figma
  vercel claude-code-setup skill-creator
)
for p in "${PLUGINS[@]}"; do
  echo "    - $p"
  claude plugin install "${p}@claude-plugins-official" --scope user \
    || echo "      (skipped: already installed or unavailable)"
done

echo "==> Installing personal skills (private repo, authenticated via SKILLS_TOKEN)"
: "${SKILLS_TOKEN:?Set SKILLS_TOKEN to a GitHub PAT with Contents:read on the skills repo}"
export SKILLS_TOKEN
mkdir -p "$HOME/.claude/skills"
TMP="$(mktemp -d)"
# Feed the token to git via GIT_ASKPASS so it never appears in argv or logs.
ASKPASS="$(mktemp)"
printf '#!/usr/bin/env bash\necho "$SKILLS_TOKEN"\n' > "$ASKPASS"
chmod +x "$ASKPASS"
AUTH_URL="$(printf '%s' "$SKILLS_REPO" | sed 's#https://#https://x-access-token@#')"
GIT_ASKPASS="$ASKPASS" GIT_TERMINAL_PROMPT=0 git clone --depth 1 "$AUTH_URL" "$TMP"
rm -f "$ASKPASS"
cp -R "$TMP"/skills/* "$HOME/.claude/skills/"
rm -rf "$TMP"

echo "==> Done. Installed plugins:"
claude plugin list || true
echo "==> Personal skills in ~/.claude/skills:"
ls -1 "$HOME/.claude/skills"
