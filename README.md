# BrainZap Studio

Shared knowledge for every BrainZap game: the rules Claude Code follows in all projects, workflow skills, and studio-level decisions. Game repos never contain this repo. Claude loads it from `~/.claude`, so a `git pull` here updates every project at once.

## Layout

- `skills/` – Claude Code skills, each junctioned into `~/.claude/skills/`
- `.claude/plans/` – plans for changes to this repo

## Setup on a new machine

Clone this repo, then from it run (Windows, no admin needed):

```
powershell -ExecutionPolicy Bypass -File link.ps1
```

`link.ps1` junctions every folder in `skills/` into `~/.claude/skills/`. It skips a skill that is already linked and refuses to replace a real folder.
