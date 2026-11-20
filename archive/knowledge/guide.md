# vfxmith guide: craft rules for adapting pro effects

Short on purpose. The build starts from real professional effects (`kit/scripts/compose.py`), so most quality
decisions (textures, flipbooks, layer layout, counts, timing) are already made by a human artist. These rules tell
you what to keep, what to change, and what to check. Deeper notes: `python3 -I vault/_tools/vault.py "<question>"`.

## 0. The one rule
**Start from human compositions, don't invent them.** Models choose textures and layouts badly when they work from
numbers; code-made assets look generic (a slash becomes a plain arc, smoke a circle fading from its centre). So:
- Never draw a texture, flipbook or mesh in code, and never swap a pro texture for a generated one.
- A texture swap goes only to another pro texture in the same role (`compose.py --swap <id>`: same kind, same
  flipbook grid, used under the same layer names). If nothing fits, keep the original.
- Prefer removing layers, recolouring, rescaling and retiming over adding new layers. When you must add a layer
  that no candidate has, take it from another pro effect (a second piece), not from scratch.
- Values (Brightness, Size, Lifetime, counts) may be tuned freely; that part is easy and safe.

## 1. Reading a request
Write a 7-line brief before searching:
1. **What it is** in plain words, split into parts (cast / travel / impact / linger; or body + ground + accents).
2. **Where it lives**: on the ground, on a character (aura, buff), between two points, flying.
3. **Scale** in character heights H (about 5 studs). Attacks clearly out-size the body (arcs 2-3 H); auras put a
   1.4-3.4 H ground layer under a 1.2-1.3 H body envelope; a hit spills past the target on every side.
4. **Timing**: total length, the contact frame, how long the residue stays.
5. **Palette**: the identity hue, one support, a dark remnant; importance tier (basic hit < spell < ultimate).
6. **Style register**: grounded (photoreal, natural, believable), stylized (clean cartoon), anime / battlegrounds,
   cute / cosy, sci-fi, or another named one. Take it from the request's words ("realistic", "cute", "anime",
   "futuristic") or from the game; if nothing says it, write "unspecified" and do not default to battlegrounds just
   because the library leans that way. compose.py reads it from the request (`--style` to set it).
7. **Named elements**: list every thing the request names, with the time it must be on screen. Each one is a
   must-have that the fault check confirms in the frames. Example layout (not a template to copy):
   `| element | role | on screen from - to (s) |` with rows such as "the thrown object, travel, 0 - 0.6",
   "the cloud, linger, 0.6 - 4", "the caster, present, whole effect". Things the request implies but does not name
   (a ground anchor, a dark partner) are craft choices, not must-haves.

## 2. Choosing compositions
- Run `compose.py "<request>" --size <main size in studs>`; it returns 3 candidates per part, ranked by type match x
  style fit when the request names a style, with each candidate's style ("top grounded, grounded fit 0.83") and its
  estimated size and starting scale. Read the layer tables: what is the primary element, is there a ground layer, a
  dark partner, a flash, thin lines?
- **Look before choosing.** Load the 2-3 most promising (one-piece specs) and capture 2-3 frames of each. Pick by
  what you see: a clear big shape, 2-tone hard shapes, a readable silhouette, nothing muddy. Numbers alone mislead.
- A good candidate already has most of: one primary element, a dark partner, a ground anchor, a flash, fine lines,
  tiered counts. Prefer the one that needs the least change.
- **Combining**: one piece per part (a pro projectile + a pro impact; a pro aura body + a pro ground ring). Keep
  each piece's internal timing; set only its delay and placement. Two pieces of different style families (cartoony
  cel vs realistic smoke) clash: pick pieces whose textures look alike.
- Match the meaning: straight, sharp shapes read as danger and speed; curves read as safe, magical, defensive. Sharp
  weapons get thin straight streaks; blunt ones get round ring bursts.
- **Meshes**: when a piece's mesh in a named role (stone, ice, crystal, a thrown object) looks weak or is missing, do
  not replace it with primitive parts. `compose.py --meshes "<role words>" --style <style>` lists pro meshes for that
  role, ranked by how many effects reuse them (the closest thing to a rating the library has) and style fit; use the
  best one as a second piece. If none is good, keep the original and say so in the report ("library has no strong
  stone mesh"), so the owner knows the weak spot.

## 2b. Style register: adapting a piece toward the brief's style
The library is mostly battlegrounds / anime packs. Rank by style first (compose.py does it); then push the chosen
pieces toward the register with values only (drop, set, glow, count, speed), never with new textures:
- **Grounded / realistic**: fewer and softer flashes (one at most, under 1.5x the main radius, glow 0.3-0.6); more
  volume: keep or add smoke and dust that is lit by the scene (LightInfluence 0.5-1, LightEmission 0-0.2), slower
  rise with drag, longer residue; drop anime extras (star glints, speed-line rings, hard cel crescents, shockwave
  rings that are brighter than the fire); fire is mostly orange-yellow with dark smoke above it; Brightness mostly
  1-5. Pick textures that look like real smoke and fire (soft flipbooks), not cel shapes.
- **Stylized / clean cartoon**: crisp shapes: keep hard-edged two-tone sprites, fewer layers (drop fine noise and
  soft haze that blurs the silhouette), saturated flat colours, one clear flash, readable at a distance.
- **Anime / battlegrounds**: the library's home register: big flashes, impact frames, star glints, thin speed lines,
  high Brightness and bloom are expected. Still scale to the scene first.
- **Cute / cosy**: rounded shapes (hearts, stars, bubbles, sparkles), pastel or warm-pink support colours, soft
  bounce timing (ease-out, a small overshoot), no dark smoke or blood-red, low Brightness (1-5), no screen flash.
- **Sci-fi**: clean geometry (hex, rings, grids, thin beams), cyan / electric palettes with a white core, crisp
  lines over soft smoke, short sharp timing, a glitch or flicker accent; little smoke.
When two pieces of different registers must be combined, push the second one toward the first, not the other way.

## 2c. Streaks follow the motion path
Streaks, speed lines, trails and debris lines take the shape of the motion they show:
- **Swirl, orbit, vortex** (black hole, gravity well, tornado, whirlpool, spinning aura): arcs that curve along the
  spin and tighten toward the core (curved beams with CurveSize0/1, arc meshes, or particles with orbital motion).
  Straight segments placed in a ring read as a broken polygon, not a spin.
- **Radial burst, dash, impact, thrust**: straight lines along the motion are right.
This is not a preference for curved meshes: a straight streak is correct when the motion is straight. Check it from
straight above: arcs that look right from the side can turn into straight chords from the top.

## 3. Adapting (what to change)
**Colour.** Shift the hue (`tint`, mode "shift") and keep each layer's saturation and value: that keeps the white
core, the dark partner layers and the colour travel the artist made. Pros move colour over a layer's life from a hot
attention colour (white-yellow, sky blue) through the theme hue to a dark saturated remnant (often violet, L ~10);
keep that. One hue family; a complementary hue only in a small, desaturated, low-opacity layer. Effect colour may
out-range the character (brighter, more saturated than the avatar), same hue family.

**Scale first, before any styling.** Pro pieces come at their artist's scale (battlegrounds moves are often 20-40
studs across; alpha1's stone spikes were "huge" and its meteor flash filled the camera). Before tint, glow or timing:
1. `C.measure()` (or the size line in compose.py) for every loaded piece: width, height, the largest single layer
   (a flash, a smoke sprite, a part), light range.
2. Set each piece's `size` to the brief's studs for that part (`sizeBy = "height"` for pillars and spikes,
   `"largest"` for a flash), against the R15 dummy (5 studs). Typical: a hand-sized cast 1-2 studs, a hit 6-10, a
   ground slam 12-20, an ultimate 30+; but the brief's numbers win.
3. Check the largest layer: a single sprite much bigger than the piece (a 150-stud flash in a 10-stud blast)
   swamps the shot: shrink it with `set` (Size) or drop it. `C.coverage(origin)` from the capture camera says how
   much of the frame it covers.
Scale whole pieces, not single layers, so proportions stay; single layers only for the largest-layer fix.

**Timing.** Use `speed` per piece for slow/fast, `delay` to sequence pieces. Keep the pro ratios:
- Flash: huge (1.5-5x the main radius) and brief (2-3 frames, 0.05-0.1 s), replaced by the next layers, not faded.
- Bright body about 0.3 s on an impact; dark residue (smoke clump, scorch, cracks, etched circle) 0.6-1.5 s more.
- Rough ratio flash : body : residue = 1 : 4 : 10. Repeated abilities get a short linger; one-shot hero moments may
  keep a long ground mark.
- Ease out on expansions (most distance in the first moments); nothing important is linear.

**Counts and brightness.** Pros emit small tiered counts on the contact frame: 1-2 big sprites, 7-15 shards or
sparks, more for fine dust. Particle Brightness median about 5, p75 15, a few accents 100+; with LightEmission 1,
Brightness above 1 pushes into bloom. In-game Bloom roughly doubles additive glow: an effect that is already blinding
in the edit viewport is too strong in play. About 1 in 7 pro emitters use negative LightEmission (dark backing).

**Removing.** Drop layers that do not serve the brief (a sword-trail layer in an impact you reuse as a ground
slam). Keep at least: the primary, its dark partner, the ground anchor, and the residue.

## 4. What good looks like (check these in your frames)
- **One primary element** with a clear silhouette and the widest value range; secondaries are smaller, softer, more
  transparent and move less. If two things fight to be primary, demote one.
- **Dark partners**: almost every bright layer has a dark alpha layer beside or behind it (black smoke in fire, a dark
  twin arc behind a slash, a black crack decal under a glow). An effect that is only additive light looks cheap.
- **Hard two-tone shapes**: big shapes are hard-edged cel shapes, light core and darker rim, lopsided with 3-4 spikes
  of different length. Softness lives only in a separate glow layer behind the shape (1.5-2x its size).
- **Hair-thin lines** (rays, dashes, dotted rings, tracers, streak sparks) carry detail; fat streaks don't.
- **Ground anchor**: nearly every pro effect touches the floor (glow pool, scorch/crack decal, thin rings, etched
  circle), even air bursts. The ground layer is flat and radial, the body vertical or curved; the ground layer is
  usually the last thing on screen.
- **Endings break up**: big shapes erode, thin to a line, split into dashes or pieces; only soft layers fade
  uniformly.
- **Shape variation**: big, medium and small sizes; asymmetry gives direction; never one size for a whole layer.
- **Value**: one dominant bright mass; white only at 1-3 focal points, under about 5% of the frame at the peak;
  avoid pure 0 and 100% values; check that the effect still separates from the ground in greyscale.
- **Smoke is a volume**: puffs overlap by a third or more, start fairly opaque, vary ~3x in size, two tones, move
  one way with drag.
- **Built in the caster's space**: forward is the caster's -Z (the dummy faces -Z), never tilted toward the camera;
  an effect that reads only from one angle is broken. Check a top-down view too.
- **Streaks follow the motion path** (section 2c): arcs for spin, straight lines for bursts and dashes.

## 5. Character effects (auras, buffs, casts)
- Most of an aura is on the ground: the ground layer is its biggest element and the feet sit in its glow.
- Soft layers behind the body, hard bright ones in front; the face stays clear; one small accent at the head in a hue
  shifted 30-50 degrees; one tall accent or a second mass to one side (perfect symmetry reads static).
- Big structure holds still; life comes from flipbooks, rotation and size curves (pro aura particles barely move,
  median speed 0.05 studs/s; ~half are 4x4 flipbooks).
- Pieces whose layers ride on rig parts (`rig parts: N` in compose output) go on the dummy with `on = "dummy"`.

## 6. Objective fault check (the only automated judgement)
AI judges disagreed with people about taste (they reversed human rankings and removed details people liked), so do
not score taste. After building, capture 6-8 moments over the effect's life, one frame with the dummy beside the effect at its
widest (size), the peak frame from the standard camera (coverage) and one top-down frame, and look only for faults:
1. **Nothing visible** at a moment where the brief needs something (a piece failed to load, all layers dropped,
   textures still loading: freshly loaded textures can show white or grey for a few seconds, re-capture).
2. **Missing part** of the brief (no impact, no ground layer, no residue when one was asked for).
3. **Wrong scale**: more than 30% off the brief's stated size (measured with `C.measure()` and seen against the
   dummy in a frame where both are visible), or the largest layer covers more than 60% of the frame height at the
   peak from the standard camera (`C.coverage`) when the brief does not ask for a screen-filling moment. With no size
   in the brief: an aura smaller than the body, a "huge" blast at knee height, a hit that does not spill past the
   target.
4. **Off-frame or misplaced**: the effect is outside the shot, under the floor, floating above it, or facing away
   from -Z when it should go forward.
5. **Timing far off the brief**: much longer or shorter than asked, everything fading together, a flash that
   lingers, or no gap between beats that the brief wants.
6. **Colour off-brief**: the identity hue is wrong, or the tint washed every layer into one flat colour (dark
   partners lost).
7. **Broken frames**: grey placeholder squares (missing texture), giant blocks (an unscaled template part), particles
   frozen at age 0 (all dots).
8. **Named element missing**: go down the brief's named-elements list (section 1, line 7); each element must be
   visible in the frames at its time (the thrown object during travel, the cloud still there at its linger time, the
   player present). One missing element is a fault even if everything else is fine.
9. **Streak against the motion**: straight streaks on a swirl / orbit / vortex, or curled lines on a straight dash
   or radial burst (section 2c). Check the top-down frame.
10. **Style register opposite the brief**: e.g. a grounded brief with anime flash stacks, star glints and speed-line
   rings; a cute brief with dark smoke or blood red; a sci-fi brief with soft campfire smoke. Only the opposite
   register is a fault; "could be more realistic" is taste.
Fix each fault with the smallest change (placement, scale, delay, drop, tint strength) and re-capture only the
affected moments. Do not keep iterating on taste.

## 7. Roblox and Studio facts that bite
- `game:GetObjects("rbxasset://vfxlib/<name>.rbxmx")` loads a file from Studio's content folder and caches by URL:
  a changed file needs a new name (kit_push.py does this).
- ParticleEmitter TimeScale is 0..1; Emit(n) on a disabled emitter fires once; Rate keeps streaming while Enabled.
- Beam TextureSpeed > 0 moves the texture from Attachment0 to Attachment1; a Beam needs both attachments.
- A Part with Transparency 1 still carries its attachments and emitters (pros use invisible carrier parts).
- Edit mode: particles and Heartbeat run, physics does not; anchored parts only.
- Never create Script instances and set their Source from execute_luau (it has crashed Studio). Keep everything in
  one Luau file run through kit_push.py.
- Use only textures and meshes the pieces already reference (asset ids). Do not upload anything.
