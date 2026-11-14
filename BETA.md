# vfxmith 0.1.6-beta2 (beta channel)

A test build of the next version. The main goal is **much cheaper runs** at the same quality. Please try it on
effects you actually want and tell us how it went.

## What is different from 0.1.5 (stable)
- **Cheaper runs.** Two helper agents on a fast, cheap model do the heavy lifting: a librarian reads the library and
  hands back the references, and a capture helper takes the Studio screenshots and returns one contact sheet per
  backdrop. The main builder keeps a small context and stops after two review rounds.
- **Better questions first.** For portals, rifts, auras and other effects that stay on screen, it always asks how the
  effect moves, what it pulls in or throws out, and whether it stands on the ground or hangs in the air.
- **A stronger payoff.** The biggest moment has to be the biggest thing on screen: a small white-hot core inside a
  big coloured glow, never a tiny sparkle and never a flat white ball.
- **Checks that catch more.** The spec check warns about giant white flashes and about effects that run much longer
  or shorter than you asked; the builder gets a close-up sheet of the payoff moments.

## What we measured so far
The same request and the same answers, run by each version (an ice slam, 2026-11-14), priced at API rates:

| | 0.1.5 full | **0.1.6-beta2** | no plugin |
|---|---|---|---|
| Cost | $57.41 | **$13.18** | $9.78 |
| Time | 70 min | **42 min** | 33 min |

The blind quality score of beta2 is **not in yet**. The first beta cut the cost by 55% but lost quality on another
test (a void rift); beta2 fixes the two causes found. So this beta is mainly for cost, speed and usability feedback,
and for telling us when an effect looks worse than you expected.

## Install
You need Claude Code, Roblox Studio with the Studio MCP connected, and Python 3 with Pillow.
```bash
claude plugin marketplace add Frxctured/roblox-vfxmith#beta
claude plugin disable vfxmith@vfxmith          # only if the stable version is installed
claude plugin install vfxmith@vfxmith-beta
```
No SSH key for GitHub? Run `export CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` first.

## Use
In Claude Code: `/vfx <your effect>`, for example `/vfx a cool ice slam`. It asks a few short questions, then builds
and checks the effect in your open Studio place. A full build takes about 40-60 minutes.

## What to send back
- what you asked for, and your answers to its questions;
- the result: a short screen recording, or the final frames it shows you;
- how long it took and how much of your usage it took (`/usage` before and after);
- anything that broke, looked wrong, or felt slow.
Open an issue on the repository, or tell the maintainer directly.

## Go back to stable
```bash
claude plugin uninstall vfxmith@vfxmith-beta
claude plugin marketplace remove vfxmith-beta
claude plugin enable vfxmith@vfxmith
```

## Known issues
- Beta2's quality has not been blind-scored yet (see above).
- The capture helper needs a Studio MCP whose screenshot result names the saved image file (current versions do).
  With an older one the builder takes the screenshots itself, which costs more.
- Textures still come mostly from the built-in recipes. A search over a much larger texture set (including the free
  VFX Studio library and its animated flipbooks) is coming in a later beta.
