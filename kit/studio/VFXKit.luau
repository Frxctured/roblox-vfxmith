--!nocheck
-- VFXKit 1.3: tested building blocks for melee / ability effects (strokes with an ink rim, mesh slashes fitted to the
-- swing, impact frame, bolt, rings, ground marks, debris, smoke, flash, charge, one freeze-safe clock, camera shake,
-- R15 pose helpers with a two-handed grip, review cameras, Lint).
-- New in 1.3: a "why" reason on every layer (fx:Layers() prints the table), an additive stack gain applied at Build,
-- scrolling-beam curtains (fx:Curtain: walls, pillars, waterfalls, energy sheets), mask / baked texture tags with a
-- recolour that only tints masks (K.TagOf, K.Tint, fx:Recolor), and an aftermath group for impacts (fx:Aftermath).
-- Guide: knowledge/vfxkit.md. Demo: kit/studio/VFXKitDemo.luau. Load both with kit/scripts/kit_push.py.
-- Edit mode, one clock, freeze-safe. Returns a table; nothing is built until you call K.new().
--
--   local K = loadstring(game:GetObjects("rbxasset://vfxlib/<name>.rbxmx")[1].Value)()   -- also stored as _G.VFXKit
--   local fx = K.new("LAB_fire", CFrame.new(0, 0, 45))      -- caster frame: origin on the floor, caster looks along -Z
--   fx:Stage(); fx:Caster(); fx:Katana(); fx:Pose(keys)
--   fx:Stroke{...}; fx:MeshSlash{...}; fx:Contact{...}; fx:Bolt{...}; fx:ImpactFrame{...}; fx:Shake(t, amp, dur) ...
--   fx:Build(); fx:Cam("player"); fx:Play()        -- live      |  fx:Play(1.92) = freeze at 1.92 s  |  fx:Stop()
--   print(fx:Lint())                                -- static "before you show me" checks
--
-- RULE 0: every position / direction you pass is in CASTER SPACE (x = caster's right, y = up, -z = look vector).
-- Nothing in here takes a camera. Readability comes from pose, size, brightness and contrast.
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local K = { VERSION = "1.3" }

---------------------------------------------------------------- small helpers
local VP, FC, VPAR = Enum.ParticleOrientation.VelocityPerpendicular, Enum.ParticleOrientation.FacingCamera, Enum.ParticleOrientation.VelocityParallel
local GRID = { ["2x2"] = Enum.ParticleFlipbookLayout.Grid2x2, ["4x4"] = Enum.ParticleFlipbookLayout.Grid4x4, ["8x8"] = Enum.ParticleFlipbookLayout.Grid8x8 }
local INK, WH = Color3.new(0, 0, 0), Color3.new(1, 1, 1)

-- NS(5) | NS(a, b) | NS(v0, t1, v1, ...) | NS(t0, v0, t1, v1, ...)
local function NS(...)
	local a = { ... }
	if #a == 1 then return NumberSequence.new(a[1]) end
	if #a == 2 then return NumberSequence.new(a[1], a[2]) end
	if #a % 2 == 1 then table.insert(a, 1, 0) end
	local k = {}
	for i = 1, #a, 2 do table.insert(k, NumberSequenceKeypoint.new(a[i], a[i + 1])) end
	return NumberSequence.new(k)
end
-- CS(c) | CS(c0, t1, c1, ...) | CS(t0, c0, t1, c1, ...)
local function CS(...)
	local a = { ... }
	if #a == 1 then return ColorSequence.new(a[1]) end
	if typeof(a[1]) == "Color3" then table.insert(a, 1, 0) end
	local k = {}
	for i = 1, #a, 2 do table.insert(k, ColorSequenceKeypoint.new(a[i], a[i + 1])) end
	return ColorSequence.new(k)
end
local function R(a, b) return NumberRange.new(a, b or a) end
-- direction from azimuth / elevation in degrees: az 0 = forward (-Z), az 90 = right (+X), el 90 = up
local function dirAE(az, el)
	az, el = math.rad(az), math.rad(el)
	return Vector3.new(math.sin(az) * math.cos(el), math.sin(el), -math.cos(az) * math.cos(el))
end
local function lerp(a, b, k) return a + (b - a) * k end
K.NS, K.CS, K.R, K.dirAE = NS, CS, R, dirAE

---------------------------------------------------------------- proven textures ({ id, grid })
K.Tex = {
	Stroke = { 13780268621, "4x4" }, -- "Layered Slash": hero crescent, a U whose opening is sprite-up at Rotation 0
	StrokeThin = { 13580369776, "4x4" }, -- thin stroke: spins, trails, anything that passes near the camera
	Highlight = { 16285219607, "4x4" }, -- thin white stroke on top of the core
	Wind = { 13580370268, "4x4" }, -- faint air arc (LE 1, Br 0.6-1.5, Transparency 0.65-0.85)
	Dissolve = { 87180053247428, "4x4" }, -- eroding crescent = ghost / tail
	BoltSmall = { 9732664178, "4x4" }, -- crackle sheet
	BoltTangle = { 88372363219378, "2x2" }, BoltTangle2 = { 76973563852665, "2x2" }, -- short tangles (blade / ground crackle)
	BoltLong = { 111899421988292, "4x4" }, -- one long bolt sprite
	BoltInk = { 16047618456, "4x4" }, -- use with Color black, Br 0
	Star = { 14006783533 }, -- 4-point pop / glint (life <= 0.08 s)
	Needle = { 16433757077, "4x4" }, -- speed line: VelocityParallel + Rotation 90 + Squash 3
	Sparkle = { 17391818367 }, -- 4-point sparkle: MAX 4 per hit, life <= 0.15 s (else "stickers")
	Dot = { 15419166595 }, -- off-centre dot = spark volume / embers
	Flash = { 10556525755 }, -- black background: LE 1 ONLY (at LE 0 it paints a dark wedge)
	Glow = { 867619398 }, -- soft glow: LE 1 only (negative LE = hard dark disc)
	Ring = { 8505111714 }, -- shock / dust ring
	Crack = { 125427453566131 }, -- radial ground crack (one copy, never tiled)
	Rock = { 15441282898, "2x2" }, -- dark texture: unlit light grey reads as stone
	Smoke = { 13013256540, "4x4" }, Steam = { 16845391847, "4x4" },
	-- beam textures for FX:Curtain (white, clear background; a Beam runs the texture's HEIGHT along its length)
	Flow = { 16892453445 }, -- smeared flowing soft noise: the body of a sheet (the most used beam texture in the library)
	FlowStreaks = { 6091474388 }, -- glittery vertical noise streaks: thin fast detail
	FlowWisps = { 12251461261 }, -- soft vertical fog wisps: hot wisps, halo, edge feather
}
-- Texture tags. "mask" = white / grey art: Color tints it freely. "baked:<hue>" = colour painted into the art: Color
-- only MULTIPLIES it (blue x gold = olive), so leave it untinted or pick a mask twin. Measured with
-- kit/scripts/texture_traits.py on the original uploads (2026-11-17). Unknown ids return "unknown": measure them and
-- K.Tag(id, "mask") before you recolour them. "card" marks a black background (additive only, LE 1).
K.TexTag = {}
function K.Tag(id, tag) K.TexTag[tostring(id)] = tag end
function K.TagOf(id)
	if type(id) == "table" then id = id[1] end
	id = tostring(id):match("%d+") or tostring(id)
	return K.TexTag[id] or "unknown"
end
function K.IsMask(id) return K.TagOf(id):sub(1, 4) == "mask" end
for _, t in K.Tex do K.Tag(t[1], "mask") end
K.Tag(K.Tex.Flash[1], "mask card") -- white on a black card: tint freely, but LE 1 only
K.Tag(120758508542035, "baked:orange") -- MeshSlash "Hot" decal
K.Tag(98079913503816, "baked:blue") -- MeshSlash "Body" decal: tinted warm it goes dark / muddy
K.Tag(18227621394, "mask") -- MeshSlash "Band" decal
-- Tint helper that only tints masks: Color3 for a layer using `tex`. Baked art gets white (its own colour) unless
-- `force` (then it multiplies; check it on a sheet).
function K.Tint(tex, c, force)
	if K.IsMask(tex) or force then return c end
	return WH
end
-- Slash meshes for FX:MeshSlash (an invisible Part + SpecialMesh + Decal; ids from the open-source pack, looked at in
-- Studio). nat = the mesh's native size (SpecialMesh.Scale = wanted size / nat), tex = decal(s), span = degrees of arc
-- the decal paints, a0 = where the arc's middle sits (degrees from the mesh's -Z toward -X), rad = arc radius / mesh
-- radius, lead = "cw" when the thick bright end is the clockwise end seen from +Y (the kit turns it to lead the swing).
-- Add your own: measure nat with AssetService:CreateMeshPartAsync(...).MeshSize and look at the decal from above.
K.Mesh = {
	Hot = { mesh = 6665452633, nat = Vector3.new(2, 0.2, 2), tex = { 120758508542035 }, span = 174, a0 = 26, rad = 0.82, lead = "cw" }, -- flat ring + thin white-hot crescent
	Body = { mesh = 6665452633, nat = Vector3.new(2, 0.2, 2), tex = { 98079913503816 }, span = 140, a0 = 24, rad = 0.8, lead = "cw" }, -- flat ring + thick soft crescent (body, dark copy)
	Band = { mesh = 17105621375, nat = Vector3.one, tex = { 18227621394 }, span = 200, a0 = 0, rad = 1 }, -- slash wrapped round a squat cylinder: keeps HEIGHT edge-on
}
-- Decal.Color3 above 1 = shine (white-hot core, coloured rim, real bloom in daylight). gain 4-10; black stays black.
function K.HDR(c, gain) gain = gain or 7; return Color3.new(c.R * gain, c.G * gain, c.B * gain) end

-- banned in this run: 13781849388 (tiles into puddles), 12018086505 (closes arcs into rings), 17612096503 (other native rotation)

-- Palette: one hue family. hot = near-white tint, main = body, deep = darker same-hue, dark = ramp end.
-- No second hue in thin strokes (the violet ramp end showed as a purple line in v3-v5).
function K.Palette(main, deep, hot, dark)
	deep = deep or main:Lerp(INK, 0.45)
	return { main = main, deep = deep, hot = hot or main:Lerp(WH, 0.55), dark = dark or deep:Lerp(INK, 0.5), white = WH, ink = INK }
end
K.Palettes = {
	Storm = K.Palette(Color3.fromRGB(63, 208, 255), Color3.fromRGB(26, 109, 255), Color3.fromRGB(170, 240, 255), Color3.fromRGB(14, 40, 120)), -- proven
	Fire = K.Palette(Color3.fromRGB(255, 140, 40), Color3.fromRGB(230, 50, 15), Color3.fromRGB(255, 225, 150), Color3.fromRGB(110, 18, 6)), -- untested starting point
}

-- Brightness tiers (LightInfluence 0 everywhere). [LE, Brightness]
K.Tier = {
	Ink = { 0, 0 }, -- black twin / scorch
	Wind = { 1, 0.6 }, -- with Transparency 0.65-0.85
	Glow = { 1, 2 }, -- soft pools 1-6
	Core = { -3, 35 }, -- stroke core: white-hot centre, hue rim, dark strands (25-40; finisher 60)
	CoreSoft = { 0, 38 }, -- strokes that pass close to the camera
	Highlight = { 0, 60 },
	Accent = { -1, 45 }, -- needles 28-45
	Bolt = { -5, 45 }, -- sprite bolts 45-60
	Spark = { -3, 28 }, -- dots, sparkles 20-30
	Smoke = { 0, 0.8 },
}

-- Why each layer reads: "<what it does for the read>; keep: <the values that carry it>; free: <safe to change>".
-- Every emitter / beam / mesh layer stores one (attribute "why"); a layer you make yourself takes `why = "..."` in its
-- props, or inherits the line of its role. fx:Layers() prints the table for LOG.md; directors change "free" values
-- for taste and "keep" values only with a reason.
K.Why = {
	core = "hero stroke: mid-tone colour x high Brightness clips to a white-hot centre with a hue rim; keep: Br 25-40, LE <= 0, constant size, life 0.15-0.4; free: size within +-15 %, hue",
	ink = "dark partner: a thin black rim keeps the bright shape readable on light floors; keep: 0.9x size, Transparency >= 0.45, black, Br 0; free: ZOffset +-0.02..0.06",
	highlight = "thin white line on the leading edge = the hottest value; keep: Br ~60, thinner than the core; free: rotation offset",
	wind = "faint air arc for volume; keep: LE 1, Br <= 1.5, Transparency >= 0.65; free: size, life",
	fan = "tilted faint copies = volume when the stroke plane is edge-on; keep: faint (Transparency >= 0.55); free: fan angle",
	needle = "thin tapered speed lines: direction and force; keep: Size <= 0.8, Squash 3, life <= 0.18 s; free: count 8-14, speed",
	dot = "tumbling spark dots: volume and heat after a hit; keep: LE -3, Br 20-30, small; free: count, spread, gravity",
	pop = "one-frame white star on contact: says WHEN; keep: life <= 0.08 s; free: size",
	sparkle = "<= 4 tiny star glints; keep: life <= 0.15 s, count <= 4 (else stickers); free: colour within the palette",
	flash = "short additive flash: the beat's peak; keep: life <= 0.06 s, LE 1, below the hero's Brightness; free: size",
	glow = "soft additive pool round the hit; keep: LE 1, Br <= 6, short; free: size, colour",
	ring = "shock ring on the ground: reads from above and past the caster; keep: flat (VelocityPerpendicular), fast growth; free: diameters",
	dust = "grey dust: weight and contact with the ground; keep: LE 0, low Brightness, see-through; free: count, size",
	hotcrack = "hot crack cooling: heat stays where it hit; keep: one copy, ZOffset <= 0.25; free: rotation, diameter",
	scorch = "dark scorch under the crack: the hit leaves a mark; keep: black, Transparency >= 0.5; free: life",
	rock = "stone debris in three sizes: mass; keep: unlit light grey, <= 8 per size, gravity; free: speed, spread",
	smoke = "lingering smoke: the end of the beat; keep: LE 0, dark-ish, slow; free: size, count",
	bolt = "strobing electric crackle; keep: life 0.05 s, LE < 0 and high Br; free: size, count",
	linger = "aftermath: faint, low and radial so the hit leaves something for 1-2 s without forming a dome; keep: Transparency >= 0.7 (dust), no upward acceleration, low; free: count, colour",
	curtain = "scrolling beam sheet: flowing surface; keep: speeds not multiples of each other, LightInfluence 0; free: width, length, colour",
}

---------------------------------------------------------------- effect object
local FX = {}
FX.__index = FX

function K.new(name, originCF, palette)
	local old = workspace:FindFirstChild(name)
	if old then
		if _G.VFXKitLive and _G.VFXKitLive[name] then pcall(function() _G.VFXKitLive[name]:Stop() end) end
		old:Destroy()
	end
	local root = Instance.new("Folder"); root.Name = name; root.Parent = workspace
	if typeof(originCF) == "Vector3" then originCF = CFrame.new(originCF) end
	local fx = setmetatable({
		name = name, root = root, CF = originCF or CFrame.new(0, 0, 45), pal = palette or K.Palettes.Storm,
		events = {}, emitters = {}, beams = {}, _emitT = {}, curtains = {}, gain = "auto", updaters = {}, shakes = {}, strokes = {}, weapon = {}, ghosts = nil, meshes = {}, meshSlashes = {},
		keys = nil, hip = 3.2, shake = true, duration = 4.5, T = 0,
	}, FX)
	_G.VFXKitLive = _G.VFXKitLive or {}
	_G.VFXKitLive[name] = fx
	return fx
end

function FX:P(v) return self.CF:PointToWorldSpace(v) end -- caster-space point -> world
function FX:V(v) return self.CF:VectorToWorldSpace(v) end -- caster-space direction -> world

local function part(parent, props)
	local p = Instance.new("Part"); p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CastShadow = false
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	for k, v in props do p[k] = v end
	p.Parent = parent
	return p
end
function FX:Part(props) return part(self.root, props) end

-- invisible holder + attachment at a world CFrame
function FX:Att(worldCF, name)
	local p = part(self.root, { Size = Vector3.one * 0.2, Transparency = 1, CFrame = worldCF, Name = name or "fx" })
	local a = Instance.new("Attachment"); a.Parent = p
	return a, p
end
-- VelocityPerpendicular sprite basis for plane normal n (world), VERIFIED on up-, down-facing and vertical planes:
-- seen from the side n points to, right = Y x n, up = n x right. Exactly vertical normals are degenerate in the
-- engine (n = -Y came out mirrored), so they are nudged 1 degree.
local function planeBasis(n)
	n = n.Unit
	if math.abs(n.Y) > 0.9995 then n = (n + Vector3.new(0.0175, 0, 0)).Unit end
	local r = Vector3.yAxis:Cross(n).Unit
	return n, r, n:Cross(r).Unit
end
-- attachment whose Up is the plane normal (EmissionDirection Top => sprite lies in the plane). pos, n in caster space.
function FX:PlaneAtt(pos, n, name)
	local nw, r = planeBasis(self:V(n))
	return self:Att(CFrame.fromMatrix(self:P(pos), r, nw, r:Cross(nw)), name), nw
end
-- Rotation that turns a sprite's "up" toward w (world) on the plane with world normal nw
local function rotFor(nw, w)
	local n, r, up = planeBasis(nw)
	return math.deg(math.atan2(w:Dot(r), w:Dot(up)))
end
-- attachment looking along dir (EmissionDirection Front => particles fly along dir). pos, dir in caster space.
function FX:AimAtt(pos, dir, name)
	local p = self:P(pos)
	local d = self:V(dir).Unit
	local up = math.abs(d.Y) > 0.99 and Vector3.xAxis or Vector3.yAxis
	return (self:Att(CFrame.lookAt(p, p + d, up), name))
end

-- emitter factory. tex = K.Tex entry or id. props.n = default Emit count. Rate 0, LightInfluence 0, VPerp, still.
function FX:E(parent, tex, props)
	local id, grid = tex, nil
	if type(tex) == "table" then id, grid = tex[1], tex[2] end
	local e = Instance.new("ParticleEmitter")
	e.Texture = "rbxassetid://" .. id
	if grid then e.FlipbookLayout = GRID[grid]; e.FlipbookMode = Enum.ParticleFlipbookMode.OneShot end
	e.Rate = 0; e.LightInfluence = 0; e.Speed = R(0.001); e.SpreadAngle = Vector2.zero
	e.Orientation = VP; e.EmissionDirection = Enum.NormalId.Top; e.LockedToPart = false
	e.Rotation = R(0); e.RotSpeed = R(0); e.Transparency = NS(0); e.ZOffset = 0
	for k, v in props do if k ~= "n" and k ~= "role" and k ~= "why" then e[k] = v end end
	e:SetAttribute("n", props.n or 1); e:SetAttribute("ts", e.TimeScale); e:SetAttribute("role", props.role or "")
	e:SetAttribute("why", props.why or K.Why[props.role or ""] or ""); e:SetAttribute("tag", K.TagOf(id))
	e.Parent = parent
	table.insert(self.emitters, e)
	return e
end

---------------------------------------------------------------- timeline
function FX:At(t, fn) table.insert(self.events, { t = t, fn = fn }) end
function FX:EmitAt(t, e, n)
	self._emitT[e] = self._emitT[e] or {}; table.insert(self._emitT[e], t) -- for the stack gain
	self:At(t, function() e:Emit(n or e:GetAttribute("n")) end); return e
end
-- set / read the reason of any layer instance (emitter, beam, part, decal)
function FX:Why(inst, text) inst:SetAttribute("why", text); return inst end
-- fn(T) runs every frame with the effect clock (and once at the freeze time): drive parts, lights, beams from T
-- so a frozen frame and a live frame are identical. Never use task.delay / tweens / os.clock of your own.
function FX:OnUpdate(fn) table.insert(self.updaters, fn) end
-- register a Beam / Trail so a freeze stops its texture scroll
function FX:TrackBeam(b, why)
	b:SetAttribute("spd", b:IsA("Beam") and b.TextureSpeed or 0); table.insert(self.beams, b)
	if why then b:SetAttribute("why", why) end
	if b:IsA("Beam") and b:GetAttribute("tag") == nil then b:SetAttribute("tag", K.TagOf(b.Texture)) end
	return b
end
-- camera shake: decaying, only in live plays (never in freezes). Proven: light hit 0.15 / 0.1 s, heavy 0.6 / 0.35 s
function FX:Shake(t, amp, dur) table.insert(self.shakes, { t, amp or 0.15, dur or 0.1 }) end

---------------------------------------------------------------- stage
-- mid-grey concrete floor (#6d6f75: judge daylight contrast here), brick wall behind the target, side wall, two trees
function FX:Stage(o)
	o = o or {}
	local f = Instance.new("Folder"); f.Name = "Stage"; f.Parent = self.root
	local function P(props, pos, rot) props.CFrame = self.CF * CFrame.new(pos) * (rot or CFrame.identity); return part(f, props) end
	P({ Name = "Floor", Size = Vector3.new(o.size or 90, 1, o.size or 90), Color = o.floorColor or Color3.fromRGB(109, 111, 117), Material = Enum.Material.Concrete }, Vector3.new(0, -0.5, -10))
	if o.walls ~= false then
		P({ Name = "WallBack", Size = Vector3.new(30, 12, 1.5), Color = Color3.fromRGB(120, 118, 112), Material = Enum.Material.Brick, CastShadow = true }, Vector3.new(0, 6, -30))
		P({ Name = "WallL", Size = Vector3.new(1.5, 7, 22), Color = Color3.fromRGB(163, 158, 150), Material = Enum.Material.Concrete, CastShadow = true }, Vector3.new(-17, 3.5, -12))
	end
	if o.trees ~= false then
		for i, x in { 14, -11 } do
			local z = i == 1 and -18 or -24
			P({ Name = "Trunk", Shape = Enum.PartType.Cylinder, Size = Vector3.new(7, 1.2, 1.2), Color = Color3.fromRGB(105, 70, 45), Material = Enum.Material.Wood, CastShadow = true }, Vector3.new(x, 3.5, z), CFrame.Angles(0, 0, math.rad(90)))
			P({ Name = "Leaves", Shape = Enum.PartType.Ball, Size = Vector3.one * 7, Color = Color3.fromRGB(70, 130, 60), Material = Enum.Material.Grass, CastShadow = true }, Vector3.new(x, 8.5, z))
		end
	end
	return f
end
-- look line (yellow, with an arrow head at the far end), target mark (red) at `mark` studs, shoulder line. For the bird's-eye.
function FX:Guides(on, mark)
	local f = self.root:FindFirstChild("Guides"); if f then f:Destroy() end
	if not on then return end
	mark = mark or 8
	f = Instance.new("Folder"); f.Name = "Guides"; f.Parent = self.root
	local Y, RD = Color3.fromRGB(255, 200, 40), Color3.fromRGB(255, 60, 60)
	local function bar(size, pos, col, yaw) part(f, { Size = size, CFrame = self.CF * CFrame.new(pos) * CFrame.Angles(0, math.rad(yaw or 0), 0), Color = col, Material = Enum.Material.Neon }) end
	bar(Vector3.new(0.12, 0.02, 14), Vector3.new(0, 0.09, -7), Y)
	bar(Vector3.new(0.12, 0.02, 1.6), Vector3.new(0.5, 0.09, -13.5), Y, 40); bar(Vector3.new(0.12, 0.02, 1.6), Vector3.new(-0.5, 0.09, -13.5), Y, -40)
	bar(Vector3.new(2, 0.02, 0.12), Vector3.new(0, 0.09, -mark), RD)
	bar(Vector3.new(10, 0.02, 0.08), Vector3.new(0, 0.09, 0), Y)
end

---------------------------------------------------------------- R15 caster + FK poses (Edit mode has no Animator)
local JOINTS = {
	{ "LowerTorso", "HumanoidRootPart", "RootRigAttachment", "root" }, { "UpperTorso", "LowerTorso", "WaistRigAttachment", "waist" },
	{ "Head", "UpperTorso", "NeckRigAttachment", "neck" },
	{ "RightUpperArm", "UpperTorso", "RightShoulderRigAttachment", "rs" }, { "RightLowerArm", "RightUpperArm", "RightElbowRigAttachment", "re" }, { "RightHand", "RightLowerArm", "RightWristRigAttachment", "rw" },
	{ "LeftUpperArm", "UpperTorso", "LeftShoulderRigAttachment", "ls" }, { "LeftLowerArm", "LeftUpperArm", "LeftElbowRigAttachment", "le" }, { "LeftHand", "LeftLowerArm", "LeftWristRigAttachment", "lw" },
	{ "RightUpperLeg", "LowerTorso", "RightHipRigAttachment", "rh" }, { "RightLowerLeg", "RightUpperLeg", "RightKneeRigAttachment", "rk" }, { "RightFoot", "RightLowerLeg", "RightAnkleRigAttachment", "ra" },
	{ "LeftUpperLeg", "LowerTorso", "LeftHipRigAttachment", "lh" }, { "LeftLowerLeg", "LeftUpperLeg", "LeftKneeRigAttachment", "lk" }, { "LeftFoot", "LeftLowerLeg", "LeftAnkleRigAttachment", "la" },
}
local function aimRot(d) -- rotation (parent space) taking -Y to d
	local from = -Vector3.yAxis
	local axis = from:Cross(d)
	local ang = math.acos(math.clamp(from:Dot(d), -1, 1))
	if axis.Magnitude < 1e-4 then return ang > 1 and CFrame.Angles(math.pi, 0, 0) or CFrame.identity end
	return CFrame.fromAxisAngle(axis.Unit, ang)
end
local function localRot(pAtt, rotParent) local o = pAtt.CFrame.Rotation; return o:Inverse() * rotParent * o end
local EASE = {
	out = function(a) return 1 - (1 - a) ^ 2 end,
	fast = function(a) return 1 - (1 - a) ^ 3.2 end, -- the swing itself: snaps through, settles into the pose
	inout = function(a) return a * a * (3 - 2 * a) end,
	lin = function(a) return a end, -- full spins (keeps a stroke's RotSpeed matched to the body)
}
K.EASE = EASE

function FX:Caster(o)
	o = o or {}
	local d = Instance.new("HumanoidDescription")
	d.HeadColor = o.skin or Color3.fromRGB(234, 184, 146)
	d.LeftArmColor = o.arms or Color3.fromRGB(28, 30, 44); d.RightArmColor = d.LeftArmColor
	d.TorsoColor = o.torso or Color3.fromRGB(32, 36, 58)
	d.LeftLegColor = o.legs or Color3.fromRGB(44, 44, 50); d.RightLegColor = d.LeftLegColor
	local m = Players:CreateHumanoidModelFromDescription(d, Enum.HumanoidRigType.R15)
	m.Name = "Caster"
	for _, x in m:GetDescendants() do
		if x:IsA("BaseScript") then x:Destroy() elseif x:IsA("BasePart") then x.Anchored = true; x.CanCollide = false end
	end
	m.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	m.Parent = self.root
	self.char = m
	self.hip = o.hip or 3.2
	if not self.keys then self:Pose({ { t = 0 } }) end
	return m
end
-- parts that follow the right-hand grip frame (blade along -Z of the grip). list = { { partProps, offsetCFrame }, ... }
function FX:Weapon(list)
	local model = Instance.new("Model"); model.Name = "Weapon"; model.Parent = self.root
	for _, it in list do table.insert(self.weapon, { part(model, it[1]), it[2] }) end
	self.weaponModel = model
	return model
end
-- the proven katana: handle, guard, 4-stud blade, Neon edge (heats with fx.heat 0..1) + 4 attachments along the blade
function FX:Katana(o)
	o = o or {}
	local len = o.length or 4
	local mid = -0.5 - len / 2
	local m = self:Weapon({
		{ { Name = "Handle", Size = Vector3.new(0.2, 0.2, 1.1), Color = Color3.fromRGB(25, 25, 30), Material = Enum.Material.Fabric }, CFrame.new(0, 0, 0.15) },
		{ { Name = "Guard", Size = Vector3.new(0.5, 0.12, 0.5), Color = Color3.fromRGB(60, 55, 40), Material = Enum.Material.Metal }, CFrame.new(0, 0, -0.42) },
		{ { Name = "Blade", Size = Vector3.new(0.06, 0.26, len), Color = Color3.fromRGB(215, 222, 232), Material = Enum.Material.Metal, Reflectance = 0.3 }, CFrame.new(0, 0, mid) },
		{ { Name = "Edge", Size = Vector3.new(0.09, 0.07, len - 0.1), Color = self.pal.main, Material = Enum.Material.Neon, Transparency = 0.55 }, CFrame.new(0, 0.12, mid) },
	})
	self.blade, self.edge, self.bladeMid, self.bladeLen = m.Blade, m.Edge, mid, len
	self.bladeAtts = {}
	for _, k in { -0.4, -0.1, 0.2, 0.475 } do
		local a = Instance.new("Attachment"); a.Position = Vector3.new(0, 0, k * len); a.Parent = m.Blade
		table.insert(self.bladeAtts, a)
	end
	return m
end

-- Pose keys (all optional except t; a missing field keeps the previous key's value):
--   t, yaw (root turn, deg), wy / wp (waist yaw / pitch, + = lean back), ra / la = { az, el } upper-arm aim in torso space,
--   eb / lb elbow bends, bl = { az, el } blade direction in torso space, dr = root drop (crouch), mv = Vector3 root move
--   (caster space: lunges, steps), e = ease INTO this key ("out" | "fast" | "inout" | "lin").
--   fz  forward travel along the look line in studs (a front-foot step into the hit; it stays, like a real step)
--   st  stride 0..1.3: the legs spread front / back (use with fz and dr: a lunge is fz 2, st 1.3, dr 0.85)
--   hy  head yaw in degrees (+ = left) on top of the automatic counter-turn: the head leads or follows the cut
--   rl  root roll in degrees (+ = left): lean into a spin or a wide swing
--   two 0..1: the off hand (left) grips the handle `fx.offHand` (0.55) studs behind the right hand, solved by a
--       two-joint IK; la / lb are ignored while it is 1. Use it on every guard, wind-up and heavy two-handed hit and
--       release it (two = 0 with K.Guard.Tuck / K.Guard.Fist) only where the move is one-handed.
-- RULE: the pose leads. Never bend arms to reach an effect's plane; fit the effect to the blade (FX:MeshSlash,
-- Stroke{ swing = }). No T-pose between hits: upper arms below the shoulders with elbows bent 18-80 degrees, pass
-- through a guard (K.Guard) from one hit to the next. Lint() samples the pose and warns about all of this.
-- Proven shape of one hit: anticipation key ("out", 0.07 s) -> swing key ("fast", 0.12-0.18 s) -> held follow-through
-- ("out", 0.13 s = 8 frames). Keep hands / blade OUTSIDE the body silhouette seen from behind (az beyond +-100).
-- Trap: lerping az across the back swings the limb round the SIDE; for an overhead cut hold az 0 and take el past 90.
local DEF = { yaw = 0, wy = 0, wp = 0, ra = { 30, -60 }, la = { -30, -60 }, eb = 15, lb = 25, bl = { 0, -10 }, dr = 0, mv = Vector3.zero, fz = 0, st = 0, hy = 0, rl = 0, two = 0 }
-- Guard poses to pass through between hits (merge into a key with K.Key). Two-handed: Mid (blade forward and a little
-- up, hands in front of the belly), Low (blade back-down at the right hip), High (overhead wind-up). One-handed: the
-- free fist at the belly (Fist) or pulled to the ribs (Tuck).
K.Guard = {
	Mid = { wy = 15, wp = 2, ra = { 22, -48 }, eb = 55, bl = { 18, 14 }, dr = 0.4, two = 1 },
	Low = { wy = -25, wp = -4, ra = { 30, -60 }, eb = 45, bl = { 140, -32 }, dr = 0.75, two = 1 },
	High = { wy = 0, wp = 10, ra = { 12, 84 }, eb = 30, bl = { 0, 128 }, la = { -12, 80 }, lb = 30, dr = 0.1, two = 1 },
	Fist = { la = { -20, -62 }, lb = 75, two = 0 },
	Tuck = { la = { -35, -62 }, lb = 100, two = 0 },
}
-- K.Key(0.8, K.Guard.Low, { e = "out", fz = 1.5 }) -> one pose key
function K.Key(t, base, over)
	local k = { t = t }
	for f, v in base or {} do k[f] = v end
	for f, v in over or {} do k[f] = v end
	return k
end
function FX:Pose(keys)
	local prev = DEF
	local out = {}
	for _, k in keys do
		local n = {}
		for f, v in DEF do n[f] = k[f] ~= nil and k[f] or prev[f] end
		n.t, n.e = k.t, k.e
		table.insert(out, n); prev = n
	end
	self.keys = out
end
local function poseAt(keys, t)
	local a, b, k = keys[1], keys[1], 0
	if t >= keys[#keys].t then a, b = keys[#keys], keys[#keys]
	elseif t > keys[1].t then
		for i = 1, #keys - 1 do
			if t < keys[i + 1].t then a, b = keys[i], keys[i + 1]; k = EASE[b.e or "inout"]((t - a.t) / (b.t - a.t)); break end
		end
	end
	local P = {}
	for _, f in { "yaw", "wy", "wp", "eb", "lb", "dr", "fz", "st", "hy", "rl", "two" } do P[f] = lerp(a[f], b[f], k) end
	for _, f in { "ra", "bl", "la" } do P[f] = { lerp(a[f][1], b[f][1], k), lerp(a[f][2], b[f][2], k) } end
	P.mv = a.mv:Lerp(b.mv, k)
	return P
end
local function fromTo(u, v) -- minimal rotation taking unit u to unit v
	local axis = u:Cross(v)
	local d = math.clamp(u:Dot(v), -1, 1)
	if axis.Magnitude < 1e-5 then return d > 0 and CFrame.identity or CFrame.fromAxisAngle(Vector3.xAxis, math.pi) end
	return CFrame.fromAxisAngle(axis.Unit, math.acos(d))
end
-- two-joint IK of one arm ("Left" | "Right"): hand centre to world point T, elbow toward down / out / back of the torso
-- (never through the chest). Returns the upper arm, lower arm and hand CFrames.
local function armIK(m, cf, side, T)
	local UA, LA, H, UT = m[side .. "UpperArm"], m[side .. "LowerArm"], m[side .. "Hand"], m.UpperTorso
	local sN, eN, wN = side .. "ShoulderRigAttachment", side .. "ElbowRigAttachment", side .. "WristRigAttachment"
	local sU, eU = UA[sN].Position, UA[eN].Position
	local eL, wL = LA[eN].Position, LA[wN].Position
	local L1 = (eU - sU).Magnitude
	local L2 = (wL - eL).Magnitude + H[wN].Position.Magnitude
	local S = (cf.UpperTorso * UT[sN].CFrame).Position
	local d = T - S
	local dist = math.clamp(d.Magnitude, math.abs(L1 - L2) + 0.05, L1 + L2 - 0.02)
	local dn = d.Unit
	local pole = cf.UpperTorso:VectorToWorldSpace(Vector3.new(side == "Left" and -0.5 or 0.5, -1, 0.35))
	pole = pole - dn * pole:Dot(dn)
	pole = pole.Magnitude > 1e-3 and pole.Unit or cf.UpperTorso.RightVector * (side == "Left" and -1 or 1)
	local a = (L1 * L1 + dist * dist - L2 * L2) / (2 * dist)
	local h = math.sqrt(math.max(0, L1 * L1 - a * a))
	local E = S + dn * a + pole * h
	local Tn = S + dn * dist
	local Rt = cf.UpperTorso.Rotation
	local rU = fromTo(Rt:VectorToWorldSpace((eU - sU).Unit), (E - S).Unit) * Rt
	local ua = CFrame.new(S) * rU * CFrame.new(-sU)
	local rL = fromTo(rU:VectorToWorldSpace((wL - eL).Unit), (Tn - E).Unit) * rU
	local la = CFrame.new(E) * rL * CFrame.new(-eL)
	return ua, la, la * LA[wN].CFrame * H[wN].CFrame:Inverse()
end
-- world CFrames of every R15 part at clock time t, plus .Grip (right hand, -Z along the blade direction `bl`)
function FX:FK(t)
	local m = self.char
	local P = poseAt(self.keys, t)
	local rootCF = self.CF * CFrame.new(P.mv + Vector3.new(0, self.hip - P.dr, -P.fz)) * CFrame.Angles(0, math.rad(P.yaw), 0) * CFrame.Angles(0, 0, math.rad(P.rl))
	local rots = {
		root = CFrame.identity, waist = CFrame.Angles(math.rad(P.wp), math.rad(P.wy), 0),
		neck = CFrame.Angles(math.rad(-P.wp * 0.5), math.rad(-P.wy * 0.6 + P.hy), 0),
		rh = CFrame.Angles(math.rad(-18 - P.st * 14), 0, math.rad(8)), rk = CFrame.Angles(math.rad(-20 - P.dr * 30), 0, 0),
		lh = CFrame.Angles(math.rad(28 + P.dr * 20 + P.st * 12), 0, math.rad(-6)), lk = CFrame.Angles(math.rad(-30 - P.dr * 30), 0, 0),
		re = CFrame.Angles(math.rad(P.eb), 0, 0), le = CFrame.Angles(math.rad(P.lb), 0, 0),
	}
	local cf = { HumanoidRootPart = rootCF }
	for _, j in JOINTS do
		local child, parent, an, key = j[1], j[2], j[3], j[4]
		local pAtt, cAtt = m[parent][an], m[child][an]
		local r = rots[key] or CFrame.identity
		if key == "rs" then r = localRot(pAtt, aimRot(dirAE(P.ra[1], P.ra[2])))
		elseif key == "ls" then r = localRot(pAtt, aimRot(dirAE(P.la[1], P.la[2])))
		elseif key == "root" or key == "waist" or key == "neck" or key == "rh" or key == "lh" then r = localRot(pAtt, r) end
		cf[child] = cf[parent] * pAtt.CFrame * r * cAtt.CFrame:Inverse()
	end
	local hand = cf.RightHand
	local grip = hand.Position + hand.UpVector * -0.25
	local bl = cf.UpperTorso:VectorToWorldSpace(dirAE(P.bl[1], P.bl[2]))
	local upHint = cf.UpperTorso:VectorToWorldSpace(Vector3.new(0, 0, 1))
	if math.abs(bl:Dot(upHint)) > 0.95 then upHint = cf.UpperTorso.RightVector end
	cf.Grip = CFrame.lookAt(grip, grip + bl, upHint)
	if P.two > 0.001 then -- off hand on the handle behind the right hand
		local ua, la, hd = armIK(m, cf, "Left", grip - bl * (self.offHand or 0.55))
		local k = math.clamp(P.two, 0, 1)
		cf.LeftUpperArm = cf.LeftUpperArm:Lerp(ua, k); cf.LeftLowerArm = cf.LeftLowerArm:Lerp(la, k); cf.LeftHand = cf.LeftHand:Lerp(hd, k)
	end
	return cf
end
function FX:ApplyPose(t)
	if not self.char then return nil end
	local cf = self:FK(t)
	local m = self.char
	local parts, cfs = { m.HumanoidRootPart }, { cf.HumanoidRootPart }
	for _, j in JOINTS do table.insert(parts, m[j[1]]); table.insert(cfs, cf[j[1]]) end
	for _, w in self.weapon do table.insert(parts, w[1]); table.insert(cfs, cf.Grip * w[2]) end
	workspace:BulkMoveTo(parts, cfs, Enum.BulkMoveMode.FireCFrameChanged)
	return cf
end
-- caster-space samplers, so effects sit on the REAL limb path:
function FX:BladeDir(t) return self.CF:VectorToObjectSpace(self:FK(t).Grip.LookVector) end
function FX:PartPos(t, partName) return self.CF:PointToObjectSpace(self:FK(t)[partName or "RightHand"].Position) end
-- the swinging tip at clock time t (caster space): the blade tip with a weapon, or a part ("RightHand", "LeftFoot" ...)
function FX:TipPos(t, by)
	local cf = self:FK(t)
	if (by and by ~= "blade") or not self.bladeLen then return self.CF:PointToObjectSpace(cf[(by and by ~= "blade") and by or "RightHand"].Position) end
	return self.CF:PointToObjectSpace(cf.Grip.Position + cf.Grip.LookVector * (self.bladeLen + 0.5))
end
-- Fit a swing: sample the tip path between two pose times, fit its plane and a circle in it. Returns (caster space)
-- { c = circle centre, n = plane normal (the sweep runs counter-clockwise about n), R = radius, mid = direction from c
-- to the path's middle, deg = swept angle, by, t0, t1 }. A straight path (a thrust) has no circle: R is then huge and
-- `straight` is true; use a Stroke / needles for those.
function FX:FitArc(t0, t1, by, N)
	N = N or 16
	local pts, m = {}, Vector3.zero
	for i = 0, N do local p = self:TipPos(lerp(t0, t1, i / N), by); pts[i + 1] = p; m += p end
	m /= #pts
	local n = Vector3.zero
	for i = 1, N do n += (pts[i] - m):Cross(pts[i + 1] - m) end
	n = n.Magnitude > 1e-6 and n.Unit or Vector3.yAxis
	local e1 = pts[1] - m; e1 = e1 - n * e1:Dot(n)
	e1 = e1.Magnitude > 1e-4 and e1.Unit or n:Cross(Vector3.xAxis).Unit
	local e2 = n:Cross(e1)
	local sxx, sxy, syy, sx, sy, sxz, syz, sz = 0, 0, 0, 0, 0, 0, 0, 0 -- Kasa circle fit in the plane
	for _, p in pts do
		local x, y = (p - m):Dot(e1), (p - m):Dot(e2)
		local z = x * x + y * y
		sxx += x * x; sxy += x * y; syy += y * y; sx += x; sy += y; sxz += x * z; syz += y * z; sz += z
	end
	local A = { { sxx, sxy, sx }, { sxy, syy, sy }, { sx, sy, #pts } }
	local B = { -sxz, -syz, -sz }
	local function det(M) return M[1][1] * (M[2][2] * M[3][3] - M[2][3] * M[3][2]) - M[1][2] * (M[2][1] * M[3][3] - M[2][3] * M[3][1]) + M[1][3] * (M[2][1] * M[3][2] - M[2][2] * M[3][1]) end
	local D0 = det(A)
	local c, R, straight = m, 1, math.abs(D0) < 1e-7
	if not straight then
		local sol = {}
		for col = 1, 3 do
			local M = { { A[1][1], A[1][2], A[1][3] }, { A[2][1], A[2][2], A[2][3] }, { A[3][1], A[3][2], A[3][3] } }
			for r = 1, 3 do M[r][col] = B[r] end
			sol[col] = det(M) / D0
		end
		local cx, cy = -sol[1] / 2, -sol[2] / 2
		R = math.sqrt(math.max(0.01, cx * cx + cy * cy - sol[3]))
		c = m + e1 * cx + e2 * cy
		straight = R > 60
	end
	local len, cum = 0, { 0 }
	for i = 1, N do len += (pts[i + 1] - pts[i]).Magnitude; cum[i + 1] = len end
	local im = 1
	for i = 1, N + 1 do if cum[i] >= len / 2 then im = i; break end end
	local md = pts[im] - c; md = md - n * md:Dot(n)
	local d0, d1 = (pts[1] - c).Unit, (pts[N + 1] - c).Unit
	local half = math.deg(math.acos(math.clamp(d0:Dot(md.Unit), -1, 1))) + math.deg(math.acos(math.clamp(md.Unit:Dot(d1), -1, 1)))
	return { c = c, n = n, R = R, mid = md.Unit, deg = half, by = by, t0 = t0, t1 = t1, straight = straight, pts = pts }
end
-- plane of a swing between two pose times: returns centre c, normal n, mid (direction to the arc's middle), reach.
-- `by` = "blade" (default with a weapon) or a part name ("RightHand", "LeftFoot") for punches / kicks.
function FX:SwingPlane(t0, t1, by)
	local c = self:PartPos((t0 + t1) / 2, "UpperTorso")
	local function d(t)
		if by and by ~= "blade" then return (self:PartPos(t, by) - c).Unit end
		return self:BladeDir(t)
	end
	-- sample the path; the middle is the ANGULAR middle (eased swings are 90 % done at half time)
	local N = 24
	local ds, cum, n = {}, { 0 }, Vector3.zero
	for i = 0, N do ds[i + 1] = d(lerp(t0, t1, i / N)) end
	for i = 1, N do
		n += ds[i]:Cross(ds[i + 1])
		cum[i + 1] = cum[i] + math.acos(math.clamp(ds[i]:Dot(ds[i + 1]), -1, 1))
	end
	if n.Magnitude < 1e-3 then n = ds[1]:Cross(Vector3.yAxis) end
	n = n.Unit
	local im = N + 1
	for i = 1, N + 1 do if cum[i] >= cum[N + 1] / 2 then im = i; break end end
	local tm = lerp(t0, t1, (im - 1) / N)
	local mid = (ds[im] - n * ds[im]:Dot(n)).Unit
	local reach
	if by and by ~= "blade" then reach = (self:PartPos(tm, by) - c).Magnitude + 1
	else reach = (self.CF:PointToObjectSpace(self:FK(tm).Grip.Position) - c).Magnitude + (self.bladeLen or 0) + 0.5 end
	return c, n, mid, reach, math.deg(cum[N + 1])
end
-- smear ghosts: `count` Neon copies of the weapon line at past clock times, only inside swing windows { {t0, t1}, ... }.
-- Square section (reads from every side). Use on vertical / heavy cuts only: on flat swings they fan out as "planks".
function FX:Ghosts(o)
	o = o or {}
	local g = { windows = o.windows or {}, step = o.step or 0.011, parts = {}, off = CFrame.new(0, 0, self.bladeMid or -2.5) }
	local len = (self.bladeLen or 4) + 0.1
	for k = 1, o.count or 7 do
		table.insert(g.parts, part(self.root, { Name = "Ghost" .. k, Size = Vector3.new(0.22, 0.22, len), Color = o.color or self.pal.hot, Material = Enum.Material.Neon, Transparency = 1 }))
	end
	self.ghosts = g
end

---------------------------------------------------------------- strokes
-- One slash / swipe / punch arc: bright core + thin ink rim (0.9x black twin, see-through) + white highlight + faint wind.
--   t      emit time                      c     centre of the arc (caster space, usually chest / shoulder)
--   n      plane normal (caster space)    mid   direction from c to the MIDDLE of the arc (caster space)
--   size   sprite size (~1.6 x reach)     life  0.2 (finisher 0.3)
--   br     core Brightness (35; finisher 60)   rs   RotSpeed deg/s (0; spins: match the body turn, e.g. -1600)
--   soft   true for strokes that pass within ~8 studs of a camera behind the caster (spins): no twin, LE 0, see-through
--   twin   false = no ink rim             twinTr  0.45 (0 = black slab from the side: never)
--   fan    degrees (10): two faint copies on planes turned +-fan about `fanAxis` (default: world up) = volume for an
--          edge-on cut. Use on every vertical cut that the player camera sees edge-on.
--   swing  { t0, t1 [, by] }: take c, n, mid and size from the pose (FX:SwingPlane) instead of typing them
--   flip   mirror the sprite (reverses which end of the flipbook stroke leads)
-- Big (size >= 14) or long (life >= 0.25) strokes fade at 42-62 % of life automatically: the late flipbook frames sit
-- elsewhere in the cell and the tail "detaches and flies off" in live playback (invisible on frozen sheets).
function FX:Stroke(s)
	local pal = s.pal or self.pal
	local c, n, mid, size = s.c, s.n, s.mid, s.size
	if s.swing then
		local sc, sn, sm, reach = self:SwingPlane(s.swing[1], s.swing[2], s.swing[3])
		c, n, mid, size = c or sc, n or sn, mid or sm, size or reach * 1.6
	end
	if s.flip then n = -n end
	local life, rs = s.life or 0.2, s.rs or 0
	local t = s.t
	local a, nw = self:PlaneAtt(c, n, s.name or "Stroke")
	local w = self:V(-mid); w = (w - nw * w:Dot(nw)).Unit -- sprite-up (the U's opening) points back at the centre
	local r = rotFor(nw, w) + (s.rotAdd or 0)
	local soft = s.soft
	local early = s.fadeEarly
	if early == nil then early = (size >= 14 or life >= 0.25) and rs == 0 end
	local ramp = soft and CS(pal.main, 1, pal.deep) or CS(0, pal.main, 0.5, pal.deep, 1, pal.dark)
	local coreTr = soft and NS(0, 0.1, 0.5, 0.2, 1, 1) or NS(0)
	if early then coreTr = NS(0, 0, 0.42, 0, 0.62, 1, 1, 1); ramp = CS(pal.main:Lerp(WH, 0.25), 1, pal.deep) end
	local tex = s.tex or (soft and K.Tex.StrokeThin or K.Tex.Stroke)
	local out = { att = a, r = r, n = n, c = c, mid = mid, size = size }
	if not s._tail then table.insert(self.strokes, { name = s.name or "Stroke", n = n.Unit, fan = s.fan, soft = soft, t = t }) end
	out.core = self:EmitAt(t, self:E(a, tex, { role = "core", Size = NS(size), Lifetime = R(life), Rotation = R(r), RotSpeed = R(rs), Color = ramp,
		LightEmission = soft and 0 or -3, Brightness = s.br or (soft and 38 or 35), Transparency = coreTr, ZOffset = 0.04 }))
	if s.twin ~= false and not soft then
		local tr = s.twinTr or 0.45
		out.twin = self:EmitAt(t, self:E(a, tex, { role = "ink", Size = NS(size * 0.9), Lifetime = R(life * 0.95), Rotation = R(r), RotSpeed = R(rs), Color = CS(INK),
			LightEmission = 0, Brightness = 0, Transparency = early and NS(0, tr, 0.42, tr, 0.62, 1, 1, 1) or NS(tr), ZOffset = 0.06 }))
	end
	if s.highlight ~= false then
		self:EmitAt(t, self:E(a, K.Tex.Highlight, { role = "highlight", Size = NS(size * 0.9), Lifetime = R(life * 0.7), Rotation = R(r + 12 * (rs >= 0 and 1 or -1)), RotSpeed = R(rs),
			Color = CS(pal.hot), LightEmission = 0, Brightness = soft and 15 or 60, Transparency = soft and NS(0.5) or (early and coreTr or NS(0)), ZOffset = 0.08 }))
	end
	if s.wind ~= false then
		self:EmitAt(t + 0.03, self:E(a, K.Tex.Wind, { role = "wind", Size = NS(size * 1.2), Lifetime = R(0.25, 0.35), Rotation = R(r - 8), RotSpeed = R(rs * 0.25), SpreadAngle = Vector2.new(3, 3),
			Color = CS(pal.hot:Lerp(WH, 0.3)), LightEmission = 1, Brightness = 0.6, Transparency = NS(0, 0.85, 1, 1), ZOffset = -0.05 }))
	end
	if s.fan then
		local axis = s.fanAxis or Vector3.yAxis
		for _, sgn in { 1, -1 } do
			local nf = CFrame.fromAxisAngle(axis, math.rad(s.fan * sgn)):VectorToWorldSpace(n)
			local fa, nfw = self:PlaneAtt(c, nf, "StrokeFan")
			local wf = self:V(-mid); wf = (wf - nfw * wf:Dot(nfw)).Unit
			local rf = rotFor(nfw, wf)
			self:EmitAt(t + 0.01, self:E(fa, tex, { role = "fan", Size = NS(size * 1.05), Lifetime = R(life * 0.75), Rotation = R(rf), Color = CS(pal.main:Lerp(WH, 0.3), 1, pal.deep),
				LightEmission = 0, Brightness = 12, Transparency = NS(0, 0.55, 0.45, 0.6, 0.62, 1, 1, 1), ZOffset = -0.02 }))
			self:EmitAt(t + 0.02, self:E(fa, K.Tex.Wind, { role = "wind", Size = NS(size * 1.25), Lifetime = R(0.3), Rotation = R(rf), Color = CS(pal.hot:Lerp(WH, 0.3)),
				LightEmission = 1, Brightness = 1.2, Transparency = NS(0, 0.7, 1, 1), ZOffset = -0.05 }))
		end
	end
	return out
end
-- points on a stroke's arc (caster space): for crackle, side sparks, impact-frame silhouettes. angles in degrees from `mid`.
function FX:ArcPoints(c, n, mid, radius, angles)
	n = n.Unit
	local pts = {}
	for _, a in angles do table.insert(pts, c + CFrame.fromAxisAngle(n, math.rad(a)):VectorToWorldSpace(mid.Unit) * radius) end
	return pts
end

---------------------------------------------------------------- mesh slashes
-- A slash made of MESHES fitted to the swing: per layer an invisible Part + SpecialMesh + Decal whose Color3 is above
-- 1 (shine). The kit samples the tip path of the pose (blade, hand or foot), fits its plane and circle (FX:FitArc)
-- and drives every layer from the effect clock: the arc's middle trails the tip by `lag` degrees, the radius grows,
-- the thickness thins, the decal holds and then fades Cubic Out. Frozen frame = live frame.
--   swing   { t0, t1 [, by] }  pose times of the swing; by = "blade" (default with a weapon) or a part name
--                              ("RightHand" for a punch, "RightFoot" for a kick)
--   on      first visible time (t0 + 0.025)        hold  opaque until (t1 - 0.02)
--   fade    seconds of the Cubic Out fade after `hold` (0.1; keep 0.08-0.25: longer = a lingering line)
--   follow  the layers stop turning with the tip at this time (t1)
--   height  multiplies the Band's height along the plane normal (1 = 1.1 studs; 2-2.4 for a cut seen edge-on)
--   band    false = no Band layer (flat cuts seen from above only)
--   gain    multiplies every layer's shine (1)
--   layers  your own stack instead of the default (see below); each layer:
--           { kind = "Hot" | "Body" | "Band" (K.Mesh), r = radius / fitted radius, th = thickness in studs, col =
--             Color3 (use K.HDR), col1 = colour at the end of its life, lag = degrees its middle trails the tip
--             (default: half the decal's span = its head sits on the blade), tr0 = start transparency, offN = offset
--             along the normal, g0 / g1 = radius growth (0.92 -> 1.1), early = seconds it ends before the others,
--             on / hold / off = own times, flip = mirror which end leads }
--   tail    true or { tex, size, life, br, t }: one flipbook sprite on the same plane for an animated, eroding tail
-- Default stack (the order pros layer it): Band in the main colour (the body with height), Body in the deep colour,
-- a BLACK Body copy at 0.9x radius, see-through, a little behind and ending first (depth; never bigger than the
-- bright layers: from the far side it would cover them), and the white-hot Hot crescent on top, cooling to the main
-- colour. Shorten from the tail: add layers with a bigger `lag` and an earlier `off`.
-- Meshes beat sprites when the slash must SHINE in daylight (HDR decal, real bloom), sit ON the blade all through the
-- swing (they turn with it; a sprite is stamped once) and keep some height when its plane is edge-on to the player
-- (the Band's wall). Sprites (FX:Stroke) are better for an animated, eroding shape (flipbook), a stylised ink look,
-- many small or cheap hits, and anything that passes within a few studs of a camera. A mesh layer fades as a whole:
-- for a tail that breaks up add `tail`, or stagger layers.
-- Returns { fit, c, n, R, mid, on, hold, off, layers }.
function FX:MeshSlash(s)
	local pal = s.pal or self.pal
	local t0, t1, by = s.swing[1], s.swing[2], s.swing[3]
	local fit = s.fit or self:FitArc(t0, t1, by, s.samples)
	local on, hold, fade = s.on or (t0 + 0.025), s.hold or (t1 - 0.02), s.fade or 0.1
	local follow = s.follow or t1
	local h, gain = s.height or 1, s.gain or 1
	local layers = s.layers
	if not layers then
		layers = {
			{ kind = "Band", r = 1.02, th = 1.1 * h, col = K.HDR(pal.main, 7 * gain) },
			{ kind = "Body", r = 0.98, th = 0.3, col = K.HDR(pal.deep, 7 * gain), offN = -0.03 },
			{ kind = "Body", r = 0.88, th = 0.3, col = Color3.new(0, 0, 0), tr0 = 0.5, offN = -0.09, early = 0.03 },
			{ kind = "Hot", r = 1.04, th = 0.3, col = K.HDR(pal.hot, 9.5 * gain), col1 = K.HDR(pal.main, 7 * gain), offN = 0.04 },
		}
		if s.band == false then table.remove(layers, 1) end
	end
	local name = s.name or "MeshSlash"
	local rec = { name = name, fit = fit, c = fit.c, n = fit.n, R = fit.R, mid = fit.mid, on = on, hold = hold, off = hold + fade, fade = fade, layers = {} }
	for i, L in layers do
		local M = type(L.kind) == "table" and L.kind or K.Mesh[L.kind]
		local p = part(self.root, { Name = ("%s_%d_%s"):format(name, i, type(L.kind) == "string" and L.kind or "mesh"), Size = Vector3.one, Transparency = 1 })
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.FileMesh; sm.MeshId = "rbxassetid://" .. M.mesh; sm.Scale = Vector3.one * 0.01; sm.Parent = p
		local decs = {}
		for _, tx in M.tex do
			local d = Instance.new("Decal"); d.Texture = "rbxassetid://" .. tx; d.Face = Enum.NormalId.Top; d.Color3 = L.col or K.HDR(pal.main); d.Transparency = 1; d.Parent = p
			table.insert(decs, d)
		end
		local lOn = L.on or on
		local lHold = L.hold or (hold - (L.early or 0))
		local lay = {
			p = p, sm = sm, decs = decs, M = M, fit = fit, by = by, follow = L.follow or follow, vis = false,
			on = lOn, hold = lHold, off = L.off or (lHold + (L.fade or fade)),
			r = L.r or 1, th = L.th or 0.3, col = L.col or K.HDR(pal.main), col1 = L.col1, lag = L.lag or (M.span / 2), tr0 = L.tr0 or 0,
			offN = L.offN or 0, g0 = L.g0 or 0.92, g1 = L.g1 or 1.1, kind = L.kind,
			why = L.why or ((L.col and L.col.R + L.col.G + L.col.B <= 0.3) and "dark copy: depth behind the bright layers; keep: r 0.86-0.9x, tr0 >= 0.5, ends first"
				or ({ Band = "band: the slash body with height, so it keeps a wall when its plane is edge-on; keep: HDR colour (shine); free: height", Body = "body: the thick soft crescent in the deep tone under the hot layer; keep: HDR > 1",
					Hot = "hot crescent: the white-hot leading edge cooling to the main colour; keep: brightest layer, HDR 8-10" })[L.kind] or "mesh slash layer"),
			sign = ((M.lead == "cw") ~= (L.flip == true)) and -1 or 1,
		}
		table.insert(self.meshes, lay); table.insert(rec.layers, lay)
	end
	table.insert(self.meshSlashes, rec)
	if not self._meshUpd then
		self._meshUpd = true
		self:OnUpdate(function(T) self:_meshes(T) end)
	end
	if s.tail then
		local tl = type(s.tail) == "table" and s.tail or {}
		self:Stroke({ name = name .. "Tail", t = tl.t or (hold - 0.03), c = fit.c, n = fit.n, mid = fit.mid, size = (tl.size or 2) * fit.R, tex = tl.tex or K.Tex.Dissolve,
			life = tl.life or 0.25, br = tl.br or 22, twin = false, highlight = false, wind = false, pal = pal, _tail = true })
	end
	return rec
end
function FX:_meshes(T)
	local tips = {}
	for _, L in self.meshes do
		if T < L.on or T >= L.off then
			if L.vis then for _, d in L.decs do d.Transparency = 1 end; L.vis = false end
		else
			L.vis = true
			local fit = L.fit
			local tf = math.min(T, L.follow)
			local key = tf .. (L.by or "")
			local tip = tips[key]; if not tip then tip = self:TipPos(tf, L.by); tips[key] = tip end
			local n = fit.n
			local d = tip - fit.c; d = d - n * d:Dot(n)
			d = d.Magnitude > 1e-4 and d.Unit or fit.mid
			local mid = CFrame.fromAxisAngle(n, -math.rad(L.lag)):VectorToWorldSpace(d) -- the arc's middle trails the tip
			local k = (T - L.on) / (L.off - L.on)
			local Rr = fit.R * L.r * lerp(L.g0, L.g1, 1 - (1 - k) ^ 2)
			local th = L.th * (1.25 - 0.5 * k)
			local nw, Z = self:V(n), self:V(-mid)
			local Y = nw * L.sign
			L.p.CFrame = CFrame.fromMatrix(self:P(fit.c + n * L.offN), Y:Cross(Z), Y, Z) * CFrame.Angles(0, -math.rad(L.M.a0 or 0), 0)
			local nat, rad = L.M.nat, L.M.rad or 1
			L.sm.Scale = Vector3.new(2 * Rr / rad / nat.X, th / nat.Y, 2 * Rr / rad / nat.Z)
			local tr = L.tr0
			if T > L.hold then tr = L.tr0 + (1 - L.tr0) * (1 - (1 - math.clamp((T - L.hold) / (L.off - L.hold), 0, 1)) ^ 3) end -- Cubic Out
			local col = L.col1 and L.col:Lerp(L.col1, math.clamp(k * 1.2, 0, 1)) or L.col
			for _, dc in L.decs do dc.Transparency = tr; dc.Color3 = col end
		end
	end
end

---------------------------------------------------------------- sparks, contact, crackle
-- thin streaks flying along dir (VelocityParallel). Leave empty space: n 8-12, Drag 12-18, life <= 0.18 s.
function FX:Needles(s)
	local pal = s.pal or self.pal
	local a = s.att or self:AimAtt(s.p, s.dir or Vector3.yAxis, "Needles")
	local sp = s.speed or { 25, 55 }
	return self:EmitAt(s.t, self:E(a, K.Tex.Needle, { role = "needle", n = s.n or 8, Orientation = VPAR, EmissionDirection = s.face or Enum.NormalId.Front, Size = NS(s.size or 0.7, 1, (s.size or 0.7) * 0.28), Squash = NS(3),
		Lifetime = R(s.life or 0.08, (s.life or 0.08) * 1.5), Speed = R(sp[1], sp[2]), Drag = s.drag or 12, SpreadAngle = Vector2.new(s.spread or 22, s.spread or 22), Rotation = R(90),
		Color = CS(pal.main), LightEmission = -1, Brightness = s.br or 40, ZOffset = 1 }))
end
-- off-centre dots = spark volume (they tumble). Gravity + drag.
function FX:Dots(s)
	local pal = s.pal or self.pal
	local a = s.att or self:AimAtt(s.p, s.dir or Vector3.yAxis, "Dots")
	local sp = s.speed or { 8, 30 }
	return self:EmitAt(s.t, self:E(a, K.Tex.Dot, { role = "dot", n = s.n or 6, Orientation = FC, EmissionDirection = s.face or Enum.NormalId.Front, Size = NS(0, 0, 0.12, s.size or 0.6, 1, 0),
		Lifetime = R(s.life or 0.5, (s.life or 0.5) * 1.8), Speed = R(sp[1], sp[2]), Drag = s.drag or 15, SpreadAngle = Vector2.new(s.spread or 60, s.spread or 60), Acceleration = Vector3.new(0, s.gravity or -15, 0),
		Rotation = R(-180, 180), RotSpeed = R(-300, 300), Color = CS(s.color or pal.hot), LightEmission = -3, Brightness = s.br or 25, ZOffset = 1.5 }))
end
-- hit contact where the stroke meets the target line: white pop star (0.06 s), needles + dots along the tangent, <= 3 sparkles
function FX:Contact(s)
	local pal = s.pal or self.pal
	local a = self:AimAtt(s.p, s.dir, "Contact")
	local t = s.t
	self:EmitAt(t, self:E(a, K.Tex.Star, { role = "pop", Orientation = FC, Size = NS(0, s.pop or 4, 1, 0), Lifetime = R(0.06), Color = CS(WH), LightEmission = 0, Brightness = 30, ZOffset = 2 }))
	if s.needles ~= 0 then self:Needles({ t = t, att = a, n = s.needles or 8, pal = pal }) end
	self:EmitAt(t + 0.01, self:E(a, K.Tex.Sparkle, { role = "sparkle", n = math.min(s.sparkles or 3, 4), Orientation = FC, EmissionDirection = Enum.NormalId.Front, Size = NS(0, 0, 0.18, 0.7, 1, 0), Lifetime = R(0.1, 0.15),
		Speed = R(15, 50), Drag = 12, Acceleration = Vector3.new(0, -15, 0), SpreadAngle = Vector2.new(45, 45), Color = CS(pal.hot), LightEmission = -3, Brightness = 25, ZOffset = 1.5 }))
	self:Dots({ t = t + 0.01, att = a, n = s.dots or 6, pal = pal })
	return a
end
-- strobing small bolts (0.05 s each, random planes) + one ink bolt, on caster-space points or existing attachments.
-- t / pops / gap: `pops` flashes `gap` apart per point. Keep size <= the thing it sits on (blade: 1.0-1.3; arc: 2.5-4).
function FX:Crackle(s)
	local pal = s.pal or self.pal
	local size, pops, gap = s.size or 3, s.pops or 3, s.gap or 0.045
	local atts = s.atts or {}
	for _, p in s.pts or {} do table.insert(atts, (self:Att(CFrame.new(self:P(p)), "Crackle"))) end
	for i, a in atts do
		local bolt = self:E(a, i % 2 == 0 and K.Tex.BoltTangle or K.Tex.BoltSmall, { role = "bolt", Size = NS(size), Lifetime = R(0.05), Rotation = R(-180, 180), Speed = R(0.01), SpreadAngle = Vector2.new(180, 180),
			Color = CS(pal.main), LightEmission = s.le or -5, Brightness = s.br or 45, ZOffset = s.z or 0.5 })
		local ink = self:E(a, K.Tex.BoltInk, { role = "ink", Size = NS(size * 1.25), Lifetime = R(0.05), Rotation = R(-180, 180), Speed = R(0.01), SpreadAngle = Vector2.new(180, 180),
			Color = CS(INK), LightEmission = 0, Brightness = 0, ZOffset = (s.z or 0.5) - 0.05 })
		local t0 = s.t + 0.01 + i * 0.012
		self:EmitAt(t0, ink, 1)
		for k = 0, pops - 1 do self:EmitAt(t0 + k * gap, bolt, 1) end
	end
end
-- charge that lives ON the weapon / limb (never a blob bigger than it): crackle getting denser from t0 to t1 on `atts`,
-- needles pulled inward from `radius` (4) studs out to `follow` (a Part), a tip glint (5 frames) just before t1, then
-- 3-4 frames of silence before the hit. size 1.0-1.3 for a 4-stud blade. It must BUILD: raise fx.heat / light with it.
function FX:Charge(s)
	local pal = s.pal or self.pal
	local t0, t1, size = s.t0, s.t1, s.size or 1.2
	for i, a in s.atts do
		local b1 = self:E(a, K.Tex.BoltTangle, { role = "bolt", Size = NS(size), Lifetime = R(0.05), Rotation = R(-180, 180), Speed = R(0.01), SpreadAngle = Vector2.new(180, 180), Color = CS(pal.main), LightEmission = -3, Brightness = 25, ZOffset = 1 })
		local b2 = self:E(a, K.Tex.BoltTangle2, { role = "bolt", Size = NS(size * 0.8), Lifetime = R(0.05), Rotation = R(-180, 180), Speed = R(0.01), SpreadAngle = Vector2.new(180, 180), Color = CS(pal.main:Lerp(pal.deep, 0.3)), LightEmission = -3, Brightness = 30, ZOffset = 1.1 })
		local tt, k = t0 + i * 0.011, 0
		while tt < t1 - 0.06 do
			self:EmitAt(tt, k % 2 == 0 and b1 or b2, 1); k += 1
			tt += math.max(0.018, 0.045 - (tt - t0) * 0.05) -- sparse at first, denser toward the release
		end
	end
	if s.follow then
		local gp = part(self.root, { Name = "Gather", Shape = Enum.PartType.Ball, Size = Vector3.one * (s.radius or 4) * 2, Transparency = 1 })
		local ge = self:E(gp, K.Tex.Needle, { role = "needle", n = 2, Orientation = VPAR, Speed = R((s.radius or 4) * 4.6, (s.radius or 4) * 5.6), Lifetime = R(0.16, 0.2), Size = NS(0, 0.35, 1, 0.15), Squash = NS(2.5), Rotation = R(90), Color = CS(pal.main), LightEmission = -1, Brightness = 30, ZOffset = 1 })
		ge.Shape = Enum.ParticleEmitterShape.Sphere; ge.ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward; ge.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
		for tt = t0 + 0.08, t1 - 0.04, 0.06 do self:EmitAt(tt, ge, 2) end
		self:OnUpdate(function() gp.CFrame = s.follow.CFrame end)
	end
	if s.tip then
		self:EmitAt(t1 - 0.12, self:E(s.tip, K.Tex.Star, { role = "pop", Orientation = FC, Size = NS(0, 0, 0.4, size * 1.3, 1, 0), Lifetime = R(0.08), Color = CS(WH), LightEmission = 0, Brightness = 60, ZOffset = 3 }))
	end
end

---------------------------------------------------------------- impact blocks
-- Flash: short and LOCAL. flash 0.05 s (LE 1), star 0.07 s, glow 0.1 s, PointLight Range <= 16 for ~0.25 s. No world tint.
-- The brightest SHAPE (bolt, stroke, fist) must stay brighter than the flash.
function FX:Flash(s)
	local pal = s.pal or self.pal
	local a = self:Att(CFrame.new(self:P(s.p)), "Flash")
	local size, t = s.size or 18, s.t
	self:EmitAt(t, self:E(a, K.Tex.Flash, { role = "flash", Orientation = FC, Size = NS(0, size, 1, 0), Lifetime = R(0.05), Color = CS(pal.hot), LightEmission = 1, Brightness = 6, ZOffset = 4 }))
	self:EmitAt(t, self:E(a, K.Tex.Star, { role = "pop", Orientation = FC, Size = NS(0, size * 0.33, 0.35, size * 0.78, 1, 0), Lifetime = R(0.07), Color = CS(WH), LightEmission = 0, Brightness = 30, ZOffset = 4.2 }))
	self:EmitAt(t, self:E(a, K.Tex.Glow, { role = "glow", Orientation = FC, Size = NS(0, size * 0.67, 1, size * 0.22), Lifetime = R(0.1), Color = CS(pal.main), LightEmission = 1, Brightness = 1, Transparency = NS(0, 0, 1, 1), ZOffset = 3 }))
	if s.light ~= false then self:Light({ t = t + (s.lightDelay or 0), p = s.p + Vector3.new(0, 1.5, 0), range = math.min(s.range or 16, 16), br = s.lightBr or 1.5, dur = 0.25 }) end
	return a
end
-- local PointLight envelope: hold 0.06 s, then quadratic falloff to `dur`. Range is clamped to 16.
function FX:Light(s)
	local _, holder = self:Att(CFrame.new(self:P(s.p)), "Light")
	local L = Instance.new("PointLight"); L.Color = s.color or self.pal.main; L.Range = math.min(s.range or 16, 16); L.Brightness = 0; L.Shadows = false; L.Parent = holder
	local t0, br, dur = s.t, s.br or 1.5, s.dur or 0.25
	self:OnUpdate(function(T)
		local x = T - t0
		L.Brightness = (x < 0 or x >= dur) and 0 or (x < 0.06 and br or br * (1 - (x - 0.06) / (dur - 0.06)) ^ 2)
	end)
	return L
end
-- Parts lightning: a COLUMN, not a line. Three Neon layers on one jagged path: white core (`width` at the ground,
-- tapering to 35 % at the top), hue sheath 2.5x at Transparency 0.4, wide glow 6x at 0.85. `shapes` pre-built variants
-- are swapped every `step` s (one short gap = restrike flicker); the last three shrink in width instead of popping off.
-- Brightest shape in daylight, freezes cleanly. from / to in caster space (default from = `height` studs above `to`;
-- make it >= 3x the caster's height so it frames the caster from behind).
-- Returns { coreParts = first shape's core (pass to ImpactFrame) }. (v7 used width 0.24 / 14 segments: "pencil bolt".)
function FX:Bolt(s)
	local pal = s.pal or self.pal
	local to = self:P(s.to)
	local segs, jit, w = s.segments or 20, s.jitter or 0.8, s.width or 0.9
	local shapes, step, t0 = s.shapes or 7, s.step or 0.035, s.t
	local folder = Instance.new("Folder"); folder.Name = "Bolt"; folder.Parent = self.root
	local all, wins, firstCore = {}, {}, {}
	for k = 0, shapes - 1 do
		local rng = Random.new((s.seed or 11) + k * 13)
		local from = s.from and self:P(s.from) or to + Vector3.new(rng:NextNumber(-2, 2), s.height or 30, rng:NextNumber(-2, 1))
		local shrink = math.clamp((shapes - k) / 3, 0.3, 1) -- last shapes thin out
		local list = {}
		local function seg(a, b, width, col, tr)
			local p = part(folder, { Size = Vector3.new(width, width, (b - a).Magnitude + width * 0.3), CFrame = CFrame.lookAt((a + b) / 2, b), Color = col, Material = Enum.Material.Neon, Transparency = 1 })
			p:SetAttribute("tr", tr); table.insert(list, p)
			if k == 0 and tr == 0 then table.insert(firstCore, p) end
		end
		local function chain(a, b, nSeg, j, w0, w1)
			local pts = { a }
			for i = 1, nSeg - 1 do
				table.insert(pts, a:Lerp(b, i / nSeg) + Vector3.new(rng:NextNumber(-j, j), rng:NextNumber(-j * 0.3, j * 0.3), rng:NextNumber(-j, j)))
			end
			table.insert(pts, b)
			for i = 1, #pts - 1 do
				local width = lerp(w0, w1, (i - 0.5) / (#pts - 1)) * shrink
				seg(pts[i], pts[i + 1], width, WH, 0); seg(pts[i], pts[i + 1], width * 2.5, pal.main, 0.4); seg(pts[i], pts[i + 1], width * 6, pal.deep, 0.85)
			end
			return pts
		end
		local main = chain(from, to, segs, jit, w * 0.35, w) -- thin at the top, thick at the ground
		local len = (from - to).Magnitude
		for b = 1, s.branches or (rng:NextNumber() < 0.5 and 1 or 2) do
			local bp = main[math.clamp(math.floor(segs * (0.45 + 0.2 * b)), 2, segs)]
			chain(bp, bp + Vector3.new(rng:NextNumber(-3.5, 3.5), rng:NextNumber(-4.5, -2.5), rng:NextNumber(-3, 3)) * math.min(1, len / 30 + 0.3), 5, jit * 0.55, w * 0.3, w * 0.08)
		end
		local a0 = t0 + k * step
		table.insert(all, list)
		table.insert(wins, { a0, a0 + ((k == 3) and step * 0.57 or step), math.max(0, (k - 1) / (shapes - 1)) ^ 1.6 * 0.5 })
	end
	self:OnUpdate(function(T)
		for i, list in all do
			local wn = wins[i]
			local on = T >= wn[1] and T < wn[2]
			for _, p in list do
				local tr = on and math.min(1, p:GetAttribute("tr") + wn[3]) or 1
				if p.Transparency ~= tr then p.Transparency = tr end
			end
		end
	end)
	return { coreParts = firstCore, shapes = all }
end
-- white-hot ball at the hit point (review fix: "a real ground burst"): Neon sphere, full white ~4 frames, then the
-- palette hue, gone by `life` (0.16 s). d = 6-8 studs. Clock-driven. NEW after the v7 review: check it on your sheet.
function FX:Burst(s)
	local pal = s.pal or self.pal
	local d, life, t0 = s.d or 7, s.life or 0.16, s.t
	local b = part(self.root, { Name = "Burst", Shape = Enum.PartType.Ball, Material = Enum.Material.Neon, Color = WH, Transparency = 1, Size = Vector3.one, CFrame = CFrame.new(self:P(s.p)) })
	self:OnUpdate(function(T)
		local x = T - t0
		if x < 0 or x >= life then if b.Transparency ~= 1 then b.Transparency = 1 end return end
		local k = x / life
		b.Size = Vector3.one * d * (0.4 + 0.6 * math.min(1, x / 0.03))
		b.Color = WH:Lerp(pal.main, math.clamp((x - 0.065) / 0.05, 0, 1))
		b.Transparency = k < 0.45 and 0.05 or lerp(0.05, 1, (k - 0.45) / 0.55)
	end)
	return b
end
-- shock ring on the ground (hue ring + 0.9x ink ring). p on the floor, diameter d0 -> d1.
function FX:ShockRing(s)
	local pal = s.pal or self.pal
	local a = s.att or self:PlaneAtt(s.p + Vector3.new(0, 0.08, 0), s.n or Vector3.yAxis, "Ground")
	local d0, d1, life = s.d0 or 2, s.d1 or 22, s.life or 0.4
	self:EmitAt(s.t, self:E(a, K.Tex.Ring, { role = "ring", Size = NS(0, d0, 1, d1), Lifetime = R(life), Rotation = R(0, 360), Color = CS(pal.main, 1, pal.deep), LightEmission = 0, Brightness = 14, Transparency = NS(0, 0.5, 1, 1), ZOffset = 0.3 }))
	self:EmitAt(s.t, self:E(a, K.Tex.Ring, { role = "ink", Size = NS(0, d0 * 0.9, 1, d1 * 0.9), Lifetime = R(life), Rotation = R(0, 360), Color = CS(INK), LightEmission = 0, Brightness = 0, Transparency = NS(0, 0.6, 1, 1), ZOffset = 0.32 }))
	return a
end
-- dust ring that reads PAST the caster's silhouette: grey ring 2 -> 14 studs in ~0.2 s + thin hue inner edge + soft
-- ground glow pool + 8 outward dust puffs.
function FX:DustRing(s)
	local pal = s.pal or self.pal
	local a = s.att or self:PlaneAtt(s.p + Vector3.new(0, 0.08, 0), Vector3.yAxis, "Ground")
	local d, t = s.d or 14, s.t
	self:EmitAt(t, self:E(a, K.Tex.Ring, { role = "dust", Size = NS(0, 2, 0.35, d, 1, d + 1), Lifetime = R(0.6), Rotation = R(0, 360), Color = CS(Color3.fromRGB(205, 208, 214)), LightEmission = 0, Brightness = 1, Transparency = NS(0, 0.35, 0.4, 0.55, 1, 1), ZOffset = 0.25 }))
	self:EmitAt(t, self:E(a, K.Tex.Ring, { role = "ring", Size = NS(0, 1.8, 1, d - 1), Lifetime = R(0.28), Rotation = R(0, 360), Color = CS(pal.main), LightEmission = 0, Brightness = 8, Transparency = NS(0, 0.45, 1, 1), ZOffset = 0.27 }))
	self:EmitAt(t, self:E(a, K.Tex.Glow, { role = "glow", Size = NS(0, d * 0.85, 1, d * 0.65), Lifetime = R(0.35), Color = CS(pal.main), LightEmission = 1, Brightness = 2, Transparency = NS(0, 0.35, 1, 1), ZOffset = 0.1 }))
	for i = 0, (s.puffs or 8) - 1 do
		local ang = i * 2 * math.pi / (s.puffs or 8)
		local da = self:AimAtt(s.p + Vector3.new(0, 0.6, 0), Vector3.new(math.sin(ang), 0.15, -math.cos(ang)), "DustOut")
		self:EmitAt(t + 0.01, self:E(da, K.Tex.Smoke, { role = "dust", n = 2, Orientation = FC, EmissionDirection = Enum.NormalId.Front, Size = NS(0, 1.5, 1, 4.5), Lifetime = R(0.45, 0.7), Speed = R(22, 32), Drag = 6, SpreadAngle = Vector2.new(12, 12),
			Rotation = R(-180, 180), RotSpeed = R(-60, 60), Color = CS(Color3.fromRGB(190, 192, 198)), LightEmission = 0, Brightness = 1, Transparency = NS(0, 0.5, 1, 1), ZOffset = -0.3 }))
	end
	return a
end
-- ONE radial crack: hot copy cooling over ~1 s + dark copy (LE 0, Transparency >= 0.5) fading over `life`. Never tile ground decals.
function FX:GroundCrack(s)
	local pal = s.pal or self.pal
	local a = s.att or self:PlaneAtt(s.p + Vector3.new(0, 0.08, 0), Vector3.yAxis, "Ground")
	local d = s.d or 10
	local rot = s.rot or 20
	self:EmitAt(s.t, self:E(a, K.Tex.Crack, { role = "hotcrack", Size = NS(0, d * 0.3, 0.05, d, 1, d * 1.05), Lifetime = R(s.hot or 1.0), Rotation = R(rot), Color = CS(pal.main:Lerp(WH, 0.25), 1, pal.deep), LightEmission = 0, Brightness = 10, Transparency = NS(0, 0.3, 0.3, 0.45, 1, 1), ZOffset = 0.22 }))
	self:EmitAt(s.t, self:E(a, K.Tex.Crack, { role = "scorch", Size = NS(0, d * 0.3, 0.05, d, 1, d * 1.05), Lifetime = R(s.life or 1.8), Rotation = R(rot), Color = CS(Color3.fromRGB(14, 14, 20)), LightEmission = 0, Brightness = 0, Transparency = NS(0, 0.5, 0.6, 0.55, 1, 1), ZOffset = 0.2 }))
	return a
end
-- straight ground scar from `from` to `to` (caster space, on the floor): tapered dark parts + a Neon hot core that
-- cools in 0.35 s; opens from -> to in `open` s, fades by `life`. Clock-driven parts: frozen and live frames match.
function FX:GroundScar(s)
	local pal = s.pal or self.pal
	local f = Instance.new("Folder"); f.Name = "GroundScar"; f.Parent = self.root
	local N, w0, w1 = s.segments or 10, s.w0 or 0.12, s.w1 or 0.87
	local A, B = self:P(s.from), self:P(s.to)
	local segLen = (B - A).Magnitude / N
	local list = {}
	for i = 0, N - 1 do
		local k = (i + 0.5) / N
		local w = lerp(w0, w1, k)
		local cf = CFrame.lookAt(A:Lerp(B, k), B + (B - A))
		local dark = part(f, { Name = "ScarDark", Size = Vector3.new(w, 0.04, segLen + 0.02), CFrame = cf + Vector3.new(0, 0.02, 0), Color = Color3.fromRGB(16, 17, 24), Material = Enum.Material.SmoothPlastic, Transparency = 1 })
		local hot = part(f, { Name = "ScarHot", Size = Vector3.new(w * 0.3, 0.05, segLen + 0.02), CFrame = cf + Vector3.new(0, 0.03, 0), Color = pal.main:Lerp(WH, 0.25), Material = Enum.Material.Neon, Transparency = 1 })
		table.insert(list, { dark = dark, hot = hot, k = k })
	end
	local t0, open, life = s.t, s.open or 0.04, s.life or 1.8
	self:OnUpdate(function(T)
		for _, sc in list do
			local a = T - (t0 + sc.k * open)
			local trD, trH = 1, 1
			if a >= 0 then
				trD = (a < 0.6) and 0.35 or math.min(1, 0.35 + (a - 0.6) / (life - 0.6) * 0.65)
				trH = math.min(1, 0.05 + a / 0.35)
			end
			if sc.dark.Transparency ~= trD then sc.dark.Transparency = trD end
			if sc.hot.Transparency ~= trH then sc.hot.Transparency = trH end
		end
	end)
	return f
end
-- rocks: unlit light grey (the texture is dark), hot for the first 15 %, spin, gravity -90, THREE sizes
-- (5 x 0.3, 3 x 0.7, 1 x 1.2 studs by default: equal round blobs read as dots). n scales the counts.
function FX:Debris(s)
	local pal = s.pal or self.pal
	local a = s.att or self:AimAtt(s.p + Vector3.new(0, 0.1, 0), s.dir or Vector3.yAxis, "Debris")
	local sp = s.speed or { 25, 50 }
	local stone = Color3.fromRGB(160, 160, 168)
	local k = (s.n or 9) / 9
	for _, g in { { 0.3, 5 }, { 0.7, 3 }, { 1.2, 1 } } do
		local n = math.floor(g[2] * k + 0.5)
		if n > 0 then
			self:EmitAt(s.t, self:E(a, K.Tex.Rock, { role = "rock", n = n, Orientation = FC, EmissionDirection = Enum.NormalId.Front, Size = NS(g[1] * (s.scale or 1), g[1] * 0.45 * (s.scale or 1)), Lifetime = R(0.8, 1.1), Speed = R(sp[1] * (1.15 - g[1] * 0.3), sp[2] * (1.15 - g[1] * 0.3)),
				SpreadAngle = Vector2.new(s.spread or 45, s.spread or 45), Acceleration = Vector3.new(0, -90, 0), Drag = 1.2, Rotation = R(-180, 180), RotSpeed = R(-500, 500),
				Color = CS(0, pal.main:Lerp(WH, 0.35), 0.15, stone, 1, stone), LightEmission = 0, Brightness = 1.1, ZOffset = 0.5 }))
		end
	end
end
-- lingering smoke (dark, rises slowly, ~2 s) + pale steam + ~27 embers over 0.7 s. The aftermath must keep some heat.
function FX:Smoke(s)
	local pal = s.pal or self.pal
	local a = s.att or self:AimAtt(s.p + Vector3.new(0, 0.1, 0), Vector3.yAxis, "Smoke")
	local F = Enum.NormalId.Front
	self:EmitAt(s.t, self:E(a, K.Tex.Smoke, { role = "smoke", n = s.n or 10, Orientation = FC, EmissionDirection = F, Size = NS(0, 3, 1, s.size or 16), Lifetime = R(1.5, 2.1), Speed = R(6, 14), SpreadAngle = Vector2.new(80, 80), Drag = 3, Acceleration = Vector3.new(0, 3, 0),
		Rotation = R(-180, 180), RotSpeed = R(-40, 40), Color = CS(s.color or Color3.fromRGB(48, 50, 62)), LightEmission = 0, Brightness = 0.8, Transparency = NS(0, 0.35, 1, 1), ZOffset = -0.5 }))
	self:EmitAt(s.t + 0.02, self:E(a, K.Tex.Steam, { role = "smoke", n = 5, Orientation = FC, EmissionDirection = F, Size = NS(0, 2, 1, (s.size or 16) * 0.6), Lifetime = R(1.0, 1.5), Speed = R(3, 8), SpreadAngle = Vector2.new(60, 60), Drag = 2, Acceleration = Vector3.new(0, 4, 0),
		Rotation = R(-180, 180), Color = CS(pal.hot:Lerp(WH, 0.3)), LightEmission = 1, Brightness = 0.6, Transparency = NS(0, 0.6, 1, 1), ZOffset = -0.4 }))
	if s.embers ~= false then
		local em = self:E(a, K.Tex.Dot, { role = "dot", Orientation = FC, EmissionDirection = F, Size = NS(0, 0.5, 1, 0.1), Lifetime = R(1.0, 1.8), Speed = R(3, 12), SpreadAngle = Vector2.new(70, 70), Drag = 3, Acceleration = Vector3.new(0, 4, 0),
			Rotation = R(-180, 180), RotSpeed = R(-250, 250), Color = CS(pal.main), LightEmission = -3, Brightness = 20, ZOffset = 1 })
		self:EmitAt(s.t + 0.01, em, 14); self:EmitAt(s.t + 0.3, em, 8); self:EmitAt(s.t + 0.7, em, 5)
	end
	return a
end
-- the whole ground strike at p (caster space, on the floor; 10-12 studs ahead keeps it clear of the caster seen from
-- behind): flash, white-hot burst, radial streaks, shock ring, dust ring, crack, needles + dots
-- up and out to both sides, rocks, smoke, lingering crackle. Use the single blocks instead when you need to vary it.
function FX:Strike(s)
	local t, p = s.t, s.p
	self:Flash({ t = t, p = p + Vector3.new(0, 2.5, 0), size = s.flash or 18, lightDelay = s.lightDelay })
	if s.burst ~= false then self:Burst({ t = t + 0.01, p = p + Vector3.new(0, 1.2, 0), d = s.burst or 7 }) end
	for i = 0, (s.streaks or 14) - 1 do -- radial ground streaks
		local ang = (i + 0.5) * 2 * math.pi / (s.streaks or 14)
		self:Needles({ t = t + 0.015, att = self:AimAtt(p + Vector3.new(0, 0.25, 0), Vector3.new(math.sin(ang), 0.04, -math.cos(ang)), "Streak"), n = 1, speed = { 70, 120 }, spread = 4, drag = 14, size = 0.6, life = 0.09, br = 40 })
	end
	local ga = self:ShockRing({ t = t + 0.01, p = p })
	self:DustRing({ t = t + 0.02, p = p, att = ga })
	self:GroundCrack({ t = t + 0.02, p = p, att = ga })
	local up = self:AimAtt(p + Vector3.new(0, 0.1, 0), Vector3.yAxis, "StrikeUp")
	self:Needles({ t = t + 0.01, att = up, n = 12, speed = { 60, 140 }, spread = 75, drag = 18, size = 0.8, life = 0.1, br = 45 })
	self:Dots({ t = t + 0.01, att = up, n = 10, speed = { 40, 110 }, spread = 70, drag = 20, gravity = -40, size = 0.45, life = 0.4, br = 30 })
	self:Debris({ t = t + 0.01, att = up })
	for _, sx in { 1, -1 } do -- thrown OUT past the caster's silhouette
		local sa = self:AimAtt(p + Vector3.new(0, 0.5, 0), Vector3.new(sx, 0.9, 0), "StrikeSide")
		self:Needles({ t = t + 0.02, att = sa, n = 8, speed = { 55, 110 }, spread = 30, drag = 16, size = 0.8, life = 0.1, br = 45 })
		self:Dots({ t = t + 0.02, att = sa, n = 6, speed = { 35, 80 }, spread = 35, drag = 18, gravity = -35, size = 0.45, life = 0.4, br = 28 })
		self:Debris({ t = t + 0.02, att = sa, n = 3, speed = { 20, 40 }, spread = 30, size = 0.6 })
	end
	self:Smoke({ t = t + 0.04, p = p })
	if s.aftermath ~= false then self:Aftermath({ t = t + 0.15, p = p, d = 12 }) end
	if s.crackle ~= false then
		local lc = self:E(ga, K.Tex.BoltSmall, { role = "linger", why = "residual crackle on the hit spot for 1.5 s: the energy stays; keep: 0.06 s flickers, spacing grows; free: size", Size = NS(2.5, 4), Lifetime = R(0.06), Rotation = R(-180, 180), Speed = R(0.01), SpreadAngle = Vector2.new(40, 40), Color = CS(self.pal.main), LightEmission = -5, Brightness = 40, ZOffset = 0.6 })
		for _, tt in { 0.05, 0.11, 0.17, 0.23, 0.3, 0.42, 0.6, 0.75, 0.95, 1.2, 1.5 } do self:EmitAt(t + tt, lc, 1) end
	end
	return ga
end

---------------------------------------------------------------- aftermath (every impact gets one)
-- What stays after a hit, for 1-2 s: FAINT, LOW and RADIAL. Dust haze rolling outward along the ground
-- (Transparency >= 0.78, no upward acceleration, so it never forms a dome), tiny glints skidding outward with a double
-- twinkle, and optional residual arcs flickering on the ground. Emitted over ~0.4 s starting at t (use hit + 0.1..0.2).
--   t, p (caster space, on the floor), d = reach in studs (10), life = longest piece (1.4 s), dust = directions (8),
--   sparks = glints in total (14), arcs = number of residual arc flickers (0; 5-7 for electric / magic hits),
--   color = glint colour (palette hot), dustColor
-- Every layer has role "linger"; Lint warns when an effect has an impact and no linger layer.
function FX:Aftermath(s)
	local pal = s.pal or self.pal
	local t, p, d, life = s.t, s.p, s.d or 10, s.life or 1.4
	local nd, ng = s.dust or 8, s.sparks or 14
	local dustCol = s.dustColor or Color3.fromRGB(150, 151, 158):Lerp(pal.deep, 0.12)
	local F = Enum.NormalId.Front
	local per = nd > 0 and math.max(1, math.ceil(ng / nd)) or 0
	for i = 0, nd - 1 do
		local ang = (i + 0.5) * 2 * math.pi / nd
		local a = self:AimAtt(p + Vector3.new(0, 0.3, 0), Vector3.new(math.sin(ang), 0.06, -math.cos(ang)), "Aftermath")
		local dust = self:E(a, K.Tex.Smoke, { role = "linger", Orientation = FC, EmissionDirection = F, Size = NS(0, d * 0.09, 1, d * 0.26),
			Lifetime = R(life * 0.7, life), Speed = R(d * 0.3, d * 0.55), Drag = 2.5, SpreadAngle = Vector2.new(12, 4), Rotation = R(-180, 180), RotSpeed = R(-30, 30),
			Color = CS(dustCol), LightEmission = 0, Brightness = 1, Transparency = NS(0, 1, 0.15, 0.8, 0.6, 0.87, 1, 1), ZOffset = -0.4,
			why = "aftermath dust: a faint low haze rolling outward says the hit had weight; keep: sideways, Transparency >= 0.78, no upward acceleration; free: count, colour, reach" })
		self:EmitAt(t, dust, 1); self:EmitAt(t + 0.3, dust, 1)
		if per > 0 then
			local sz = s.size or 0.2
			local gl = self:E(a, K.Tex.Dot, { role = "linger", Orientation = FC, EmissionDirection = F, Size = NS(0, 0, 0.08, sz, 0.3, sz * 0.35, 0.5, sz, 1, 0),
				Lifetime = R(life * 0.4, life * 0.85), Speed = R(d * 0.25, d * 0.8), Drag = 3, SpreadAngle = Vector2.new(25, 10), Acceleration = Vector3.new(0, -5, 0),
				Rotation = R(-180, 180), Color = CS(s.color or pal.hot), LightEmission = -3, Brightness = s.br or 22, Transparency = NS(0, 0.15, 0.7, 0.45, 1, 1), ZOffset = 1,
				why = "aftermath glints: a few tiny sparks skidding low and outward with a double twinkle keep the hit alive; keep: tiny (<= 0.25), low, few; free: colour, count" })
			self:EmitAt(t + 0.02, gl, math.ceil(per * 0.6)); self:EmitAt(t + 0.25, gl, math.max(1, math.floor(per * 0.4)))
		end
	end
	if (s.arcs or 0) > 0 then
		local rng = Random.new(s.seed or 3)
		local arc = {}
		for k = 1, 3 do
			local ang, rr = rng:NextNumber(0, 2 * math.pi), d * rng:NextNumber(0.15, 0.4)
			local a = self:PlaneAtt(p + Vector3.new(math.sin(ang) * rr, 0.1, -math.cos(ang) * rr), Vector3.yAxis, "AftermathArc")
			arc[k] = self:E(a, K.Tex.BoltSmall, { role = "linger", Size = NS(d * 0.13), Lifetime = R(0.06), Rotation = R(-180, 180), Speed = R(0.01),
				Color = CS(pal.main), LightEmission = -3, Brightness = 30, Transparency = NS(0.3), ZOffset = 0.5,
				why = "aftermath arcs: residual flickers on the ground after an energy hit; keep: flat, 0.06 s each, spaced 0.08-0.15 s; free: count, size" })
		end
		for j = 0, s.arcs - 1 do self:EmitAt(t + 0.05 + j * (0.6 / s.arcs) + rng:NextNumber(0, 0.03), arc[j % 3 + 1], 1) end
	end
end

---------------------------------------------------------------- curtains: scrolling-beam sheets
-- A flowing surface (fire wall, waterfall, lava fall, energy or wind wall, aura sheet, portal rim) made of Beams
-- between attachment pairs, each layer scrolling at its own TextureSpeed and TextureLength so the pattern never
-- visibly repeats. Wrapped for 3D: a LINE becomes 2+ staggered rows of overlapping panels with alternating yaw (reads
-- from the front, the side and the ends); a RING becomes 6-8 panels round a vertical axis (a pillar that reads from
-- every side; 5 or fewer show a polygon with bright corners from above, where neighbours overlap). One flat sheet is a slab from above and a stick from the side: never use one.
-- Axes (measured): with FaceCamera off the ribbon's WIDTH follows the attachments' Y axis and CurveSize bends along
-- their X axis. The kit sets X = the panel's front (normal), Y = across; upright attachments collapse it to a line.
-- Soft edges: neighbouring panels overlap (`overlap` 0.35), each layer has its own width (narrow dense layers inside
-- wide faint ones = a gradient across the width) and a faint wide halo layer blends the seams; Transparency fades at
-- the foot and to 1 at the top along the length. No hard prism corners.
--   t (start), rise (0.35 s, eased out), hold (2 s), fall (0.6 s: sinks to `sink` x height and fades)
--   line = { from = Vector3, to = Vector3 } on the floor (caster space)   or   ring = { c = Vector3, r = 3 }
--   h height (6), n panels (line: one per `panel` studs (3); ring: 8, overlap 0.2), rows (2), depth between rows (0.9),
--   yaw alternating panel turn in degrees (8), lean = CurveSize bulge toward the front / outward (0.6, sways with the
--   clock), flicker = height variation (0.1), sweep = seconds the rise travels along the line (0.25; `from` =
--   "start" | "centre" | "end"), base = ground strip glow (true), scorch = dark ground line after the fall (true),
--   layers = your own stack (default K.CurtainLayers(palette)); each layer:
--     { name, tex, w = width x panel width, w1 = width at the top (x panel width), spd = TextureSpeed, len =
--       TextureLength (repeats), col, le, br, tr = Transparency, foot = extra Transparency at the foot, curve, z, why }
-- Clock-driven (frozen frame = live frame); beams are tracked, so freezes stop their scroll. Returns { panels, folder }.
function K.CurtainLayers(pal)
	return {
		{ name = "deep", tex = K.Tex.Flow, w = 1.15, w1 = 0.8, spd = 0.45, len = 2.6, col = pal.dark, le = 0, br = 2, tr = 0.45, foot = 0.2,
			why = "dark body: a darker value under the bright layers gives the sheet depth on a light floor; keep: LE 0, dark colour, Transparency 0.4-0.5; free: width, speed" },
		{ name = "body", tex = K.Tex.Flow, w = 1.0, w1 = 0.65, spd = 0.7, len = 1.9, col = pal.main, le = 0, br = 12, tr = 0.3, foot = 0.1,
			why = "body: mid-tone x Brightness 10-15 clips to a hot centre with a hue rim (pro rule 2); keep: LE 0, mid-tone colour; free: Br 8-18, length" },
		{ name = "streaks", tex = K.Tex.FlowStreaks, w = 0.75, w1 = 0.45, spd = 1.35, len = 1.2, col = pal.main, le = 0, br = 22, tr = 0.45, foot = 0.1,
			why = "streaks: thin fast detail sells the flow direction; keep: speed not a multiple of the body's, narrower than the body; free: Br 15-30" },
		{ name = "wisps", tex = K.Tex.FlowWisps, w = 0.85, w1 = 0.5, spd = 2.2, len = 0.8, col = pal.hot, le = 1, br = 1.6, tr = 0.5, foot = 0,
			why = "hot wisps: the fastest additive layer, the lit inside of the sheet; keep: LE 1, Br <= 3 (counts toward the stack gain); free: colour within the palette" },
		{ name = "halo", tex = K.Tex.FlowWisps, w = 1.6, w1 = 1.25, spd = 0.3, len = 3.5, col = pal.main, le = 1, br = 0.7, tr = 0.78, foot = 0, curve = 1.3,
			why = "halo: a faint wide veil that softens panel edges and blends the seams (no hard prism corners); keep: wider than the body, Transparency >= 0.75; free: width" },
	}
end
function FX:Curtain(s)
	local pal = s.pal or self.pal
	local rng = Random.new(s.seed or 7)
	local up = self:V(Vector3.yAxis)
	local h, t0 = s.h or 6, s.t or 0
	local rise, hold, fall = s.rise or 0.35, s.hold or 2, s.fall or 0.6
	local overlap, lean, flick, sink = s.overlap or 0.35, s.lean or 0.6, s.flicker or 0.1, s.sink or 0.7
	local layers = s.layers or K.CurtainLayers(pal)
	local panels = {}
	local footA, footB, footW
	if s.ring then
		local c, r, n = s.ring.c or Vector3.zero, s.ring.r or 3, s.n or 8
		local w = 2 * r * math.sin(math.pi / n) * (1 + (s.overlap or 0.2))
		for i = 0, n - 1 do
			local a = i / n * 2 * math.pi + math.rad(s.ring.a0 or 0)
			local out = Vector3.new(math.sin(a), 0, -math.cos(a))
			table.insert(panels, { pos = c + out * r * math.cos(math.pi / n), across = Vector3.new(math.cos(a), 0, math.sin(a)), normal = out, w = w, k = i / n, row = 0 })
		end
	else
		local A, B = s.line.from, s.line.to
		local dir = Vector3.new(B.X - A.X, 0, B.Z - A.Z)
		local L = dir.Magnitude; dir = dir.Unit
		local nrm = Vector3.yAxis:Cross(dir).Unit
		local rows, depth = s.rows or 2, s.depth or 0.9
		local n = s.n or math.max(2, math.ceil(L / (s.panel or 3)))
		local seg = L / n
		for row = 0, rows - 1 do
			local off = (row - (rows - 1) / 2) * depth
			local odd = row % 2 == 1
			for i = 0, n - (odd and 2 or 1) do
				local along = odd and seg * (i + 1) or seg * (i + 0.5)
				local yaw = math.rad(((i + row) % 2 == 0 and 1 or -1) * (s.yaw or 8) + rng:NextNumber(-3, 3))
				local across = CFrame.fromAxisAngle(Vector3.yAxis, yaw):VectorToWorldSpace(dir)
				table.insert(panels, { pos = A + dir * along + nrm * off, across = across, normal = Vector3.yAxis:Cross(across).Unit, w = seg * (1 + overlap), k = along / L, row = row })
			end
		end
		footA, footB, footW = A, B, (rows - 1) * depth + 1.6
	end
	local sweep, from = s.sweep or (s.ring and 0 or 0.25), s.from or "start"
	local folder = Instance.new("Folder"); folder.Name = s.name or "Curtain"; folder.Parent = self.root
	local tEnd = t0
	for pi, P in panels do
		local k = from == "centre" and math.abs(P.k - 0.5) * 2 or (from == "end" and 1 - P.k or P.k)
		P.delay = k * sweep + rng:NextNumber(0, 0.04)
		P.hk = (1 + rng:NextNumber(-0.12, 0.12)) * (P.row > 0 and 0.88 or 1)
		P.seed = pi * 1.37
		tEnd = math.max(tEnd, t0 + P.delay + rise + hold + fall)
		local holder = part(folder, { Size = Vector3.one * 0.2, Transparency = 1, CFrame = CFrame.new(self:P(P.pos)), Name = "Panel" .. pi })
		local X, Y = self:V(P.normal), self:V(P.across)
		local base = CFrame.fromMatrix(self:P(P.pos), X, Y, X:Cross(Y))
		local a0 = Instance.new("Attachment"); a0.Name = "Foot"; a0.Parent = holder; a0.WorldCFrame = base
		local a1 = Instance.new("Attachment"); a1.Name = "Top"; a1.Parent = holder; a1.WorldCFrame = base + up * 0.05
		P.a0, P.a1, P.base, P.beams = a0, a1, base, {}
		for li, L in layers do
			local tex = type(L.tex) == "table" and L.tex[1] or L.tex
			local b = Instance.new("Beam"); b.Name = ("L%d_%s"):format(li, L.name or "layer")
			b.Attachment0, b.Attachment1 = a0, a1
			b.Texture = "rbxassetid://" .. tex; b.TextureMode = Enum.TextureMode.Stretch
			b.TextureLength = L.len * rng:NextNumber(0.85, 1.15); b.TextureSpeed = L.spd * rng:NextNumber(0.85, 1.15)
			b.FaceCamera = false; b.LightInfluence = 0; b.LightEmission = L.le or 0; b.Brightness = L.br or 1
			b.Color = CS(K.Tint(tex, L.col or pal.main)); b.Width0 = P.w * L.w; b.Width1 = P.w * (L.w1 or L.w)
			b.Segments = 16; b.ZOffset = L.z or (li * 0.02); b.Transparency = NS(1)
			b:SetAttribute("role", "curtain"); b:SetAttribute("why", L.why or K.Why.curtain); b:SetAttribute("tag", K.TagOf(tex))
			b:SetAttribute("w0", t0 + P.delay); b:SetAttribute("w1", t0 + P.delay + rise + hold + fall); b:SetAttribute("h", h * P.hk); b:SetAttribute("trMin", L.tr or 0.3)
			b.Parent = holder
			self:TrackBeam(b)
			table.insert(P.beams, { b = b, tr = L.tr or 0.3, foot = L.foot or 0.1, curve = L.curve or 1 })
		end
	end
	local strips = {}
	if footA and s.base ~= false then
		local function strip(name, tex, col, le, br, tr, w, spd, why)
			local A, B = self:P(footA + Vector3.new(0, 0.06, 0)), self:P(footB + Vector3.new(0, 0.06, 0))
			local along = (B - A).Unit
			local Y = up:Cross(along).Unit -- width across the wall, flat on the ground
			local X = Y:Cross(along).Unit
			local holder = part(folder, { Size = Vector3.one * 0.2, Transparency = 1, CFrame = CFrame.new(A), Name = name })
			local a0 = Instance.new("Attachment"); a0.Parent = holder; a0.WorldCFrame = CFrame.fromMatrix(A, X, Y, X:Cross(Y))
			local a1 = Instance.new("Attachment"); a1.Parent = holder; a1.WorldCFrame = CFrame.fromMatrix(B, X, Y, X:Cross(Y))
			local b = Instance.new("Beam"); b.Name = name; b.Attachment0, b.Attachment1 = a0, a1
			b.Texture = "rbxassetid://" .. tex; b.TextureMode = Enum.TextureMode.Stretch; b.TextureLength = 2; b.TextureSpeed = spd
			b.FaceCamera = false; b.LightInfluence = 0; b.LightEmission = le; b.Brightness = br; b.Color = CS(col)
			b.Width0, b.Width1 = w, w; b.Segments = 1; b.ZOffset = -0.1; b.Transparency = NS(1)
			b:SetAttribute("role", name == "Scorch" and "scorch" or "glow"); b:SetAttribute("why", why); b:SetAttribute("tag", K.TagOf(tex))
			b:SetAttribute("trMin", tr); b.Parent = holder; self:TrackBeam(b)
			table.insert(strips, { b = b, tr = tr, kind = name })
		end
		strip("FootGlow", K.Tex.FlowWisps[1], pal.main, 1, 2, 0.35, footW + 1.2, 0.25,
			"foot glow: a flat additive strip along the base reads from above, where vertical sheets are thin; keep: flat, LE 1; free: width, Br 1-3")
		if s.scorch ~= false then
			strip("Scorch", K.Tex.Flow[1], Color3.new(0, 0, 0), 0, 0, 0.55, footW + 0.4, 0,
				"scorch line: the ground keeps a dark mark for ~1 s after the collapse; keep: black, Transparency >= 0.5; free: width, life")
		end
	elseif s.ring and s.base ~= false then
		local a = self:PlaneAtt(s.ring.c or Vector3.zero, Vector3.yAxis, "CurtainBase")
		local e = self:E(a, K.Tex.Glow, { role = "glow", Size = NS((s.ring.r or 3) * 1.4), Lifetime = R(rise + hold + fall), Color = CS(pal.main), LightEmission = 1, Brightness = 2,
			Transparency = NS(0, 1, 0.12, 0.5, 0.85, 0.55, 1, 1), ZOffset = 0.1,
			why = "base pool: a flat additive glow under the pillar reads from above; keep: flat, LE 1; free: size" })
		self:EmitAt(t0, e, 1)
	end
	local function env(x, hk)
		if x < 0 then return 0.05, 1 end
		if x < rise then local k = x / rise; return h * hk * math.max(0.02, 1 - (1 - k) ^ 3), math.max(0, 1 - k / 0.4) end
		if x < rise + hold then return h * hk, 0 end
		if x < rise + hold + fall then local k = (x - rise - hold) / fall; return h * hk * (1 - sink * k ^ 1.5), k ^ 1.2 end
		return 0.05, 1
	end
	self:OnUpdate(function(T)
		for _, P in panels do
			local ht, fade = env(T - t0 - P.delay, P.hk)
			if fade < 1 then ht = ht * (1 + flick * math.noise(T * 2.3, P.seed, 0.5)) end
			P.a1.WorldCFrame = P.base + up * math.max(ht, 0.05)
			local sway = 1 + 0.3 * math.sin(T * 1.6 + P.seed)
			for _, B in P.beams do
				B.b.CurveSize0 = lean * B.curve * sway; B.b.CurveSize1 = -lean * B.curve * sway * 0.5
				if fade ~= P.lastFade then
					local tr = B.tr + (1 - B.tr) * fade
					B.b.Transparency = fade >= 1 and NS(1) or NS(0, math.min(1, tr + B.foot), 0.15, tr, 0.62, tr, 1, 1)
				end
			end
			P.lastFade = fade
		end
		for _, S in strips do
			local x = T - t0
			local fade
			if S.kind == "Scorch" then -- appears with the wall, stays ~1.2 s after it
				fade = x < 0 and 1 or math.clamp(1 - x / 0.3, 0, 1)
				if T > tEnd then fade = math.clamp((T - tEnd) / 1.2, 0, 1) end
			else
				local _, f = env(x, 1); fade = f
			end
			if fade ~= S.last then S.b.Transparency = fade >= 1 and NS(1) or NS(0, 1, 0.08, S.tr + (1 - S.tr) * fade, 0.92, S.tr + (1 - S.tr) * fade, 1, 1); S.last = fade end
		end
	end)
	self.duration = math.max(self.duration, tEnd + 1.6)
	table.insert(self.curtains, { name = folder.Name, t0 = t0, t1 = tEnd, n = #panels, rows = s.rows or (s.ring and 0 or 2), ring = s.ring ~= nil })
	return { panels = panels, folder = folder }
end

---------------------------------------------------------------- recolour (masks only)
-- fx:Recolor(newPalette): re-tints a built effect. Layers whose texture is a MASK (K.TagOf) get their Color ramp
-- remapped: exact palette colours go to the new palette's same role, other colours turn by the hue difference keeping
-- saturation and value; near-white, grey and near-black keypoints stay. Baked and unknown textures are left alone and
-- listed (tag unknown ones with K.Tag(id, "mask") after texture_traits.py says white / grey). Neon parts are recoloured
-- too. Closures that read the palette while playing (Burst) keep the old one: for a new palette, rebuild instead.
local function hdrSplit(c) local m = math.max(c.R, c.G, c.B, 1); return Color3.new(c.R / m, c.G / m, c.B / m), m end
function FX:Recolor(newPal)
	local old = self.pal
	local dh = (newPal.main:ToHSV()) - (old.main:ToHSV())
	local function map(c)
		local base, m = hdrSplit(c)
		for _, k in { "main", "deep", "hot", "dark" } do
			local o = old[k]
			if o and math.abs(o.R - base.R) + math.abs(o.G - base.G) + math.abs(o.B - base.B) < 0.02 then local n = newPal[k]; return Color3.new(n.R * m, n.G * m, n.B * m) end
		end
		local h, sat, v = base:ToHSV()
		if sat < 0.12 or v < 0.08 then return c end
		local n = Color3.fromHSV((h + dh) % 1, sat, v)
		return Color3.new(n.R * m, n.G * m, n.B * m)
	end
	local function seq(cs) local kp = {}; for _, k in cs.Keypoints do table.insert(kp, ColorSequenceKeypoint.new(k.Time, map(k.Value))) end; return ColorSequence.new(kp) end
	local done, skipped = 0, {}
	local function one(inst, tex)
		if K.IsMask(tex) then inst.Color = seq(inst.Color); done += 1 else skipped[tostring(tex):match("%d+") or "?"] = K.TagOf(tex) end
	end
	for _, e in self.emitters do one(e, e.Texture) end
	for _, b in self.beams do if b:IsA("Beam") then one(b, b.Texture) end end
	for _, L in self.meshes do
		if K.IsMask(L.M.tex[1]) then L.col = map(L.col); if L.col1 then L.col1 = map(L.col1) end; done += 1 else skipped[tostring(L.M.tex[1])] = K.TagOf(L.M.tex[1]) end
	end
	local parts = 0
	for _, p in self.root:GetDescendants() do
		if p:IsA("BasePart") and p.Material == Enum.Material.Neon then p.Color = map(p.Color); parts += 1 end
	end
	self.pal = newPal
	local out = { ("recoloured %d layers and %d Neon parts"):format(done, parts) }
	for id, tag in skipped do table.insert(out, ("left alone: %s (%s)"):format(id, tag)) end
	return table.concat(out, "\n")
end

---------------------------------------------------------------- stack gain (additive layers)
-- Additive layers (LightEmission > 0) add up: stacked at one spot they clip to a white blob that hides the hero
-- shape. At Build the kit finds, for every additive layer, which additive layers cover its centre while it is alive
-- (emitters: attachment and Size; beams: their mid point and width) and sums their light, Brightness x (1 - the
-- lowest Transparency). At the busiest spot that sum S is the stack's light and N the number of layers. One
-- per-effect gain then scales the Brightness of every additive layer that sits in a stack (2+):
--   fx.gain = "auto" (default): the lower of  fx.budget / S  (budget 2) and the count rule 1 - 0.04 x (N - 6)
--             (12 layers -> 0.76), never below 0.1. Flashes and pops (life <= 0.12 s) are left out: they are meant
--             to clip for a few frames.
--   fx.gain = <number>: that gain (1 = off). Set Brightness BEFORE Build; the original is kept as attribute br0.
-- Measured (Studio, daylight, against the sky): additive light ADDS TO THE BACKGROUND, so on a light backdrop a stack
-- clips long before its own sum reaches 1. 12 soft glows over a stroke: one white disc at gain 1, 0.76 and 0.28
-- (summed Br 36 / 27 / 10); at summed Br ~2 still white; at ~0.9 the stroke shows at the rim only. The gain keeps
-- big stacks from burning whiter than lean ones; it cannot rescue a heavy stack. The real fix is fewer additive
-- layers: give the body to LE 0 layers with a dark partner (pro guide rules 1-4). fx.gainInfo = { g, N, S, at } after
-- Build; Lint prints it. Opaque (LE <= 0) layers are never touched: they carry the shape.
function FX:_applyGain()
	local items = {}
	local function maxKP(ns) local m = 0; for _, k in ns.Keypoints do m = math.max(m, k.Value) end; return m end
	for _, e in self.emitters do
		local br0 = e:GetAttribute("br0"); if br0 then e.Brightness = br0 end
		if e.LightEmission > 0 and e.Brightness > 0 and e.Lifetime.Max > 0.12 then -- flashes / pops may clip for 3 frames
			local par = e.Parent
			local pos = par:IsA("Attachment") and par.WorldPosition or (par:IsA("BasePart") and par.Position)
			if pos then
				local ws, ts = {}, self._emitT[e]
				if e.Rate > 0 or not ts then ws = { { 0, self.duration } } else for _, t in ts do table.insert(ws, { t, t + e.Lifetime.Max }) end end
				local trMin = 1; for _, k in e.Transparency.Keypoints do trMin = math.min(trMin, k.Value) end
				table.insert(items, { i = e, p = pos, r = maxKP(e.Size), w = ws, l = e.Brightness * (1 - trMin) })
			end
		end
	end
	for _, b in self.beams do
		if b:IsA("Beam") then
			local br0 = b:GetAttribute("br0"); if br0 then b.Brightness = br0 end
			if b.LightEmission > 0 and b.Brightness > 0 and b.Attachment0 and b.Attachment1 then
				local p0, p1 = b.Attachment0.WorldPosition, b.Attachment1.WorldPosition
				local hh = b:GetAttribute("h")
				local mid = hh and (p0 + self:V(Vector3.yAxis) * hh / 2) or (p0 + p1) / 2
				local w0, w1 = b:GetAttribute("w0"), b:GetAttribute("w1")
				local trMin = b:GetAttribute("trMin") -- animated beams (curtains) store their hold Transparency
				if not trMin then trMin = 1; for _, k in b.Transparency.Keypoints do trMin = math.min(trMin, k.Value) end end
				table.insert(items, { i = b, p = mid, r = math.max(b.Width0, b.Width1) / 2, w = { { w0 or 0, w1 or self.duration } }, l = b.Brightness * (1 - trMin) })
			end
		end
	end
	local function overlapT(a, b) for _, x in a do for _, y in b do if x[1] < y[2] and y[1] < x[2] then return true end end end return false end
	local N, S, at = 1, 0, nil
	for _, A in items do
		local c, l = 0, 0
		for _, B in items do if (A.p - B.p).Magnitude <= math.max(B.r * 0.8, 0.3) and overlapT(A.w, B.w) then c += 1; l += B.l end end
		A.c = c
		if c > N then N = c end
		if l > S then S, at = l, A.i end
	end
	local auto = math.min(math.clamp((self.budget or 2) / math.max(S, 1e-3), 0, 1), 1 - 0.04 * math.max(0, N - 6))
	local g = type(self.gain) == "number" and self.gain or math.clamp(auto, 0.1, 1)
	for _, A in items do
		if A.c >= 2 and g ~= 1 then A.i:SetAttribute("br0", A.i.Brightness); A.i.Brightness = A.i.Brightness * g end
	end
	self.gainInfo = { g = g, N = N, S = S, at = at and (at.Parent and at.Parent.Parent and at.Parent.Parent.Name .. "/" or "") .. at.Name or "-", auto = type(self.gain) ~= "number" }
	return self.gainInfo
end

---------------------------------------------------------------- layer table with reasons
-- fx:Layers() -> a markdown table of every layer: name, role, texture (mask / baked), LE, Brightness (x gain),
-- size, life, min Transparency, ZOffset and WHY it reads. Curtain beams are grouped per layer. Paste it into LOG.md
-- with every version: the builder writes the reasons, the director sees what is safe to change ("free") and what
-- carries the read ("keep").
function FX:Layers()
	local rows = { "| layer | role | texture (tag) | LE | Br | size | life s | min Tr | Z | why |", "|---|---|---|---|---|---|---|---|---|---|" }
	local function mm(ns) local a, b = math.huge, -math.huge; for _, k in ns.Keypoints do a = math.min(a, k.Value); b = math.max(b, k.Value) end; return a, b end
	local function br(x) local b0 = x:GetAttribute("br0"); return b0 and ("%.3g x%.2f"):format(b0, x.Brightness / b0) or ("%.3g"):format(x.Brightness) end
	local function id(tex) return tostring(tex):match("%d+") or "?" end
	for _, e in self.emitters do
		local holder = e.Parent and e.Parent.Parent
		local _, size = mm(e.Size); local trMin = mm(e.Transparency)
		table.insert(rows, ("| %s | %s | %s (%s) | %g | %s | %.2f | %.2f-%.2f | %.2f | %.2f | %s |"):format(holder and holder.Name or "?", e:GetAttribute("role") or "", id(e.Texture),
			e:GetAttribute("tag") or K.TagOf(e.Texture), e.LightEmission, br(e), size, e.Lifetime.Min, e.Lifetime.Max, trMin, e.ZOffset, e:GetAttribute("why") or ""))
	end
	local groups, order = {}, {}
	for _, b in self.beams do
		if b:IsA("Beam") then
			local f = b:FindFirstAncestorOfClass("Folder")
			local key = (f and f.Name or "?") .. "/" .. b.Name
			if not groups[key] then groups[key] = { b = b, n = 0 }; table.insert(order, key) end
			groups[key].n += 1
		end
	end
	for _, key in order do
		local g = groups[key]; local b = g.b
		local trMin = mm(b.Transparency)
		local w0, w1 = b:GetAttribute("w0"), b:GetAttribute("w1")
		table.insert(rows, ("| %s x%d | %s | %s (%s) | %g | %s | w %.2f>%.2f | %s | %s | %.2f | %s |"):format(key, g.n, b:GetAttribute("role") or "beam", id(b.Texture), b:GetAttribute("tag") or K.TagOf(b.Texture),
			b.LightEmission, br(b), b.Width0, b.Width1, w0 and ("%.2f-%.2f"):format(w0, w1) or "-", trMin < 1 and ("%.2f"):format(trMin) or "(animated)", b.ZOffset, b:GetAttribute("why") or ""))
	end
	for _, L in self.meshes do
		table.insert(rows, ("| %s | mesh | %s (%s) | - | decal %.1f | r %.2f | %.2f-%.2f | %.2f | - | %s |"):format(L.p.Name, tostring(L.M.tex[1]), K.TagOf(L.M.tex[1]), math.max(L.col.R, L.col.G, L.col.B), L.r, L.on, L.off, L.tr0, L.why or ""))
	end
	if self.gainInfo then table.insert(rows, ("\ngain %.2f (%s; peak %d additive layers, light %.1f at %s)"):format(self.gainInfo.g, self.gainInfo.auto and "auto" or "set", self.gainInfo.N, self.gainInfo.S, self.gainInfo.at)) end
	return table.concat(rows, "\n")
end

---------------------------------------------------------------- impact frame + dark beat
-- invisible tapering parts along an arc (for the impact-frame silhouette of a stroke). c, n, mid in caster space.
function FX:ArcSilhouette(c, n, mid, radius, a0, a1, width)
	local list = {}
	local N = 12
	local angs = {}
	for i = 0, N do table.insert(angs, lerp(a0, a1, i / N)) end
	local pts = self:ArcPoints(c, n, mid, radius, angs)
	for i = 1, N do
		local p0, p1 = self:P(pts[i]), self:P(pts[i + 1])
		local w = (width or 0.55) * (1 - (i - 1) / N * 0.75)
		table.insert(list, part(self.root, { Name = "ArcSil", Size = Vector3.new(w, w, (p1 - p0).Magnitude + 0.1), CFrame = CFrame.lookAt((p0 + p1) / 2, p1), Transparency = 1 }))
	end
	return list
end
-- Impact frame: screen-space white sheet + black silhouettes (ViewportFrame clones). Works day and night
-- (ColorCorrection alone cannot whiten a dark world). Default 5 frames: 2 white, 2 INVERTED (black world, white
-- silhouettes), 1 white (v7's 2 identical white frames were "too short to register").
--   t, phases = { { "white" | "invert", seconds }, ... }, parts = extra BaseParts (Bolt().coreParts, ArcSilhouette()),
--   focus = caster-space ground point: adds 10 radial ink streaks around it, darkBeat = false to skip the 0.12 s dim before.
-- The caster and weapon are always included. Screen-space by design: the only camera-facing thing in the kit.
function FX:ImpactFrame(s)
	local t, list = s.t, {}
	for _, p in s.phases or { { "white", 0.034 }, { "invert", 0.033 }, { "white", 0.017 } } do table.insert(list, { t, t + p[2], p[1] }); t += p[2] end
	local parts = {}
	for _, p in s.parts or {} do table.insert(parts, p) end
	if s.focus then
		local rng = Random.new(5)
		for i = 0, 9 do
			local ang = (i + rng:NextNumber(-0.3, 0.3)) * math.pi / 5
			local d = Vector3.new(math.sin(ang), 0, -math.cos(ang))
			local r0, len = rng:NextNumber(2.5, 4), rng:NextNumber(5, 10)
			local a, b = self:P(s.focus + d * r0 + Vector3.new(0, 0.1, 0)), self:P(s.focus + d * (r0 + len) + Vector3.new(0, 0.1, 0))
			table.insert(parts, part(self.root, { Name = "IFStreak", Size = Vector3.new(0.35, 0.06, len), CFrame = CFrame.lookAt((a + b) / 2, b), Transparency = 1 }))
		end
	end
	self.impact = { t0 = s.t, t1 = t, phases = list, parts = parts, caster = s.caster ~= false }
	if s.darkBeat ~= false then self.darkBeat = { s.t - (s.darkLead or 0.12), s.t } end
end
function FX:_gui()
	local name = self.name .. "_IF"
	local g = CoreGui:FindFirstChild(name)
	if g then return g end
	g = Instance.new("ScreenGui"); g.Name = name; g.IgnoreGuiInset = true; g.Enabled = false; g.DisplayOrder = 50
	local w = Instance.new("Frame"); w.Name = "White"; w.Size = UDim2.fromScale(1, 1); w.BackgroundColor3 = Color3.fromRGB(245, 250, 255); w.BorderSizePixel = 0; w.Parent = g
	local v = Instance.new("ViewportFrame"); v.Name = "Sil"; v.Size = UDim2.fromScale(1, 1); v.BackgroundTransparency = 1
	v.Ambient = WH; v.LightColor = WH; v.ImageColor3 = INK; v.Parent = g
	local c = Instance.new("Camera"); c.Parent = v; v.CurrentCamera = c
	g.Parent = CoreGui
	return g
end
function FX:_fillSil(g)
	local v = g.Sil
	for _, x in v:GetChildren() do if not x:IsA("Camera") then x:Destroy() end end
	local function add(p)
		if not p:IsA("BasePart") then return end
		local c
		if p:IsA("MeshPart") then
			c = p:Clone(); c.TextureID = ""; for _, k in c:GetChildren() do k:Destroy() end
		else
			c = Instance.new("Part"); c.Size = p.Size; c.CFrame = p.CFrame; c.Shape = p:IsA("Part") and p.Shape or Enum.PartType.Block
		end
		c.Anchored = true; c.Color = WH; c.Transparency = 0; c.Material = Enum.Material.SmoothPlastic; c.Parent = v
	end
	if self.impact.caster and self.char then
		for _, p in self.char:GetChildren() do if p.Name ~= "HumanoidRootPart" then add(p) end end
		for _, w in self.weapon do if w[1].Material ~= Enum.Material.Neon then add(w[1]) end end
	end
	for _, p in self.impact.parts do add(p) end
end
function FX:_cc()
	local cam = workspace.CurrentCamera
	local c = cam:FindFirstChild(self.name .. "_CC")
	if not c then c = Instance.new("ColorCorrectionEffect"); c.Name = self.name .. "_CC"; c.Parent = cam end
	return c
end

---------------------------------------------------------------- clock
function FX:Update(T)
	self.T = T
	self:ApplyPose(T)
	local g = self.ghosts
	if g then
		local function inWin(t) for _, w in g.windows do if t >= w[1] and t <= w[2] + 0.02 then return true end end return false end
		for k, p in g.parts do
			local tp = T - k * g.step
			if inWin(T) and inWin(tp) and tp > 0 then
				p.CFrame = self:FK(tp).Grip * g.off; p.Transparency = 0.3 + k * 0.09
			elseif p.Transparency ~= 1 then p.Transparency = 1 end
		end
	end
	for _, fn in self.updaters do fn(self.poseOnly and -1 or T) end
	if self.poseOnly then return end
	if self.darkBeat or self.impact then
		local c = self:_cc()
		local dark = self.darkBeat and T >= self.darkBeat[1] and T < self.darkBeat[2]
		c.Brightness = dark and -0.07 or 0; c.Contrast = dark and 0.1 or 0; c.Saturation = dark and -0.2 or 0
	end
	if self.impact then
		local gui = self:_gui()
		local ph
		for _, p in self.impact.phases do if T >= p[1] and T < p[2] then ph = p[3] end end
		local on = ph ~= nil
		if on and not gui.Enabled then self:_fillSil(gui) end
		if on then
			gui.White.BackgroundColor3 = ph == "invert" and Color3.fromRGB(6, 8, 14) or Color3.fromRGB(245, 250, 255)
			gui.Sil.ImageColor3 = ph == "invert" and WH or INK
		end
		if on then local cam = workspace.CurrentCamera; gui.Sil.CurrentCamera.CFrame = cam.CFrame; gui.Sil.CurrentCamera.FieldOfView = cam.FieldOfView end
		gui.Enabled = on
	end
end
function FX:_shakeAt(T)
	local a = 0
	for _, s in self.shakes do
		local x = (T - s[1]) / s[3]
		if x >= 0 and x < 1 then a += s[2] * (1 - x) ^ 2 end
	end
	if a <= 0 then return CFrame.identity end
	return CFrame.new(math.noise(T * 30, 1.3) * a * 1.6, math.noise(T * 30, 7.1) * a * 1.6, 0)
end
-- call once after all blocks are declared (sorts the timeline, shows pose 0)
function FX:Build()
	table.sort(self.events, function(a, b) return a.t < b.t end)
	local last = 0
	for _, e in self.events do last = math.max(last, e.t) end
	self.duration = math.max(self.duration, last + 2.2)
	self:Update(0)
	self:_applyGain()
	return ("%s built: %d emitters, %d beams, %d events, %.2f s, gain %.2f (peak %d additive, light %.1f)"):format(self.name, #self.emitters, #self.beams, #self.events, self.duration, self.gainInfo.g, self.gainInfo.N, self.gainInfo.S)
end
function FX:_halt()
	if self.conn then self.conn:Disconnect(); self.conn = nil end
	if self.camBase then workspace.CurrentCamera.CFrame = self.camBase; self.camBase = nil end
end
-- Play() = live (with camera shake); Play(t) = run to t then freeze everything (emitters TimeScale 0, beams
-- TextureSpeed 0, clock stopped, no shake). Returns the wall-clock start in ms (log it for cutting recordings).
function FX:Play(freezeAt)
	self:_halt()
	for _, e in self.emitters do e:Clear(); e.TimeScale = e:GetAttribute("ts") or 1 end
	for _, b in self.beams do if b:IsA("Beam") then b.TextureSpeed = b:GetAttribute("spd") end end
	local ei = 1
	local shake = (freezeAt == nil) and self.shake and #self.shakes > 0
	if shake then self.camBase = workspace.CurrentCamera.CFrame end
	if self.impact then self:_gui().Enabled = false end
	self:Update(0)
	local t0 = os.clock()
	self.playMs = DateTime.now().UnixTimestampMillis
	self.conn = RunService.Heartbeat:Connect(function()
		local T = os.clock() - t0
		if freezeAt and T >= freezeAt then T = freezeAt end
		while ei <= #self.events and self.events[ei].t <= T do if not self.poseOnly then self.events[ei].fn() end; ei += 1 end
		self:Update(T)
		if shake and self.camBase then workspace.CurrentCamera.CFrame = self.camBase * self:_shakeAt(T) end
		if freezeAt and T >= freezeAt then
			for _, e in self.emitters do e.TimeScale = 0 end
			for _, b in self.beams do if b:IsA("Beam") then b.TextureSpeed = 0 end end
			self.conn:Disconnect(); self.conn = nil
		elseif T > self.duration then
			self:_halt()
		end
	end)
	return self.playMs
end
function FX:Stop()
	self:_halt()
	for _, e in self.emitters do e:Clear(); e.TimeScale = e:GetAttribute("ts") or 1 end
	if self.root.Parent then pcall(function() self:Update(0) end) end
	local c = workspace.CurrentCamera:FindFirstChild(self.name .. "_CC"); if c then c:Destroy() end
	local g = CoreGui:FindFirstChild(self.name .. "_IF"); if g then g:Destroy() end
end
function FX:Destroy()
	self:Stop(); self.root:Destroy()
	if _G.VFXKitLive then _G.VFXKitLive[self.name] = nil end
end

-- PoseOnly(true): plays and freezes show the caster and weapon alone (no events fire, updaters get T = -1), for the
-- pose sheet: fx:PoseOnly(true); fx:Shots(fx:Dense("side", 0, lastKeyTime, 0.1)) ... then fx:PoseOnly(false).
function FX:PoseOnly(on) self.poseOnly = on and true or false; return self.poseOnly end

---------------------------------------------------------------- cameras (review only; effects never read them)
-- player = behind the caster, 2.5 right, 6.5 up, 12 back | side | front (3/4) | bird (top-down, look vector = screen up;
-- 2 degrees off vertical on purpose: an exactly vertical Scriptable camera came out rotated 180 deg in Edit mode)
K.Cams = {
	player = { Vector3.new(2.5, 6.5, 12), Vector3.new(0, 3, -6) },
	side = { Vector3.new(23, 6, 3), Vector3.new(0, 4, -4.5) },
	front = { Vector3.new(-14, 8, -24), Vector3.new(0, 3.5, -4) },
	bird = { Vector3.new(0, 36, -2.7), Vector3.new(0, 0, -4) },
}
function FX:Cam(name)
	local c = K.Cams[name] or K.Cams.player
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable; cam.FieldOfView = 70
	cam.CFrame = CFrame.lookAt(self:P(c[1]), self:P(c[2]))
	return cam.CFrame
end
-- Night(true/false) switches the review light (ClockTime 0.3 / 14.5); the place's own ClockTime is remembered the
-- first time and put back by K.RestoreLighting() (call it when the build is finished).
function K.Night(on)
	if K._clock == nil then K._clock = Lighting.ClockTime end
	Lighting.ClockTime = on and 0.3 or 14.5
end
function K.RestoreLighting()
	if K._clock ~= nil then Lighting.ClockTime = K._clock; K._clock = nil end
end

-- Frozen stills on every OS: fx:Shots(list) stores a plan, each fx:NextShot() sets light, guides and camera, plays to
-- the shot's time, freezes, waits for the viewport to redraw and returns a label ("03 player_0.14_day (3/18)") or
-- "done". Send each NextShot call together with ONE MCP screen_capture (same message, in that order).
-- list = { { "player", 0.14, "day" }, { "bird", 1.05, "day" }, { "player", 1.05, "night" }, ... }
-- fx:Dense(cam, t0, t1, step) returns such rows every `step` s (default 1/30 = every 2nd frame) for motion checks.
function FX:Shots(list) self.shotPlan = list; self.shotI = 0; return "shots planned: " .. #list end
function FX:Dense(cam, t0, t1, step, light)
	local rows = {}
	step = step or 1 / 30
	for i = 0, math.floor((t1 - t0) / step + 0.5) do table.insert(rows, { cam, math.floor((t0 + i * step) * 1000 + 0.5) / 1000, light or "day" }) end
	return rows
end
function FX:NextShot()
	local plan = self.shotPlan
	if not plan then return "no plan: call fx:Shots(list) first" end
	self.shotI += 1
	local s = plan[self.shotI]
	if not s then
		K.Night(false); self:Guides(false); self:Stop(); self.shotPlan = nil
		return "done"
	end
	K.Night(s[3] == "night"); self:Guides(s[1] == "bird", self.mark)
	self:Cam(s[1]); self:Play(s[2])
	local limit = os.clock() + s[2] + 5
	while self.conn and os.clock() < limit do task.wait() end
	task.wait(self.shotWait or 1.2) -- an unfocused Studio viewport redraws about once a second
	return ("%02d %s_%.2f_%s (%d/%d)"):format(self.shotI, s[1], s[2], s[3] or "day", self.shotI, #plan)
end

-- OPTIONAL (Linux helper kit/scripts/optional/sched.py): wall-clock schedule for an outside screenshot tool.
-- Frozen contact sheet, Studio side. shots = { { "player", 0.17, "day" }, ... }; startUnix = the wall-clock second the
-- shooter (optional/sched.py) also got; pad = seconds between slots (3). Slot i starts at sum(t + pad) of the earlier shots;
-- the shooter shoots at slot + t + 1.9 s (an unfocused Studio viewport redraws ~1/s).
function FX:Schedule(shots, startUnix, pad)
	pad = pad or 3
	local function now() return DateTime.now().UnixTimestampMillis / 1000 end
	task.spawn(function()
		local slot = 0
		for _, s in shots do
			while now() - startUnix < slot do task.wait() end
			K.Night(s[3] == "night"); self:Guides(s[1] == "bird", self.mark)
			self:Cam(s[1]); self:Play(s[2])
			slot += s[2] + pad
		end
		task.wait(pad + 3); K.Night(false); self:Guides(false); self:Stop()
	end)
	return "scheduled " .. #shots
end
-- Live run for the 60 fps recording: one play per camera, `gap` s apart (default duration + 0.8). Returns immediately
-- with a JSON-ish string of { cam = playMs } filled in as the plays start (read fx.liveLog afterwards).
function FX:LiveRun(cams, gap)
	gap = gap or (self.duration + 0.8)
	self.liveLog = {}
	task.spawn(function()
		for _, c in cams do
			K.Night(c == "night"); self:Guides(c == "bird", self.mark)
			self:Cam(c == "night" and "player" or c)
			task.wait(0.4)
			self.liveLog[c] = self:Play()
			task.wait(gap)
		end
		K.Night(false); self:Guides(false); self:Stop(); self.liveLog.done = true
	end)
	return gap * #cams + 1
end

---------------------------------------------------------------- lint: static "before you show me" checks
local function hue(c) local h, s, v = c:ToHSV(); return h, s, v end
function FX:Lint()
	local out = {}
	local function warn(m) table.insert(out, "WARN " .. m) end
	local maxBr, sparkle, darkBig = 0, {}, 0
	local noWhy, linger, impact = 0, false, self.impact ~= nil
	local mh = hue(self.pal.main)
	for _, e in self.emitters do
		local role = e:GetAttribute("role")
		local size = 0
		for _, k in e.Size.Keypoints do size = math.max(size, k.Value) end
		local minTr = 1
		for _, k in e.Transparency.Keypoints do minTr = math.min(minTr, k.Value) end
		maxBr = math.max(maxBr, e.Brightness)
		local where = ("%s (%s, %s)"):format(e.Parent and e.Parent.Parent and e.Parent.Parent.Name or "?", role, e.Texture:match("%d+") or "")
		if e.LightInfluence > 0 then warn(where .. ": LightInfluence > 0 (goes dark at night / matte)") end
		if e.Brightness == 0 and e.LightEmission <= 0 and size >= 6 and minTr < 0.4 and e.Lifetime.Max < 1 then warn(where .. ": big opaque black layer = dark slab; Transparency >= 0.45 and size 0.9x of its stroke") end
		if e.LightEmission < -3 and size >= 8 and e.Lifetime.Max > 0.08 then warn(where .. ": large layer at LE " .. e.LightEmission .. " reads as a dark wedge near the camera") end
		if e.ZOffset <= -1 and e.Brightness == 0 then warn(where .. ": ink at ZOffset <= -1 vanishes behind floors / walls; use +-0.02..0.06") end
		if e.Texture:find(tostring(K.Tex.Sparkle[1])) or (role == "sparkle") then
			if e:GetAttribute("n") > 4 then warn(where .. ": more than 4 star sparkles per hit = stickers") end
			if e.Lifetime.Max > 0.16 then warn(where .. ": star sparkle life > 0.15 s = stickers") end
		end
		if e.Texture:find(tostring(K.Tex.Flash[1])) and e.LightEmission < 1 then warn(where .. ": Flash texture below LE 1 paints a dark wedge") end
		if (role == "flash" or role == "pop") and e.Lifetime.Max > 0.12 then warn(where .. ": flash / pop longer than 0.12 s floods the frame") end
		if role == "flash" and e.Brightness > 20 then warn(where .. ": flash Brightness > 20 outshines the hero shape") end
		if e.Orientation == VPAR and size > 1 and e.Squash.Keypoints[1].Value < 2 then warn(where .. ": wide VelocityParallel sprite = pale planks; Size <= 0.8, Squash 3") end
		if role == "rock" and (size > 1.5 or e:GetAttribute("n") > 8) then warn(where .. ": rocks 0.3-1.4 studs, <= 8 per size (big dark blobs)") end
		if (e:GetAttribute("why") or "") == "" then noWhy += 1 end
		if role == "linger" then linger = true end
		if role == "flash" or role == "ring" or role == "hotcrack" or role == "pop" then impact = true end
		local tag = e:GetAttribute("tag") or K.TagOf(e.Texture)
		if tag:sub(1, 5) == "baked" then
			for _, k in e.Color.Keypoints do local _, s2 = k.Value:ToHSV(); if s2 > 0.15 then warn(where .. ": texture is " .. tag .. " but Color is tinted: Color only multiplies baked colour (muddy). Leave it white (K.Tint) or use a mask texture"); break end end
		end
		if (role == "core" or role == "highlight" or role == "fan") then
			for _, k in e.Color.Keypoints do
				local h, s, v = hue(k.Value)
				local dh = math.abs(h - mh); dh = math.min(dh, 1 - dh)
				if s > 0.25 and v > 0.2 and dh > 0.11 then warn(where .. ": ramp leaves the palette hue (stray colour line late in life)"); break end
			end
			if role == "core" and e.Brightness < 20 then warn(where .. ": core Brightness < 20 is timid (25-40, finisher 60)") end
			if role == "core" and (size >= 14 or e.Lifetime.Max >= 0.25) and minTr == 0 and e.Transparency.Keypoints[#e.Transparency.Keypoints].Value < 1 and e.RotSpeed.Max == 0 then warn(where .. ": big / long stroke without an early fade: tail detaches in live play") end
		end
	end
	for _, b in self.beams do
		if b:IsA("Beam") then
			if b.LightInfluence > 0 then warn(b:GetFullName() .. ": beam LightInfluence > 0 (matte, dark at night)") end
			if (b:GetAttribute("why") or "") == "" then noWhy += 1 end
			maxBr = math.max(maxBr, b.Brightness)
		end
	end
	if maxBr < 40 then warn("no layer above Brightness 40: timid (accents 40-60)") end
	if noWhy > 0 then warn(("%d layers have no `why`: give every layer you make a reason (props.why = \"<reads because>; keep: ...; free: ...\")"):format(noWhy)) end
	if impact and not linger then warn("an impact without an aftermath group: add fx:Aftermath{ t = hit + 0.15, p = ... } (faint, low, radial, 1-2 s)") end
	local gi = self.gainInfo
	if gi and (gi.N > 6 or gi.S > (self.budget or 2)) and gi.g >= 1 then warn(("%d additive layers (light %.1f) overlap at %s with gain 1: white-blob risk (leave fx.gain = \"auto\" or set it < 1)"):format(gi.N, gi.S, gi.at)) end
	for _, c in self.curtains do
		if c.ring and c.n < 6 then warn(c.name .. ": a ring curtain with fewer than 6 panels shows a polygon with bright overlap corners from above (6-8)") end
		if not c.ring and c.rows < 2 then warn(c.name .. ": one row of panels = a stick from the end and a slab from above; rows = 2+ (and keep the foot glow)") end
	end
	for _, d in self.root:GetDescendants() do
		if d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
			if d.Range > 16 then warn(d:GetFullName() .. ": light Range > 16 is not local") end
		end
	end
	-- dead time: gaps without any event between the first and the last "hit" (core strokes / flashes)
	local ts = {}
	for _, e in self.events do table.insert(ts, e.t) end
	for _, L in self.meshes do for i = 0, 4 do table.insert(ts, lerp(L.on, L.hold, i / 4)) end end -- mesh layers move every frame from on to hold
	for _, c in self.curtains do for x = c.t0, c.t1, 0.1 do table.insert(ts, x) end end -- curtains scroll and move all through their life
	table.sort(ts)
	for i = 2, #ts do
		if ts[i] - ts[i - 1] > 0.2 and ts[i - 1] < ts[#ts] - 1.0 then warn(("dead time: nothing is emitted from %.2f to %.2f s"):format(ts[i - 1], ts[i])) end
	end
	-- escalation: core stroke sizes should grow ~15 % per hit
	local cores = {}
	for _, e in self.emitters do if e:GetAttribute("role") == "core" then table.insert(cores, e.Size.Keypoints[1].Value) end end
	for i = 2, #cores do if cores[i] < cores[i - 1] then warn(("stroke %d (%.1f) is smaller than stroke %d (%.1f): escalate +15 %% per hit"):format(i, cores[i], i - 1, cores[i - 1])) end end
	for _, st in self.strokes do
		if math.abs(st.n.Z) < 0.3 and math.abs(st.n.Y) < 0.8 then
			warn(("%s: its plane contains the look vector = edge-on (a thin line) from behind the caster.%s Choose a cut whose normal leans 45-60 deg toward forward, or pair it with a crescent ACROSS the front 4-6 studs ahead + a flat ground crescent"):format(st.name, st.fan and "" or " No fan either."))
		end
	end
	-- mesh slashes
	for _, ms in self.meshSlashes do
		if ms.fit.straight then warn(ms.name .. ": the tip path is straight (a thrust): no circle to fit, use a Stroke / needles") end
		if ms.fade < 0.08 or ms.fade > 0.25 then warn(("%s: decal fade %.2f s (0.08-0.25: shorter pops off, longer leaves a lingering line)"):format(ms.name, ms.fade)) end
		local bright, tall = 0, 0
		for _, L in ms.layers do
			if L.col.R + L.col.G + L.col.B > 0.3 then bright = math.max(bright, L.r) end
			if L.kind == "Band" then tall = math.max(tall, L.th) end
		end
		for _, L in ms.layers do
			if L.col.R + L.col.G + L.col.B <= 0.3 then
				if L.r >= bright then warn(ms.name .. ": the dark copy is as big as the bright layers (covers them from the far side): r 0.86-0.9x") end
				if L.tr0 < 0.4 then warn(ms.name .. ": opaque dark copy = black slab; tr0 0.5-0.6") end
			end
		end
		if math.abs(ms.n.Z) < 0.3 and math.abs(ms.n.Y) < 0.8 and tall < 1.5 then
			warn(ms.name .. ": its plane contains the look vector = edge-on from behind the caster; give it a tall Band (height 2-2.4) so its wall faces the player camera")
		end
	end
	-- pose: sampled every 0.05 s over the keys
	if self.char and self.keys and #self.keys > 1 then
		local function arm(cf, side)
			local T = cf.UpperTorso
			local u = T:VectorToObjectSpace(-cf[side .. "UpperArm"].UpVector)
			local l = T:VectorToObjectSpace(-cf[side .. "LowerArm"].UpVector)
			local hand = T:PointToObjectSpace(cf[side .. "Hand"].Position)
			local out = math.abs(u.X) > 0.75 and u.Y > -0.14 and math.deg(math.acos(math.clamp(u:Dot(l), -1, 1))) < 18 -- straight, sideways, at shoulder height
			return out, (math.abs(hand.X) < 0.8 and math.abs(hand.Y) < 0.75 and math.abs(hand.Z) < 0.38)
		end
		local tEnd = self.keys[#self.keys].t
		local tpose, inside, runR, runL, stiff, twoUsed = nil, nil, 0, 0, nil, false
		for _, k in self.keys do if k.two > 0 then twoUsed = true end end
		for i = 0, math.floor(tEnd / 0.05) do
			local t = i * 0.05
			local cf = self:FK(t)
			local oR, iR = arm(cf, "Right")
			local oL, iL = arm(cf, "Left")
			if oR and oL and not tpose then tpose = t end
			if (iR or iL) and not inside then inside = t end
			runR = oR and runR + 1 or 0; runL = oL and runL + 1 or 0
			if (runR >= 5 or runL >= 5) and not stiff then stiff = t end
		end
		if tpose then warn(("pose: T-pose at %.2f s (both arms straight out at shoulder height): bend the elbows 18-80 deg, upper arms below the shoulders, pass through a guard (K.Guard)"):format(tpose)) end
		if stiff then warn(("pose: one arm is held straight out sideways for 0.25 s up to %.2f s: bend it or bring it to a guard"):format(stiff)) end
		if inside then warn(("pose: a hand is inside the torso at %.2f s (arm through the body): keep the arm's az on its own side or lift it over"):format(inside)) end
		if self.bladeLen and self.bladeLen >= 3 and not twoUsed then warn("pose: a long weapon is held one-handed all the way: two = 1 on guards, wind-ups and heavy cuts (off hand on the handle)") end
	end
	if #self.shakes == 0 then warn("no camera shake declared (light hit 0.15 / 0.1 s, heavy 0.6 / 0.35 s)") end
	if not self.impact then warn("no ImpactFrame on the payoff") end
	table.insert(out, 1, ("LINT %s: %d emitters, %d beams, %d events, max Brightness %d, gain %s, %d warnings"):format(self.name, #self.emitters, #self.beams, #self.events, maxBr,
		gi and ("%.2f (peak %d additive, light %.1f at %s)"):format(gi.g, gi.N, gi.S, gi.at) or "not built", #out))
	return table.concat(out, "\n")
end

_G.VFXKit = K
return K
