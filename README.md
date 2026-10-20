# BrainZap Studio

Shared knowledge for every BrainZap game: the studio rules and the skills Claude Code uses in all projects. This repo is private and is the only place they are edited. Game repos never contain a copy.

## How it reaches Claude

| Where Claude runs | How it gets the skills | How it gets the rules always-on |
| --- | --- | --- |
| Any terminal or VM signed in to Leo's claude.ai account | claude.ai account skills, synced into `~/.claude/skills/synced/` | The game repo's `CLAUDE.md` tells Claude to load `brainzap-rules` |
| Cloud sessions (claude.ai/code, mobile, `--cloud`) | claude.ai account skills, loaded at session start | Same pointer in the game repo's `CLAUDE.md` |
| This PC, after `link.ps1` | Same as above | Also imported into `~/.claude/CLAUDE.md`, so they load even outside game repos |

Cloud sessions can't clone this private repo (GitHub access is limited to the session's own repositories, and setup scripts don't get environment variables), and they don't load plugins. That's why the skills are published to the account rather than fetched.

## Layout

- `skills/<name>/SKILL.md` – one folder per skill. `brainzap-rules` holds the studio rules; `CLAUDE.md` imports it, so there is one source.
- `package.ps1` – zips every skill into `dist/` (git-ignored) for upload.
- `link.ps1` – adds the `CLAUDE.md` import to `~/.claude/CLAUDE.md` on a Windows machine. Optional.
- `.claude/plans/` – plans for changes to this repo.

## Publishing a change

1. Edit the skill here, commit and push.
2. Run `powershell -ExecutionPolicy Bypass -File package.ps1`.
3. On claude.ai, Settings > Skills: replace the skill with its new zip from `dist/` (upload a new skill the same way, and turn it on).

Running sessions pick up the change within about 10 minutes; new sessions get it at start.

Upload rules: `SKILL.md` frontmatter may only use `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools`, and the description must stay under 1024 characters.

## Each game repo

Its `CLAUDE.md` (from the game template) carries this pointer, which is what makes the rules apply in cloud sessions:

> Studio rules: before any git, GitHub, planning, ADR or code task, load the `brainzap-rules` skill, and follow `leo-architecture-standards`. This file and the GDD win where they conflict.
