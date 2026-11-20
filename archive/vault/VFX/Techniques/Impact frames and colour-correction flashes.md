---
title: Impact frames and colour-correction flashes
tags: [vfx, timing, impact, camera, technique]
type: technique
updated: 2026-11-18
source: https://www.youtube.com/watch?v=Rexby2jBmRY (ghxstying, 02:50-07:56, 18:20-20:16); https://www.youtube.com/watch?v=RKX4zPPAsAA (Hazaze, 02:31-02:39, 05:42); https://www.youtube.com/watch?v=XXCGWREKpo0 (MoldySugar, 08:54-10:22)
---
# Impact frames and colour-correction flashes

> TL;DR
> - An impact frame is a 2-4 frame moment where the whole screen goes black-and-white (or inverted) exactly as the hit particles appear; anime fights use it and Roblox VFX artists copy it.
> - Made with one ColorCorrectionEffect: Saturation -1 and Contrast +5 (black-and-white), Contrast -5 for the inverted white frame, Brightness -1 on the black frame, 0 otherwise; then back to the base.
> - Values are held, not eased (easing None): each flash frame lasts ~3 frames at 60 fps (keys at 72, 75, 78 seen).
> - Timing is everything: the flash must coincide with the burst frame; one frame late looks bad, so artists nudge it by single frames.
> - Pair it with a Highlight outline that fades in during the charge and peaks at the release, and a short camera FOV kick.

## Recipe (from ghxstying)
1. Add a ColorCorrection in Lighting; key its base values with easing None for the whole clip.
2. On the burst frame: white frame (Contrast -5, Saturation -1), next: black frame (Contrast 5, Saturation -1, Brightness -1), then base. About 4 frames total.
3. Adjust contrast to the scene's lighting ("5 or maybe more").
4. Scrub to the frame and check the silhouettes: the slash crescent and sparks must read as clean shapes in pure black/white. If a layer clips through as a black blob, fix that layer.

## Around it
- Highlight on the attacker: OutlineTransparency from 1 to visible over the charge, stop at the release (frame 96 seen).
- Camera: slow eased CFrame drift through the charge, then several short keys around the release; FOV zoom-out with the release flare.
- Hazaze adds tweened light sources and impact frames on top of particles on the big hits only; the finisher fills the screen with a white starburst for a few frames.

## Scripted tinted flash (MoldySugar)
- Code-only version: create a NEW ColorCorrectionEffect in Lighting per hit (Contrast 30, TintColor matched to the effect, e.g. (128,0,128)/255), after 0.04 s switch to Saturation -1 / Contrast 3, after another 0.02 s Destroy. About 3-4 frames total; destroying instead of restoring means overlapping hits never leave the screen stuck.
- "Tweak the saturation and contrast to fit the color" - the tint alone is not enough.
- His showcase effects hold it longer: the scene collapses to 2-3 flat colours (yellow/black/green, cyan/blue/white) with the effect's silhouette in white (09:21-10:22). Fired on the same frame as the burst, camera shake (ShakeOnce magnitude 4, roughness 10) and rock debris.

## Runtime (ours)
- Client-only, local player's own big hits (or hits they receive): set ColorCorrection properties directly, wait 2-3 frames (task.wait on RenderStepped count), set the next, restore. Never tween.
- Rate-limit it: once per move, never in rapid combos; offer a setting to turn it off (flashing screens).
- Related: [[Syncing effects to a character animation]], [[Value, contrast and glow]], [[Silhouette-first reading]], [[Anticipation, climax and dissipation]].
