# vfxmith: make Roblox VFX like experienced artists do

A Claude Code plugin (or a plain folder for any AI agent) that lets you say **"make a cool light beam with an
explosion"** and get an effect built the way experienced Roblox VFX artists build them. It knows how, because it
catalogued ~1,900 real open-source effects, read ~1,200 of them layer by layer (every value) and played 75 frame
by frame.

| | What |
|---|---|
| **Library** | ~1,200 real effects, one card each with every layer's values ([`library/`](library/)), searchable by description |
| **Gallery** | real effects frozen at t = 0.03, 0.1, 0.2 ... s ([`gallery/effects/`](gallery/effects/)) and the most-shared textures ([`gallery/textures/`](gallery/textures/)) |
| **Kit** | an effect clock with an exact freeze and a posable dummy, a texture generator, a texture shortlist, a reference-vs-yours comparison ([`kit/`](kit/)) |
| **Skills** | `vfx` (router), `vfx-make` (START.md), `vfx-replicate` (copy a given reference, compare loop), `vfx-find` (compose.py search), `vfx-feedback`, `vfx-study-pack` (safe pack study) |
| **Pack** | the cleaned open-source pack itself: [release download](https://github.com/Frxctured/roblox-vfxmith/releases/tag/pack-v1) (~580 files, ~410 MB, optional), contents in [`PACK.md`](PACK.md), safety in [`SECURITY.md`](SECURITY.md). Agents fetch it with `kit/scripts/get_pack.py` and cut any card's effect into Studio with `rbxcut.py --id <id> --studio` |

## vfxmith 1.0.0-alpha5 (branch v1, lab test build)
**Replicate mode matches the small details.** In the alpha4 test the replica had the right timing, colours and layers
but not the small things: a soft glow and a needle where the reference had a ragged burst of sharp flame shards, one
blurry crescent for its thin tapering swirl arcs, a few round dots for dozens of fine streaked sparks, a smooth fog
bank for its wispy, grainy smoke, and no star glint.
- `skills/vfx-replicate`: a detail stage from about pass 3: zoomed crops of the reference and yours at the same box
  and moments, a detail table (count, size, edge, texture, shape, motion per small element), the 3 biggest detail
  gaps fixed per pass, mostly through the texture; a soft round blob never stands in for a ragged, streaky or thin
  element.
- `kit/refcompare.py`: `detail.png` (the zoomed side by side plus a fine-detail view; `--crop x,y,w,h | auto`,
  `--detail-at`) and small-detail measures per frame: specks (count, size, streaking), dark specks, thin lines,
  grain, edge density, how ragged and how crisp the bright burst is, with the differences vs the reference (numpy).
- `kit/maketex.py`: detail shapes with parameters (`--set ragged=.. taper=.. grain=..`, `--name`, `--sheet`):
  `flame_burst`, `flame_shard`, `arc`, `swoosh`, `spark_streak`, `smoke_wisp`, `glint`, `crack_line`, `glitter`.
- **Cost:** the one measured replicate run took 5 points of the 5-hour window and 21 minutes for 6 passes; the detail
  stage adds about 3-4 passes, so very roughly 8-15 points and 35-60 minutes (an estimate from one run).

## vfxmith 1.0.0-alpha4 (branch v1, lab test build)
**Replicate mode.** Given a reference effect ("/vfx replicate <reference>", or "copy/match this"), the agent now copies
it as closely as it can instead of going its own way: in the alpha3 test it saw the reference once and built a heavy
opaque fireball with thick smoke lasting 1.8 s against a light additive star flash that is over by about 0.8 s.
- `skills/vfx-replicate`: a cost warning first, then the reference's timeline and a layer list by eye, a build to
  that list and a compare-and-fix loop (3 biggest differences per pass, about 6 passes).
- `kit/refcompare.py`: reference row over yours at the same times (frame sheet, video, stills or gallery id, aligned
  on an anchor) with measured differences per frame: coverage, added light, opaque mass, warmth and hues, centre and
  spread, and the fade curve. Pure Python + Pillow (numpy optional).
- `kit/stage.luau`: `Stage.light("dark" | "day")` to compare on the reference's lighting.
- **Cost:** replicate mode takes many build-capture-compare passes: an estimated 2-4 times a normal run (a normal run
  is about 4-7 points of the 5-hour window, about 20 minutes). The skill says so and asks before it starts.

## vfxmith 1.0.0-alpha3 (branch v1, lab test build)
**No plugin, plus a thin, optional kit.** Blind tests kept showing that a model with no plugin made the effects
people preferred: it authored a whole little scene (a moving character, props, code-made shapes and textures) on one
effect clock and kept reworking it by eye. alpha1 and alpha2 forbade exactly that. alpha3 drops the rules and the
compose pipeline and keeps only helpers ([`START.md`](START.md)):
- `kit/stage.luau`: one effect clock with an exact freeze (`BlindTestPlay` / `BlindTestStop`), driven sprites that
  hold any moment in Edit mode, a grey R15 dummy with keyframed poses. Tested offline (`kit/tests/run.sh`).
- `kit/maketex.py`: textures drawn in code (faces, soft shapes, cracks, rings ...) installed into Studio's content
  folder with versioned names.
- `kit/TEXTURES.md`: a short optional list of built-ins and pro textures by role.
- `kit/scripts/compose.py`: the 1,927 pro effects as read-only references.

The alpha1/alpha2 pipeline, guide, rules and vault are in `archive/`. Older notes: `archive/README-history.md`.

## Install (Claude Code)
```
/plugin marketplace add Frxctured/roblox-vfxmith
/plugin install vfxmith@vfxmith
```
Then ask for an effect ("make a purple ground slam", "a light beam with an explosion"), or use `/vfx <request>`.
To copy an effect you have frames or a video of: `/vfx replicate <path>` (costs several normal runs; it asks first).
For the build loop, connect Roblox Studio through the Studio MCP server (the agent builds, captures and reworks the
effect in Studio); without it you still get references.

**Any other agent, or no install:** clone or download this folder and tell the agent "use this folder to make
<effect>". It starts at [`AGENTS.md`](AGENTS.md).

## For people (no AI)
- Browse [`gallery/effects/`](gallery/effects/) and read [`archive/knowledge/categories/`](archive/knowledge/categories/) for your
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
[`archive/knowledge/os-conventions.md`](archive/knowledge/os-conventions.md).

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
