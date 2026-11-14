# Builder notes: read this instead of the whole knowledge folder

The rules that decided three blind tests (2026-11-14), the traps that cost the most time, and the token rules. With
`spec-format.md` (the effect format) and the category study's anatomy and timing tables, this is all a builder needs
to start. Open the long notes (`patterns.md`, `gotchas.md`, `texture-vocab.md`, `os-conventions.md`) only for a
specific question: `grep -n` the term, then read that section with `sed -n a,bp`.

## Keep it cheap (most of a build's tokens are context re-read every turn)
- **Count turns, not files.** A full build should take about 30-40 turns. Put independent calls in ONE message (they
  run in parallel and cost one turn): all pack files, the three sheets, `execute_luau` + `screen_capture`, the three
  reviewers. The 0.1.6-beta builder used 86 turns, ~45 of them reading docs one file or one chunk at a time.
- **Read through the pack:** `kit/scripts/builder_pack.py` puts the notes, the spec format, the category studies with
  their recipes and the chosen cards into a few files; read them all at once with Read. Never `cat` a big file
  through Bash: output over ~30k characters is saved to a file and costs extra reads.
- **One Studio call per version:** `C.update("devkit", "<Name>", { length, frame, stage, camera })` reloads the spec,
  checks it and freezes the framing frame (vfx-make step 4); send the screenshot in the same message.
- **Finish with `kit/scripts/export_effect.py`** for a single-file preview; don't write your own exporter.
In blind test 3 the 0.1.5 full loop cost 3.3x a plain agent. About two thirds of its context by the end was 128
screenshots it had taken one by one, and every one of its 212 turns re-read them. The reviewers were only 13%.
- **Never capture frame by frame yourself.** Take at most ONE framing shot per version (`C.hold` + `screen_capture`).
  The `vfx-capturer` helper (fast model) takes the timeline on both backdrops and returns one sheet per backdrop.
- **Look at the capturer's sheets, not frames:** the daylight overview, the payoff focus sheet (the peak at 640 px)
  and the void overview, per version. Open a single full frame only when one moment is disputed.
- **References: the librarian finds, you read.** The `vfx-librarian` (fast model) searches the library and ranks the
  best cards. Then read the category study (`knowledge/categories/<type>.md`, ~10k tokens) and the 2-3 best cards
  yourself: 15-20k tokens, about $0.50 over a whole run. In test 4 a 2.5 KB librarian summary replaced them and the
  effect came out generic (a smooth lens, layering 5/10 against 8.5 for the run that read the cards). Never read
  `texture-vocab.md` whole or the runtime source.
- **Edit, don't rewrite**: change the spec with small edits; never write the whole file again.
- **One Studio call per step**: re-install the spec and return `C.check` in the same `execute_luau`.
- **Keep tool output short**: pipe long output through `head`/`tail`; never `cat` a whole long file.
- **Stop at two panels** (vfx-make step 7). In test 3 the third panel moved the builder's own score 6.17 -> 6.33.

## Sizes, timing and the check
- A particle's `Size` is its HALF-width (Size N = 2N studs across); beam widths and part sizes are full widths. On
  screen at 1080p and FOV 70, a particle is about 1540 x Size / distance px across, a beam about 770 x width / distance.
- Size every beat from the brief in studs, and treat the PAYOFF's size as a minimum, not a cap. Payoffs smaller than
  asked lost every time (test 3: ~13 studs for 15-20 asked; test 4: a 7-stud flash and a 12-14 stud ring, scored last
  in every lens); one 40% over (24-28 studs) still won both panels.
- After every edit: `C.check("<Name>", { length = <the brief's length in s> })`. Fix every ERROR and WARN. It also
  reports the peak particle count, bright-white streaks, the widest particle and when the effect is last visible.

## Look (patterns.md 15 in short)
1. **Daylight decides.** Tune on `C.stage("day")` (or the user's map), check the void stage too. Dark layers stay thin
   and saturated (purple-black, blue-black, amber-brown) and cool to translucent grey-violet; a solid black puff, or a
   grey-blue mist, reads as dirt.
2. **One hero shape per beat.** About 25 bright-white streaks or needles at most at any beat; 2-3 white layers at most
   overlapping.
3. **The payoff is the biggest thing on screen at its peak.** Its bloom and ring are wider than anything before it
   (about 1.5x the hold's height or more; a signature move fills ~1/3 of the screen at gameplay distance) and it is the
   brightest beat. Check it on the payoff frames of your sheet: if the open portal, the charge or the hold looks bigger
   than the payoff, the payoff is too small. Then an aftermath that ends at the brief's length: an empty screen before
   the end reads as a hard cut, running long reads as muddy.
4. **Anticipation and no dead air.** At least ~0.2 s of wind-up (0.5-1.5 s for a big move). Keep the collapsing or
   charging shape on screen until the payoff fires (a hot slit shrinking to a pinpoint); a quiet beat is ~0.05-0.1 s,
   not an empty frame.
5. **Repeated beats differ and escalate**: a second flash, ring or pulse gets a different shape and is bigger.
6. **Sustained effects build.** A hold (portal, rift, aura, charge) must visibly rise: pulses growing from about +-5%
   to +-12% and speeding up, a rim getting hotter, a pull that accelerates. A pull needs visible debris or streaks
   converging, not faint wisps.
7. **Rings and shockwaves travel.** Start at 20% of the final size or less, ease out (quad/quint out), keep growing
   while fading (about 80% of the size in the first 40% of the life) to at least the brief's width. Give the ring
   thickness or a soft glow band behind it. In daylight no dark twin ring unless it is thin, deep, saturated ink (a grey
   twin reads as a soap bubble).
8. **Flashes in daylight: a hot core inside a BIG coloured bloom.** The pure-white core stays small (3-6 studs, full
   white for about 0.1 s) and the coloured bloom around it (the effect's hot colour, bright) carries the size: as wide as
   the payoff. Both extremes lost points: a solid white disc 14-16 studs across hid the implosion (tests 3 and 4, every
   reviewer), and a 4-stud core with no real bloom read as "a tiny sparkle, no white-hot moment" (test 4, last place).
   White only at the hottest moment (`C.check` warns on a near-white sprite over 8 studs).
9. **One rendering style**, the user's: toon (flat shapes, outlines, cel steps) or soft glow. Never fix one beat by
   switching style.
10. **Fire and explosions:** reach orange by ~0.2 s, give the body 0.6-0.9 s, cool slowly (explosion.md).
11. **Hero shapes with character.** A smooth, symmetric primitive (a clean lens, a plain disc, an even hoop) reads as
   generic ("a portal or an eye", "a UI circle"). Torn, jagged, asymmetric, layered shapes won (a jagged tear with a
   nebula inside and a hot rim). Take the shape language from the references you read.

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
