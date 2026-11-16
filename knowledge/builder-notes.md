# Builder notes: read this instead of the whole knowledge folder

The rules that decided five blind tests (2026-11-14) and two human polls, the traps that cost the most time, and the token rules. With
`spec-format.md` (the effect format) and the category study's anatomy and timing tables, this is all a builder needs
to start. Open the long notes (`patterns.md`, `gotchas.md`, `texture-vocab.md`, `os-conventions.md`) only for a
specific question: `grep -n` the term, then read that section with `sed -n a,bp`.

## Keep it cheap (most of a build's tokens are context re-read every turn)
- **Batch what is independent.** Put independent calls in ONE message (they run in parallel and cost one turn): all
  pack files, the three sheets, `execute_luau` + `screen_capture`, the three reviewers. The 0.1.6-beta builder used 86
  turns, ~45 of them reading docs one file or one chunk at a time. No turn cap: spend the turns on versions.
- **Read through the pack:** `kit/scripts/builder_pack.py` puts the notes, the spec format, the category studies with
  their recipes and the chosen cards into a few files; read them all at once with Read. Never `cat` a big file
  through Bash: output over ~30k characters is saved to a file and costs extra reads.
- **One Studio call per version:** `C.update("devkit", "<Name>", { length, frame, stage, camera })` reloads the spec,
  checks it and freezes the framing frame (vfx-make step 4); send the screenshot in the same message.
- **Finish with `kit/scripts/export_effect.py`** for a single-file preview; don't write your own exporter.
In blind test 3 the 0.1.5 full loop cost 3.3x a plain agent. About two thirds of its context by the end was 128
screenshots it had taken one by one, and every one of its 212 turns re-read them. The reviewers were only 13%.
- **Timelines go to the capturer; the hero you see yourself.** The `vfx-capturer` helper (fast model) takes the full
  timeline on both backdrops and returns one sheet per backdrop: use the sheets for timing. But every version, also
  look at the hero at full size: the payoff frame and one hold frame, plus one shot of your own with the hero filling
  about a third of the frame (about 1x the effect's width away). Shapes, facets and colour can't be judged from 400-px
  cells: in test 5 the beta2 builder never saw its spikes up close and kept "chubby pale teardrops"; the winner looked
  at 8-9 full frames per version from ~16 studs.
- **References: the librarian finds, you read.** The `vfx-librarian` (fast model) searches the library and ranks the
  best cards. Then read the category study (`knowledge/categories/<type>.md`, ~10k tokens) and the 2-3 best cards
  yourself: 15-20k tokens, about $0.50 over a whole run. In test 4 a 2.5 KB librarian summary replaced them and the
  effect came out generic (a smooth lens, layering 5/10 against 8.5 for the run that read the cards). Never read
  `texture-vocab.md` whole or the runtime source.
- **Edit, don't rewrite** when tuning: change the spec with small edits. When the construction is wrong (a layer can't
  reach the look by values, or the same complaint returns), rebuild that layer; test 5's winner rewrote its whole
  effect once when v1's approach could not render.
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
4. **Anticipation INTO the hit, and no dead air.** At least ~0.2 s of wind-up (0.5-1.5 s for a big move), and it
   peaks INTO contact: brightest on the frame before (a falling comet, a fist trail, a strike path). Never fade the
   wind-up out before contact (test 5: beta2's was at 0 white pixels the frame before; the winner's comet was at its
   brightest there). The hit lands in ONE frame: one frame after contact the white is at ~85%+ of its peak (winner
   88%, beta2 33%, whose brightest moment came 83 ms late from the spikes). Capture the frames just before and just
   after contact to check. Keep the collapsing or
   charging shape on screen until the payoff fires (a hot slit shrinking to a pinpoint); a quiet beat is ~0.05-0.1 s,
   not an empty frame.
5. **Repeated beats differ and escalate**: a second flash, ring or pulse gets a different shape and is bigger.
6. **Sustained effects build.** A hold (portal, rift, aura, charge) must visibly rise: pulses growing from about +-5%
   to +-12% and speeding up, a rim getting hotter, a pull that accelerates. A pull needs visible debris or streaks
   converging, not faint wisps.
7. **Rings and shockwaves travel.** Start at 20% of the final size or less, ease out (quad/quint out), keep growing
   while fading (about 80% of the size in the first 40% of the life) to at least the brief's width. Give the ring
   thickness or a soft glow band behind it. One crisp, thin bright ring racing out (test 5: 4 -> 34 studs in 0.3 s)
   beat wide soft bands, which read as a grey plate over a pale floor. In daylight no dark twin ring unless it is thin, deep, saturated ink (a grey
   twin reads as a soap bubble).
8. **Flashes in daylight: the fault is a ROUND blob, not size.** A round soft white sprite over ~8 studs reads as a
   flat white ball and hides what is behind it (tests 3 and 4, every reviewer). Carry the size with SHAPE instead: a
   white starburst with thin rays, thin Neon speed lines, a hard neon shell, each 20-30 studs for only 0.1-0.15 s (test
   5's winner: a 32-stud sparkle star, 22 Neon speed lines thinning out, a 0.11 s neon dome), or a bright coloured
   bloom around a small white core (3-6 studs). A 4-stud core with nothing around it reads as "a tiny sparkle" (test 4,
   last). Crisp materials (ice, crystal, metal, glass): flash 1-3 frames, then show the material's own colours; a long
   white glow hides the spikes (test 5: all three plugin builds marked down for it). `C.check` warns on big round
   white sprites; a star or ray texture is fine.
9. **One rendering style**, the user's: toon (flat shapes, outlines, cel steps), anime crisp (sharp shapes, punchy
   flash, no outlines) or soft glow. Never fix one beat by
   switching style.
10. **Fire and explosions:** reach orange by ~0.2 s, give the body 0.6-0.9 s, cool slowly (explosion.md).
11. **Hero shapes with character, designed by you.** A smooth, symmetric primitive (a clean lens, a plain disc, an
   even hoop, a smooth cone, a round puff) reads as generic ("a portal or an eye", "a pincushion"). Torn, jagged,
   faceted, asymmetric, layered shapes won in every test (a jagged rift with a nebula inside; a crescent with a hot
   edge; faceted crystals). References show techniques; the shape is yours. If no library asset matches the design
   closely, build that shape: Parts, wedges, beams, custom layers, `ctx.Crystal` for any faceted solid (crystals,
   rocks, debris, gems, shards), meshes made in code.
12. **The hero carries its own value range.** Put light, body colour and shadow ON the hero shape itself: the hottest
   or most lit part white (a blade's edge, a fireball's core, a beam's centre line, a crystal's tip), the body in the
   saturated colour, the deep tone where it is in shadow or at its roots (the trailing edge, the outer smoke, the base,
   facet shadows). A shape tinted as one flat colour reads flat however many layers sit around it (test 5: "one flat
   colour" heroes after two panels; test 2: a single-value orange fireball read as "jelly"). Pieces that break off
   are their own shapes in the same range, not scaled copies of the hero. In daylight put dark tones on geometry and
   decals, not on sprite twins: a dark sprite twin read as "dirt" or "fur".
13. **Every object tells its whole story in the first draft:** how it is born (where, staggered, with an overshoot),
   what keeps it alive while it holds, the warning before it ends (a shake, a flicker, a 2-3 frame white flash), how
   it ends (it breaks, bursts, dissolves, collapses), where its pieces go (3-7 per object by size, on arcs with gravity
   about 60 studs/s^2 that LAND and stop, then shrink) and what stays (stumps, scorch, embers, a fading mark). The
   ending is the moment people remember (owner's favourite: "when the ice crystals exploded"), and what stays holds at
   70%+ until ~80% of the asked linger before it fades (0.1.6 dropped its frost ~0.5 s early and lost on it). This
   holds for crystals, rocks, shields, portals, projectiles, fireballs. Reviewers had to ask the test-5 runner-up for
   each of these one round at a time; the winner had them all in v1.
14. **Ground marks are Decals in daylight.** Scorch, cracks, frost, magic circles, splashes: a flat part with a Decal
   (`kind = "part"` with `decal = {...}`, alpha-blended) stays visible on a pale floor; flat particles wash out in
   daylight and sink at low y (test 5 panel, 3 of 3: "gone early in day").
15. **Colour that lives, glow as its own layer.** Animate the hero's colour: white-hot at birth, cooling to its body
   colour over ~0.15-0.2 s; a slight shimmer or pulse while it holds (about +-10%); a hot glint just before it ends.
   Glow is restrained (`knowledge/taste.md`: the owner preferred the ice slam with LESS glow; 0.1.6's light and halos
   changed 52% of the screen at the hit against 21%): solid heroes don't glow while they hold, flashes last 0.1-0.15 s,
   the effect light stays near the effect. Where glow helps, give it its OWN small layer (a soft sprite, a thin Neon
   core); a glow baked into the hero washes its edges out. Saturation should suit the material, not be maxed. Smoke, mist and dust in daylight: tint them and give them LightEmission ~0.3-0.8 for magic or cold effects,
   warm grey with a darker core for fire; flat grey (LightEmission ~0.1) reads as dust.
16. **Anime lines are thin Neon.** Speed lines, slash streaks, impact rays: Neon parts or beams 0.07-0.16 studs thick
   that thin out to nothing instead of fading (fading Neon turns grey in daylight).
17. **Gaps are yours to design.** Where `refs.md` says no reference fits (a "gap"), build that beat yourself; don't
   fill it with the nearest texture. In test 5 the three listed gaps became the three weakest beats.

## Textures
- **Fresh textures, not the recipe's defaults.** Every effect in the first five blind tests drew all its 14-16
  textures from the same 185 the recipes use, so different effects started to look alike. Two libraries are
  searchable together (~10,000 textures, ~2,750 animated flipbooks): the open-source library and VFX Studio (a free
  Roblox plugin's catalogue). The librarian's `textures.jpg` shows 8 candidates per role, ranked by keyword match + a measured quality score (`q0.82` on the sheet; low = pixelated, cut off, faint or on a card) and chosen to look different from each other (`--why` shows the score parts);
  `kit/scripts/find_textures.py "<words>" [--flipbook] --sheet out.jpg` finds more (one image).
- **Flipbooks animate on their own** (a ring that breaks up, smoke that rolls, an impact that bursts):
  `FlipbookLayout = 4` (2, 4 or 8 = the grid), `FlipbookMode = "OneShot"` plays the frames once over the particle's
  Lifetime.
Check every id you pick outside the sheet: `python3 -I "ROOT/kit/scripts/texture_traits.py" <id> ...` (`C.check`
lists the ids used).
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
- Things made in code (no upload): `ctx.Crystal` for crystals; `AssetService:CreateEditableMesh` + `CreateMeshPartAsync`
  for other meshes (vertex colours via `AddColor`/`SetFaceColors`, flat facet normals); `CreateEditableImage` textures
  work on Decals and MeshParts but NOT on particles (nothing shows) or beams (a flat white strip): measured in test 5.
  Particles can use Studio's built-in `rbxasset://textures/particles/sparkles_main.dds` / `smoke_main.dds`. In a live
  game EditableMesh/EditableImage need Experience Settings > Security > "Allow Mesh / Image APIs" and client memory;
  creation then returns nil, so always keep a fallback (ctx.Crystal falls back to wedges by itself). Nothing made at
  runtime is saved with the place: the effect file rebuilds it.
- Per-object sparkles, puffs or dust in a custom layer: make the emitters under `ctx.folder` (they freeze with the
  effect) and `:Emit()` when `lt` first passes the time (keep a flag in the state).
- `game.Lighting.Technology` cannot be read from MCP; judge the lighting from a capture.
