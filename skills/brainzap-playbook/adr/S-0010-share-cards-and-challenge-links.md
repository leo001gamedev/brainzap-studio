# S-0010: Share cards that work alone, and challenge links

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0025, ADR-0045

## Context
Shares are the studio's free growth channel. A share should show off the result, bring a stranger straight to the same puzzle, and say where it came from, without spoiling a daily or breaking portal rules.

## Decision
**The card**
- A 1080 × 1350 image (4:5, suits phone feeds), drawn off-screen from the solved puzzle: board, headline, level or "Daily #N", stats as large chips, the logo and a call to action. It follows the player's current theme.
- **Dailies hide the solution;** other levels may show it.
- **The card works without its link,** since images travel alone (reposts, screenshots): the website card prints the plain site address large enough to type; the Playgama card says "Play free on Playgama" and no web address. No QR code: viewers are usually on the phone they'd scan with.

**Sharing**
- On tap: if `navigator.canShare({ files })`, open the share sheet with image, line and link; otherwise copy the line and link and download the image, and say which happened.
- The share line ends with the link. Analytics records where (`daily` / `pack`) and how (`share_sheet` / `clipboard` / `failed`).

**Links**
- Website: a **challenge link** to the exact puzzle, with utm tags (`utm_source=player_share`, `utm_medium=share_sheet|clipboard`, `utm_campaign=daily|pack`). GoatCounter (cookieless, no prompt) counts visits and campaigns on the live site.
- Playgama: the game's Playgama page only, no challenge parameters (the iframe can't read them reliably, and off-platform links break portal rules).

**Where a challenge link lands**
- A daily: today's daily of that tier, played normally; a past date falls back to today's, so old dailies stay a reward for regulars.
- A level the visitor has unlocked: a normal play.
- A locked level: a **challenge play** that can be won but saves nothing, and says what to unlock to keep it.
- Bad or unknown parameters: the home screen.
- A newcomer sees a one-card how-to first, then the challenge, then the tutorial; the consent prompt waits until the home screen.
- Parsing and deciding the outcome is pure core logic; the scene only acts on the outcome.

## Alternatives considered
- Linking to the home screen: visitors have to find the puzzle themselves, and most won't.
- A landing page with a Play button: one more step before the puzzle.
- Animated GIF or video of the solve: spoils dailies, slow to encode on low-end phones, many targets keep only the first frame.
- Letting a challenge play unlock or count: bypasses progression and changes the save format.

## Consequences
- The share line format changes once, then stays stable.
- End-to-end tests need a reachable URL; PR previews work before the domain is live.
- New analytics events and dimensions follow S-0006 (`challenge_open` with an `outcome`, `via` on level events).
