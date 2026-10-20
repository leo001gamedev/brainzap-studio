# Release test pass

The manual pass before a release, generalised from Vine Trail's `docs/release-checklist.md`. Copy it into the game's own release checklist and add the game's specific checks (its modes, timers, tutorial).

## Devices

iPhone Safari, Android Chrome, desktop Chrome, desktop Safari, desktop Firefox (and Edge when the layout or input code changed).

## Checks

- [ ] Fresh player: the tutorial, then the home screen; the consent prompt shows over home, once.
- [ ] Play several levels and a daily, reload: progress kept.
- [ ] Fast, messy input never produces an invalid game state.
- [ ] Rotate the phone and resize the window: layout and board stay correct, and play state survives.
- [ ] Sound: SFX and music start after the first tap; the music loop has no gap on Safari; Settings switches work.
- [ ] Switching tabs or minimising pauses timers and sound.
- [ ] The page never scrolls or zooms while playing (real iPhone and Android).
- [ ] Night theme and Auto following the device's dark mode; reduced motion stops ambient motion.
- [ ] 60 fps while playing on a mid-range phone (see performance-budgets.md).
- [ ] Pen and mouse input work, not only touch.
- [ ] Settings shows the version and commit of this release.

## Playgama build

- [ ] Download the Playgama artifact or Release zip and run it through Playgama's QA tool.
- [ ] `game_ready` arrives; an interstitial appears only where the pacing rules allow (S-0009); the rewarded ad pays out only when watched, and a skip says so.
- [ ] Sound stops during ads and when minimised.
- [ ] The listing title matches the in-game title exactly; no external analytics (`npm run check:playgama` passed in CI).

## After the release

- [ ] If content was added: the new daily epoch date is set, and shipped levels and dailies are recorded (S-0008).
- [ ] Tag pushed and the GitHub Release holds both zips (S-0005).
