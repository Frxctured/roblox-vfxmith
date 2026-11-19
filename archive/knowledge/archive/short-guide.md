# Short VFX guide (Roblox)

The one-page version. Values and recipes: `knowledge/pro-guide.md`. Blocks: `knowledge/vfxkit.md`.

Build with plain ParticleEmitters, Beams, Trails, Attachments and a few Parts, driven by one small Luau script. Look at
your own screenshots often and fix what you see. That is the whole method.

## What makes effects look good (from people rating real effects)
- **Craft over texture.** Okay textures look great when layered, timed and sized well.
- **Soft and crisp together.** Soft see-through layers (rings, haze, wind lines that wash out) carry the volume; a few
  crisp bright shapes carry the read. Many kinds and sizes of particles, never a few identical specks.
- **One dominant bright mass.** Everything else is dimmer or line art. White only at 1-3 focal points. A dark (ink)
  layer next to the brightest shape gives contrast; it must read on a daylight map too.
- **Size against the character** (about 5 studs tall). Hits and payoffs are usually 2-4 character heights.
- **Timing:** a short anticipation, a payoff that is on in a frame, then a slower decay; a small, see-through leftover
  that fades last. Fast things (sparks, lines) live 0.1-0.3 s; smoke and haze 0.6-1.5 s.
- **Motion:** big structure mostly holds still or moves with purpose; life comes from textures, particles and
  brightness. Curves must look continuous (enough Beam Segments, overlapping particles).
- **Endings matter:** the disappearance is a highlight, not a cut.
- **Smooth beats busy.** Raters punish effects that "don't look smooth": hard edges popping, gaps in trails, particles
  appearing in visible steps.

## Engine facts (measured)
- A ParticleEmitter's Size is the HALF-width (Size 4 draws 8 studs). Beam Width and Part Size are full widths.
- `ParticleEmitter.TimeScale = 0` freezes live particles exactly; also set Beam TextureSpeed 0 and stop your own tweens
  and clocks to freeze a frame.
- The first play after loading may miss textures: preload them (`ContentProvider:PreloadAsync`) before playing.
- Emitters far from the camera do not simulate: point the camera at the effect before playing it.
- Black-background textures only work additively (LightEmission 1). Check every version in DAYLIGHT; a black stage
  flatters dark layers and additive glow.
- A comment in the middle of a property line can swallow the rest of it; put notes on their own line.
- Every screenshot you take stays in your context: take few, purposeful ones (a sheet of 4-6 moments, from the
  player's view and from the side).

## Lessons from directed builds
Every builder made the same first-version mistakes; these fixed them:
- **Light is local.** A colour grade or strong lights that tint the whole world/floor look cheap ("pink paint"). The
  effect's light is a pool that falls off fast and travels with the hero; the rest of the world keeps its colours.
- **No stickers.** Hard spiky starbursts, flat discs and opaque swirls read as stickers. Flashes are soft and short
  (<= 0.1 s); rings are thin and mostly transparent; swirls are see-through layers.
- **Nothing that reads as a rod or box.** Trails/tunnels are soft round energy: overlapping soft puffs, a brighter
  core, twisting wisps, tapered streaks, ragged moving edges. A cylinder, slab or beam with straight edges = "pencil".
- **Energy, not a marble.** A hero orb is layered soft light (white core ~0.4 R, coloured body, feathered darker rim,
  specks inside); a hard reflective highlight makes it a glass marble. Keep a little shine, not a mirror.
- **Judge from the player's camera** (behind the caster, slightly right and above). The caster's body hides anything
  cast straight ahead: offset the casting point toward the hand. Check that a travelling projectile reads as moving
  AWAY from this camera (rays toward the vanishing point, light that leaves with it, no glow left at the first wall).
- **Glare kills the hero.** Any layer brighter than the hero (beam roots, flares, white glows) swallows it. The hero
  stays the brightest, clearest shape in every frame.
- **Check at night too.** ColorCorrection cannot whiten a black world (impact frames collapse at night): use a
  screen-space or far white layer; the place's Bloom can smear thin ink lines (turn it off for those frames).
- **Compare with the best existing versions** side by side at the same beats, find the beat where theirs hits harder,
  fix that beat. Then stop adding features and polish (popping, straight lines, day/night consistency).
- **Directed beats undirected.** Short rounds (one version, one contact sheet incl. player/side/bird/night views,
  specific feedback) improved every builder fast; dense consecutive stills or a live recording catch what single
  frames hide.

## Textures
Search ~10,000 known textures (open-source effects + the free VFX Studio library), ranked by quality:

    python3 -I kit/scripts/find_textures.py "purple energy sphere" -n 12 --sheet out.jpg
    python3 -I kit/scripts/find_textures.py --roles "core=energy orb; ring=shockwave ring; lines=wind lines" -n 8 --sheet out.jpg

Look at the sheet, then use a hit by its id (`rbxassetid://<id>`). A flipbook needs `FlipbookLayout` (Grid2x2 / 4x4 /
8x8 as listed), `FlipbookMode` and a framerate. `--flipbook` / `--single` filter.
