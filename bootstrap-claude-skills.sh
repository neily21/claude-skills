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
#   - Cloud: paste this into your Claude Code web environment's setup/init step.
#   - Local: ./bootstrap-claude-skills.sh
#     (override the repo with SKILLS_REPO=... if you fork or rename it)
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

echo "==> Installing personal skills (public repo, no auth needed)"
mkdir -p "$HOME/.claude/skills"
TMP="$(mktemp -d)"
git clone --depth 1 "$SKILLS_REPO" "$TMP"
cp -R "$TMP"/skills/* "$HOME/.claude/skills/"
rm -rf "$TMP"

echo "==> Done. Installed plugins:"
claude plugin list || true
echo "==> Personal skills in ~/.claude/skills:"
ls -1 "$HOME/.claude/skills"
