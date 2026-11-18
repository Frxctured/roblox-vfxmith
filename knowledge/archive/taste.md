# Taste: what people liked and disliked in real effects

Read this before designing (builders) and before scoring (reviewers). It is built from human answers about finished
effects (`feedback/*.md`) and blind polls, not from AI reviews, and it overrides any rule elsewhere that disagrees with
it. Each rule says how much evidence it has: one person's answer is a lean, not a law. Rules are written for every
effect type; the effect named in the evidence is only where it was seen. Update it with the `vfx-feedback` skill.

## Craft over texture
- **Okay textures can look awesome; the craft is in how they are used.** (owner, 2026-11-16: "vfx isn't all about
  texture. You can have okayish textures but make them look awesome") Timing, motion, layering, scale, colour and
  composition decide the look. Pick a fitting texture and move on; spend the effort on how the layers move and
  stack, never on hunting for a perfect sprite.

## The bar
- **10 = professional, expensive work.** (owner, 2026-11-16) A casual viewer's 9 was the owner's 7, and his 8.5-9 goes
  to effects like the four reference auras in "Character effects" below. Score and aim on that scale.

## Size against the character
- **Size every beat in character heights (H = about 5 studs) and look at it beside a character.** (round 1: a sword
  slash about 1.3 H wide with a thin band was "a bit small; unclear what it is meant for", while the same combo's
  2.5 H finisher read; a 1.5 H missile hit was a pop on the target's chest. The four reference auras put a 1.4-3.4 H
  layer on the ground under a 1.2-1.3 H body envelope.) An attack must clearly out-size the body that makes or takes
  it: arcs 2-3 H with a band thicker than a limb, a hit that spills past the target's silhouette on every side. The
  brief's stud numbers are a floor.

## Smoke, dust and small particles
- **Smoke is a volume or it is nothing.** (round 1: "the smoke effect is kinda low quality" for 8 faint, separate,
  same-size puffs, each showing its whole sprite; a flat white dust cloud the same value as the pale character
  behind it hid the character) Puffs overlap by a third or more, start fairly opaque (Transparency 0.2-0.4), vary ~3x
  in size, carry two tones (darker core or underside, lighter edge), are born on the thing that makes them and move
  one way (rise, roll out, get pulled in) with Drag. Its value differs from whatever is behind it.
- **Leftover particles are designed, not sprinkled.** (round 1: "the particles at the end could be higher quality"
  for a dozen identical round dots drifting at 2-5 studs/s) Mix 3-4 size tiers and 2+ shapes (streak, glint, chunk,
  dot), mostly tiny (about 0.02-0.05 H across) and many; fast at birth, slowed by Drag, stretched along their
  motion, cooling white -> body -> deep and shrinking to nothing.
- **A payoff has three clocks.** (reference pulses; round 1's hits were over in ~0.15 s with nothing behind them)
  Sharp energy for 1-3 frames, the body for 0.15-0.3 s, then a tail of a DIFFERENT kind (cool, desaturated smoke,
  glints, a mark) for 0.3-0.8 s. Don't fade everything together.

## Value and contrast
- **Dark ink is a real layer, next to the brightest shape.** (all four references; round 1's pale blue-white hit on a
  pale target under a pale sky had no dark value and read weak in daylight) One hue family, values from near-black
  ink to a white-hot core. This is what keeps contrast in daylight and at night.
- **Exactly one dominant bright mass**; everything else is line art or dim. White only at 1-3 focal points, and
  hue-shifted (warm white for red/orange, cyan-white for blue, pink-white for violet), not flat #FFFFFF.
- **The character is never washed out.** Keep the body darker than, or a different value from, the effect around
  it; no pale haze, cage or cloud over a pale body.

## Motion and rhythm
- **Big structure holds still; the life is in textures, particles and brightness.** (references: structure pin-sharp
  in an 18 s average, interior never repeating. Round 1's aura did the opposite: one ribbon cage turning as a whole,
  the same in every frame, so it "barely moves")
- **Heartbeats: on in 1 frame, decay over 0.4-0.8 s, every ~0.7-1.1 s with jitter**, and a second layer answers in
  the same frames. Several unsynced periods (0.5, 1, 2, 4 s) plus random emitters, so no loop shows; every repeat
  differs while the average stays the same.
- **Lifetime by energy:** slashes, needles and lightning 1-3 frames (longer reads as a sticker); flames ~0.2 s;
  smoke and ink 0.3 s and up; embers 0.4-2 s. Don't ease electricity.

## Character effects (auras, buffs, charges; four reference auras the owner rates 8.5-9)
- **Most of it is on the ground:** the ground layer (sigil, rings, glow) is the biggest element, 1.4-3.4 H wide,
  feet buried in its glow. Huge power-ups may go 5-10 H and swallow the character on purpose.
- **One small accent at the head** in a hue shifted 30-50 degrees (eye glow, flames or steam around the head): the
  face itself stays clear; bright shapes cross it for a frame at most.
- **Asymmetry:** one tall accent (~2 H) or a second mass to one side. Perfect symmetry reads static.
- **Soft layers behind the body, hard bright ones in front**; a few thin outliers poke past the main envelope.

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
- **Solid fills are fine.** (owner, 2026-11-16: "solid fills arent bad") A flat, solid-colour shape (a filled
  crescent, a hard-edged disc, a solid streak) is a valid texture choice; don't avoid or down-rank it just for having no
  gradient.
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
