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

This repo is **public** (it holds only generic, non-sensitive skills), so the
bootstrap clone needs no authentication — which matters because Claude Code web
setup scripts run *before* env vars/secrets are injected, so a token wouldn't be
available there anyway.

1. **Cloud (the "default environment"):** paste `bootstrap-claude-skills.sh`
   into your Claude Code web environment's setup/init step so it runs on every
   new session. No environment variables or tokens required.
2. **New laptop:** `./bootstrap-claude-skills.sh`

> The MCP-backed plugins (playwright, figma, vercel, github) also need the cloud
> environment to permit their MCP servers/network to be fully functional. The
> skills themselves load regardless.
