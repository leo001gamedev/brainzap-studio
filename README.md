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
- `.github/workflows/skills.yml`, `scripts/` – checks skills and publishes changed ones (see below).
- `package.ps1` – zips every skill into `dist/` (git-ignored) for upload, offline.
- `link.ps1` – adds the `CLAUDE.md` import to `~/.claude/CLAUDE.md` on a Windows machine. Optional.
- `.claude/plans/` – plans for changes to this repo.

## Publishing a change

1. Edit the skill here, commit and push to `master`.
2. The **Skills** workflow checks every skill against the upload rules, zips the changed ones into a GitHub Release, and opens an issue "Upload changed skills: …" with a download link per skill. Each zip is named `<skill>-<short sha>.zip`, so you can tell which commit you are uploading (`-dirty` from `package.ps1` means uncommitted changes).
3. Follow the issue: on claude.ai, Settings > Skills, replace each skill with its zip (upload a new one and turn it on; remove a deleted one). Close the issue.

Running sessions pick up an upload within about 10 minutes. An open upload issue means claude.ai is behind this repo. The upload stays manual because claude.ai has no API for personal account skills ([anthropics/claude-code#93163](https://github.com/anthropics/claude-code/issues/93163)); when one lands, `scripts/publish-skills.sh` can call it instead of opening an issue.

To publish every skill (say, after setting up a new account), run the workflow by hand: Actions > Skills > Run workflow. Offline, `package.ps1` builds the same zips into `dist/`.

Upload rules, checked by `node scripts/check-skills.mjs` in CI and by `package.ps1`: frontmatter may only use `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools`; `name` matches its folder, uses lowercase letters, digits and hyphens, and avoids "anthropic" and "claude"; the description stays under 1024 characters with no XML tags.

## Each game repo

Its `CLAUDE.md` (from the game template) carries this pointer, which is what makes the rules apply in cloud sessions:

> Studio rules: before any git, GitHub, planning, ADR or code task, load the `brainzap-rules` skill, and follow `leo-architecture-standards`. This file and the GDD win where they conflict.
