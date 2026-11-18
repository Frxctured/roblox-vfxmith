# Compose spec reference (kit/studio/VFXCompose.luau)

A spec is a Luau file that returns one table. `kit/scripts/export_compose.py spec.luau --out final.luau` inlines it
with VFXCompose into one self-contained file.

```lua
return {
	name = "FrostNova",          -- label
	folder = "VFXCompose",       -- Workspace folder the plays live in (use your LAB_<tag> name in a lab test)
	length = 2.5,                -- seconds the effect lasts (auto cleanup of unfrozen plays: length + 4 s)
	dummy = true,                -- plain grey R15 dummy standing at the origin, facing -Z (needed for scale checks
	                             -- and for on = "dummy" pieces)
	yaw = 0,                     -- turns the whole effect (degrees about Y); forward is -Z
	speed = 1,                   -- playback speed of everything
	pieces = {
		{
			file = "fx_8f69477f9552", -- written by compose.py --cut 8f69477f9552
			at = Vector3.new(0, 0, 0), -- offset from the origin in effect space (after the piece is centred)
			rot = Vector3.new(0, 0, 0), -- extra rotation of the piece (degrees, X Y Z)
			anchor = "auto",       -- "auto": median layer over the origin, lowest layers on the floor;
			                       -- "pivot": the piece's own pivot at the origin (beams between two points, etc.)
			on = nil,              -- "dummy": layers on rig parts (Torso, Right Arm...) are snapped onto the dummy
			delay = 0,             -- seconds after play start
			scale = 1,             -- whole-piece size (parts, attachments, particle sizes and speeds, beam widths)
			speed = 1,             -- this piece's playback speed
			tint = "#7FD8FF",      -- target hue; saturation and value stay as authored
			tintMode = "shift",    -- "shift" (rotate all hues together, keeps colour travel) or "set" (all saturated
			                       -- colours onto the target hue)
			tintStrength = 1,      -- 0..1 blend
			glow = 1,              -- Brightness multiplier on emitters, beams, trails
			count = 1,             -- EmitCount multiplier
			drop = { "Glow2", "~trail" }, -- destroy layers by exact Name or ClassName, "~text" = name contains text
			set = {                -- per layer (exact Name, ClassName, "~text" or "*"): properties, "@Attr" = attribute
				["Shockwave"] = { Texture = "rbxassetid://16867483883", ["@EmitCount"] = 2 },
				["~spark"] = { Brightness = 12 },
			},
			move = { by = Vector3.new(0, 0, -40), time = 0.6, ease = 0.5, arc = 0 }, -- fly the piece by this offset
			                       -- (effect space) over time s after its delay; ease 0 linear .. 1 ease-out; arc =
			                       -- height of a parabola. Use for projectiles/dashes; put the impact piece at the end
			                       -- point with delay = the flight time
			seed = 8,              -- random seed of the replay
		},
	},
}
```

Order of adaptation inside one piece: drop, set, tint, scale, speed, glow, count. `set` values are real Luau values
(`NumberSequence.new(...)`, `ColorSequence.new(...)`, `Color3.fromHex(...)`, `Enum...`).

## How pieces are played
The driver replays the conventions pro files use: `EmitCount` / `EmitDelay` / `EmitDuration` attributes on emitters
(with `TimeScale_*` ramps), Forge-format beams and Start/End meshes, running emitters keep running, script-driven
emitters (no attributes, disabled) emit once. Lights and plain parts show for the whole play. The scripts that came
with the pack are removed, so effects that depended on their own script for motion (moving a projectile, tweening a
part) do not move: move them with `move` (and put the impact at the end point as a second piece), or pick a candidate that is EmitCount-driven
(compose.py shows "N/M layers EmitCount-driven").

## API (in Studio)
```lua
local C = <loadstring of VFXCompose>   -- export_compose's final.luau does this for you
C.build(spec)            -- JSON summary: pieces with emitter/beam/trail/part counts
C.layers(1)              -- piece 1's layer list: class, name, texture, first colour, Brightness, EmitCount
C.camera(origin, { dist = 22, yaw = 25, pitch = 0.28, height = 2.5 })
C.play(origin, freezeAt) -- freezeAt: returns "frozen at t" once that frame is built
C.stop()
```
