# vfxmith: make Roblox VFX like experienced artists do

A Claude Code plugin (or a plain folder for any AI agent) that lets you say **"make a cool light beam with an
explosion"** and get an effect built the way experienced Roblox VFX artists build them. It knows how, because it
catalogued ~1,900 real open-source effects, read ~1,200 of them layer by layer (every value) and played 75 frame
by frame.

| | What |
|---|---|
| **Library** | ~1,200 real effects, one card each with every layer's values ([`library/`](library/)), searchable by description |
| **Gallery** | real effects frozen at t = 0.03, 0.1, 0.2 ... s ([`gallery/effects/`](gallery/effects/)) and the most-shared textures ([`gallery/textures/`](gallery/textures/)) |
| **Knowledge** | 11 effect-type studies with anatomy tables, timing, technique recipes and mistakes, plus a starting recipe each; cross-effect rules; texture ids by role ([`knowledge/`](knowledge/)) |
| **Skills** | `vfx` (router), `vfx-direct` (directed build loop, beta default), `vfx-make` (classic build loop), `vfx-find` (references), `vfx-review` (blind panel), `vfx-study-pack` (safe pack study) |
| **Kit** | tested building blocks (`VFXKit`), effect runtime (`VFXTimeline`), Studio capture and playback modules, scripts to search, capture, compare and study packs ([`kit/`](kit/)) |
| **Pack** | the cleaned open-source pack itself: [release download](https://github.com/Frxctured/roblox-vfxmith/releases/tag/pack-v1) (~580 files, ~410 MB, optional), contents in [`PACK.md`](PACK.md), safety in [`SECURITY.md`](SECURITY.md). Agents fetch it with `kit/scripts/get_pack.py` and cut any card's effect into Studio with `rbxcut.py --id <id> --studio` |

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

## Install (Claude Code)
```
/plugin marketplace add Frxctured/roblox-vfxmith
/plugin install vfxmith@vfxmith
```
Then ask for an effect ("make a purple ground slam", "a light beam with an explosion"), or use `/vfx <request>`.
For the build loop, connect Roblox Studio through the Studio MCP server (the agent places, captures and reviews the
effect in Studio); without it you still get references and a ready spec.

**Any other agent, or no install:** clone or download this folder and tell the agent "use this folder to make
<effect>". It starts at [`AGENTS.md`](AGENTS.md).

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

## For people (no AI)
- Browse [`gallery/effects/`](gallery/effects/) and read [`knowledge/categories/`](knowledge/categories/) for your
  effect type; the cards in [`library/cards/`](library/cards/) list every value of each effect.
- [Download the pack](https://github.com/Frxctured/roblox-vfxmith/releases/tag/pack-v1), read [`SECURITY.md`](SECURITY.md), and drag a `.rbxm` into Studio. Most effects play with:
```lua
-- fire every emitter the way most open-source VFX expect (attributes EmitCount / EmitDelay / EmitDuration)
local function play(effect: Instance)
	for _, e in effect:GetDescendants() do
		if e:IsA("ParticleEmitter") then
			task.delay(e:GetAttribute("EmitDelay") or 0, function()
				local duration = e:GetAttribute("EmitDuration") or 0
				e:Emit(math.max(1, math.floor(tonumber(e:GetAttribute("EmitCount")) or 1)))
				if duration > 0 then
					e.Enabled = true
					task.delay(duration, function() e.Enabled = false end)
				end
			end)
		end
	end
end
```
VFX Forge-style effects (models with `Start`/`End` parts, beams with `Width0_Start` ...) are documented in
[`knowledge/os-conventions.md`](knowledge/os-conventions.md).

## Limits, honestly
- Frames come from effects replayed **without their own scripts**: motion an effect's code made (moving meshes, paths,
  camera shake) is missing, and the studies say where.
- Some pro techniques are undocumented engine behaviour (negative `LightEmission`, `Transparency` below 0,
  `Brightness` in the hundreds): they work today and could change.
- Unattended batch capture uses Linux tools (niri, wf-recorder); the per-frame capture (`C.hold` + MCP screenshot)
  works everywhere.
- No other plugin is required. If you also use the LihFolk plugin, its vault is used as an optional extra for engine
  facts.

## Safety
Read [`SECURITY.md`](SECURITY.md): two pack files had real backdoors (neutralised), one a leaked webhook token
(removed), five files ripped from live games were left out. A scan can miss things: check before pressing Play.

## Credits
The effects belong to their creators. Names found in the files as credits or signatures (file names, instance names,
script headers), in no particular order:
dull, Kyrushui, Luckk, Tosic, TUF, 7amm, Sinister, Phantom, Goldx, chatitslilcam, DahPatave, mmy, Arklight Studio,
PihhZ, M1st3k, Sev, szl, Harlequin, Gezzu, Sad_iogurt, Cri, Regret, Chromatic, Lovlicious, seaser_n, bhristt,
Aidaren, Hell4Cash, pizza, Blaze, DCJSanityy, N0tKep, Powerbow47, lolmansReturn, Retsatrophe, Fake_Bobcat,
KalariaUw, VUUKSTUDIOS, Tomroblox54321, AmPro, coolcapidog, ApprenticeOfMadara, Vaschex, lopjoss (HyperText),
BloodLight (Bloodify), zilibobi (VFX Forge), ForeverHD (HD Admin, TopbarPlus), Parihsz (Chrono).
Many files carry no name. If something here is yours, open an issue to have it credited or removed.

## Licence
MIT for this project's work ([`LICENSE`](LICENSE) has the scope). The pack's files and the effects in the library and
gallery keep their creators' terms; VFX Forge's emit module is VFX-DL ([`LICENSES/VFX-DL.txt`](LICENSES/VFX-DL.txt)).
Details: [`THIRD_PARTY.md`](THIRD_PARTY.md).
