# vfxmith 0.1.9-beta1 (beta channel)

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
- **It knows how professionals set their values.** A new pro guide covers brightness, dark outlines, flipbooks and
  timing, with numbers. The most common fault of AI-made effects (dim, matte, glow everywhere) is addressed first.
- **It checks itself before it shows you anything:** 28 yes/no checks every round.
- **Effects are built around the character, not the camera.** Nothing is tilted toward the screen to look better, so
  the effect holds up from every angle.
- **No special model needed.** The builder and the director run on Opus.
- The previous loop is still there: `/vfx classic <your effect>`.

## What we measured so far
Early numbers from the maintainer's own tests (one run each, not a blind poll yet):

| Test | Result |
|---|---|
| Fire punch combo, builder + automatic director | 6.0 after the first version, 6.8 after one director round (AI director's own scale, which is about a point harsher than people) |
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
