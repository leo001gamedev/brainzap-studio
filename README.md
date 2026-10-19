# BrainZap Studio

Shared knowledge for every BrainZap game: the rules Claude Code follows in all projects, workflow skills, and studio-level decisions. Game repos never contain this repo. Claude loads it from `~/.claude`, so a `git pull` here updates every project at once.

## Layout

- `skills/` – Claude Code skills, each junctioned into `~/.claude/skills/`
- `.claude/plans/` – plans for changes to this repo

## Setup

Each script links every folder in `skills/` into `~/.claude/skills/` and adds an `@<repo>/CLAUDE.md` import line to `~/.claude/CLAUDE.md`. Both are safe to rerun: they skip what is already linked and never replace a real folder.

**Windows** (no admin needed), from a clone:

```
powershell -ExecutionPolicy Bypass -File link.ps1
```

**Linux or macOS** (e.g. a VM), from a clone:

```
./link.sh
```

**Claude Code cloud sessions** don't see `~/.claude` from your machine and don't install plugins, so the cloud environment installs the studio itself. Paste this into the environment's setup script on claude.ai (Settings of the environment → Setup script). The Claude GitHub App must be installed on this repo so the session can clone it:

```bash
#!/bin/bash
git clone --depth 1 https://github.com/leo001gamedev/brainzap-studio.git /opt/brainzap-studio
/opt/brainzap-studio/link.sh
```

Every new cloud session clones the latest `master`. To check, run `/context` in a session and look for the studio `CLAUDE.md` under Memory files.

## Updating

Edit and push here. Local machines get the change with `git pull` (links point into the clone); cloud sessions get it on their next start.
