# S-0007: Mobile web canvas – sharpness, fluid layout, safe areas and sound

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0018, ADR-0031, ADR-0033, ADR-0043

## Context
Most players are on phones in a browser or a portal iframe, on every screen shape. Vine Trail hit each of these: soft art on 3x phones, letterbox strips on non-standard shapes, plain bands under browser insets (DuckDuckGo on Android), and sound that must survive iOS's audio unlock.

## Decision
**Sharpness**
- Device pixel ratio capped at **3**, and lowered further to keep the canvas under about 4 million pixels. A cap of 2 made fine art soft on 3x phones (every iPhone since the X).
- Use `Scale.FIT` with a game size that follows the container. Phaser 4's `Scale.RESIZE` ignores the pixel ratio, so text and lines go soft.
- Don't zoom cameras to scale menus (it blurs text); position or scroll instead.
- Tiny previews of a board get their own simpler style; full-size depth turns to mud at a few pixels per tile.

**Layout**
- The canvas is the container's size times the capped pixel ratio; a resize or rotation re-lays out after a short debounce.
- **One pure layout module** in core (`core/screen.ts`) decides every rectangle, unit-tested per device shape; all numbers in config.
- Menus and popups: a centred design column (Vine Trail: 390 × 844) at the fit scale. The play screen is fluid: controls keep the fit scale, the board grows into all spare room, with a maximum cell size so small boards don't balloon on tablets.
- A resize redraws in place without losing play state, the same path as a theme change.

**Safe areas**
- No safe-area padding on the page: the canvas covers the whole screen, insets included, so backgrounds reach every edge.
- Measure the insets in a service (a hidden element padded by `env(safe-area-inset-*)`), at boot and on resize; layout places controls inside them, while backdrops, dims and particles use the whole canvas.
- Dev builds show the insets and window size under the fps meter, to see what a device's browser reports.

**Sound**
- Short SFX are synthesised with Web Audio from recipes in code (no files, no licences), through Phaser's audio context so its iOS unlock and hidden-tab suspend cover them. Keep the recipes exportable to `.wav` for reuse.
- Music is a shipped loop in two formats (webm, plus m4a for Safari), loaded after the first screen.

## Alternatives considered
- Letterboxing a fixed column: strips on every other screen shape, and the board never uses spare room.
- A side rail for controls on wide screens: built and played; the controls felt disconnected from the board.
- Painting the page behind the canvas to fake edge-to-edge: the seam never matches on every theme and size.
- Royalty-free SFX files: bytes, licences and a Safari format pair each.

## Consequences
- 2.25× the pixels on 3x phones; check frame rate on a low-end Android, in landscape and on a large desktop window.
- Baked textures grow with the canvas; cache a few sizes, and merge large static layers if memory is tight.
- Anything new that lays out against the whole canvas must use the safe area for controls.
