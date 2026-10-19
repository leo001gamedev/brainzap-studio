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

**Claude Code cloud sessions** don't see `~/.claude` from your machine and don't install plugins, so the cloud environment installs the studio itself. This repo stays private, and a setup script can't use the session's GitHub access (a plain clone fails with `could not read Username`), so it clones with a read-only token:

1. GitHub → Settings → Developer settings → Fine-grained tokens → Generate new token: only `brainzap-studio`, permission *Contents: Read-only*, nothing else. Note its expiry date.
2. In the claude.ai cloud environment, add the environment variable `STUDIO_TOKEN` with the token.
3. Set the environment's setup script to this single line:

```bash
git clone --depth 1 "https://leo001gamedev:${STUDIO_TOKEN}@github.com/leo001gamedev/brainzap-studio.git" /opt/brainzap-studio && git -C /opt/brainzap-studio remote remove origin && bash /opt/brainzap-studio/link.sh
```

Keep it on one line: if a copy-paste merges two lines, `git clone` gets an extra argument and fails with `Too many arguments`. Removing `origin` takes the token out of the clone's git config. When the token expires, cloud setup fails with an authentication error: generate a new one and replace `STUDIO_TOKEN`.

Every new cloud session clones the latest `master`. To check, run `/context` in a session and look for the studio `CLAUDE.md` under Memory files.

## Updating

Edit and push here. Local machines get the change with `git pull` (links point into the clone); cloud sessions get it on their next start.
