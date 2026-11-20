---
name: vfx-replicate
description: EXPERIMENTAL. Copy a given reference Roblox effect as closely as possible (replicate mode) - from a frame sheet, a video, several stills or a gallery/library effect id - with a build-capture-compare loop against the reference at the same times, per-element comparison (colours, timing, how neat or organic), then a detail stage on zoomed crops (sparks, thin arcs, ragged flames, smoke edges, grain), optionally with textures lifted straight from the recording. Use for "/vfx replicate <reference>", "copy this effect", "match this", "replicate this", "make it exactly like this". Costs more than a normal /vfx run (roughly twice); warns first.
---

# Replicate a reference effect (experimental)

> **Experimental.** In our fair tests the replicas matched the reference closely from the recording's own camera
> but not from other angles, or (when built from real 3D elements) lost detail such as the bolt shape and the
> fire texture. Expect a rough copy, not a match, and a higher cost than a normal run.

`ROOT` = `<base directory>/../..` (`${CLAUDE_PLUGIN_ROOT}`); quote it. Read `ROOT/START.md` for the kit
(`kit/stage.luau`, `kit/maketex.py`, `kit/TEXTURES.md`).

In the normal mode the design is yours. **Here it is not: the goal is to look like the reference.** Same parts, same
sizes on screen, same colours and blend, same timing. Where you can't tell what the reference does, pick the simplest
thing that looks the same in the frames.

## 0. Cost warning (first, before any work)
Send this to the user, then wait for the answer:

> Replicate mode is experimental: it gets the timing, size and layout close, but the result is a rough copy,
> not a match. It copies the reference as closely as it can, which takes many build-capture-compare passes. That uses
> more of your plan than a normal `/vfx` run (about 4-7 points of the 5-hour window, about 20 minutes). In our two
> measured full replicate runs (a ground slam and a busier lightning slam) it took about 8-10 points of the 5-hour
> window and 26-28 minutes each; a busy reference can take more. Go ahead, or use the normal mode instead (one look
> at the reference, then the effect is built its own way)?
>
> And one question: is this effect yours, or free to copy (open-source, licensed to you)? If so I can cut textures
> straight out of the recording (its real flame edges, crackles and smoke), which gets much closer. If not, I'll only
> use it as a guide and draw my own.

Lifting pixels from someone else's protected effect is copying their art: only lift when the user says the effect is
theirs or free to copy. Otherwise draw your own textures.

If they choose the normal mode, use `vfx-make` and treat the reference as inspiration. In auto/headless mode (nobody
to ask), print the warning and continue; lift textures only if the request already says the effect may be copied.

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

| element | from - to (s after anchor) | shape | colour | blend (additive glow / opaque) | size vs character | motion | region (x,y,w,h of the frame) |
|---|---|---|---|---|---|---|---|

Typical: flash/star, dome or sphere, shock ring, swirl arcs, smoke ring, sparks, embers, cracks, decal, light.
Say what is NOT there too (no fireball, no rocks, no lingering smoke) - leaving things out matters as much as adding.
The region column is a rough box where that element sits; refcompare can then measure each element on its own.
Use the biggest frames you can get: a 400 px gallery sheet hides most small details (for a library effect, replay it
in Studio or record it; for a video, cut full-size stills).

## 3. Build to the list
**One texture per element, the way the reference was made.** A pro effect is many emitters, each with its own small
texture: a smoke puff, a spark streak, a crackle, a flame tongue, a ring. Particles of that texture, spread through
space, are what give it volume: walk round it and the cloud changes shape. So for each row of the table, get one
texture for that element alone, by whichever of these gets closest:
1. **Lift a single piece** from the recording (only when the user says the effect is theirs or free to copy): one
   crackle, one flame tongue, one smoke puff, a few sparks, where it sits alone on a dark-stage frame.
   `kit/reflift.py` keys it out (the difference from the empty stage becomes the picture and its alpha), so it keeps
   the reference's own edges and grain:
   ```
   python3 -I "ROOT/kit/reflift.py" ref.mp4 --at 0.45 --auto 8 --sheet tex/lift_sheet.png       # separate pieces
   python3 -I "ROOT/kit/reflift.py" ref.mp4 --at 0.40 --box 0.42,0.35,0.05,0.06 --name crackle --grey
   python3 -I "ROOT/kit/maketex.py" --install my_fx --files tex/*.png
   ```
   `--grey` gives a white version to tint per particle with Color; `--mode dark` for smoke in daylight. A small box
   around one piece is the goal; a box around half the effect is a screenshot, not a texture.
2. **Find the closest existing texture**: `python3 -I "ROOT/kit/scripts/find_textures.py" "red lightning crackle"
   --sheet tex/find_crackle.jpg` searches the pro textures by name and look (one contact sheet; ids load in Studio as
   `rbxassetid://<id>`). Put it next to a crop of the reference element and pick by eye.
3. **Redraw it as accurately as you can**: `kit/maketex.py` shapes with parameters (flame_burst, flame_shard, arc,
   spark_streak, smoke_wisp, glint, crack_line, glitter, ...) or your own drawing code, compared side by side with a
   crop of the reference element until the edge, grain, taper and thickness match.

Then build that element the way the reference does: usually an emitter (or several) of that texture, with the count,
size spread, rotation, speed, spread and lifetime that make the same mass on screen, placed where the element really
is (the burst at the impact, the cloud at its height, a ring flat on the ground; size and depth from the scene, not
from screen position alone). Check it from the top and the
side too: a crowd of particles holds up from every angle.

Lifting a whole moment of the recording (a box around everything, or the full frame in strips) gives a near-perfect
match from that one camera and the same flat picture from every other angle; our tests did exactly that twice. It
can still be a quick first look at timing, but it doesn't stand in for the elements.

Build each row of the table with the kit (one clock, `S:sprite` / parts / beams / decals). Put the anchor at a fixed
effect time (e.g. `HIT = 0.2`). Match the lighting: if the reference was shot on a dark stage, compare on one too:
`Stage.light("dark")` (ClockTime 21) and `Stage.light("day")` to go back. Use the reference's camera framing as well
as you can.

Some things that often make a pro effect look organic rather than drawn (tips, not rules; use what fits):
- a mass (a burst, a flame, a smoke cloud) built from many overlapping semi-transparent pieces, each rotated, sized
  and timed a little differently, instead of one clean centred shape;
- additive glow mixed with normal-blend dark smoke or debris, with the dark parts inside and behind the fire as well
  as around it;
- textures with uneven edges and grain, colours that vary within one element (hot core, darker edges).

## 4. Compare and fix (the loop)
Each pass:
1. Capture your effect frozen at `HIT + t` for every reference time t (`_G.BlindTestPlay(origin, HIT + t)`,
   `screen_capture`, `_G.BlindTestStop()`); save as `captures/pN/t<effect time>.png`, plus `base.png` = the empty stage
   from the same camera (it makes the numbers better).
   Also capture two other views at a couple of key moments, e.g. top-down and from the side (90 degrees around), and
   look at them: does it still read as the same effect, centred where it should be, with depth? The reference shows
   only one view, so here you judge by eye; anything that turns into a flat card or drifts away from the impact
   point needs to move into 3D.
2. Run
   ```
   python3 -I "ROOT/kit/refcompare.py" --ref <reference> [--ref-times ...] --ours captures/pN --ours-at <HIT> \
       --labels "Reference,Pass N" --region burst=0.4,0.35,0.2,0.3 --region smoke=0.1,0.6,0.8,0.3 --out compare/pN
   ```
   Look at `compare/pN/sheet.png` (reference row over yours, same crop and time) and `curves.png`. The printed
   numbers (coverage, added light, opaque mass, warmth and hues, centre and spread, the fade) are hints for the eye,
   not a score. With `--region name=x,y,w,h` (one per element from your table) it also measures each element on its
   own: its peak and fade times, its main colours (hex, with `regions.png` showing them as swatches next to the
   crops), how symmetric its outline is (`sym`: neat stars, rings and discs score high, torn bursts low) and how much
   its brightness varies inside (`tone`: flat fills low, layered fire and smoke high). A good overall number can hide
   one wrong element; these show which. The hex colours can go straight into your ColorSequences.
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
3. Fix the **3 biggest detail gaps**. Many details come from the **texture**, not the emitter: lift it from the
   reference with `kit/reflift.py` when that is allowed, pick a library texture that already has the right grain,
   raggedness, taper or thinness, or draw it with `kit/maketex.py` (`flame_burst`,
   `flame_shard`, `arc`, `swoosh`, `spark_streak`, `smoke_wisp`, `glint`, `crack_line`, `glitter`, with
   `--set ragged=.. taper=.. thickness=.. grain=..`; `--sheet` shows them). Then the emitter: count (Rate / burst),
   Size spread, Squash or VelocityParallel for streaks, Rotation, LightEmission, Transparency curves.
4. A soft round blob of the right colour and size rarely reads like a ragged, streaky or thin element. Where the
   reference has jagged flame shards, thin tapering arcs, streaked sparks, wispy torn smoke edges, star glints or
   hairline cracks, giving yours that shape too (even small) usually closes the gap. The reverse happens as well:
   when ours is neater than the reference (a clean star where it has a messy burst, crisp arcs where it has soft
   ones), roughen and overlap it.
5. Tell the user "pass N (detail): <the three things>" and show `detail.png` if they are around.

Stop after about 3-4 detail passes (about 9-10 passes in all), or earlier when the user says it is close enough, or
when the zoomed crops show no clear difference left. After the dark-stage match, check the final once in the place's
daylight (`Stage.light("day")`) and say how it reads there, and once from a few other angles (top-down, side, low
behind) and say how it reads from each.

## 6. Deliver
`final.luau` as in the normal mode (with any lifted textures installed next to it), `NOTES.md` (layer table, detail table, the differences per pass, what still
differs, small details included, how it looks from other angles) and the last `compare/pN/sheet.png` and `detail.png`.
