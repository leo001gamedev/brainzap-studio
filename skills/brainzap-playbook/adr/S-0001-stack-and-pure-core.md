# S-0001: Phaser 4, strict TypeScript and Vite, with rules in a pure core

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0001, ADR-0002, ADR-0009

## Context
BrainZap games are small HTML5 puzzle games for web portals first and Android later. Claude writes most of the code, so the stack must be code-only (no editor scenes), small to download, and easy to test without a browser. Offline tools (level generators, solvers) need the same game rules as the game.

## Decision
- **Stack:** Phaser 4 with strict TypeScript, built by Vite from the official template (`npm create @phaserjs/game@latest`, Vite + TypeScript). Vitest for tests, ESLint and Prettier. Android later through Capacitor wrapping the same build.
- **Check the current major version before scaffolding.** Vine Trail's GDD said Phaser 3; by M0 the official template already pinned Phaser 4, so the first ADR was superseded on day one.
- **Pure core:** all game rules, generation, solving, layout maths and decision logic live in `src/core/` with no Phaser imports. Scenes render state and forward input only. Services (`src/services/`) wrap browser and platform APIs.
- **Config, not constants in scenes:** every tuning value lives in `src/config/`.
- **Tests first for core:** every core module is unit-tested before a scene uses it.

## Alternatives considered
- Unity or Cocos: heavier downloads, editor-bound scenes Claude can't edit well.
- Logic inside scenes: quicker to start, but untestable and unusable from Node scripts.
- Pinning Phaser 3: starts a major version behind with no reason to.

## Consequences
- Fast Vitest runs and one codebase for game and tools (Vine Trail's pack generator runs the same core in Node).
- Needs discipline about where code goes; reviews check that no Phaser import leaks into `src/core/`.
- Fewer community answers for Phaser 4 than 3; check the official v4 migration guide first when stuck.
- Rendering with standard objects (Graphics, Text, Sprites, no custom WebGL pipelines) keeps engine upgrades cheap.
