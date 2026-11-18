# 1.0.0-alpha1 (branch v1)
The v1 rewrite: builds start from real pro compositions (see README "vfxmith 1.0.0-alpha1" and START.md). Not released; for lab tests only.

# vfxmith 0.1.9-beta2 (beta channel)

A test build of the next version. The main change is a new way of building: the **directed loop**. Please try it on
effects you actually want and tell us how it went.

## What is different from 0.1.6 (stable)
- **Two agents instead of one.** A builder makes the effect. A separate director only watches each version, from
  behind the character, from the side, from the front, from straight above and at night, plus frame-by-frame stills
  around every hit, and sends back one ranked list of at most 8 fixes. That repeats up to three times, then you rate
  the result and your answers are saved for the next effect.
- **It starts from tested parts.** `VFXKit` has building blocks that already survived many review rounds (slash
  strokes with a dark rim, an impact frame, a lightning bolt, shock rings, ground cracks, debris, smoke, camera shake,
  character poses), so the first version starts at a higher level.
- **Mesh slashes.** Sword and limb swings can use glowing mesh slashes that are fitted to the weapon's real path and
  turn with it, the way the brightest slashes in the library are made, instead of a flat picture stamped once.
- **Characters hold the weapon properly.** Two hands on the hilt, a step into each hit, guard poses between hits
  instead of a T-pose; the checklist has four animation checks for it.
- **It knows how professionals set their values.** A new pro guide covers brightness, dark outlines, flipbooks and
  timing, with numbers. The most common fault of AI-made effects (dim, matte, glow everywhere) is addressed first.
- **It checks itself before it shows you anything:** 37 yes/no checks every round.
- **Effects are built around the character, not the camera.** Nothing is tilted toward the screen to look better, so
  the effect holds up from every angle.
- **No special model needed.** The builder and the director run on Opus.
- The previous loop is still there: `/vfx classic <your effect>`.

## New in beta2
Five lessons from studying another agent's VFX research notes, rewritten for every effect type and tested in Studio
(VFXKit 1.3):
- **A reason next to every value.** Each layer says why it reads, which values carry that and which are free to
  change. The builder writes it, the director sees what is safe to change.
- **Glow that does not pile up into a white blob.** Overlapping glowing layers are turned down together by one
  per-effect gain. It helps; it cannot save a heavy stack, so the guides now say to keep few glow layers.
- **Flowing walls and pillars.** A new block builds fire, water, lava, energy or wind sheets from several scrolling
  beams, in rows or a ring so it reads from the side and from above, not as one flat sheet.
- **Textures you can and cannot recolour.** Every texture is marked as tintable (white art) or with its colour baked
  in, and a recolour helper only tints the tintable ones.
- **Something stays after every hit.** A faint, low, outward aftermath (dust, glints, small arcs) for 1-2 seconds.

### beta2 update: big picture first (from the fire wall test)
The fire wall came out as a flat billboard of realistic flames: one height, a straight top, square ends, a long
still hold, muddy smoke over the peak. Fixed for every effect type, not just walls:
- **The brief** now names at least 3 beats that each look different, one hero shape that reads on its own (a
  silhouette, not a texture area), and for held or placed effects how the hold stays alive. The style defaults to
  your game's look (stylised for Roblox) unless you ask for realism, and the brief says which texture families fit.
  A caster link is only asked for cast moves.
- **The director** starts every round with the big picture (silhouette, beats, style, the read from the player
  camera) before any detail; below 8/10 it may not "keep" the main shape, and a weak big read is fix number one.
  Smoke may not cover the hero at its peak. The final version gets a director score when the budget allows.
- **Walls, falls and pillars** (`fx:Curtain`) no longer stand at one height: uneven skyline, tapered ends, surges
  and flare-ups during the hold, a collapse wave; a soft dark layer (no dark rectangles), per-layer colour and
  transparency ramps and a height hook for your own curves.
- **Lint** warns when more than 4 glowing layers stack on one spot at one moment.

## What we measured so far
Early numbers from the maintainer's own tests (one run each, not a blind poll yet):

| Test | Result |
|---|---|
| Fire punch combo, builder + automatic director, 3 versions | director 6.0 -> 6.8 -> 7.3; a separate blind AI reviewer gave the final 6.3 (directors rate their own build about a point high; that blind reviewer runs about a point harsher than people) |
| Lightning strike, `/vfx` in a clean session (this beta, end to end) | director 6.0 -> 7.0 -> 7.6 over 3 rounds, 4 versions; about 70 min and $28 at API prices (Opus) |
| Sword combo with a lightning finisher, directed by hand through the same loop | rated 8/10 by a person |
| One builder round | about 25 minutes |

A blind comparison against 0.1.6 and against no plugin has not been run yet. That is what this beta is for.

## Install
You need Claude Code, Roblox Studio with the Studio MCP connected, and Python 3 with Pillow.
```bash
claude plugin marketplace add Frxctured/roblox-vfxmith#beta
claude plugin disable vfxmith@vfxmith          # only if the stable version is installed
claude plugin install vfxmith@vfxmith-beta
```
No SSH key for GitHub? Run `export CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` first.
Already on the beta: `claude plugin marketplace update vfxmith-beta`, then `claude plugin update vfxmith@vfxmith-beta`.

## Use
In Claude Code: `/vfx <your effect>`, for example `/vfx a fire punch combo` or `/vfx a lightning sword slash`. It
asks a few short questions, then builds in your open Studio place (Edit mode, in its own `LAB_...` folder, on a small
test stage: an empty place is best). Expect about an hour for a full run with three director rounds. It tells you the
score after each round; you can stop it or steer it at any time, and what you say outranks the director.

It works on Windows, macOS and Linux. Screen recording is not needed.

## What to send back
- what you asked for, and your answers to its questions;
- the result: a short screen recording, or the final sheet it shows you;
- your own rating from 1 to 10, and the director's scores per round (did they match what you saw?);
- how long it took and how much of your usage it took (`/usage` before and after);
- anything that broke, looked wrong, or felt slow. Especially: anything that looks tilted toward the camera, and
  whether the captures worked on your system.
Open an issue on the repository, or tell the maintainer directly.

## Go back to stable
```bash
claude plugin uninstall vfxmith@vfxmith-beta
claude plugin marketplace remove vfxmith-beta
claude plugin enable vfxmith@vfxmith
```

## Known issues
- The building blocks cover melee moves, abilities, impacts and strikes best. For beams, projectiles, auras and
  loops the builder uses the kit's stage, cameras and checks but builds the layers itself, so results vary more.
- The result is one effect file that plays on the test stage. Putting it into your game is a separate step; ask for
  it afterwards.
- The test character is posed with simple keyframes. Stiff or odd poses can happen; say so and it will redo them.
- The capture needs a Studio MCP whose screenshot result names the saved image file (current versions do). With an
  older one the agents look at the screenshots directly, which costs more.
- On a machine where the Studio window is hidden or minimised, stills can show an older frame. Keep Studio visible.
- The AI director's scores jump around by about a point between rounds. Trust your own eyes over its number.
