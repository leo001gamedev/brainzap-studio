# Kickoff files

What a new BrainZap game repo starts with, generalised from Vine Trail's first commit.

The GDD holds only what this game decides. What is the same for every game (stack, folder layout, platforms, builds, saves, ad pacing, analytics, browser support, budgets, the release test pass) lives in `brainzap-playbook` and `brainzap-rules`, and the GDD leaves it out. Where this game departs from one of those, the departure is a game ADR.

## docs/GDD.md

```markdown
# <Game> – Game Design Document

<YYYY-MM-DD> · Leo

## 0. How to use this document

The single source of truth for this game's design. Reading order for a new session: this section, the current milestone in section 11, then only the sections it references. Everything that is the same for every BrainZap game is in the studio skills (`brainzap-rules`, `brainzap-playbook`).

**This game's decisions**

| ADR | Decision | GDD section |
| --- | --- | --- |
| 0001 | <this game's first own decision, or its first departure from a studio ADR> | <n> |

**Glossary**

| Term | Meaning |
| --- | --- |

## 1. Overview

<One paragraph: what it is and how long a session takes.>

**Pitch:**
**Design pillars** <three or four, each a sentence a feature can be tested against>
**Session length:**
**In scope for v1:**
**Out of scope for v1:**
**Backlog:**

## 2. Core rules

**Definition** <what a puzzle or run is, and what solved or won means>
**Move rules**
**Validation function** <the pure core function that decides a win, with its signature>
**Scoring** <placement, clears, combos and bonuses, as formulas; what the Juice Line does here>
**Edge cases to handle**

## 3. <The game's model>

<The board, deck, word list or world as data. Vine Trail's was its hex grid.>
**Types** · **Required functions** · **Sizes** · **Tests**

## 4. Input and feedback

**Pointer handling** <this game's gestures; mouse and keys make the same moves; how mobile fingers feel, e.g. the piece follows the finger with an offset so it sits above the thumb>
**Feedback** <a table: event, animation, sound>
**Buttons**
**Accessibility** <what this game needs beyond the studio's defaults>

## 5. Content

**Where it comes from** <generated or hand-made, and how>
**Data format**
**Daily selection** <when the game has a daily>
**Tests**

## 6. Modes, progression and difficulty

**Modes** · **Progression** · **Tutorial** <the brief's First minute, taught by doing> · **Hints** · **Difficulty levers, in order of impact**

## 7. Art direction, audio and feel

**Look** <one line each: mood · camera and scale · shapes · values (what is brightest, what stays quiet) · palette with roles · where detail goes · one outline and shading rule · one signature detail>
**Typography** · **Rendering approach** · **Audio** · **Motion**

## 8. Screens and UI flow

**Flow** · **First launch** · **Layout of this game's screens**

## 9. Core modules and save data

**Core modules** <this game's pure core modules and their key interfaces>
**Save data** <the fields this game saves>

## 10. Ads and Playgama

**Rewarded ads** <what each one gives the player and where it is offered>
**Interstitial moments** <the natural breaks where one may show, in games-per-break or minutes-of-active-play as this game decides; if this differs from the studio default (S-0009: one per 2–3 minutes of active play), it is a game ADR>
**Playgama leaderboards** <the leaderboard ids this game uses, which one is main, and where scores are submitted; Bridge calls `setScore(leaderboardId, score)` after a run ends and `getEntries(leaderboardId)` when the type is `in_game`, from Playgama's docs>

## 11. Milestones

`start-milestone` adds each `### Mn – Name` section here when that milestone starts. The usual order of stages is the studio's: the `new-game` skill's references/milestone-arc.md.

## 12. Testing and open questions

**Core tests** <which core modules, and the cases that matter most>
**Manual checks for this game** <what the studio's release test pass does not cover>
**Open questions**
```

## CLAUDE.md

The `## Studio rules` section is what makes the studio rules apply in cloud sessions. This is its one source: an existing repo copies it from here.

```markdown
# <Game> – instructions for Claude Code

<One line: what it is and where it ships.>

## Read first
1. `docs/GDD.md` section 0, then the current milestone in section 11, then only the sections it references.
2. `docs/adr/` for decisions already made.
3. `NOTES.md` for open assumptions and deferred items.

## Studio rules
Before any git, GitHub, planning, ADR or code task, load the `brainzap-rules` skill (git flow, milestones, Bug burndown, ADRs, pure core, compatibility), and follow the `leo-architecture-standards` skill. Use `brainzap-playbook` for the studio's proven decisions (saves, builds, Playgama, analytics, mobile canvas, content, sharing) and for writing ADRs. All three come from the private `brainzap-studio` repo through Leo's claude.ai account, so cloud sessions have them too. Where they conflict with this file or the GDD, this project's own rules win.

## Commands
<The project's check commands, added when the setup milestone creates them.>

## Project specifics
- Milestone tasks live in GDD section 11 as Mn.x.
- The Bug burndown milestone is GitHub milestone #<n>. Model a new milestone's spec issue on #<n>.

## Where things live
- `design/brief.md` – the approved brief
- `design/concepts/` – mocks and references
- `design/handoffs/` – design export bundles; commit each one before implementing it
- `assets/` – shipped game assets
```

## NOTES.md

```markdown
# Notes

Decisions go in `docs/adr/`. This file holds assumptions and deferred items only, newest first.

## Assumptions

## Deferred
```
