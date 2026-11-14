-- VFXTimeline: plays an effect that is described as DATA (layers, start times, keyframed properties, particle bursts,
-- a colour grade) on one shared Heartbeat. Each effect is a ModuleScript (e.g. ReplicatedStorage.VFX.<Name>) returning a
-- spec table, so an agent or a person can change one number ("the dome grows over 0.2 s, not 0.3") and replay it.
-- The full spec format, the capture/compare pipeline and the review loop are documented in the skill
-- skills/vfx-make/SKILL.md.
--
--   local VFXTimeline = require(ReplicatedStorage.VFXTimeline)
--   local handle = VFXTimeline.play(require(ReplicatedStorage.VFX.VoidRend), CFrame.new(pos), { scale = 1, seed = 7 })
--   handle.stop()
--
-- Options: scale (size of everything), speed (time scale, 0.25 = slow motion for capture; particles follow through
-- ParticleEmitter.TimeScale), seed, important (skip the distance cull), noGrade (skip colour grades), parent, onDone,
-- freezeAt (capture: hold the effect at exactly this time until handle.stop() or handle.setSpeed(1)).
-- Client-side only in games (the server sends "play X at Y"); also runs in Studio Edit mode for capture.
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ContentProvider = game:GetService("ContentProvider")

local VFXTimeline = {}
VFXTimeline.CullDistance = 260 -- studs from the camera; beyond it non-important effects don't play
VFXTimeline.Quality = 1 -- multiplies every Emit count (set 0.6 on touch devices)
VFXTimeline.Assets = nil -- Folder of template parts by name (default: ReplicatedStorage.VFXAssets)

--------------------------------------------------------------------------------------------------------------------
-- Easing (name -> f(0..1) -> 0..1). "step" holds the previous key's value until this key's time (colour-by-age swaps).
local function backOut(x)
	local c1 = 1.70158
	return 1 + (c1 + 1) * (x - 1) ^ 3 + c1 * (x - 1) ^ 2
end
local EASE = {
	linear = function(x) return x end,
	step = function(x) return if x >= 1 then 1 else 0 end,
	quadIn = function(x) return x * x end,
	quadOut = function(x) return 1 - (1 - x) ^ 2 end,
	quadInOut = function(x) return if x < 0.5 then 2 * x * x else 1 - (-2 * x + 2) ^ 2 / 2 end,
	cubicIn = function(x) return x ^ 3 end,
	cubicOut = function(x) return 1 - (1 - x) ^ 3 end,
	quartOut = function(x) return 1 - (1 - x) ^ 4 end,
	quintOut = function(x) return 1 - (1 - x) ^ 5 end,
	expoIn = function(x) return if x <= 0 then 0 else 2 ^ (10 * x - 10) end,
	expoOut = function(x) return if x >= 1 then 1 else 1 - 2 ^ (-10 * x) end,
	sineIn = function(x) return 1 - math.cos(x * math.pi / 2) end,
	sineOut = function(x) return math.sin(x * math.pi / 2) end,
	sineInOut = function(x) return -(math.cos(math.pi * x) - 1) / 2 end,
	backOut = backOut,
	backIn = function(x)
		local c1 = 1.70158
		return (c1 + 1) * x ^ 3 - c1 * x * x
	end,
	elasticOut = function(x)
		if x <= 0 or x >= 1 then return x end
		return 2 ^ (-10 * x) * math.sin((x * 10 - 0.75) * (2 * math.pi) / 3) + 1
	end,
}
VFXTimeline.Ease = EASE

--------------------------------------------------------------------------------------------------------------------
-- Value conversion. Specs use plain Luau values: numbers, "#RRGGBB" or palette names for colours, {x, y, z} for
-- vectors, {{t, v}, ...} for sequences, {min, max} for ranges, enum item NAMES ("Neon", "VelocityPerpendicular").
local function isVec(v)
	return type(v) == "table" and #v == 3 and type(v[1]) == "number" and type(v[2]) == "number" and type(v[3]) == "number"
end

local function color(v, ctx)
	if typeof(v) == "Color3" then return v end
	if type(v) == "string" then
		if string.sub(v, 1, 1) == "#" then return Color3.fromHex(v) end
		local p = ctx.palette[v]
		if p then return color(p, ctx) end
		error("unknown colour '" .. v .. "'")
	end
	if isVec(v) then return Color3.fromRGB(v[1], v[2], v[3]) end
	error("bad colour " .. tostring(v))
end

local function vec(v, k)
	k = k or 1
	if typeof(v) == "Vector3" then return v * k end
	if type(v) == "number" then return Vector3.one * v * k end
	if isVec(v) then return Vector3.new(v[1], v[2], v[3]) * k end
	error("bad vector " .. tostring(v))
end

local function numSeq(v, k)
	k = k or 1
	if typeof(v) == "NumberSequence" then return v end
	if type(v) == "number" then return NumberSequence.new(v * k) end
	local kps = {}
	for _, e in ipairs(v) do table.insert(kps, NumberSequenceKeypoint.new(e[1], e[2] * k, (e[3] or 0) * k)) end
	table.sort(kps, function(a, b) return a.Time < b.Time end)
	if kps[1].Time > 0 then table.insert(kps, 1, NumberSequenceKeypoint.new(0, kps[1].Value, kps[1].Envelope)) end
	if kps[#kps].Time < 1 then table.insert(kps, NumberSequenceKeypoint.new(1, kps[#kps].Value, kps[#kps].Envelope)) end
	return NumberSequence.new(kps)
end

local function colSeq(v, ctx)
	if typeof(v) == "ColorSequence" then return v end
	if type(v) == "string" or typeof(v) == "Color3" or isVec(v) then return ColorSequence.new(color(v, ctx)) end
	local kps = {}
	for _, e in ipairs(v) do table.insert(kps, ColorSequenceKeypoint.new(e[1], color(e[2], ctx))) end
	table.sort(kps, function(a, b) return a.Time < b.Time end)
	if kps[1].Time > 0 then table.insert(kps, 1, ColorSequenceKeypoint.new(0, kps[1].Value)) end
	if kps[#kps].Time < 1 then table.insert(kps, ColorSequenceKeypoint.new(1, kps[#kps].Value)) end
	return ColorSequence.new(kps)
end

local function range(v, k)
	k = k or 1
	if typeof(v) == "NumberRange" then return v end
	if type(v) == "number" then return NumberRange.new(v * k) end
	return NumberRange.new(v[1] * k, v[2] * k)
end

local function texture(v, ctx)
	if type(v) == "number" then return "rbxassetid://" .. v end
	if type(v) == "string" then
		if ctx.textures[v] then return texture(ctx.textures[v], ctx) end
		if string.match(v, "^%d+$") then return "rbxassetid://" .. v end
	end
	return v
end

local GRIDS = { [2] = "Grid2x2", [4] = "Grid4x4", [8] = "Grid8x8" }
local ENUMS = {
	FlipbookLayout = Enum.ParticleFlipbookLayout,
	FlipbookMode = Enum.ParticleFlipbookMode,
	Orientation = Enum.ParticleOrientation,
	ShapeStyle = Enum.ParticleEmitterShapeStyle,
	ShapeInOut = Enum.ParticleEmitterShapeInOut,
	EmissionDirection = Enum.NormalId,
	TextureMode = Enum.TextureMode,
	Material = Enum.Material,
	Face = Enum.NormalId,
}

-- Converts one spec value for property `prop` of instance `inst` (k = the effect's scale).
local function convert(inst, prop, v, ctx)
	local k = ctx.scale
	if prop == "Texture" or prop == "TextureId" or prop == "MeshId" then return texture(v, ctx) end
	if inst:IsA("ParticleEmitter") then
		if prop == "Color" then return colSeq(v, ctx) end
		if prop == "Size" then return numSeq(v, k) end
		if prop == "Transparency" or prop == "Squash" then return numSeq(v) end
		if prop == "Speed" then return range(v, k) end
		if prop == "Lifetime" or prop == "Rotation" or prop == "RotSpeed" or prop == "FlipbookFramerate" then return range(v) end
		if prop == "SpreadAngle" then return if type(v) == "number" then Vector2.new(v, v) else Vector2.new(v[1], v[2]) end
		if prop == "Acceleration" then return vec(v, k) end
		if prop == "Shape" then return Enum.ParticleEmitterShape[v] end
		if prop == "FlipbookLayout" and type(v) == "number" then return Enum.ParticleFlipbookLayout[GRIDS[v]] end
	elseif inst:IsA("Beam") then
		if prop == "Color" then return colSeq(v, ctx) end
		if prop == "Transparency" then return numSeq(v) end
		if prop == "Width0" or prop == "Width1" or prop == "CurveSize0" or prop == "CurveSize1" then return v * k end
		if prop == "TextureLength" then return v * k end
	elseif inst:IsA("BasePart") then
		if prop == "Color" then return color(v, ctx) end
		if prop == "Size" then return vec(v, k) end
		if prop == "Shape" then return Enum.PartType[v] end
	elseif inst:IsA("Light") then
		if prop == "Color" then return color(v, ctx) end
		if prop == "Range" then return v * k end
	elseif inst:IsA("ColorCorrectionEffect") then
		if prop == "TintColor" then return color(v, ctx) end
	elseif inst:IsA("Decal") then
		if prop == "Color3" then return color(v, ctx) end
	end
	local enum = ENUMS[prop]
	if enum and type(v) == "string" then return enum[v] end
	return v
end

local function set(inst, prop, v, ctx, layerId)
	local ok, err = pcall(function() inst[prop] = convert(inst, prop, v, ctx) end)
	if not ok then
		local key = layerId .. "." .. prop
		if not ctx.warned[key] then
			ctx.warned[key] = true
			warn(string.format("[VFXTimeline] %s: layer %s, %s: %s", ctx.name, layerId, prop, tostring(err)))
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
-- Tracks: { {t, value, ease}, ... }, t in seconds from the layer's start. The ease belongs to the segment that ENDS at
-- that key. Values interpolate as numbers, Vector3s or Color3s; anything else steps.
local function lerp(a, b, x)
	local ta = typeof(a)
	if ta == "number" then return a + (b - a) * x end
	if ta == "Vector3" or ta == "Color3" then return a:Lerp(b, x) end
	return if x >= 1 then b else a
end

local function prepTrack(keys, ctx, kind)
	local out = {}
	for _, key in ipairs(keys) do
		local v = key[2]
		if kind == "color" then
			v = color(v, ctx)
		elseif kind == "vector" then
			v = vec(v)
		elseif kind == "vectorOrNumber" then
			if type(v) ~= "number" then v = vec(v) end
		end
		table.insert(out, { t = key[1], v = v, ease = EASE[key[3] or "linear"] or EASE.linear })
	end
	table.sort(out, function(a, b) return a.t < b.t end)
	return out
end

local function sample(track, t)
	local first = track[1]
	if t <= first.t then return first.v end
	for i = 2, #track do
		local key = track[i]
		if t < key.t then
			local prev = track[i - 1]
			local x = (t - prev.t) / math.max(key.t - prev.t, 1e-6)
			return lerp(prev.v, key.v, key.ease(x))
		end
	end
	return track[#track].v
end

-- Which value kind a track holds, so keys are converted once up front.
local COLOR_TRACKS = { Color = true, TintColor = true, DecalColor = true, Color3 = true }
local VECTOR_TRACKS = { Offset = true, Rot = true, A = true, B = true }

--------------------------------------------------------------------------------------------------------------------
local active = {}
local conn

local function assetFolder()
	if VFXTimeline.Assets then return VFXTimeline.Assets end
	local rs = game:GetService("ReplicatedStorage")
	return rs:FindFirstChild("VFXAssets")
end

local function newAnchor(ctx, size)
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
	p.Transparency = 1
	p.Size = size or Vector3.one * 0.2
	p.Parent = ctx.folder
	return p
end

local function degCF(v)
	return CFrame.Angles(math.rad(v.X), math.rad(v.Y), math.rad(v.Z))
end

-- The layer's frame in world space: origin * at * rot (the layer is free to move inside it with Offset/Rot tracks).
local function layerFrame(ctx, L)
	return ctx.origin * CFrame.new(L.at * ctx.scale) * L.rotCF
end

-- One frame of a "part" layer: scale about the pivot, then place.
local function placePart(ctx, L, s, lt)
	local inst = s.inst
	local scale = if L.tracks.Scale then sample(L.tracks.Scale, lt) else 1
	local sv = if type(scale) == "number" then Vector3.one * scale else scale
	local offset = if L.tracks.Offset then sample(L.tracks.Offset, lt) else Vector3.zero
	local rot = if L.tracks.Rot then sample(L.tracks.Rot, lt) else Vector3.zero
	local spin = if L.spin then L.spin * lt else Vector3.zero
	local size = s.baseSize * sv
	if s.mesh then
		s.mesh.Scale = s.meshScale * sv
		size = s.meshSize * sv
	else
		inst.Size = Vector3.new(math.max(size.X, 0.001), math.max(size.Y, 0.001), math.max(size.Z, 0.001))
	end
	local cf = layerFrame(ctx, L) * CFrame.new(offset * ctx.scale) * degCF(rot + spin)
	inst.CFrame = cf * CFrame.new(-L.pivot * size)
end

local KIND = {}

KIND.part = {
	start = function(ctx, L)
		local s = {}
		local inst
		if L.template then
			local folder = assetFolder()
			local tpl = folder and folder:FindFirstChild(L.template, true)
			if not tpl then
				warn("[VFXTimeline] " .. ctx.name .. ": missing template " .. tostring(L.template))
				return nil
			end
			inst = tpl:Clone()
			s.baseSize = (L.size and vec(L.size, ctx.scale)) or inst.Size * ctx.scale
		else
			inst = Instance.new("Part")
			inst.Material = Enum.Material.Neon
			s.baseSize = vec(L.size or 1, ctx.scale)
			if L.mesh then
				local m = Instance.new("SpecialMesh")
				m.MeshType = Enum.MeshType.FileMesh
				m.MeshId = texture(L.mesh, ctx)
				if L.meshTexture then m.TextureId = texture(L.meshTexture, ctx) end
				m.Parent = inst
				s.mesh = m
				s.meshScale = vec(L.meshScale or 1, ctx.scale)
				s.meshSize = vec(L.meshSize or 1, ctx.scale) -- the mesh's native size, for the pivot
			end
		end
		inst.Anchored, inst.CanCollide, inst.CanQuery, inst.CanTouch, inst.CastShadow = true, false, false, false, false
		for prop, v in pairs(L.props) do set(inst, prop, v, ctx, L.id) end
		if L.decal then
			local d = Instance.new("Decal")
			for prop, v in pairs(L.decal) do set(d, prop, v, ctx, L.id) end
			d.Parent = inst
			s.decal = d
		end
		s.inst = inst
		placePart(ctx, L, s, 0)
		inst.Parent = ctx.folder
		return s
	end,
	update = function(ctx, L, s, lt)
		placePart(ctx, L, s, lt)
		local tr = L.tracks
		if tr.Color then s.inst.Color = sample(tr.Color, lt) end
		if tr.Transparency then s.inst.Transparency = sample(tr.Transparency, lt) end
		if s.decal then
			if tr.DecalColor then s.decal.Color3 = sample(tr.DecalColor, lt) end
			if tr.DecalTransparency then s.decal.Transparency = sample(tr.DecalTransparency, lt) end
		end
	end,
}

-- Beams hang between two attachments on the effect's holder part (origin space): a and b, moved by A/B tracks.
local function beamPoint(ctx, L, base, track, lt)
	local p = base + (if track then sample(track, lt) else Vector3.zero)
	return (CFrame.new(L.at) * L.rotCF * CFrame.new(p)).Position * ctx.scale
end

KIND.beam = {
	start = function(ctx, L)
		local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
		if L.axis then -- curve direction (CurveSize0 bends along it at a, CurveSize1 against it at b): {0,1,0} = arches
			local axis = (L.rotCF * CFrame.new(vec(L.axis))).Position.Unit
			local secondary = if math.abs(axis.Y) > 0.9 then Vector3.zAxis else Vector3.yAxis
			a0.Axis, a0.SecondaryAxis = axis, secondary
			a1.Axis, a1.SecondaryAxis = axis, secondary
		end
		a0.Parent, a1.Parent = ctx.holder, ctx.holder
		local b = Instance.new("Beam")
		b.LightInfluence = 0
		b.FaceCamera = true
		-- A beam samples Transparency/Color sequences only at its segment ends: with Segments 1 a fade that is 1 at both
		-- ends ({0,1},{0.15,0},{0.85,0},{1,1}) hides the WHOLE beam. 10 is cheap and safe; set 1 only for plain beams.
		b.Segments = 10
		for prop, v in pairs(L.props) do set(b, prop, v, ctx, L.id) end
		local texSpeed = b.TextureSpeed
		b.TextureSpeed = texSpeed * ctx.speed
		b.Attachment0, b.Attachment1 = a0, a1
		local s = {
			inst = b, a0 = a0, a1 = a1, texSpeed = texSpeed,
			pa = vec(L.a or { 0, 0, 0 }), pb = vec(L.b or { 0, 1, 0 }),
			w0 = b.Width0, w1 = b.Width1, baseT = b.Transparency,
		}
		KIND.beam.update(ctx, L, s, 0)
		b.Parent = ctx.holder
		return s
	end,
	update = function(ctx, L, s, lt)
		local tr = L.tracks
		s.a0.Position = beamPoint(ctx, L, s.pa, tr.A, lt)
		s.a1.Position = beamPoint(ctx, L, s.pb, tr.B, lt)
		if tr.Width then
			local w = sample(tr.Width, lt)
			s.inst.Width0, s.inst.Width1 = s.w0 * w, s.w1 * w
		end
		if tr.Color then s.inst.Color = ColorSequence.new(sample(tr.Color, lt)) end
		if tr.Fade then -- 0 = as authored, 1 = gone; keeps the authored transparency shape
			local f = math.clamp(sample(tr.Fade, lt), 0, 1)
			local kps = {}
			for _, kp in ipairs(s.baseT.Keypoints) do
				table.insert(kps, NumberSequenceKeypoint.new(kp.Time, 1 - (1 - kp.Value) * (1 - f)))
			end
			s.inst.Transparency = NumberSequence.new(kps)
		end
		if tr.CurveSize0 then s.inst.CurveSize0 = sample(tr.CurveSize0, lt) * ctx.scale end
		if tr.CurveSize1 then s.inst.CurveSize1 = sample(tr.CurveSize1, lt) * ctx.scale end
	end,
}

-- Emitters sit on an invisible anchored part (`box` = emission volume, studs). emit = { {t, count[, over]}, ... }.
KIND.emitter = {
	start = function(ctx, L)
		local part = newAnchor(ctx, if L.box then vec(L.box, ctx.scale) else nil)
		part.CFrame = layerFrame(ctx, L)
		local e = Instance.new("ParticleEmitter")
		e.LightInfluence = 0
		e.Rate = 0
		for prop, v in pairs(L.props) do set(e, prop, v, ctx, L.id) end
		-- an authored TimeScale (artists use 0.6-0.9 to slow a layer) is kept and multiplied by the play speed
		e:SetAttribute("VFXBaseTimeScale", e.TimeScale)
		e.TimeScale = math.clamp(e.TimeScale * ctx.speed, 0, 1)
		e.Parent = part
		local emits = {}
		for _, x in ipairs(L.emit or {}) do
			table.insert(emits, { t = x[1], n = x[2], over = x[3] or 0, done = 0 })
		end
		return { inst = e, part = part, emits = emits, rate = e.Rate, linger = e.Lifetime.Max }
	end,
	update = function(ctx, L, s, lt)
		local tr = L.tracks
		if tr.Offset then s.part.CFrame = layerFrame(ctx, L) * CFrame.new(sample(tr.Offset, lt) * ctx.scale) end
		if tr.Rate then s.inst.Rate = sample(tr.Rate, lt) * VFXTimeline.Quality end
		for _, x in ipairs(s.emits) do
			if lt >= x.t and x.done < x.n then
				local want = if x.over > 0 then math.min(x.n, math.floor(x.n * math.min(1, (lt - x.t) / x.over) + 0.5)) else x.n
				local count = math.floor((want - x.done) * VFXTimeline.Quality + 0.5)
				if want >= x.n and count < 1 and x.done == 0 then count = 1 end
				if count > 0 then s.inst:Emit(count) end
				x.done = want
			end
		end
	end,
	finish = function(ctx, L, s)
		s.inst.Rate = 0
		return s.linger -- effect seconds to keep the part so live particles finish (particles age with TimeScale)
	end,
}

KIND.light = {
	start = function(ctx, L)
		local part = newAnchor(ctx)
		part.CFrame = layerFrame(ctx, L)
		local light = Instance.new(L.class or "PointLight")
		light.Shadows = false
		for prop, v in pairs(L.props) do set(light, prop, v, ctx, L.id) end
		light.Parent = part
		return { inst = light, part = part }
	end,
	update = function(ctx, L, s, lt)
		local tr = L.tracks
		if tr.Brightness then s.inst.Brightness = sample(tr.Brightness, lt) end
		if tr.Range then s.inst.Range = sample(tr.Range, lt) * ctx.scale end
		if tr.Color then s.inst.Color = sample(tr.Color, lt) end
	end,
}

-- A colour grade on the whole view (ColorCorrectionEffect in Lighting, owned by this layer, removed at its end).
KIND.grade = {
	start = function(ctx, L)
		if ctx.noGrade then return nil end
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Name = "VFXGrade_" .. ctx.name
		for prop, v in pairs(L.props) do set(cc, prop, v, ctx, L.id) end
		cc.Parent = Lighting
		return { inst = cc }
	end,
	update = function(ctx, L, s, lt)
		for prop, track in pairs(L.tracks) do s.inst[prop] = sample(track, lt) end
	end,
}

-- Escape hatch: start(ctx, L) -> state, update(ctx, L, state, lt, dt), stop(ctx, L, state). ctx.random is seeded.
KIND.custom = {
	start = function(ctx, L) return L.start(ctx, L) or {} end,
	update = function(ctx, L, s, lt, dt) if L.update then L.update(ctx, L, s, lt, dt) end end,
	finish = function(ctx, L, s) if L.stop then L.stop(ctx, L, s) end end,
}

--------------------------------------------------------------------------------------------------------------------
-- Expands a spec into a flat, time-sorted list of layer instances (copies resolved with the seeded random).
local function expand(spec, ctx)
	local list = {}
	for _, raw in ipairs(spec.layers) do
		if raw.enabled == false then continue end
		local copies = raw.copies or { n = 1 }
		for i = 1, copies.n or 1 do
			local r = ctx.random
			local function jitter(v) -- {x,y,z} -> random within +-v
				if not v then return Vector3.zero end
				local s = vec(v)
				return Vector3.new(r:NextNumber(-s.X, s.X), r:NextNumber(-s.Y, s.Y), r:NextNumber(-s.Z, s.Z))
			end
			local at = vec(raw.at or { 0, 0, 0 }) + jitter(copies.spread)
			local rot = vec(raw.rot or { 0, 0, 0 }) + jitter(copies.rotSpread)
			if copies.yawEven then rot += Vector3.new(0, 360 * (i - 1) / copies.n, 0) end
			local L = {
				id = raw.id or raw.kind,
				kind = raw.kind,
				t = (raw.t or 0) + (i - 1) * (copies.every or 0) + (if copies.jitter then r:NextNumber(0, copies.jitter) else 0),
				life = raw.life or 1,
				at = at,
				rotCF = degCF(rot),
				pivot = vec(raw.pivot or { 0, 0, 0 }),
				spin = if raw.spin then vec(raw.spin) else nil,
				props = raw.props or {},
				decal = raw.decal,
				template = raw.template,
				mesh = raw.mesh, meshTexture = raw.meshTexture, meshScale = raw.meshScale, meshSize = raw.meshSize,
				size = raw.size,
				a = raw.a, b = raw.b, box = raw.box, axis = raw.axis,
				emit = raw.emit,
				class = raw.class,
				start = raw.start, update = raw.update, stop = raw.stop,
				data = raw.data, index = i,
				tracks = {},
			}
			for prop, keys in pairs(raw.tracks or {}) do
				local kind = if COLOR_TRACKS[prop] then "color"
					elseif VECTOR_TRACKS[prop] then "vector"
					elseif prop == "Scale" then "vectorOrNumber"
					else nil
				L.tracks[prop] = prepTrack(keys, ctx, kind)
			end
			table.insert(list, L)
		end
	end
	table.sort(list, function(a, b) return a.t < b.t end)
	return list
end

local function destroyState(st)
	for _, key in ipairs({ "part", "inst", "a0", "a1" }) do
		local inst = st[key]
		if typeof(inst) == "Instance" then inst:Destroy() end
	end
end

local function setSpeed(fx, speed)
	fx.ctx.speed = speed
	for _, st in pairs(fx.state) do
		if not st then continue end
		if typeof(st.inst) == "Instance" and st.inst:IsA("ParticleEmitter") then
			st.inst.TimeScale = math.clamp((st.inst:GetAttribute("VFXBaseTimeScale") or 1) * speed, 0, 1)
		elseif st.texSpeed then
			st.inst.TextureSpeed = st.texSpeed * speed
		end
	end
end

local function stepEffect(fx, dt)
	local ctx = fx.ctx
	fx.t += dt * ctx.speed
	if ctx.freezeAt and fx.t >= ctx.freezeAt and not fx.frozen then
		fx.t = ctx.freezeAt -- the frame is built at exactly this time, then everything holds
		fx.frozen = true
		fx.freezeNext = true
	end
	local t = fx.t
	local alive = false
	for _, L in ipairs(fx.layers) do
		local st = fx.state[L]
		if st == nil then
			if t >= L.t then
				local kind = KIND[L.kind]
				local ok, s = pcall(kind.start, ctx, L)
				if not ok then
					warn(string.format("[VFXTimeline] %s: layer %s failed to start: %s", ctx.name, L.id, tostring(s)))
					s = nil
				end
				fx.state[L] = s or false
				st = fx.state[L]
			else
				alive = true
				continue
			end
		end
		if st == false then continue end
		if st.endsAt then -- finished, waiting for its particles
			if t < st.endsAt then alive = true else
				destroyState(st)
				fx.state[L] = false
			end
			continue
		end
		local lt = t - L.t
		local kind = KIND[L.kind]
		local ok, err = pcall(kind.update, ctx, L, st, math.min(lt, L.life), dt * ctx.speed)
		if not ok and not ctx.warned[L.id .. ".update"] then
			ctx.warned[L.id .. ".update"] = true
			warn(string.format("[VFXTimeline] %s: layer %s update: %s", ctx.name, L.id, tostring(err)))
		end
		if lt >= L.life then
			local linger = if kind.finish then kind.finish(ctx, L, st) else nil
			if type(linger) == "number" and linger > 0 then
				st.endsAt = t + linger
				alive = true
			else
				destroyState(st)
				fx.state[L] = false
			end
		else
			alive = true
		end
	end
	if fx.freezeNext then
		fx.freezeNext = false
		setSpeed(fx, 0)
		alive = true
	end
	return alive or fx.frozen
end

local function finishEffect(fx)
	for L, st in pairs(fx.state) do
		if st and KIND[L.kind].finish and not st.endsAt then pcall(KIND[L.kind].finish, fx.ctx, L, st) end
		if st then destroyState(st) end
	end
	fx.ctx.folder:Destroy()
	if fx.ctx.onDone then task.spawn(fx.ctx.onDone) end
end

local function heartbeat(dt)
	for i = #active, 1, -1 do
		local fx = active[i]
		local ok, alive = pcall(stepEffect, fx, dt)
		if fx.stopped or not ok or not alive then
			if not ok then warn("[VFXTimeline] " .. fx.ctx.name .. ": " .. tostring(alive)) end
			table.remove(active, i)
			finishEffect(fx)
		end
	end
	if #active == 0 and conn then
		conn:Disconnect()
		conn = nil
	end
end

local NOOP = { stop = function() end, time = function() return 0 end }

function VFXTimeline.play(spec, origin, opts)
	opts = opts or {}
	if typeof(origin) == "Vector3" then origin = CFrame.new(origin) end
	local cam = Workspace.CurrentCamera
	if not opts.important and cam and (cam.CFrame.Position - origin.Position).Magnitude > VFXTimeline.CullDistance then
		return NOOP
	end
	local folder = Instance.new("Folder")
	folder.Name = "VFX_" .. (spec.name or "Effect")
	local ctx = {
		name = spec.name or "Effect",
		origin = origin,
		scale = (spec.scale or 1) * (opts.scale or 1),
		speed = opts.speed or 1,
		palette = spec.palette or {},
		textures = spec.textures or {},
		random = Random.new(opts.seed or math.floor(os.clock() * 1000) % 2 ^ 31),
		noGrade = opts.noGrade,
		freezeAt = opts.freezeAt, -- capture: stop the clock (and all particles) at exactly this effect time
		onDone = opts.onDone,
		warned = {},
		folder = folder,
	}
	ctx.holder = newAnchor(ctx)
	ctx.holder.Name = "Holder"
	ctx.holder.CFrame = origin
	local fx = { ctx = ctx, t = 0, layers = expand(spec, ctx), state = {} }
	folder.Parent = opts.parent or Workspace
	table.insert(active, fx)
	if not conn then conn = RunService.Heartbeat:Connect(heartbeat) end
	heartbeat(0) -- layers at t = 0 appear on this frame
	return {
		stop = function() fx.stopped = true end,
		time = function() return fx.t end,
		-- Changes the time scale live: 0 freezes the effect (timeline, particles and beam scrolling) for a still
		-- capture, 0.25 is slow motion, 1 is normal.
		setSpeed = function(speed)
			if speed > 0 then fx.frozen = false; ctx.freezeAt = nil end
			setSpeed(fx, speed)
		end,
	}
end

-- Preloads every texture/mesh id a spec uses (call once before the first play).
function VFXTimeline.preload(spec)
	local ids, seen = {}, {}
	local function add(v)
		if type(v) == "number" or (type(v) == "string" and string.match(v, "^%d+$")) then v = "rbxassetid://" .. v end
		if type(v) == "string" and string.find(v, "rbxassetid://") and not seen[v] then
			seen[v] = true
			local d = Instance.new("Decal")
			d.Texture = v
			table.insert(ids, d)
		end
	end
	for _, v in pairs(spec.textures or {}) do add(v) end
	for _, L in ipairs(spec.layers) do
		if L.mesh then add(L.mesh) end
		if L.props and L.props.Texture then add(spec.textures and spec.textures[L.props.Texture] or L.props.Texture) end
	end
	task.spawn(function() pcall(ContentProvider.PreloadAsync, ContentProvider, ids) end)
end

-- Total length of a spec in seconds (latest layer end), for capture tools.
function VFXTimeline.length(spec)
	local n = 0
	for _, L in ipairs(spec.layers) do
		local last = (L.t or 0) + (L.life or 1)
		if L.copies then last += ((L.copies.n or 1) - 1) * (L.copies.every or 0) + (L.copies.jitter or 0) end
		n = math.max(n, last)
	end
	return n
end

--------------------------------------------------------------------------------------------------------------------
-- Dev check (Studio, before every capture): lists authoring mistakes the player would silently ignore, plus the peak
-- numbers the clutter rule needs. Costs nothing unless called.
--   local report, problems, stats = VFXTimeline.check(spec)   -- report = text for the MCP output
-- ERROR = the value never reaches the instance (unknown property, bad enum/colour, unknown texture or palette name).
-- WARN  = valid but almost certainly not meant: an unknown layer key (a typo, or a property put outside `props`), a
--         track this kind ignores, an unknown ease (plays linear), no Transparency anywhere (opaque the whole life,
--         then a hard cut: the classic "a comment swallowed the line" bug), an emit or a key after the layer's life
--         (never reached), an emitter that never emits, no Lifetime (Roblox default 5-10 s), no Texture (default
--         sparkle), more than one light.
-- Stats: length, layers, peak live particles, elongated ones (VelocityParallel / FacingCameraWorldUp / Squash: streaks,
-- flames, bolts) and the bright-white elongated ones among them (needles and streaks laid over the hero shape: the
-- clutter the blind test's reviewers flagged), all at Quality 1 from emit counts x Lifetime,
-- peak active layers, the widest particle in studs (a particle's width is 2 x Size), and every texture id with the
-- layers and LightEmission that use it (check those ids with kit/scripts/texture_traits.py).
local COMMON_KEYS = { id = true, kind = true, t = true, life = true, at = true, rot = true, props = true, tracks = true,
	copies = true, enabled = true, data = true }
local KIND_KEYS = {
	part = { template = true, mesh = true, meshTexture = true, meshScale = true, meshSize = true, size = true,
		pivot = true, spin = true, decal = true },
	beam = { a = true, b = true, axis = true },
	emitter = { box = true, emit = true },
	light = { class = true },
	grade = {},
	custom = { start = true, update = true, stop = true },
}
local KIND_TRACKS = {
	part = { Scale = true, Offset = true, Rot = true, Color = true, Transparency = true, DecalColor = true,
		DecalTransparency = true },
	beam = { A = true, B = true, Width = true, Color = true, Fade = true, CurveSize0 = true, CurveSize1 = true },
	emitter = { Rate = true, Offset = true },
	light = { Brightness = true, Range = true, Color = true },
}
local SPEC_KEYS = { name = true, scale = true, palette = true, textures = true, layers = true }

local function maxOfSeq(v)
	if type(v) == "number" then return v end
	if type(v) ~= "table" then return 0 end
	if #v == 2 and type(v[1]) == "number" and type(v[2]) == "number" then return math.max(v[1], v[2]) end -- range
	local m = 0
	for _, e in ipairs(v) do
		if type(e) == "table" and type(e[2]) == "number" then m = math.max(m, e[2] + (e[3] or 0)) end
	end
	return m
end

local function meanOfRange(v, default)
	if type(v) == "number" then return v end
	if type(v) == "table" and type(v[1]) == "number" then return (v[1] + (v[2] or v[1])) / 2 end
	return default
end

function VFXTimeline.check(spec)
	local problems = {}
	local function add(level, where, msg)
		table.insert(problems, { level = level, where = where, msg = msg })
	end
	if type(spec) ~= "table" or type(spec.layers) ~= "table" then
		return "ERROR spec: not a table with `layers`", { { level = "ERROR", where = "spec", msg = "no layers" } }, {}
	end
	for k in pairs(spec) do
		if not SPEC_KEYS[k] then add("WARN", "spec", "unknown top-level key `" .. tostring(k) .. "` (ignored)") end
	end
	local ctx = { name = spec.name or "Effect", scale = spec.scale or 1, palette = spec.palette or {},
		textures = spec.textures or {}, warned = {} }
	for name, v in pairs(ctx.textures) do
		if type(v) ~= "number" and not (type(v) == "string" and (string.match(v, "^%d+$") or string.find(v, "://"))) then
			add("ERROR", "textures." .. tostring(name), "not an asset id: " .. tostring(v))
		end
	end
	local scratch = {
		part = Instance.new("Part"), beam = Instance.new("Beam"), emitter = Instance.new("ParticleEmitter"),
		light = { PointLight = Instance.new("PointLight"), SpotLight = Instance.new("SpotLight"),
			SurfaceLight = Instance.new("SurfaceLight") },
		grade = Instance.new("ColorCorrectionEffect"), decal = Instance.new("Decal"),
	}
	local seenIds, lights, textures = {}, 0, {}
	local bursts, spans = {}, {} -- particle bursts {t, n, over, life, streak, white}; layer spans {from, to}
	local widest, widestId = 0, nil
	local length = VFXTimeline.length(spec)

	for index, L in ipairs(spec.layers) do
		local id = tostring(L.id or ("#" .. index))
		local where = "layer " .. id
		local kind = L.kind
		if L.id == nil then add("WARN", where, "no id (reviews and warnings can't name it)") end
		if seenIds[id] then add("WARN", where, "duplicate id") end
		seenIds[id] = true
		if not KIND[kind] then
			add("ERROR", where, "unknown kind `" .. tostring(kind) .. "`")
			continue
		end
		if L.enabled == false then continue end
		for k in pairs(L) do
			if not COMMON_KEYS[k] and not KIND_KEYS[kind][k] then
				local other
				for kk, keys in pairs(KIND_KEYS) do if keys[k] then other = kk end end
				add("WARN", where, "key `" .. tostring(k) .. "` is ignored" ..
					(if other then " (it belongs to kind " .. other .. ")" else " (typo, or a property that belongs in props?)"))
			end
		end
		local life = L.life or 1
		local props, tracks = L.props or {}, L.tracks or {}
		-- props: set each on a scratch instance of the same class
		local inst = scratch[kind]
		if kind == "light" then inst = scratch.light[L.class or "PointLight"] or scratch.light.PointLight end
		local tplClone
		if kind == "part" and L.template then
			local folder = assetFolder()
			local tpl = folder and folder:FindFirstChild(L.template, true)
			if tpl then
				tplClone = tpl:Clone()
				inst = tplClone
			else
				add("WARN", where, "template `" .. tostring(L.template) .. "` not found (VFXTimeline.Assets / ReplicatedStorage.VFXAssets): props not checked")
				inst = nil
			end
		end
		if typeof(inst) == "Instance" then
			for prop, v in pairs(props) do
				if (prop == "Texture" or prop == "TextureId") and type(v) == "string" and not ctx.textures[v]
					and not string.match(v, "^%d+$") and not string.find(v, "://") then
					add("ERROR", where, prop .. " `" .. v .. "` is not in `textures`")
				else
					local ok, err = pcall(function() inst[prop] = convert(inst, prop, v, ctx) end)
					if not ok then add("ERROR", where, "props." .. tostring(prop) .. ": " .. tostring(err)) end
				end
			end
		end
		if tplClone then tplClone:Destroy() end
		if L.decal then
			for prop, v in pairs(L.decal) do
				local ok, err = pcall(function() scratch.decal[prop] = convert(scratch.decal, prop, v, ctx) end)
				if not ok then add("ERROR", where, "decal." .. tostring(prop) .. ": " .. tostring(err)) end
			end
		end
		-- tracks
		for prop, keys in pairs(tracks) do
			local known = KIND_TRACKS[kind]
			if kind == "grade" then
				local ok = pcall(function() return scratch.grade[prop] end)
				if not ok then add("WARN", where, "track `" .. tostring(prop) .. "` is not a ColorCorrection property") end
			elseif known and not known[prop] then
				add("WARN", where, "track `" .. tostring(prop) .. "` is ignored by kind " .. kind ..
					(if kind == "emitter" and (prop == "Transparency" or prop == "Size" or prop == "Color")
						then " (particles take Transparency/Size/Color as sequences over each particle's life in props)" else ""))
			end
			if type(keys) ~= "table" or #keys == 0 then
				add("ERROR", where, "track `" .. tostring(prop) .. "` has no keys")
				continue
			end
			for _, key in ipairs(keys) do
				if type(key[1]) ~= "number" then
					add("ERROR", where, "track `" .. tostring(prop) .. "`: a key has no time")
				elseif key[1] > life + 1e-6 then
					add("WARN", where, string.format("track `%s`: key at %.2f s is after the layer's life %.2f s (never reached)",
						prop, key[1], life))
				end
				if key[3] ~= nil and not EASE[key[3]] then
					add("WARN", where, "track `" .. tostring(prop) .. "`: unknown ease `" .. tostring(key[3]) .. "` (plays linear)")
				end
			end
			local trackKind = if COLOR_TRACKS[prop] then "color" elseif VECTOR_TRACKS[prop] then "vector"
				elseif prop == "Scale" then "vectorOrNumber" else nil
			local ok, err = pcall(prepTrack, keys, ctx, trackKind)
			if not ok then add("ERROR", where, "track `" .. tostring(prop) .. "`: " .. tostring(err)) end
		end
		-- fades: opaque the whole life, then gone in one frame
		if kind == "emitter" and props.Transparency == nil then
			add("WARN", where, "no Transparency: particles are fully opaque their whole life, then pop out")
		elseif kind == "beam" and props.Transparency == nil and not tracks.Fade then
			add("WARN", where, "no Transparency or Fade: fully opaque, then a hard cut at the end")
		elseif kind == "part" and not L.template and props.Transparency == nil and not tracks.Transparency then
			add("WARN", where, "no Transparency (props or track): fully opaque, then a hard cut at the end")
		end
		if kind == "part" and not L.template and props.Color == nil and not tracks.Color then
			add("WARN", where, "no Color: a new Part is grey")
		end
		-- emitters
		if kind == "emitter" then
			if props.Lifetime == nil then add("WARN", where, "no Lifetime: Roblox's default 5-10 s") end
			if props.Texture == nil then add("WARN", where, "no Texture: Roblox's default sparkle") end
			local emits = L.emit or {}
			if #emits == 0 and not tracks.Rate and not (type(props.Rate) == "number" and props.Rate > 0) then
				add("WARN", where, "never emits (no emit list, Rate or Rate track)")
			end
			for _, e in ipairs(emits) do
				if type(e[1]) ~= "number" or type(e[2]) ~= "number" then
					add("ERROR", where, "emit entries are {t, count[, over]}")
				elseif e[1] > life + 1e-6 then
					add("WARN", where, string.format("emit at %.2f s is after the layer's life %.2f s (never fires)", e[1], life))
				end
			end
			local w = 2 * maxOfSeq(props.Size or 1) * ctx.scale
			if w > widest then widest, widestId = w, id end
		end
		if kind == "light" then lights += 1 end
		-- spans, bursts, textures (per copy)
		local copies = L.copies or { n = 1 }
		local plife = meanOfRange(props.Lifetime, 7.5)
		local streak = props.Orientation == "VelocityParallel" or props.Orientation == "FacingCameraWorldUp"
			or (props.Squash ~= nil and maxOfSeq(props.Squash) ~= 0)
		local white = false
		if streak and props.Brightness ~= 0 then
			local c0 = props.Color
			if type(c0) == "table" and not isVec(c0) and type(c0[1]) == "table" then c0 = c0[1][2] end
			local ok, c = pcall(color, c0 or "#FFFFFF", ctx)
			white = ok and (0.299 * c.R + 0.587 * c.G + 0.114 * c.B) > 0.9 -- near white (pale yellow flames do not count)
		end
		for i = 1, copies.n or 1 do
			local t0 = (L.t or 0) + (i - 1) * (copies.every or 0)
			table.insert(spans, { t0, t0 + life })
			if kind == "emitter" then
				for _, e in ipairs(L.emit or {}) do
					if type(e[1]) == "number" and type(e[2]) == "number" and e[1] <= life + 1e-6 then
						table.insert(bursts, { t = t0 + e[1], n = e[2], over = e[3] or 0, life = plife, streak = streak, white = white })
					end
				end
				if type(props.Rate) == "number" and props.Rate > 0 and not tracks.Rate then
					for s = 0, life, 0.05 do
						table.insert(bursts, { t = t0 + s, n = props.Rate * 0.05, over = 0, life = plife, streak = streak, white = white })
					end
				end
				if tracks.Rate then
					local keys = tracks.Rate
					for s = 0, life, 0.05 do -- a Rate track as 0.05 s bursts
						local r = 0
						for k = 1, #keys do
							if keys[k][1] <= s then r = keys[k][2] end
						end
						if type(r) == "number" and r > 0 then
							table.insert(bursts, { t = t0 + s, n = r * 0.05, over = 0, life = plife, streak = streak, white = white })
						end
					end
				end
			end
		end
		local tex = props.Texture or props.TextureId or L.meshTexture or (L.decal and L.decal.Texture)
		if tex ~= nil then
			local key = tostring(if type(tex) == "string" and ctx.textures[tex] then ctx.textures[tex] else tex)
			textures[key] = textures[key] or {}
			local le = props.LightEmission
			table.insert(textures[key], id .. (if kind == "emitter" or kind == "beam"
				then " LE " .. (if le == nil then "0" else tostring(le)) else ""))
		end
	end
	if lights > 1 then add("WARN", "spec", lights .. " lights (one per effect is the budget)") end

	-- peaks on a 0.05 s grid
	local horizon = length
	for _, b in ipairs(bursts) do horizon = math.max(horizon, b.t + b.over + b.life) end
	local peakP, peakPT, peakS, peakST, peakL, peakLT, peakW, peakWT = 0, 0, 0, 0, 0, 0, 0, 0
	for tau = 0, horizon, 0.05 do
		local p, s, l, w = 0, 0, 0, 0
		for _, b in ipairs(bursts) do
			if tau >= b.t then
				-- born evenly over [t, t + over]; each dies `life` after its birth
				local born = if b.over > 0 then b.n * math.clamp((tau - b.t) / b.over, 0, 1) else b.n
				local dead = if b.over > 0 then b.n * math.clamp((tau - b.life - b.t) / b.over, 0, 1)
					elseif tau - b.t >= b.life then b.n else 0
				local alive = born - dead
				p += alive
				if b.streak then s += alive end
				if b.white then w += alive end
			end
		end
		for _, sp in ipairs(spans) do
			if tau >= sp[1] and tau < sp[2] then l += 1 end
		end
		if p > peakP then peakP, peakPT = p, tau end
		if s > peakS then peakS, peakST = s, tau end
		if w > peakW then peakW, peakWT = w, tau end
		if l > peakL then peakL, peakLT = l, tau end
	end
	for _, inst in pairs(scratch) do
		if typeof(inst) == "Instance" then inst:Destroy() else for _, x in pairs(inst) do x:Destroy() end end
	end

	local order = { ERROR = 1, WARN = 2 }
	table.sort(problems, function(a, b)
		if order[a.level] ~= order[b.level] then return order[a.level] < order[b.level] end
		return a.where < b.where
	end)
	local stats = {
		length = length, layers = #spec.layers, peakParticles = math.floor(peakP + 0.5), peakParticlesAt = peakPT,
		peakStreaks = math.floor(peakS + 0.5), peakStreaksAt = peakST,
		peakWhiteStreaks = math.floor(peakW + 0.5), peakWhiteStreaksAt = peakWT, peakLayers = peakL, peakLayersAt = peakLT,
		widestParticle = widest, widestParticleLayer = widestId, lights = lights, textures = textures,
	}
	local lines = {}
	for _, p in ipairs(problems) do table.insert(lines, p.level .. " " .. p.where .. ": " .. p.msg) end
	local nErr, nWarn = 0, 0
	for _, p in ipairs(problems) do if p.level == "ERROR" then nErr += 1 else nWarn += 1 end end
	table.insert(lines, string.format("%s: %d errors, %d warnings | %.2f s, %d layers | peak %d particles at %.2f s "
		.. "(%d elongated at %.2f s, %d of them bright white at %.2f s), %d layers active at %.2f s | widest particle "
		.. "%.1f studs (%s) | %d light(s)",
		ctx.name, nErr, nWarn, length, #spec.layers, stats.peakParticles, peakPT, stats.peakStreaks, peakST,
		stats.peakWhiteStreaks, peakWT, peakL, peakLT, widest, tostring(widestId), lights))
	local ids = {}
	for k, v in pairs(textures) do table.insert(ids, k .. " (" .. table.concat(v, ", ") .. ")") end
	table.sort(ids)
	table.insert(lines, "textures: " .. table.concat(ids, "; "))
	return table.concat(lines, "\n"), problems, stats
end

return VFXTimeline
