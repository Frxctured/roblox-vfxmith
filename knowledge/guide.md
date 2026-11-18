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
Write a 5-line brief before searching:
1. **What it is** in plain words, split into parts (cast / travel / impact / linger; or body + ground + accents).
2. **Where it lives**: on the ground, on a character (aura, buff), between two points, flying.
3. **Scale** in character heights H (about 5 studs). Attacks clearly out-size the body (arcs 2-3 H); auras put a
   1.4-3.4 H ground layer under a 1.2-1.3 H body envelope; a hit spills past the target on every side.
4. **Timing**: total length, the contact frame, how long the residue stays.
5. **Palette**: the identity hue, one support, a dark remnant; importance tier (basic hit < spell < ultimate).

## 2. Choosing compositions
- Run `compose.py "<request>"`; it returns 3 candidates per part. Read the layer tables: what is the primary
  element, is there a ground layer, a dark partner, a flash, thin lines?
- **Look before choosing.** Load the 2-3 most promising (one-piece specs) and capture 2-3 frames of each. Pick by
  what you see: a clear big shape, 2-tone hard shapes, a readable silhouette, nothing muddy. Numbers alone mislead.
- A good candidate already has most of: one primary element, a dark partner, a ground anchor, a flash, fine lines,
  tiered counts. Prefer the one that needs the least change.
- **Combining**: one piece per part (a pro projectile + a pro impact; a pro aura body + a pro ground ring). Keep
  each piece's internal timing; set only its delay and placement. Two pieces of different style families (cartoony
  cel vs realistic smoke) clash: pick pieces whose textures look alike.
- Match the meaning: straight, sharp shapes read as danger and speed; curves read as safe, magical, defensive. Sharp
  weapons get thin straight streaks; blunt ones get round ring bursts.

## 3. Adapting (what to change)
**Colour.** Shift the hue (`tint`, mode "shift") and keep each layer's saturation and value: that keeps the white
core, the dark partner layers and the colour travel the artist made. Pros move colour over a layer's life from a hot
attention colour (white-yellow, sky blue) through the theme hue to a dark saturated remnant (often violet, L ~10);
keep that. One hue family; a complementary hue only in a small, desaturated, low-opacity layer. Effect colour may
out-range the character (brighter, more saturated than the avatar), same hue family.

**Scale.** Scale whole pieces (`scale`), not single layers, so proportions stay. Check against the dummy.

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

## 5. Character effects (auras, buffs, casts)
- Most of an aura is on the ground: the ground layer is its biggest element and the feet sit in its glow.
- Soft layers behind the body, hard bright ones in front; the face stays clear; one small accent at the head in a hue
  shifted 30-50 degrees; one tall accent or a second mass to one side (perfect symmetry reads static).
- Big structure holds still; life comes from flipbooks, rotation and size curves (pro aura particles barely move,
  median speed 0.05 studs/s; ~half are 4x4 flipbooks).
- Pieces whose layers ride on rig parts (`rig parts: N` in compose output) go on the dummy with `on = "dummy"`.

## 6. Objective fault check (the only automated judgement)
AI judges disagreed with people about taste (they reversed human rankings and removed details people liked), so do
not score taste. After building, capture 6-8 moments over the effect's life and look only for faults:
1. **Nothing visible** at a moment where the brief needs something (a piece failed to load, all layers dropped,
   textures still loading: freshly loaded textures can show white or grey for a few seconds, re-capture).
2. **Missing part** of the brief (no impact, no ground layer, no residue when one was asked for).
3. **Wrong scale** against the dummy (aura smaller than the body, a "huge" blast at knee height, a hit that does not
   spill past the target).
4. **Off-frame or misplaced**: the effect is outside the shot, under the floor, floating above it, or facing away
   from -Z when it should go forward.
5. **Timing far off the brief**: much longer or shorter than asked, everything fading together, a flash that
   lingers, or no gap between beats that the brief wants.
6. **Colour off-brief**: the identity hue is wrong, or the tint washed every layer into one flat colour (dark
   partners lost).
7. **Broken frames**: grey placeholder squares (missing texture), giant blocks (an unscaled template part), particles
   frozen at age 0 (all dots).
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
