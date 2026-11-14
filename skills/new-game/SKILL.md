---
name: new-game
description: Start a new BrainZap game from an idea - two or three concepts to pick from, a one-page brief filled in conversation and written on Leo's yes, then the kickoff package a game repo starts from (GDD, CLAUDE.md, NOTES.md, ADR template and first ADRs). Use when Leo brings a new game idea, wants game ideas, asks to start, set up or kick off a game, or wants a brief or a GDD for a game that has no GDD yet.
---

# New game

Turns no idea, or a rough one, into a one-page **brief**, then into the kickoff package the first milestone builds from. A few exchanges, not fifteen. The brief is the gate: nothing is written before Leo's yes. Load `brainzap-rules` first.

## 1. Concept

From Leo's idea (or one open question when he gives none), propose **two or three one-line concepts**, verb-first or a mashup of genre and theme. He picks or combines them. An idea that already has its hook goes straight to step 2.

If `design/brief.md` exists, read it and refine it instead of starting over; its *In your words* section is only ever added to.

## 2. Fill the brief

In conversation, several fields per exchange, from [references/game-brief.md](references/game-brief.md):

- **In your words:** everything Leo writes about the game, word for word: the idea, his descriptions, his changes. When he only picked a concept, it holds his idea and which concept he picked.
- **Working title:** offer one from the concept; he changes it.
- **Pitch:** the excited one-liner.
- **Genre**, **Controls** and **Look** (how it looks and sounds, in his words): one line each.
- **Question** (what a first playable must answer) and **Hook** (what makes it this game and not its genre): propose them from the concept; he changes them.
- **Session:** how long one puzzle, round or run takes. Ask it; it is his answer.
- **Core loop:** the two to four steps the player repeats.
- **Goal and end:** what the player tries to do, and how a puzzle or run ends.
- **First minute** and **Challenge:** propose a short paragraph each from the concept; he changes them.
- **Features:** the short list that makes it the game, each `[ ]`. More than seven: push back, propose which to cut (the ones the core loop works without), and keep seven or fewer.
- **Out of scope:** what he is deliberately leaving out; the cut features go here.
- **Avoid:** every removal in his words ("no timers") and anything he turns down.
- **Build order:** the riskiest or least proven part first.
- **Kill condition**, **Who it's for** and **Games you love / don't:** one line each; offer, don't force.

Mark each field Leo did not give *(guessed)*, or *(provisional)* when he said "you pick". **Keep** stays empty: it fills after he has played.

Platforms, stack, saves, ads and analytics are studio decisions (`brainzap-playbook`), so the brief leaves them out.

## 3. Show it, then write it

Show the filled brief in full. Then ask, as its own question: "Brief is ready. May I write it to `design/brief.md`?" Write only on an explicit yes to this question; agreeing to a cut or saying "go on" is a different answer. On a revision, change the named field, show it before and after, and ask again.

Write it in the game's repo, asking Leo for the repo when the session isn't in one. If he stops before the write, say the brief lives only in this conversation.

## 4. Prove an unproven loop

When no shipped game plays the way the brief's core loop does, name `/prototype` for Leo to run on the brief's Question, and stop. After he has played it, what he liked goes on Keep, what he disliked on Avoid, and his verdict decides: proceed goes to step 5, pivot back to step 2, and a third pivot on one idea is a kill.

## 5. Write the kickoff package

Beside the brief, write these files and leave them uncommitted:

- `docs/GDD.md` from [references/kickoff-files.md](references/kickoff-files.md). Fill each section from the brief. The GDD holds only what this game decides; what is the same for every game stays in the studio skills. What the brief leaves undecided becomes a line under Open questions in section 12.
- `CLAUDE.md` and `NOTES.md` from the same file, and `docs/adr/0000-template.md` from `brainzap-playbook`'s references/writing-adrs.md. Every *(guessed)* and *(provisional)* line of the brief becomes a dated Assumption in `NOTES.md`; each Out of scope item Leo wants back later becomes a Deferred line.
- One Proposed ADR for each decision the brief makes that is this game's own, per writing-adrs.md. A decision a studio ADR covers gets no game ADR and no GDD section; a departure from one is a game ADR that names it (`studio S-0003`).

Done when every GDD section is filled or has its open questions listed, and every game ADR in section 0's table exists as a file.

## 6. Hand over

Report the files written, what was guessed, and the open questions. Then name the next commands for Leo: `/grill-with-docs` on the open questions, then `start-milestone` for the first stage of [references/milestone-arc.md](references/milestone-arc.md), as M0, whose first commit carries this package.
