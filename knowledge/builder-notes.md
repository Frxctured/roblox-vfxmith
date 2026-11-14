# Builder notes: read this instead of the whole knowledge folder

The rules that decided three blind tests (2026-11-14), the traps that cost the most time, and the token rules. With
`spec-format.md` (the effect format) and the category study's anatomy and timing tables, this is all a builder needs
to start. Open the long notes (`patterns.md`, `gotchas.md`, `texture-vocab.md`, `os-conventions.md`) only for a
specific question: `grep -n` the term, then read that section with `sed -n a,bp`.

## Keep it cheap (most of a build's tokens are context re-read every turn)
In blind test 3 the 0.1.5 full loop cost 3.3x a plain agent. About two thirds of its context by the end was 128
screenshots it had taken one by one, and every one of its 212 turns re-read them. The reviewers were only 13%.
- **Never capture frame by frame yourself.** Take at most ONE framing shot per version (`C.hold` + `screen_capture`).
  The `vfx-capturer` helper (fast model) takes the timeline on both backdrops and returns one sheet per backdrop.
- **Look at one sheet per backdrop per version.** Open a single full frame only when one moment is disputed.
- **Get references from the librarian** (`vfx-librarian`, fast model): it reads the cards and returns the values to
  copy. Do not read library cards, `texture-vocab.md` or the runtime source yourself.
- **Edit, don't rewrite**: change the spec with small edits; never write the whole file again.
- **One Studio call per step**: re-install the spec and return `C.check` in the same `execute_luau`.
- **Keep tool output short**: pipe long output through `head`/`tail`; never `cat` a whole long file.
- **Stop at two panels** (vfx-make step 7). In test 3 the third panel moved the builder's own score 6.17 -> 6.33.

## Sizes, timing and the check
- A particle's `Size` is its HALF-width (Size N = 2N studs across); beam widths and part sizes are full widths. On
  screen at 1080p and FOV 70, a particle is about 1540 x Size / distance px across, a beam about 770 x width / distance.
- Size every beat to the brief's numbers in studs. In test 3 one shockwave came out 24-28 studs against 15-20 asked
  (shape reviewer) and another about 13: both lost points.
- After every edit: `C.check("<Name>", { length = <the brief's length in s> })`. Fix every ERROR and WARN. It also
  reports the peak particle count, bright-white streaks, the widest particle and when the effect is last visible.

## Look (patterns.md 15 in short)
1. **Daylight decides.** Tune on `C.stage("day")` (or the user's map), check the void stage too. Dark layers stay thin
   and saturated (purple-black, blue-black, amber-brown) and cool to translucent grey-violet; a solid black puff, or a
   grey-blue mist, reads as dirt.
2. **One hero shape per beat.** About 25 bright-white streaks or needles at most at any beat; 2-3 white layers at most
   overlapping.
3. **The payoff is the biggest and brightest beat**, sized per the brief (a signature move fills ~1/3 of the screen at
   gameplay distance), then an aftermath that ends at the brief's length. Ending early (an empty screen) reads as a hard
   cut; running long reads as muddy.
4. **Anticipation and no dead air.** At least ~0.2 s of wind-up (0.5-1.5 s for a big move). Keep the collapsing or
   charging shape on screen until the payoff fires (a hot slit shrinking to a pinpoint); a quiet beat is ~0.05-0.1 s,
   not an empty frame.
5. **Repeated beats differ and escalate**: a second flash, ring or pulse gets a different shape and is bigger.
6. **Sustained effects build.** A hold (portal, rift, aura, charge) must visibly rise: pulses growing from about +-5%
   to +-12% and speeding up, a rim getting hotter, a pull that accelerates. A pull needs visible debris or streaks
   converging, not faint wisps.
7. **Rings and shockwaves travel.** Start at 20% of the final size or less, ease out (quad/quint out), keep growing
   while fading (about 80% of the size in the first 40% of the life). Give the ring thickness or a soft glow band
   behind it. In daylight no dark twin ring unless it is thin, deep, saturated ink (a grey twin reads as a soap bubble).
8. **Flashes in daylight:** a 3-6 stud white core inside a coloured falloff, full white for 0.08 s or less, never wider
   than half the payoff. White only at the hottest moment (`C.check` warns on a near-white sprite over 8 studs).
9. **One rendering style**, the user's: toon (flat shapes, outlines, cel steps) or soft glow. Never fix one beat by
   switching style.
10. **Fire and explosions:** reach orange by ~0.2 s, give the body 0.6-0.9 s, cool slowly (explosion.md).

## Textures
Check every id: `python3 -I "ROOT/kit/scripts/texture_traits.py" <id> ...` (`C.check` lists the ids used).
- A coloured texture tinted another hue goes muddy; a texture on a black or faint card shows its square below
  LightEmission 1; several streaks in one image used as one streak make a comb; low-resolution art drawn big is
  stair-stepped.
- Swapping a texture: scale `Size` by old fill / new fill, or the on-screen size jumps.
- A velocity-aligned streak (`Orientation = VelocityParallel`) follows the texture's own long axis: if the streak shows
  ACROSS its motion, set `Rotation = 90` (or use a texture drawn the other way).

## Studio traps
- Never create a Script or LocalScript from `execute_luau` and set its `Source`: it has crashed Studio. Ship scripts
  inside an `.rbxmx` (`kit/scripts/rbx_assets.py local ...`) and load it with `game:GetObjects("rbxasset://vfxlib/...")`.
- `require` a `:Clone()` of a ModuleScript to get its latest source (`require` caches).
- Emitters far from the camera do not simulate: capture where the camera looks (`C.hold` and `C.next` do).
- The first play after a load can miss textures: the capture functions preload; game code calls
  `VFXTimeline.preload(spec)` once.
- A comment in the middle of a `props` line swallows the rest of it (`C.check`: no Lifetime / no Transparency).
- `game.Lighting.Technology` cannot be read from MCP; judge the lighting from a capture.
