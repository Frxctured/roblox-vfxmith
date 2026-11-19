---
name: vfx-replicate
description: Copy a given reference Roblox effect as closely as possible (replicate mode) - from a frame sheet, a video, several stills or a gallery/library effect id - with a build-capture-compare loop against the reference at the same times, then a detail stage on zoomed crops (sparks, thin arcs, ragged flames, smoke edges, grain). Use for "/vfx replicate <reference>", "copy this effect", "match this", "replicate this", "make it exactly like this". Costs more than a normal /vfx run (roughly twice, estimated from one test); warns first.
---

# Replicate a reference effect

`ROOT` = `<base directory>/../..` (`${CLAUDE_PLUGIN_ROOT}`); quote it. Read `ROOT/START.md` for the kit
(`kit/stage.luau`, `kit/maketex.py`, `kit/TEXTURES.md`).

In the normal mode the design is yours. **Here it is not: the goal is to look like the reference.** Same parts, same
sizes on screen, same colours and blend, same timing. Where you can't tell what the reference does, pick the simplest
thing that looks the same in the frames.

## 0. Cost warning (first, before any work)
Send this to the user, then wait for the answer:

> Replicate mode copies the reference as closely as it can, which takes many build-capture-compare passes. That uses
> more of your plan than a normal `/vfx` run (about 4-7 points of the 5-hour window, about 20 minutes). Our one
> measured replicate run took 5 points and 21 minutes for 6 passes; it matched the big shapes and timing but not the
> small details. The detail passes added since then (zoomed crops, textures redrawn for sparks, arcs, flames and
> smoke edges) add about 3-4 more passes (about 0.8 points and 3-4 minutes each in that run, likely more with texture
> work), so expect very roughly 8-15 points and 35-60 minutes. That is a guess from a single test run, not a promise;
> a busy reference can take more. Go ahead, or use the normal mode instead (one look at the reference, then the
> effect is built its own way)?

If they choose the normal mode, use `vfx-make` and treat the reference as inspiration. In auto/headless mode (nobody
to ask), print the warning and continue.

## 1. Get the reference frames and their timeline
| Reference | How |
|---|---|
| frame sheet (gallery style, `t=` labels) | use it as is; `refcompare.py` splits it (gallery layout: 4 columns, 26 px title band; else `--ref-grid 4x2 --ref-head N`). Read the times off the labels; pass them with `--ref-times` if they are not the gallery's 0.03 0.1 0.2 0.35 0.55 0.8 1.2 1.8 |
| video | `refcompare.py` cuts it with ffmpeg. For your own look, cut stills too: `ffmpeg -ss <s> -i ref.mp4 -frames:v 1 ref_t<s>.png` at fixed times (e.g. every 0.05 s around the hit, then 0.1-0.3 s apart) |
| several stills | ask for (or estimate) the time of each; `--ref-times` |
| gallery/library id | `--ref <id>` finds `gallery/effects/*/<id>.jpg` and its times. For more moments, with Studio and the pack (`kit/scripts/get_pack.py`): `python3 -I "ROOT/kit/scripts/rbxcut.py" --id <id> --studio` and replay it with `ROOT/archive/kit/studio/VFXLibPlayer.luau` (`P.stills`) when that file is there (lab snapshots leave `archive/` out). Its frames show the effect without its own scripts |

Pick the **anchor**: the moment everything is timed from (the ground hit, the first frame, the release). Write the
reference times as seconds after it. Note how the reference was lit (dark stage, daylight, the place) and the camera
(distance, height, how big the character is on screen).

## 2. Break it into layers (by eye, written down)
Look at every frame large. List each visible element in a table in `NOTES.md`:

| element | from - to (s after anchor) | shape | colour | blend (additive glow / opaque) | size vs character | motion |
|---|---|---|---|---|---|---|

Typical: flash/star, dome or sphere, shock ring, swirl arcs, smoke ring, sparks, embers, cracks, decal, light.
Say what is NOT there too (no fireball, no rocks, no lingering smoke) - leaving things out matters as much as adding.
Use the biggest frames you can get: a 400 px gallery sheet hides most small details (for a library effect, replay it
in Studio or record it; for a video, cut full-size stills).

## 3. Build to the list
Build each row of the table with the kit (one clock, `S:sprite` / parts / beams / decals). Put the anchor at a fixed
effect time (e.g. `HIT = 0.2`). Match the lighting: if the reference was shot on a dark stage, compare on one too:
`Stage.light("dark")` (ClockTime 21) and `Stage.light("day")` to go back. Use the reference's camera framing as well
as you can.

## 4. Compare and fix (the loop)
Each pass:
1. Capture your effect frozen at `HIT + t` for every reference time t (`_G.BlindTestPlay(origin, HIT + t)`,
   `screen_capture`, `_G.BlindTestStop()`); save as `captures/pN/t<effect time>.png`, plus `base.png` = the empty stage
   from the same camera (it makes the numbers better).
2. Run
   ```
   python3 -I "ROOT/kit/refcompare.py" --ref <reference> [--ref-times ...] --ours captures/pN --ours-at <HIT> \
       --labels "Reference,Pass N" --out compare/pN
   ```
   Look at `compare/pN/sheet.png` (reference row over yours, same crop and time) and `curves.png`. The printed
   numbers (coverage, added light, opaque mass, warmth and hues, centre and spread, the fade) are hints for the eye,
   not a score.
3. Write the **3 biggest differences** in `NOTES.md` in plain words ("ours fades at 1.5 s, theirs by 0.9 s"; "ours is
   an opaque orange ball, theirs is a thin additive star"; "their swirl arcs are missing").
4. Fix those three. Tell the user "pass N of about 9-10: <the three things>" and show the sheet if they are around.

Do this until the big shapes, sizes and timing are roughly right (usually about pass 3). Then switch to the detail
stage.

## 5. Detail stage (from about pass 3: the small things)
Matching size and timing is not enough: the look lives in the small elements. In the ground-slam test the size and
timing were close but the reference had a ragged burst of sharp flame shards where ours had a soft glow and a needle,
thin tapered swirl arcs where ours had one blurry crescent, dozens of fine streaked sparks where ours had a few round
dots, and wispy, grainy smoke where ours was a smooth fog bank. Each pass from here:
1. Run refcompare as before; now look at `compare/pN/detail.png` first: the same box cut from the reference and from
   yours at 3 key moments, large, plus a "fine detail" row that shows only sparks, thin lines, ragged outlines and
   grain. Use `--crop x,y,w,h` (fractions of the frame) and `--detail-at` for other boxes and moments (e.g. the hit,
   the dome, the smoke edge). Also crop and enlarge frames yourself when you need to see something closer.
2. Write a **detail table** in `NOTES.md`, one row per small element, reference vs yours:

   | element | count | size / width | edge (crisp, soft, ragged, torn) | texture (grain, streaks, flat) | shape (taper, points, notches) | motion (streaking, spin, flicker) |
   |---|---|---|---|---|---|---|

   e.g. "sparks: ref ~40 at +0.1 s, 3-8 px, streaked 4:1 with a white head, flung radially; ours 5 round dots".
   The printed small-detail numbers (specks and their size and streaking, thin lines, grain, edge density, how
   ragged and how crisp the bright burst is) point at where to look; they inform, they do not gate.
3. Fix the **3 biggest detail gaps**. Many details come from the **texture**, not the emitter: pick a library texture
   that already has the right grain, raggedness, taper or thinness, or draw it with `kit/maketex.py` (`flame_burst`,
   `flame_shard`, `arc`, `swoosh`, `spark_streak`, `smoke_wisp`, `glint`, `crack_line`, `glitter`, with
   `--set ragged=.. taper=.. thickness=.. grain=..`; `--sheet` shows them). Then the emitter: count (Rate / burst),
   Size spread, Squash or VelocityParallel for streaks, Rotation, LightEmission, Transparency curves.
4. **A soft round blob never stands in for a ragged, streaky or thin element.** If the reference has jagged flame
   shards, thin tapering arcs, streaked sparks, wispy torn smoke edges, star glints or hairline cracks, yours must
   have that shape too, even small. A glow or puff of the right colour and size is not a match.
5. Tell the user "pass N (detail): <the three things>" and show `detail.png` if they are around.

Stop after about 3-4 detail passes (about 9-10 passes in all), or earlier when the user says it is close enough, or
when the zoomed crops show no clear difference left. After the dark-stage match, check the final once in the place's
daylight (`Stage.light("day")`) and say how it reads there.

## 6. Deliver
`final.luau` as in the normal mode, `NOTES.md` (layer table, detail table, the differences per pass, what still
differs, small details included) and the last `compare/pN/sheet.png` and `detail.png`.
