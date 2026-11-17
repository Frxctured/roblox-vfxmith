---
effect: golden sigil (recreation of a reference image), version 2
request: same as v1; v2 rebuilt from a deep region-by-region analysis of the reference
made_with: vfxmith 0.1.7-beta1 (no AI panel; owner reviewed)
rating: not given ("looks horrible compared to the original")
cost_usd: 18.29 (v1 + v2)
rater: owner
---

# Golden sigil recreation, version 2: owner's feedback

"idek what to give as feedback, ours just looks horrible compared to the original"

Maintainer's side-by-side reading (reference vs v2 at 3.8 s): every element moved closer (smoke inside the effect, two
soft ribbons, still eye glint, rays, dark floor), but the gap stays large because of art quality: the emblem and the
rune circle were drawn in code inside Roblox (EditableImage, low resolution) and read as clip art (flat, chunky,
blurry), the smoke is soft fuzz instead of a real billowing smoke texture, there is no overall haze/bloom tying the
layers together, and the layout differs (emblem lower and flatter, ribbons cutting across instead of sweeping around).

## Lessons (general, for any effect)
- Hero art (emblems, logos, sigils, magic circles, detailed symbols) can't be painted convincingly in code inside
  the engine. Make it outside Roblox at high resolution (a Blender mesh with bevels and emission, or a 1024-2048 px
  image drawn with anti-aliasing, gradients and inner glow) and upload it; or use a fitting library/VFX Studio texture.
- Smoke that matters to the look needs a real smoke texture or flipbook (billowing, lit edges, colour shift), not
  soft sprites.
- A recreation needs the reference's overall grade: haze, bloom, the light that ties the layers together.
- Match the composition first (positions, tilt, overlaps); details on the wrong layout still look wrong.
