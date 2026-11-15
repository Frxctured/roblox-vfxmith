# Taste: what people liked and disliked in real effects

Read this before designing (builders) and before scoring (reviewers). It is built from human answers about finished
effects (`feedback/*.md`) and blind polls, not from AI reviews, and it overrides any rule elsewhere that disagrees with
it. Each rule says how much evidence it has: one person's answer is a lean, not a law. Rules are written for every
effect type; the effect named in the evidence is only where it was seen. Update it with the `vfx-feedback` skill.

## Glow and light
- **Less glow; let the shapes carry the look.** (owner feedback, ice slam; test 7 panel: the 0.1.6 ice was "the most
  blown out of five")
  - Solid hero shapes (crystals, rocks, blades, shields) stay non-glowing while they hold: SmoothPlastic / Glass, or
    sprites at LightEmission 0.3 or less. Neon or white-hot only for 2-4 frames (a birth flash or the warning before a
    break).
  - Flashes are short: full white for 0.1-0.15 s, then gone or cooled to the body colour.
  - One effect light, kept to the effect's own area: Range about 1.6x the effect's radius, Brightness 3 or less at
    the peak, off within ~0.3 s, and no second light pop later (it lights the whole scene before the moment it is
    for). Measured: the preferred ice slam (Range 12, Brightness 3, off by 0.55 s) changed 21% of the screen at the
    hit; the over-glowing one (Range 20, Brightness 6, a second pop at the break) 52%, still 49% at 0.5 s.
  - Wind-up light stays low (at most ~1/5 of the peak's lit area), so the hit is a jump: the preferred version's lit
    area grew 6.4x at contact, the other only 1.3x.
  - Particles keep Brightness 1 unless one layer must stand out; mist and smoke on natural materials stay at
    LightEmission 0.1-0.15 (glowing mist reads as more glow, not as cold air).
  - White: under ~5% of the frame at the peak, under ~0.5% within 0.2 s, near zero in holds.
  - No permanent halo or bloom layer around a hero; glints on tips and edges instead.

## Colour
- **Saturation should suit the effect and the material; more is not automatically better.** (owner, ice slam: "Saturated
  color can be bad. In this case, it wasn't", but the best ice "being a little less saturated would make it even
  better"; test 5 poll: a vivid azure ice came second, above paler, washed-out ones)
  - Avoid both washed-out grey-white and neon-loud: a clear value range (white core or tips, a body colour, a deeper
    tone) matters more than how saturated the body is.
  - For natural materials (ice, stone, water, smoke) lean slightly below full saturation; magic energy and fire can go
    higher.

## Endings and what stays
- **The break or disappearance is a highlight.** (owner: the favourite moment was "when the ice crystals exploded, when
  the thing disappeared ... the effects that popped out")
  - Design each object's ending: it shakes or glints as a warning, the object ITSELF turns white-hot for 2-3 frames
    (at 60 fps) and breaks in one frame into a stump and 3-7 pieces, small things pop out (chips, dust, a glint star),
    and the breaks travel (centre outward over ~0.15 s) so you see many separate pops. No scene-wide flash or light
    pop before the break. Pieces land and rest at least ~0.25 s.
- **Residue stays for the whole linger.** (owner: liked "how it stayed a bit there"; 0.1.6 removed its frost about 0.5 s
  too early)
  - Ground marks, frost, scorch, puddles and small leftovers hold at 90% or more until about 80% of the asked linger,
    then fade slow-at-first (ease in, not quad-out) by its end, ending softly (no hard cut with the mark still showing).
    The residue must read in daylight: clearly visible, not a faint decal.
  - Reviewer advice must not remove what people like: 0.1.6 lost its frost, its resting shards and its per-crystal
    break flash because it followed "frost plate", "shards freezing" and "crown goes white" literally. Fix how such a
    thing looks; don't shorten or remove it.

## Shapes and craft
- **Animated, textured rings and shockwaves, not plain fading discs.** (owner, ice slam: preferred 0.1.6's ring,
  "textured ... with animated frames", over the no-plugin "simple fading out circle", even though he preferred the
  no-plugin effect overall) Use a flipbook ring texture played once over the ring's life (`FlipbookLayout` 4 or 8,
  `FlipbookMode = "OneShot"`; find one with `kit/scripts/find_textures.py "shockwave ring" --flipbook`), expanding
  and thinning out. Keep it within the glow rules: textured detail, not a bright halo.
- **Designed, characterful hero shapes.** (test 5 poll; owner: the ice spikes were "very good")
- **Soft effects use soft particles.** (owner, healing aura 7/10: the plus sparkles looked "too pixely, for a healing
  effect like this I'd expect them to be soft") Check each texture's effective resolution against its size on screen
  (`texture_traits.py`, the `eff` trait) and pick soft, high-resolution art for gentle effects.
- **Curves look continuous.** (healing aura: "I can tell each segment apart ... not fully smooth") Spirals, ribbons and
  trails need enough Beam segments or curved Beams/Trails with overlapping joins; check the joins in a close-up.
- **Basic stretched sprites look cheap.** (test 6 poll: the plain fire tornado looked "made of REALLY basic
  parts/textures (stretched ovals only basically) and just low quality") Vary shapes and sizes; use fitting textures or
  geometry, not the same oval stretched everywhere.

## Recreating a reference (owner, golden sigil v1: 5/10)
- **Read the reference deeply first:** every element zoomed, its details, edges, inner shading, colours and the soft
  light it throws. A quick read gave "the emblem looks cheap" and "way more particles in the original".
- **Smoke and atmosphere belong to the effect:** wrapped around and through it at its depth, overlapping the hero,
  never a separate cloud in the background.
- **Nothing extra:** no element the reference or the person didn't show or ask for (an unexpected third beam stood out).
- **Match the reference's colours inside streaks and beams:** copy the colour bands the reference shows (in the golden
  sigil: darker and brighter streaks, "black ... and also white, like between gold"); don't flatten them into one
  bright colour that outshines the rest (v1's grabbing beams were "too white compared to the rest").
- **Rich, varied particles:** many kinds and sizes (stars, glints, motes, embers), not a few plain specks.
- **Glints stay where the reference has them:** a glint that scrolls across the hero reads as a glitch.
- **Hero art is made outside the engine, at high resolution.** (golden sigil v2: an emblem and rune circle painted in
  code inside Roblox read as clip art next to the reference, "ours just looks horrible compared to the original")
  Emblems, logos, sigils and magic circles: a Blender mesh (bevels, emissive details) or a 1024-2048 px image drawn
  with anti-aliasing, gradients and inner glow, uploaded; or a fitting library/VFX Studio texture. Code-drawn images
  are for simple masks and gradients only. Smoke that carries the look needs a real smoke texture or flipbook.
- **Match the composition and the overall grade first:** positions, tilt and overlaps, then the haze and bloom that tie
  the layers together; details on the wrong layout still look wrong.

## Who it is for
- Effects should be good enough to ship as is in a fighting or ability game (owner: "I would use it as is").

## House examples (effects people rated 8 or higher)
`library/house/INDEX.md`: the effect files, frames and a note on what makes each work. Learn from them; don't copy them.
