# Performance budgets

From Vine Trail's GDD (section 12) and its M4.3 measurement (`docs/performance.md`, 2026-10-08). A new game starts from these and records its own measurements in its repo.

## Budgets

| Budget | Target | Vine Trail result |
| --- | --- | --- |
| Initial download without the engine | under 1 MB | about 63 KB gzipped |
| Total download with Phaser | under 2.5 MB | about 400 KB gzipped before music, 575 KB with it |
| Audio a player downloads | under 400 KB | one music file, 171 KB (webm) or 258 KB (m4a, Safari) |
| Time to interactive, mid-range phone on 4G | under 3 s | 2.0 s on 4G; 3.6 s on slow 4G |
| Frame rate while playing | 60 fps on a mid-range phone | 58 fps average unthrottled; 32 fps at 4× CPU slowdown on the largest board |

Phaser itself is about 338 KB gzipped, most of the download and of the slow-4G load time. An HTML splash in `index.html` keeps the page from looking blank meanwhile.

## How to measure

- **Download:** the production build served with gzip (`vite preview`), file sizes from the network panel or the `dist/` folder, raw and gzipped.
- **Time to interactive:** a `performance.mark` at the moment the first screen is ready to take input; three runs each on WebPageTest-style 4G (9 Mbps, 170 ms RTT) and Lighthouse slow 4G (1.6 Mbps, 150 ms RTT), at 4× CPU slowdown, in headless Chromium.
- **Frame rate:** frame times from `requestAnimationFrame` during scripted back-and-forth drags on the largest board, with and without 4× CPU slowdown; report the average and the 95th percentile.
- **Real devices:** confirm 60 fps on a mid-range Android phone and an iPhone before release, and after any rendering change (new art style, higher pixel ratio, particles).

## Rendering habits that kept the budget

- No canvas shadow blur or translucent overlaps redrawn every frame; bake glows and shadows into textures once.
- Cache baked textures by theme and size, and keep only the last few sizes.
- Load music after the first screen.
