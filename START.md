# vfxmith 1.0.0-alpha8: a thin, optional kit for Roblox VFX

You have Roblox Studio through the Studio MCP and your own judgement. That is the real toolset. This folder only
adds a few helpers that save time. Use any of them, change them, or ignore them all. The effect is yours to design.

## What we hope you'll make
- **A whole little scene, not only particles.** Build whatever tells the moment: a character (or two) that winds up,
  moves and reacts, a prop it holds, the ground it hits, things that fly, break, rise and linger. All of it can be
  made in code: parts, wedges, Neon and ForceField shapes, beams, lights, decals, particles.
- **Your own shapes and textures** whenever nothing existing looks right: draw them in code (`kit/maketex.py`, or
  your own script) and load them into Studio.
- **One effect clock.** Drive everything (poses, props, particles, lights) from one effect time `t`, so any moment
  can be frozen exactly and looked at again.
- **Judge it by eye and keep going.** Capture many moments from the camera it will be seen from, look at them the
  way an artist would ("this reads as a blob", "the hit has no weight", "too small on screen"), and rework until it genuinely looks great. Several versions is normal; finishing early is not a goal.
  A fresh-eyes helper agent that sees only the frames can be useful; you decide what to take from it.
- **A one-line request is enough.** Pick the style, scale, colours, timing and story yourself and make them work.

## The kit
| | |
|---|---|
| `kit/stage.luau` | the effect clock: `_G.BlindTestPlay(origin, freezeAt?)` / `_G.BlindTestStop()` with an exact freeze, driven sprites, a posable grey R15 dummy. Paste it at the top of your `final.luau`. Header comments = the full API. |
| `kit/maketex.py` | PNG textures from code (glow, ring, shock, smoke, crack, scorch, faces, petal; detail shapes with parameters: flame_burst, flame_shard, arc, swoosh, spark_streak, smoke_wisp, glint, crack_line, glitter ... or your own with its helpers), `--sheet` for a contact sheet, and `--install` into Studio's content folder. |
| `kit/TEXTURES.md` | a short list of textures that work: Studio built-ins and some pro library ids. |
| `kit/refcompare.py` | reference vs yours: one sheet with the reference row over yours at the same times (sheet, video, stills or gallery id; aligned on an anchor such as the hit) and measured differences (coverage, added light, opaque mass, colour, fade); with numpy also a zoomed side by side (`detail.png`) and small-detail measures (sparks, thin lines, grain, ragged or crisp edges). Python + Pillow. |
| `kit/reflift.py` | replicate mode: cut an element (a crackle, a flame burst, a smoke puff, or a short flipbook of one) out of a reference recording into a texture with alpha. Only for effects the user owns or may copy. |
| `kit/scripts/compose.py` | pro effects as references: `python3 -I kit/scripts/compose.py "<description>"` shows how artists layered similar effects (layer tables, sometimes frames). Read-only; nothing to load. |

## stage.luau at a glance
```lua
-- (kit/stage.luau pasted above this line)
local stage = Stage.define({
	name = "LAB_my_effect", length = 3.0,
	build = function(S)                          -- runs at the start of every play
		local hero = S:dummy()                   -- grey R15 standing at S.origin, facing -Z
		local move = hero:keys({
			{ t = 0, at = S.cf, j = {} },
			{ t = 0.4, at = S.cf * CFrame.new(0, 0, -2), j = { RightShoulder = Stage.deg(90, 0, 0) } },
		})
		local orb = S:part({ Shape = Enum.PartType.Ball, Material = Enum.Material.Neon })
		local glow = S:sprite("rbxasset://textures/particles/explosion01_implosion_main.dds", { lightEmission = 1 })
		S:at(0.4, function(t) --[[ one-shot moment ]] end)
		S:on(function(t)                         -- every frame; also exactly at any freezeAt
			move(t)
			local p = hero:point("RightHand") + Vector3.new(0, 0, -2 * t)
			orb.CFrame = CFrame.new(p)
			glow:set({ pos = p, size = 4 * Stage.window(t, 0.3, 2.5, 0.1, 0.5), transparency = 0.2 })
		end)
	end,
})                                               -- now _G.BlindTestPlay / _G.BlindTestStop exist
```
`S:emitter(parent, props)` gives normal ParticleEmitters too (the clock then runs in real time up to `freezeAt`).
`S:decal(texture)` is a flat image on the ground. `Stage.cleanLab()` deletes old `LAB_*` folders,
`Stage.camera(from, at)` points the Edit camera. Tested offline: `kit/tests/run.sh`.

## Things that often help (optional)
- In a Studio window that is not focused, Edit-mode particles may never age: they stay at birth size or do not
  show. Driven sprites (`S:sprite`) and parts are not affected; flipbooks need ageing particles.
- Studio caches `rbxasset://` files by path for the session, so a changed PNG needs a new name (`maketex.py
  --install` does this).
- `screen_capture` takes `camera_position` / `look_at_position`. AlwaysOnTop BillboardGuis do not show in Edit-mode
  captures.

## Replicate mode (experimental: copy a given reference)
> **Experimental.** In our fair tests the replicas matched the reference closely from the recording's own camera
> but not from other angles, or (when built from real 3D elements) lost detail such as the bolt shape and the
> fire texture. Expect a rough copy, not a match, and a higher cost than a normal run.

When the user gives a reference effect and asks to copy, match or replicate it (`/vfx replicate <reference>`), the
goal changes: look like the reference, not like your own idea. Follow `skills/vfx-replicate/SKILL.md`: warn about the
cost first, list the reference's layers by eye (time span, shape, colour, additive or opaque, size, motion), build
to that list, then capture at the reference's times and compare with `kit/refcompare.py`, fixing the three biggest
differences per pass until shapes and timing are right (about 3 passes), then a detail stage on zoomed crops
(sparks, thin arcs, ragged flames, smoke edges, grain, matched mostly through the textures). `refcompare.py
--region` measures each element on its own (colours, timing, how neat or organic), and `kit/reflift.py` can lift
textures straight from the recording when the user says the effect may be copied; each element gets its own texture (a lifted
single piece, the closest pro texture from `kit/scripts/find_textures.py`, or an accurate redraw) on emitters at its
real 3D place, checked from other angles each pass. Match the lighting while
comparing (`Stage.light("dark")` / `Stage.light("day")`). **Cost:** two measured full runs took about 8-10 points of the 5-hour window and 26-28 minutes each (a normal run is
about 4-7 points and 20 minutes).
