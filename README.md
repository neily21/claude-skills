# claude-skills

My portable Claude Code skill setup — used to reconstruct skills in a fresh
environment (a new laptop, or a **Claude Code on the web** cloud sandbox, which
starts from a clean clone and does **not** see `~/.claude/` from my machine).

## What's here

- `skills/` — personal skills that aren't in any marketplace, copied verbatim
  into `~/.claude/skills/`:
  - `liquid-glass-ui`
  - `qa-uat-cycle`
- `bootstrap-claude-skills.sh` — reinstalls everything: the 13 marketplace
  plugins below **plus** the personal skills above.

## Plugins (from `anthropics/claude-plugins-official`)

frontend-design · github · playwright · code-review · feature-dev ·
code-simplifier · ralph-loop · security-guidance · superpowers · figma ·
vercel · claude-code-setup · skill-creator

These aren't stored here — they're reinstalled from the public marketplace by
the bootstrap script.

## Use it

This repo is **private**, so the bootstrap clone authenticates with a
fine-grained GitHub PAT supplied via the `SKILLS_TOKEN` environment variable
(the script feeds it to git through `GIT_ASKPASS`, so it never lands in argv).

1. Create a fine-grained PAT: GitHub → Settings → Developer settings →
   Personal access tokens → Fine-grained tokens. Scope it to **only**
   `neily21/claude-skills`, with **Repository permissions → Contents:
   Read-only**. Copy the `github_pat_…` value.
2. **Cloud (the "default environment"):** add `SKILLS_TOKEN` as an environment
   variable/secret in your Claude Code web environment, then paste this script
   into its setup/init step so it runs on every sandbox.
3. **New laptop:** `SKILLS_TOKEN=github_pat_xxx ./bootstrap-claude-skills.sh`

> The MCP-backed plugins (playwright, figma, vercel, github) also need the cloud
> environment to permit their MCP servers/network to be fully functional. The
> skills themselves load regardless.
