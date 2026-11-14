-- Dev-only player for OPEN-SOURCE effects cut out with kit/scripts/rbxcut.py (skill vfxmith), so they can be
-- watched and captured in Studio EDIT mode without running any of their scripts. Lives next to VFXCapture in
-- ServerStorage.VFXDev. Files are read from Studio's local content folder (rbxasset://vfxlib/<name>.rbxmx): no upload.
--
--   local P = require(game.ServerStorage.VFXDev.VFXLibPlayer:Clone())
--   P.stage("grey")                       -- flat mid-grey box: dark ink and additive glow both read ("void" = black)
--   P.load("burst")                       -- caches the template (scripts stripped again, defensively)
--   P.frame()                             -- camera framed from the effect's own sizes/speeds; returns the radius
--   P.play()                              -- one real-time play (video)
--   return P.stills({ times = {...}, hold = 2.2, lead = 6 })   -- same protocol as VFXCapture.stills / stills.py
--   P.clear()
--
-- How effects are driven: knowledge/os-conventions.md, reimplemented here in our own code (driver v2):
--   particles  EmitCount/EmitDelay/EmitDuration (+ TimeScale_* ramps); no attributes: running ones keep running,
--              disabled ones Emit(1) once (they were script-driven)
--   beams      Forge set (EffectDuration, Width*/CurveSize*/Length_Texture*/Speed_Texture*/Transparency_Scale* with
--              bezier curves, Speed_* playback rate), legacy Width0/Duration, generic EmitDelay/EmitDuration
--   Models     {Start, End}: Forge mesh (copies tween offset/size/scale/transparency/decals/flipbooks, spin applied
--              twice, spread, nested children emitted inside each copy with delays added) or TweenParams/EasyMesh;
--              spin Models (SpinRotation, Scale_*). Templates are hidden at spawn.
--   One clock per play with seeded rolls: freeze() stops it, so a still holds exactly effect time t.
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local P = {}
_G.__VFXLib = _G.__VFXLib or {}
local S = _G.__VFXLib
P.Origin = Vector3.new(0, 3000, 0)

local function block(parent, size, cf, color, neon)
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
	p.Material = if neon then Enum.Material.Neon else Enum.Material.SmoothPlastic
	p.Color = color
	p.Size = size
	p.CFrame = cf
	p.Parent = parent
	return p
end

function P.stage(kind)
	local old = Workspace:FindFirstChild("VFXStage")
	if old then old:Destroy() end
	local folder = Instance.new("Folder")
	folder.Name = "VFXStage"
	local o, R = P.Origin, 400
	local col = if kind == "void" then Color3.new(0, 0, 0) else Color3.fromRGB(38, 38, 44)
	block(folder, Vector3.new(2 * R, 2, 2 * R), CFrame.new(o - Vector3.new(0, 1, 0)), col, true)
	block(folder, Vector3.new(2 * R, 2, 2 * R), CFrame.new(o + Vector3.new(0, R, 0)), col, true)
	for _, z in ipairs({ -R, R }) do
		block(folder, Vector3.new(2 * R, 2 * R, 2), CFrame.new(o + Vector3.new(0, R / 2, z)), col, true)
	end
	for _, x in ipairs({ -R, R }) do
		block(folder, Vector3.new(2, 2 * R, 2 * R), CFrame.new(o + Vector3.new(x, R / 2, 0)), col, true)
	end
	folder.Parent = Workspace
	return "stage " .. tostring(kind)
end

local function strip(root)
	local n = 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("LuaSourceContainer") then
			d:Destroy()
			n += 1
		end
	end
	return n
end

-- Loads rbxasset://vfxlib/<name>.rbxmx (written by rbxcut.py) and keeps it as the template.
function P.load(name)
	local objs = game:GetObjects("rbxasset://vfxlib/" .. name .. ".rbxmx")
	local root = objs[1]
	assert(root, "nothing in " .. name)
	if root:IsA("LuaSourceContainer") then error("root is a script") end
	local stripped = strip(root)
	S.template = root
	S.name = name
	local counts = { emitters = 0, beams = 0, trails = 0, parts = 0 }
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("ParticleEmitter") then counts.emitters += 1
		elseif d:IsA("Beam") then counts.beams += 1
		elseif d:IsA("Trail") then counts.trails += 1
		elseif d:IsA("BasePart") then counts.parts += 1 end
	end
	return HttpService:JSONEncode({ root = root.ClassName, name = root.Name, stripped = stripped, n = counts })
end

-- Builds a fresh instance of the template on the stage: a Model "VFX_Lib" pivoted so the effect's own pivot sits
-- at the origin (rotation kept, so the authored "up" stays up).
local function spawnEffect(origin)
	local old = Workspace:FindFirstChild("VFX_Lib")
	if old then old:Destroy() end
	local model = Instance.new("Model")
	model.Name = "VFX_Lib"
	local inst = S.template:Clone()
	local carrier
	if inst:IsA("Attachment") or inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail") then
		carrier = Instance.new("Part")
		carrier.Name = "Carrier"
		carrier.Transparency, carrier.Size = 1, Vector3.one * 0.2
		carrier.CFrame = if inst:IsA("Attachment") then inst.WorldCFrame else CFrame.new()
		carrier.Parent = model
		inst.Parent = carrier
		if inst:IsA("Attachment") then inst.CFrame = CFrame.new() end
	else
		inst.Parent = model
	end
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Anchored, d.CanCollide, d.CanQuery, d.CanTouch, d.CastShadow = true, false, false, false, false
		end
	end
	local pivot
	if inst:IsA("BasePart") then
		pivot = inst.CFrame
	elseif inst:IsA("Model") and inst.PrimaryPart then
		pivot = inst.PrimaryPart.CFrame
	else
		local ok, cf = pcall(function() return model:GetBoundingBox() end)
		pivot = if ok then cf else CFrame.new()
	end
	local rot = pivot - pivot.Position
	model.WorldPivot = pivot
	model:PivotTo(CFrame.new(origin) * rot)
	-- Place by the layers, not the bounding box: the median emitter/beam carrier goes over the origin and the lowest
	-- (10th percentile) one onto the floor, so nothing authored below the model's centre ends up under the stage.
	local xs, ys, zs = {}, {}, {}
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
			local c = d.Parent
			local p = if c and c:IsA("Attachment") then c.WorldPosition elseif c and c:IsA("BasePart") then c.Position else nil
			if d:IsA("Beam") and d.Attachment0 then p = d.Attachment0.WorldPosition end
			if p then table.insert(xs, p.X); table.insert(ys, p.Y); table.insert(zs, p.Z) end
		end
	end
	if #xs > 0 then
		table.sort(xs); table.sort(ys); table.sort(zs)
		local mid = math.floor(#xs / 2) + 1
		local low = ys[math.max(1, math.floor(#ys * 0.1 + 0.5))]
		local shift = origin - Vector3.new(xs[mid], low, zs[mid])
		model:PivotTo(model:GetPivot() + shift)
	end
	model.Parent = Workspace
	return model
end

local function num(x, d)
	return if type(x) == "number" then x else d
end

local function seqMax(seq)
	local m = 0
	for _, k in ipairs(seq.Keypoints) do m = math.max(m, k.Value + k.Envelope) end
	return m
end

-- Rough radius of what the effect covers, from the template (75th percentile of layer reaches).
function P.radius()
	local model = spawnEffect(P.Origin)
	local reach = {}
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("ParticleEmitter") then
			local pos = if d.Parent:IsA("Attachment") then d.Parent.WorldPosition elseif d.Parent:IsA("BasePart") then d.Parent.Position else P.Origin
			local life = d.Lifetime.Max
			local v = d.Speed.Max
			local travel = if d.Drag > 0 then v / d.Drag * (1 - math.exp(-d.Drag * life)) else v * life
			travel += 0.5 * d.Acceleration.Magnitude * life * life
			table.insert(reach, (pos - P.Origin).Magnitude + math.min(travel, 150) + seqMax(d.Size) / 2)
		elseif d:IsA("Beam") and d.Attachment0 and d.Attachment1 then
			table.insert(reach, math.max((d.Attachment0.WorldPosition - P.Origin).Magnitude, (d.Attachment1.WorldPosition - P.Origin).Magnitude))
		elseif d:IsA("BasePart") and d.Transparency < 1 then
			table.insert(reach, (d.Position - P.Origin).Magnitude + d.Size.Magnitude / 2)
		end
	end
	model:Destroy()
	table.sort(reach)
	if #reach == 0 then return 10 end
	local r = reach[math.max(1, math.ceil(#reach * 0.6))]
	return math.clamp(r, 3, 120)
end

-- Camera. A view is {look = Vector3 (offset from the origin), dist, yaw (deg), pitch (height/dist)}; the camera is
-- LOCKED to it every frame while capturing (S.lockCam), so nothing (a click, an MCP screenshot, a plugin) can move it.
local function viewCFrame(v)
	local yaw = math.rad(v.yaw or 25)
	local look = P.Origin + (v.look or Vector3.zero)
	local d = v.dist
	local pos = look + Vector3.new(math.sin(yaw) * d, d * (v.pitch or 0.25), -math.cos(yaw) * d)
	return CFrame.lookAt(pos, look)
end

local function applyView(v)
	local cam = Workspace.CurrentCamera
	if not S.savedCamera then S.savedCamera = { cam.CFrame, cam.FieldOfView } end
	S.view = v
	S.viewCF = viewCFrame(v)
	S.viewFocus = CFrame.new(P.Origin + (v.look or Vector3.zero))
	cam.FieldOfView = 70
	cam.CFrame = S.viewCF
	cam.Focus = S.viewFocus -- Studio's edit camera re-aims at Focus: it must be the look point, or the view swings away
	if not S.camConn then
		S.camConn = game:GetService("RunService").Heartbeat:Connect(function()
			if S.lockCam and S.viewCF then
				local c = Workspace.CurrentCamera
				if c.CFrame ~= S.viewCF then c.CFrame = S.viewCF end
				if S.viewFocus and c.Focus ~= S.viewFocus then c.Focus = S.viewFocus end
				if c.FieldOfView ~= 70 then c.FieldOfView = 70 end
			end
		end)
	end
end

-- Default view from the estimated radius (used until calibrate() has measured the effect on screen).
function P.defaultView(r)
	return { look = Vector3.new(0, r * 0.3, 0), dist = r / math.tan(math.rad(35)) * 1.1, yaw = 25, pitch = 0.25 }
end

function P.frame(o)
	o = o or {}
	local r = o.radius or P.radius()
	applyView(o.view or P.defaultView(r))
	S.radius = r
	return r
end

-- Re-aim a view from what a capture showed: (cx, cy) = centre of the effect's box in the viewport (0..1, from the
-- top-left), h / w = its height / width as fractions of the viewport. Moves the look point onto that centre and sets the
-- distance so the effect fills `fill` of the height (or 0.8 of the width, whichever is tighter).
function P.calibrate(name, m, fill)
	local lib = S.lib[name]
	local v = lib.view or P.defaultView(lib.radius)
	local cf = viewCFrame(v)
	local cam = Workspace.CurrentCamera
	local vp = cam.ViewportSize
	local halfH = math.tan(math.rad(35)) * v.dist -- world half-height of the view at the look point
	local halfW = halfH * vp.X / vp.Y
	-- capped steps: a measurement can mistake a glow for the effect, so move at most part of the way and re-measure
	local dx = math.clamp((m.cx - 0.5) * 2 * halfW, -0.6 * halfW, 0.6 * halfW)
	local dy = math.clamp((0.5 - m.cy) * 2 * halfH, -0.6 * halfH, 0.6 * halfH)
	local look = (v.look or Vector3.zero) + cf.RightVector * dx + cf.UpVector * dy
	local f = math.clamp(math.max(m.h / (fill or 0.55), m.w / 0.8), 0.3, 2.5)
	if m.edge then f = math.max(f, 1.4) end -- cut off by the frame: its real size is bigger than measured
	lib.view = { look = look, dist = math.clamp(v.dist * f, 2, 900), yaw = v.yaw, pitch = v.pitch }
	return lib.view.dist
end

-- ===================================================================================== driver v2
-- Reimplements the attribute conventions in knowledge/os-conventions.md (own code, written from that description;
-- no shipped runtime is used). One clock per play: freeze() stops it, so a still holds exactly effect time t.

-- Curves (os-conventions 1.2): 24 bytes per anchor, f32 LE (anchor, out handle, next in handle), y = 1 - value.
local curveCache = {}
local OUT_CUBIC = { { 0, 1, 0.215, 0.39, 0.355, 0, 1, 0 } }
local LINEAR = { { 0, 1, 0, 1, 1, 0, 1, 0 } }
local function decodeCurve(s)
	if type(s) ~= "string" or #s < 48 or #s % 24 ~= 0 then return nil end
	local c = curveCache[s]
	if c then return c end
	local b = buffer.fromstring(s)
	local n = #s // 24
	local segs = {}
	for i = 0, n - 2 do
		local o = i * 24
		table.insert(segs, {
			buffer.readf32(b, o), buffer.readf32(b, o + 4), buffer.readf32(b, o + 8), buffer.readf32(b, o + 12),
			buffer.readf32(b, o + 16), buffer.readf32(b, o + 20), buffer.readf32(b, o + 24), buffer.readf32(b, o + 28),
		})
	end
	curveCache[s] = segs
	return segs
end
local function bz(a, b, c, d, u)
	local v = 1 - u
	return v * v * v * a + 3 * v * v * u * b + 3 * v * u * u * c + u * u * u * d
end
local function dbz(a, b, c, d, u)
	local v = 1 - u
	return 3 * v * v * (b - a) + 6 * v * u * (c - b) + 3 * u * u * (d - c)
end
local function ease(segs, t)
	t = math.clamp(t, 0, 1)
	local s = segs[#segs]
	for _, g in ipairs(segs) do
		if t >= g[1] and t < g[7] then s = g break end
	end
	local u = if s[7] > s[1] then math.clamp((t - s[1]) / (s[7] - s[1]), 0, 1) else 1
	for _ = 1, 5 do
		local dx = dbz(s[1], s[3], s[5], s[7], u)
		if dx == 0 then break end
		local step = (bz(s[1], s[3], s[5], s[7], u) - t) / dx
		u = math.clamp(u - step, 0, 1)
		if math.abs(step) < 0.001 then break end
	end
	return 1 - bz(s[2], s[4], s[6], s[8], u)
end
local function curveOf(inst, name, default)
	return decodeCurve(inst:GetAttribute(name)) or default or OUT_CUBIC
end

local function num(x, d)
	if type(x) == "number" then return x end
	if type(x) == "string" then return tonumber(x) or d end
	return d
end
local function roll(rng, v, d)
	if typeof(v) == "NumberRange" then return v.Min + (v.Max - v.Min) * rng:NextNumber() end
	return num(v, d)
end
local function lerp(a, b, t) return a + (b - a) * t end

local function hideTemplate(p)
	for _, d in ipairs(p:GetDescendants()) do
		if d:IsA("BasePart") then d.Transparency = 1
		elseif d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1
		elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") or d:IsA("Light") then d.Enabled = false end
	end
	if p:IsA("BasePart") then p.Transparency = 1 end
end

local function isStartEnd(m)
	local a, b = m:FindFirstChild("Start"), m:FindFirstChild("End")
	return m:IsA("Model") and a and b and a:IsA("BasePart") and b:IsA("BasePart")
end
local FORGE_MESH_KEYS = { "EffectDuration", "Part_CFrame_Curve", "Part_Size_Curve", "Part_Transparency_Start",
	"Part_Transparency_End", "Part_RotSpeed_Start", "Part_RotSpeed_End", "Speed_Start", "Speed_End", "SpreadAngle",
	"MinInitRot", "MaxInitRot", "RotAroundOrigin", "Mesh_Scale_Curve", "EmitCount" }
local function meshKind(m)
	for _, k in ipairs(FORGE_MESH_KEYS) do
		if m:GetAttribute(k) ~= nil then return "forge" end
	end
	if m:GetAttribute("Part_TweenParams") or m:GetAttribute("Mesh_TweenParams") or m:GetAttribute("Decal_TweenParams")
		or m:GetAttribute("_EasyMeshEmitData") then return "tween" end
	return "forge" -- legacy: out-cubic over Duration
end

local function drive(model, seed)
	local rng = Random.new(seed or 7)
	local clock, frozen = 0, false
	local timed, jobs = {}, {}
	local emitters, beams = {}, {}
	local tpl = {}
	local scratch = Instance.new("Folder")
	scratch.Name = "Copies"
	scratch.Parent = model

	local function at(t, f) table.insert(timed, { t = t, f = f }) end
	local function job(f) table.insert(jobs, f) end

	-- playback-rate ramp (os-conventions 1.4): returns a function(dt) -> scaled dt, or nil when the effect is over
	local function speedRamp(inst)
		local s0, s1 = num(inst:GetAttribute("Speed_Start"), 1), num(inst:GetAttribute("Speed_End"), 1)
		if s0 == 1 and s1 == 1 then return function(dt) return dt end end
		local dur = num(inst:GetAttribute("Speed_Duration"), 0.1)
		local cv = curveOf(inst, "Speed_Curve")
		local real = 0
		return function(dt)
			real += dt
			local sp = lerp(s0, s1, ease(cv, if dur > 0 then real / dur else 1))
			if s1 == 0 and real >= dur then return nil end
			return dt * math.max(sp, 0)
		end
	end

	local walk

	local function particle(e, t0)
		local count = num(e:GetAttribute("EmitCount"), nil)
		local d = t0 + num(e:GetAttribute("EmitDelay"), 0)
		local dur = num(e:GetAttribute("EmitDuration"), 0)
		local wasOn = e.Enabled
		e.Enabled = false
		table.insert(emitters, e)
		e:SetAttribute("__TS", e.TimeScale)
		if count then
			local ts0, ts1 = e:GetAttribute("TimeScale_Start"), e:GetAttribute("TimeScale_End")
			at(d, function()
				if type(ts0) == "number" and type(ts1) == "number" and ts0 ~= ts1 then
					local td, cv, c = num(e:GetAttribute("TimeScale_Duration"), 0.1), curveOf(e, "TimeScale_Curve"), 0
					job(function(dt)
						c += dt
						e.TimeScale = lerp(ts0, ts1, math.clamp(ease(cv, c / math.max(td, 1e-3)), 0, 1))
						return c >= td
					end)
				elseif type(ts0) == "number" then
					e.TimeScale = ts0
				end
				if dur > 0 then e.Enabled = true end
				local n = math.floor(count)
				if n < 1 and count > 0 then n = 1 end
				if n > 0 then e:Emit(n) end
			end)
			if dur > 0 then
				at(d + dur, function() e.Enabled = false end)
			elseif count <= 0 and e.Rate > 0 then
				-- EmitCount 0 + a Rate: the effect streamed while its own script had it on; show 0.6 s of stream
				at(d, function() e.Enabled = true end)
				at(d + 0.6, function() e.Enabled = false end)
			end
		elseif wasOn and e.Rate > 0 then
			at(d, function() e.Enabled = true end) -- no emit attributes: a running emitter keeps running
		else
			at(d, function() e:Emit(1) end) -- script-driven originally: show the layer once
		end
	end

	local function beam(b, t0)
		table.insert(beams, b)
		local A = function(k) return b:GetAttribute(k) end
		local d = t0 + num(A("EmitDelay"), 0)
		local forge = false
		for _, k in ipairs({ "EffectDuration", "Width0_Start", "Width0_End", "Width1_Start", "Width1_End",
			"Transparency_Scale_Start", "Transparency_Scale_End", "CurveSize0_Start", "Speed_Texture_Start",
			"Length_Texture_Start" }) do
			if A(k) ~= nil then forge = true break end
		end
		local legacyDur = num(A("Duration"), nil)
		if not forge and legacyDur and legacyDur > 0 and (A("Width0") ~= nil or A("Width1") ~= nil) then forge = true end
		if forge then
			local life = roll(rng, A("EffectDuration"), legacyDur or 1)
			local w0s = num(A("Width0_Start"), num(A("StartWidth0"), b.Width0))
			local w0e = num(A("Width0_End"), num(A("Width0"), b.Width0))
			local w1s = num(A("Width1_Start"), num(A("StartWidth1"), b.Width1))
			local w1e = num(A("Width1_End"), num(A("Width1"), b.Width1))
			local c0s, c0e = num(A("CurveSize0_Start"), b.CurveSize0), num(A("CurveSize0_End"), b.CurveSize0)
			local c1s, c1e = num(A("CurveSize1_Start"), b.CurveSize1), num(A("CurveSize1_End"), b.CurveSize1)
			local ls, le = num(A("Length_Texture_Start"), b.TextureLength), num(A("Length_Texture_End"), b.TextureLength)
			local ss, se = num(A("Speed_Texture_Start"), b.TextureSpeed), num(A("Speed_Texture_End"), b.TextureSpeed)
			local ts0 = num(A("Transparency_Scale_Start"), 1)
			local ts1 = num(A("Transparency_Scale_End"), num(A("EndTransparencyScale"), 1))
			local base = b.Transparency
			local cw0, cw1 = curveOf(b, "Width0_Curve"), curveOf(b, "Width1_Curve")
			local cc0, cc1 = curveOf(b, "CurveSize0_Curve"), curveOf(b, "CurveSize1_Curve")
			local ctr, clen, cspd = curveOf(b, "Transparency_Scale_Curve"), curveOf(b, "Length_Texture_Curve"), curveOf(b, "Speed_Texture_Curve")
			local function scaleT(s)
				local ks = {}
				for _, k in ipairs(base.Keypoints) do
					local v = if s <= 1 then k.Value * s else k.Value + (1 - k.Value) * (s - 1)
					table.insert(ks, NumberSequenceKeypoint.new(k.Time, math.clamp(v, 0, 1), k.Envelope))
				end
				return NumberSequence.new(ks)
			end
			b.Enabled = false
			at(d, function()
				b.Enabled = true
				local step = speedRamp(b)
				local c = 0
				local function apply()
					local t = if life > 0 then c / life else 1
					b.Width0 = lerp(w0s, w0e, ease(cw0, t))
					b.Width1 = lerp(w1s, w1e, ease(cw1, t))
					if c0s ~= c0e then b.CurveSize0 = lerp(c0s, c0e, ease(cc0, t)) end
					if c1s ~= c1e then b.CurveSize1 = lerp(c1s, c1e, ease(cc1, t)) end
					if ls ~= le then b.TextureLength = lerp(ls, le, ease(clen, t)) end
					if ss ~= se then b.TextureSpeed = lerp(ss, se, ease(cspd, t)) end
					if ts0 ~= ts1 then b.Transparency = scaleT(lerp(ts0, ts1, ease(ctr, t)))
					elseif ts0 ~= 1 then b.Transparency = scaleT(ts0) end
				end
				walk(b, clock)
				job(function(dt)
					local sdt = step(dt)
					if sdt == nil then b.Enabled = false return true end
					c = math.min(c + sdt, life)
					apply()
					if c >= life then b.Enabled = false return true end
					return false
				end)
			end)
		elseif A("EmitDelay") ~= nil or A("EmitDuration") ~= nil then
			local dur = num(A("EmitDuration"), 0)
			local wasOn = b.Enabled
			b.Enabled = false
			at(d, function() b.Enabled = true end)
			if dur > 0 then at(d + dur, function() b.Enabled = false end)
			elseif not wasOn then at(d + 0.05, function() b.Enabled = false end) end
		end -- no attributes / legacy Duration 0: authored state for the whole play
	end

	local function nearestAttachment(inst)
		local p = inst.Parent
		while p and p ~= model do
			if p:IsA("Attachment") then return p end
			p = p.Parent
		end
		return nil
	end

	local function forgeMesh(m, t0)
		local A = function(k) return m:GetAttribute(k) end
		local startP, endP = m.Start, m.End
		local count = math.max(1, math.floor(num(A("EmitCount"), 1)))
		local d = t0 + num(A("EmitDelay"), 0)
		local hasDecal = startP:FindFirstChildWhichIsA("Decal") ~= nil
		local legacyDur = num(A("Duration"), 1)
		local minR, maxR = A("MinInitRot"), A("MaxInitRot")
		minR = if typeof(minR) == "Vector3" then minR else Vector3.zero
		maxR = if typeof(maxR) == "Vector3" then maxR else Vector3.zero
		local spread = A("SpreadAngle")
		spread = if typeof(spread) == "Vector3" then spread else Vector3.zero
		local pt0 = num(A("Part_Transparency_Start"), num(A("Mesh_StartTransparency"), if hasDecal then 1 else 0))
		local pt1 = num(A("Part_Transparency_End"), num(A("Mesh_EndTransparency"), if hasDecal then 1 else 0))
		local around = A("RotAroundOrigin") == true
		local destroyDelay = num(A("DestroyDelay"), 0)
		local cCF, cSize, cMesh = curveOf(m, "Part_CFrame_Curve"), curveOf(m, "Part_Size_Curve"), curveOf(m, "Mesh_Scale_Curve")
		local cTr, cRot = curveOf(m, "Part_Transparency_Curve"), curveOf(m, "Part_RotSpeed_Curve")
		local att = nearestAttachment(m)
		for _ = 1, count do
			local life = roll(rng, A("EffectDuration"), legacyDur)
			local rs0, rs1 = roll(rng, A("Part_RotSpeed_Start"), 0), roll(rng, A("Part_RotSpeed_End"), 0)
			local init = Vector3.new(lerp(minR.X, maxR.X, rng:NextNumber()), lerp(minR.Y, maxR.Y, rng:NextNumber()), lerp(minR.Z, maxR.Z, rng:NextNumber()))
			local sign = Vector3.new(math.sign(init.X), math.sign(init.Y), math.sign(init.Z))
			local sp = CFrame.Angles(math.rad((rng:NextNumber() * 2 - 1) * spread.X), math.rad((rng:NextNumber() * 2 - 1) * spread.Y), 0)
			at(d, function()
				local origin = if att then att.WorldCFrame else startP.CFrame
				local full = startP.CFrame:Inverse() * endP.CFrame
				local copy = tpl[m]:Clone()
				copy.Anchored, copy.CanCollide, copy.CanQuery, copy.CanTouch = true, false, false, false
				local sm0, sm1 = startP:FindFirstChildWhichIsA("SpecialMesh"), endP:FindFirstChildWhichIsA("SpecialMesh")
				local cm = copy:FindFirstChildWhichIsA("SpecialMesh")
				local decals = {}
				for _, dc in ipairs(copy:GetChildren()) do
					if dc:IsA("Decal") then
						local e = endP:FindFirstChild(dc.Name)
						local frames = {}
						local fb = dc:GetAttribute("FlipbookTextures")
						if dc:GetAttribute("FlipbookEnabled") == true and type(fb) == "string" and #fb >= 8 then
							local bb = buffer.fromstring(fb)
							for i = 0, #fb // 8 - 1 do table.insert(frames, buffer.readf64(bb, i * 8)) end
						end
						table.insert(decals, {
							d = dc, t0 = num(dc:GetAttribute("Transparency_Start"), num(A("Decal_StartTransparency"), 0)),
							t1 = num(dc:GetAttribute("Transparency_End"), num(A("Decal_EndTransparency"), 1)),
							ct = curveOf(dc, "Transparency_Curve"), c0 = dc.Color3, c1 = if e and e:IsA("Decal") then e.Color3 else dc.Color3,
							cc = curveOf(dc, "Color_Curve"), frames = frames, fdur = num(dc:GetAttribute("Flipbook_Change_Duration"), life),
							cf = curveOf(dc, "Flipbook_Change_Curve", LINEAR),
						})
					end
				end
				local R = Vector3.new(math.rad(init.X), math.rad(init.Y), math.rad(init.Z))
				local c = 0
				local step = speedRamp(m)
				local function apply(tc)
					local t = if life > 0 then tc / life else 1
					local off = CFrame.identity:Lerp(full, ease(cCF, t))
					local Rcf = CFrame.Angles(R.X, R.Y, R.Z)
					copy.CFrame = if around then origin * sp * Rcf * off * Rcf else origin * sp * off * Rcf * Rcf
					if startP.Size ~= endP.Size then copy.Size = startP.Size:Lerp(endP.Size, ease(cSize, t)) end
					if cm and sm0 and sm1 then cm.Scale = sm0.Scale:Lerp(sm1.Scale, ease(cMesh, t)) end
					copy.Transparency = lerp(pt0, pt1, ease(cTr, t))
					for _, x in ipairs(decals) do
						x.d.Transparency = lerp(x.t0, x.t1, ease(x.ct, t))
						if x.c0 ~= x.c1 then x.d.Color3 = x.c0:Lerp(x.c1, ease(x.cc, t)) end
						if #x.frames > 0 then
							local a = ease(x.cf, if x.fdur > 0 then tc / x.fdur else 1)
							local i = math.clamp(math.max(math.floor(#x.frames * a + 0.5), 1), 1, #x.frames)
							x.d.Texture = "rbxassetid://" .. string.format("%.0f", x.frames[i])
						end
					end
				end
				apply(0)
				copy.Parent = scratch
				walk(copy, clock)
				job(function(dt)
					local sdt = step(dt)
					if sdt == nil then copy:Destroy() return true end
					local rsp = lerp(rs0, rs1, ease(cRot, if life > 0 then math.min(c, life) / life else 1))
					R += sign * rsp * sdt
					c += sdt
					if c >= life + destroyDelay then copy:Destroy() return true end
					apply(math.min(c, life))
					return false
				end)
			end)
		end
	end

	local TweenService = game:GetService("TweenService")
	local function tweenMesh(m, t0)
		local A = function(k) return m:GetAttribute(k) end
		local startP, endP = m.Start, m.End
		local dur = num(A("Duration"), nil)
		local partP, meshP, decalP = A("Part_TweenParams"), A("Mesh_TweenParams"), A("Decal_TweenParams")
		local js = A("_EasyMeshEmitData")
		if type(js) == "string" then
			local ok, inner = pcall(function() return HttpService:JSONDecode(HttpService:JSONDecode(js)) end)
			if ok and type(inner) == "table" then
				dur = dur or num(inner["General/Tween Duration"], nil)
				partP = partP or ((inner["Part/Tween Information/Easing Style"] or "Linear") .. "," .. (inner["Part/Tween Information/Easing Direction"] or "In"))
			end
		end
		dur = dur or 0.1
		local style, dir = Enum.EasingStyle.Linear, Enum.EasingDirection.In
		if type(partP) == "string" then
			local a, b = string.match(partP, "^%s*(%w*)%s*,?%s*(%w*)")
			pcall(function() if a and a ~= "" then style = Enum.EasingStyle[a] end end)
			pcall(function() if b and b ~= "" then dir = Enum.EasingDirection[b] end end)
		end
		local st = num(A("StartTransparency"), 0)
		at(t0, function()
			local copy = tpl[m]:Clone()
			copy.Anchored, copy.CanCollide, copy.CanQuery, copy.CanTouch = true, false, false, false
			copy.CFrame = startP.CFrame
			local decal = copy:FindFirstChildWhichIsA("Decal")
			local cm, sm1 = copy:FindFirstChild("Mesh"), endP:FindFirstChild("Mesh")
			local sm0 = startP:FindFirstChild("Mesh")
			local trStart = if copy:IsA("MeshPart") or not decal then st else copy.Transparency
			if decal and not copy:IsA("MeshPart") then decal.Transparency = st end
			copy.Parent = scratch
			walk(copy, clock)
			local c = 0
			job(function(dt)
				c += dt
				local a = TweenService:GetValue(math.clamp(c / dur, 0, 1), style, dir)
				copy.CFrame = startP.CFrame:Lerp(endP.CFrame, a)
				copy.Size = startP.Size:Lerp(endP.Size, a)
				copy.Transparency = lerp(trStart, 1, a)
				if meshP and cm and sm0 and sm1 and cm:IsA("SpecialMesh") then cm.Scale = sm0.Scale:Lerp(sm1.Scale, a) end
				if decalP and decal then decal.Transparency = lerp(st, 1, a) end
				if c >= dur then copy:Destroy() return true end
				return false
			end)
		end)
	end

	local function spin(m, t0)
		local rot = m:GetAttribute("SpinRotation")
		local s0, s1 = num(m:GetAttribute("Scale_Start"), 1), num(m:GetAttribute("Scale_End"), 1)
		if (typeof(rot) ~= "Vector3" or rot.Magnitude == 0) and s0 == s1 then return end
		rot = if typeof(rot) == "Vector3" then rot else Vector3.zero
		local dur = num(m:GetAttribute("SpinDuration"), 0.5)
		local cs = curveOf(m, "Scale_Curve")
		at(t0 + num(m:GetAttribute("EmitDelay"), 0), function()
			local base = m:GetPivot()
			local c = 0
			job(function(dt)
				c = math.min(c + dt, dur)
				local r = rot * c
				m:PivotTo(base * CFrame.fromOrientation(math.rad(r.X), math.rad(r.Y), math.rad(r.Z)))
				if s0 ~= s1 then pcall(function() m:ScaleTo(lerp(s0, s1, ease(cs, c / dur))) end) end
				return c >= dur
			end)
		end)
	end

	walk = function(inst, t0)
		for _, ch in ipairs(inst:GetChildren()) do
			if ch:IsA("ParticleEmitter") then
				particle(ch, t0)
			elseif ch:IsA("Beam") then
				beam(ch, t0)
			elseif ch:IsA("Trail") then
				local wasOn = ch.Enabled
				ch.Enabled = false
				at(t0 + num(ch:GetAttribute("EmitDelay"), 0), function() ch.Enabled = wasOn or true end)
			elseif isStartEnd(ch) then
				if not tpl[ch] then
					tpl[ch] = ch.Start:Clone()
					hideTemplate(ch.Start)
					hideTemplate(ch.End)
				end
				if meshKind(ch) == "tween" then tweenMesh(ch, t0) else forgeMesh(ch, t0) end
			elseif ch:IsA("Folder") and ch.Name == "EmitOnFinish" then
				-- emitted by the parent's handler in Forge; skipped here
			else
				if ch:IsA("Model") then spin(ch, t0) end
				walk(ch, t0)
			end
		end
	end

	-- templates first (so nothing shows before its time), then the walk
	for _, d in ipairs(model:GetDescendants()) do
		if isStartEnd(d) and not tpl[d] then
			tpl[d] = d.Start:Clone()
			hideTemplate(d.Start)
			hideTemplate(d.End)
		end
	end
	walk(model, 0)
	table.sort(timed, function(a, b) return a.t < b.t end)

	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		if frozen then return end
		clock += dt
		local i = 1
		while i <= #timed do
			local ev = timed[i]
			if ev.t <= clock then
				table.remove(timed, i)
				local ok, err = pcall(ev.f)
				if not ok then warn("[VFXLib] " .. tostring(err)) end
			else
				i += 1
			end
		end
		local k = 1
		while k <= #jobs do
			local ok, done = pcall(jobs[k], dt)
			if not ok then warn("[VFXLib] " .. tostring(done)) end
			if (not ok) or done then table.remove(jobs, k) else k += 1 end
		end
	end)
	local h = {}
	function h.time() return clock end
	function h.freeze(on)
		frozen = on
		for _, e in ipairs(model:GetDescendants()) do
			if e:IsA("ParticleEmitter") then
				if on then e:SetAttribute("__TSF", e.TimeScale); e.TimeScale = 0
				elseif e:GetAttribute("__TSF") then e.TimeScale = e:GetAttribute("__TSF") end
			elseif e:IsA("Beam") then
				if on then e:SetAttribute("__TSpd", e.TextureSpeed); e.TextureSpeed = 0
				elseif e:GetAttribute("__TSpd") then e.TextureSpeed = e:GetAttribute("__TSpd") end
			end
		end
	end
	function h.stop()
		if conn then conn:Disconnect() end
		model:Destroy()
	end
	return h
end

function P.play(o)
	o = o or {}
	local model = spawnEffect(P.Origin)
	local h = drive(model, o and o.seed)
	S.handle = h
	task.delay(o.life or 8, function() if S.handle == h then h.stop() end end)
	return "playing"
end

local function waitUntil(ms)
	while DateTime.now().UnixTimestampMillis < ms do task.wait() end
end

local function markers()
	-- Flat on-screen squares (a ScreenGui in StarterGui, which Studio draws over the edit viewport): no bloom, no depth,
	-- fixed pixels whatever the camera does. Earlier 3D cubes were covered by close effects or smeared by bloom.
	for _, n in ipairs({ "VFXMarkers" }) do
		local o = Workspace:FindFirstChild(n)
		if o then o:Destroy() end
	end
	local sg = game:GetService("StarterGui")
	local old = sg:FindFirstChild("VFXMarkersGui")
	if old then old:Destroy() end
	local g = Instance.new("ScreenGui")
	g.Name = "VFXMarkersGui"
	g.IgnoreGuiInset = true
	g.DisplayOrder = 100
	g.ResetOnSpawn = false
	local cubes, pixels = {}, {}
	for i = 1, 5 do
		local f = Instance.new("Frame")
		f.Name = "M" .. i
		f.BorderSizePixel = 0
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Size = UDim2.fromOffset(26, 26)
		f.Position = UDim2.fromOffset(40 + (i - 1) * 40, 40)
		f.BackgroundColor3 = Color3.new(0, 0, 0)
		f.Parent = g
		cubes[i] = f
		pixels[i] = { 40 + (i - 1) * 40, 40 }
	end
	g.Parent = sg
	return cubes, pixels
end

local function showIndex(cubes, k)
	for i, f in ipairs(cubes) do
		f.BackgroundColor3 = if math.floor(k / 2 ^ (i - 1)) % 2 == 1 then Color3.new(1, 1, 1) else Color3.new(0, 0, 0)
	end
end

local function clearMarkers()
	local g = game:GetService("StarterGui"):FindFirstChild("VFXMarkersGui")
	if g then g:Destroy() end
	local o = Workspace:FindFirstChild("VFXMarkers")
	if o then o:Destroy() end
end

-- Freeze-frame stills (protocol shared with kit/scripts/stills.py): play k starts at S_k, freezes at effect time t_k for
-- `hold` s while the marker cubes show k, then S_k+1 = S_k + t_k + hold + gap.
function P.stills(o)
	local times, hold, gap = o.times, o.hold or 2.2, o.gap or 0.3
	local start = DateTime.now().UnixTimestampMillis + math.floor((o.lead or 6) * 1000)
	local cubes, pixels = markers()
	task.spawn(function()
		local s = start
		for k, t in ipairs(times) do
			waitUntil(s)
			local model = spawnEffect(P.Origin)
			local h = drive(model, o and o.seed)
			-- at least 2 rendered frames after spawn: freezing on the frame the particles are emitted shows them at age 0
			local frames = 0
			while h.time() < t or frames < 2 do RunService.Heartbeat:Wait(); frames += 1 end
			h.freeze(true)
			showIndex(cubes, k % 32)
			waitUntil(s + (t + hold) * 1000)
			h.stop()
			showIndex(cubes, 0)
			s += (t + hold + gap) * 1000
		end
		clearMarkers()
	end)
	local total = 0
	for _, t in ipairs(times) do total += t + hold + gap end
	return HttpService:JSONEncode({ start = start, n = #times, ends = start + math.floor(total * 1000), markers = pixels })
end

-- Batch mode: P.prepare({names}) loads + preloads every template (call once, it yields), then
-- P.batch({ items = {{name=, times={...}}, ...}, hold, gap, between, lead }) schedules every still of every effect and
-- returns { markers, shots = {{name, t, k, a, b}} } (a..b = frozen window, epoch ms) for kit/scripts/stills.py --plan.
function P.prepare(names)
	S.lib = S.lib or {}
	local out, pending = {}, 0
	for _, name in ipairs(names) do
		local ok, err = pcall(function()
			local root = game:GetObjects("rbxasset://vfxlib/" .. name .. ".rbxmx")[1]
			strip(root)
			S.lib[name] = { template = root }
			S.template = root
			S.lib[name].radius = P.radius()
		end)
		out[name] = if ok then math.floor(S.lib[name].radius * 10) / 10 else ("ERR " .. tostring(err))
		if ok then
			pending += 1
			task.spawn(function()
				pcall(function() game:GetService("ContentProvider"):PreloadAsync({ S.lib[name].template }) end)
				pending -= 1
			end)
		end
	end
	local t0 = os.clock()
	while pending > 0 and os.clock() - t0 < 90 do task.wait(0.2) end
	out.__pending = pending
	return HttpService:JSONEncode(out)
end

function P.batch(o)
	local hold, gap, between = o.hold or 1.9, o.gap or 0.3, o.between or 0.8
	local start = DateTime.now().UnixTimestampMillis + math.floor((o.lead or 6) * 1000)
	local cubes, pixels = markers()
	local shots, s, k = {}, start, 0
	local plan = {}
	for _, it in ipairs(o.items) do
		local entry = { name = it.name, s0 = s, stills = {} }
		for _, t in ipairs(it.times) do
			k += 1
			table.insert(shots, { name = it.name, t = t, k = k % 32, a = math.floor(s + t * 1000), b = math.floor(s + (t + hold) * 1000) })
			table.insert(entry.stills, { t = t, s = s, k = k % 32 })
			s += (t + hold + gap) * 1000
		end
		s += between * 1000
		table.insert(plan, entry)
	end
	S.runId = (S.runId or 0) + 1
	local myRun = S.runId
	task.spawn(function()
		for _, entry in ipairs(plan) do
			if S.runId ~= myRun then break end -- P.stop() or a newer batch: this loop ends
			local lib = S.lib[entry.name]
			if lib then
				S.template = lib.template
				P.frame({ radius = lib.radius, view = lib.view })
				S.lockCam = true
				cubes = markers()
				task.wait(between) -- camera and markers settle before the first still of this effect
				for _, st in ipairs(entry.stills) do
					if S.runId ~= myRun then break end
					-- relative timing: every still is held for the full `hold` after it is frozen, however long a heavy
					-- effect took to reach t (a fixed timetable made late stills flash for one frame and get missed)
					local model = spawnEffect(P.Origin)
					local h = drive(model, o and o.seed)
					-- at least 2 rendered frames after spawn: freezing on the frame the particles are emitted shows them at age 0
			local frames = 0
			while h.time() < st.t or frames < 2 do RunService.Heartbeat:Wait(); frames += 1 end
					h.freeze(true)
					RunService.Heartbeat:Wait()
					showIndex(cubes, st.k)
					task.wait(hold)
					h.stop()
					showIndex(cubes, 0)
					task.wait(gap)
				end
			end
		end
		clearMarkers()
		S.lockCam = false
	end)
	return HttpService:JSONEncode({ start = start, ends = math.floor(s), markers = pixels, shots = shots })
end

function P.views()
	local out = {}
	for name, lib in pairs(S.lib or {}) do
		local v = lib.view or P.defaultView(lib.radius)
		out[name] = { v.look.X, v.look.Y, v.look.Z, v.dist }
	end
	return HttpService:JSONEncode(out)
end

-- Stops any running batch (it ends before its next still) and removes what it shows.
function P.stop()
	S.runId = (S.runId or 0) + 1
	S.lockCam = false
	task.wait(0.1)
	for _, n in ipairs({ "VFX_Lib" }) do
		local f = Workspace:FindFirstChild(n)
		if f then f:Destroy() end
	end
	clearMarkers()
	return "stopped"
end

function P.clear()
	S.runId = (S.runId or 0) + 1
	S.lockCam = false
	clearMarkers()
	for _, n in ipairs({ "VFX_Lib", "VFXStage", "VFXMarkers" }) do
		local f = Workspace:FindFirstChild(n)
		if f then f:Destroy() end
	end
	if S.handle then pcall(S.handle.stop) S.handle = nil end
	if S.savedCamera then
		local cam = Workspace.CurrentCamera
		cam.CFrame, cam.FieldOfView = S.savedCamera[1], S.savedCamera[2]
		S.savedCamera = nil
	end
	S.template = nil
	return "cleared"
end

return P
