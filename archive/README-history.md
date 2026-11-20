# README sections retired in 1.0.0-alpha3

Version notes and the old workflow/pattern sections, moved out of README.md when alpha3 dropped the compose
pipeline and the rules. Paths in here point to files now under `archive/`.

## vfxmith 1.0.0-alpha2 (branch v1, lab test build)
Four general fixes from a blind human review of alpha1 (4 raters: alpha1 beat 0.1.6 and 0.1.9 but not "no plugin"):
- **Style register**: the brief names a style (grounded, stylized, anime/battlegrounds, cute, sci-fi); every effect
  has a style score (`catalog/traits.json.gz`, `build_style_index.py`: layer brightness/additive/flash/smoke/lit
  shares, colours, materials, names, texture families) and `compose.py` ranks by type x style fit (`--style`).
  `knowledge/guide.md` 2b says how to push a piece toward a style with values only.
- **Scale to the scene first**: `C.measure()` and a per-piece `size` (studs) fit every piece to the brief before any
  styling; `C.coverage()` flags a layer that fills the frame; compose.py prints each candidate's size and starting
  scale (`--size`). More than 30% off the brief is a fault.
- **Every named element on screen**: the brief lists each thing the request names with its time; the fault check
  confirms each one in the frames.
- **Streaks follow the motion path**: arcs for swirl/orbit/vortex, straight lines for bursts and dashes, checked
  top-down (guide 2c, vault rule). Weak meshes: `compose.py --meshes "<role>"` instead of primitives.

## vfxmith 1.0.0-alpha1 (branch v1, lab test build)
**Start from human compositions, don't invent them.** Earlier versions asked a model to compose effects from numbers;
it chose textures and layouts badly, and code-made assets looked generic. v1 never invents the look:
- `kit/scripts/compose.py "<request>"` finds the best-matching professional open-source effects (1,927 indexed, per
  part of the request, with their layer tables) and `--cut` loads their real instance trees into Studio.
- A short spec (`knowledge/compose-spec.md`) adapts them: hue shift that keeps the artist's values, whole-piece scale,
  speed, delay, travel, placement, dropped layers, same-role pro texture swaps (`--swap`). `kit/studio/VFXCompose.luau`
  plays them on one freezable clock; `kit/scripts/export_compose.py` writes one self-contained `final.luau`.
- Lean knowledge: `knowledge/guide.md` (one page of craft rules) + the research vault in `vault/` with a search tool,
  instead of the 40k-token pack (now `knowledge/archive/`).
- Workflow (`START.md`, skill `vfx-make`): brief, find + look, pick (checkpoint), adapt, one objective fault check
  (agent `vfx-fault-checker`), export. The taste review panels and the director are retired (AI judges disagreed
  with people).

## What's new in 0.1.9-beta1 (beta channel: see [`BETA.md`](BETA.md))
- **The directed loop** (`vfx-direct`, what `/vfx` now runs): two agents instead of one. A **builder** builds the
  effect and checks every version itself; a separate **director** only watches (five views and consecutive frames)
  and sends one ranked list of at most 8 fixes per round, for at most three rounds. Then you rate it.
  In its first test a fire punch went from 6.0 to 6.8 in one director round, and a sword combo directed the same way
  was rated 8/10 by a person.
- **VFXKit** ([`kit/studio/VFXKit.luau`](kit/studio/VFXKit.luau)): tested building blocks so round 1 starts where
  earlier builds ended: strokes with an ink rim, an impact frame, a bolt, shock and dust rings, ground cracks, debris,
  smoke, flash, charge-up, one clock that freezes exactly, camera shake, character poses, a stage with five review
  cameras and a `Lint()` that catches common faults.
- **Mesh slashes and better poses** (VFXKit 1.2): `fx:MeshSlash` builds a slash from meshes fitted to the real blade
  path (an invisible part + mesh + a decal brighter than white: it shines in daylight and turns with the blade;
  [`knowledge/mesh-slash.md`](knowledge/mesh-slash.md) says when meshes beat sprites). Poses gained a step, stride,
  head turn, lean, a two-handed grip and guard poses, and `Lint()` now warns about T-poses and arms through the body.
- **Pro guide** ([`knowledge/pro-guide.md`](knowledge/pro-guide.md)): how professional Roblox effects are built, with
  values: brightness tiers (first drafts are 5-10x too dim), the three uses of LightEmission, dark partners,
  flipbooks, timing in frames, and what causes "matte", "sticker", "pencil" and "solid disk" complaints.
- **A checklist and a self-check** ([`checklist.md`](knowledge/checklist.md), [`selfcheck.md`](knowledge/selfcheck.md)):
  28 yes/no checks and an every-round routine: player, side, front, bird's-eye and night views plus dense stills
  around each hit. It works on Windows, macOS and Linux with only the Studio MCP; a live screen recording is an
  optional extra.
- **Everything in the caster's space:** nothing is turned toward a camera to look better. Builder and director both
  follow it, and the bird's-eye view checks it.
- **Works for everyone:** the builder, director and reviewers run on Opus; no agent needs a newer model.
- The 0.1.8 loop is still there: `/vfx classic <effect>` (`vfx-make`).

## What's new in 0.1.6
- **About a third of the cost of 0.1.5.** Helpers on a fast, cheap model find references and take the Studio
  screenshots, the builder reads everything it needs in one go, and it stops after two review panels. A full build
  cost $15.47 at API prices in blind test 6, against $40-57 for 0.1.5 and $26.44 for the same agent with no plugin.
- **The library is a guide, not a template.** The builder designs the effect first and borrows techniques, timing and
  values from real effects; it builds the hero shape itself when nothing in the library fits.
- **Shapes built in code:** `ctx.Crystal` makes faceted solids (rocks, debris, crystals, gems, shards) with their own
  light-to-dark colours, no upload needed.
- **~10,000 textures to choose from:** one search over the open-source library and the free VFX Studio catalogue,
  ~2,750 animated flipbooks, each with measured traits.
- **Reviewers calibrated on people:** an Appeal score, bold colour counts as a plus, and real human poll results as
  the reference.
- Tested blind: in test 6 (a fire tornado) people picked the 0.1.6 effect over the same agent without the plugin by a
  wide margin. Update: `/plugin marketplace update vfxmith`, then `/plugin update vfxmith@vfxmith`.

## How an agent makes an effect
1. **Find references**: `kit/scripts/find_effects.py "light beam with an explosion"` splits the request into parts and
   returns, per part, the closest real effects (cards with exact values, frames), the effect-type study and its recipe.
2. **Start from recipes**: one spec with both recipes' layers (the explosion shifted to the beam's impact), adapted to
   the request with values from the cards ([`knowledge/spec-format.md`](knowledge/spec-format.md)); every texture
   checked for traps (`texture_traits.py`: coloured, black or faint card, multi-part, low resolution).
   Fresh textures per role come from one search over ~10,000 textures (`find_textures.py`): the library's own and
   the free VFX Studio plugin's catalogue (~2,750 animated flipbooks), each with measured traits.
3. **Check it, play it in Studio and look**: the kit installs without Rojo or uploads; `C.check(name)` catches silent
   spec mistakes; `C.hold(name, t)` + a screenshot captures frozen frames on any OS, on a black stage AND a default
   daylight baseplate (dark layers that vanish on black can read as dirt in daylight).
4. **Compare and review**: side by side with the references (`compare.py`), three blind reviewer agents (shape, timing,
   colour) list concrete fixes, scoring absolute quality for a description or resemblance for a video; at most two
   review rounds by default (a faster draft mode and a third "polish" round exist for when you ask for them).
   Helpers keep it cheap: a fast librarian agent reads the library, a fast capturer agent takes the frames and hands
   back one contact sheet per backdrop, so the builder never re-reads dozens of screenshots on every turn.
5. **Ship**: copy `kit/runtime/VFXTimeline.luau` + the spec into your game and play it on the client.

## What the pack taught us
Eleven category studies (75 effects frame by frame in the gallery, plus statistics over every emitter in the pack) agree on these.
Details, numbers and sources: [`knowledge/patterns.md`](knowledge/patterns.md) section 14 and the
category studies in [`knowledge/categories/`](knowledge/categories/).

1. **Fire everything at t = 0 and let lifetimes make the timeline**: flash 0.015-0.16 s, rings 0.1-1.1 s, smoke
   0.35-2.5 s, ground marks 0.5-2.5 s. Size-from-0 curves, flipbooks and fade-ins do the staging, not delays.
2. **`Brightness = 0` turns any texture black.** Give every bright shape a black twin (same texture and motion,
   1.0-1.6x bigger, slightly lower `ZOffset`). Effects without an ink layer read as white blobs.
3. **Opaque glow beats additive stacks**: 44% of all emitters use `LightEmission` 0 or less. `LightEmission 0` with
   `Brightness` 5-75 stays saturated and covers instead of summing to white; a dark colour at high `Brightness`
   (e.g. `#721A00` at 60) gives a white-hot centre with a coloured edge from ONE layer.
4. **Fade by colour, not transparency**: colour ramps that end at black fade additive layers cleanly; one shared ramp
   on every layer ties the effect into one look.
5. **Pop, then settle**: flashes appear at full size and shrink to 0; rings grow from 0 and reach a quarter to half
   of their size within the first 10% of their life.
6. **Burst and stop**: a particle travels about `Speed / Drag` studs (sparks 66-350 studs/s with `Drag` 5-30).
7. **Flat rings**: `Orientation = VelocityPerpendicular`, `Speed` ~0.005, `SpreadAngle` 0-15 (flat) or 3333 (a shell of
   random tilts); spin with `RotSpeed` in one direction per layer.
8. **Size everything from one number** (the main ring's size D: glow 0.8-1.9 D, smoke 0.3-0.75 D, sparks 0.04-0.13 D)
   and set `Brightness` by screen area (veils 0.05-0.16, rings 1-3, sparks 15-35, tiny embers 50-200).
9. **One particle can do several things**: multi-key `Size` curves pulse or blink, `Squash` keys stretch sparks into
   streaks, all without scripts.
10. **Avoid**: thousands of particles per second, layers held at 85-98% transparency (invisible), fractional
    `EmitCount` below 1 (emits nothing), stacked additive cards (white-out with visible card edges), no white core.

