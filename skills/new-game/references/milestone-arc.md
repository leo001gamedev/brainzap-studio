# Milestone arc

The usual order of a BrainZap game's first milestones, from Vine Trail's M0 to M5. The riskiest work is proven first, and the game is playable by the end of the third stage.

Each stage becomes a milestone through `start-milestone` when it starts, not before. Its "Done when" is written for the game at that point, something a player or Leo can check; the lines below are the pattern to follow.

| Stage | Proves | Done when (pattern) |
| --- | --- | --- |
| Project setup | The toolchain | `npm run dev` shows a blank scene in portrait, `npm test` runs one passing test, `npm run build` succeeds |
| Core, no graphics | The riskiest rule or generator, in the pure core | A measurable result, e.g. "100 puzzles per size generate with one solution; the same seed gives the same output" |
| Playable | The feel of the main input | One puzzle, round or run can be played to its end by touch on a phone and by mouse on desktop, with no misread input in five tries |
| Loop and content | The game around the core loop | A fresh player goes from launch through the tutorial, plays on, reloads and keeps all progress |
| Feel and polish | The look and sound | Every event in the GDD's feedback table (section 4) has its animation and sound, and the studio's budgets pass |
| Platform and release | Shipping | The game passes Playgama's review and is live on both targets |

A game may merge, split or reorder stages; say why in the milestone's spec issue.
