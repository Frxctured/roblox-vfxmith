-- VFXCompose (vfxmith 1.0.0-alpha2, MIT): build an effect from REAL pro pieces instead of inventing it.
-- A piece is one open-source effect cut out with kit/scripts/compose.py --cut <id> (scripts removed) into Studio's
-- content folder (rbxasset://vfxlib/fx_<id>.rbxmx). A spec lists the pieces and how each is adapted (colour, scale,
-- speed, placement, delay, dropped or changed layers); VFXCompose loads them, adapts them once and plays them all on
-- one clock that can be frozen at an exact effect time. kit/scripts/export_compose.py turns spec + this file into one
-- self-contained final.luau.
--
--   local C = loadstring(<this source>)()   (or require a ModuleScript copy)
--   C.build(spec)                 load + adapt every piece (yields until textures are preloaded); returns a summary
--   C.layers(i)                   piece i's layers (class, name, texture, colour, EmitCount): names to use in set/drop
--   C.measure(i?)                 measured size of piece i (or all): width/height in studs and character heights,
--                                 the largest single layer, light range, the fit factor used (scale to the scene FIRST)
--   C.coverage(origin?, camPos?)  from camPos (or the current camera): how much of the frame the largest layer of each piece
--                                 covers at its biggest (> 0.6 of the frame height is a fault unless the brief wants it)
--   C.play(origin, freezeAt?)     play once with the base at origin; with freezeAt hold still at that effect time
--                                 (returns once that frame is built) until C.stop(); a new play stops the old one
--   C.stop()                      stop and remove the current play
--   C.camera(origin, {dist, yaw, pitch, height, top})   point the edit camera at the effect (top = straight down)
--
-- Spec (a Luau table; full reference in knowledge/compose-spec.md):
--   { name = "FrostNova", folder = "VFXCompose", length = 2.5, dummy = true, yaw = 0, speed = 1,
--     pieces = { { file = "fx_8f69477f9552", at = Vector3.new(0, 0, 0), rot = Vector3.new(0, 0, 0), delay = 0,
--                  scale = 1, speed = 1, tint = "#7FD8FF", tintMode = "shift", tintStrength = 1, glow = 1, count = 1,
--                  drop = { "Name", "~substring" }, set = { ["LayerName"] = { Rate = 0, ["@EmitCount"] = 3 } },
--                  on = "dummy", anchor = "auto", size = 10, sizeBy = "width" } } }
--
-- The driver below (how pro effects fire: EmitCount/EmitDelay/EmitDuration attributes, Forge-format beams and
-- Start/End meshes) is a copy of VFXLibPlayer.luau's driver v2 (own code, see THIRD_PARTY.md), with a playback speed
-- and a start time added.
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local C = {}
_G.__VFXCompose = _G.__VFXCompose or {}
local S = _G.__VFXCompose

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

local function drive(model, seed, speed, t0)
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
	walk(model, t0 or 0)
	table.sort(timed, function(a, b) return a.t < b.t end)

	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		if frozen then return end
		dt *= (speed or 1)
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


-- ===================================================================================== composition
local RIG = {
	Head = "Head", HumanoidRootPart = "HumanoidRootPart", Torso = "UpperTorso", UpperTorso = "UpperTorso",
	LowerTorso = "LowerTorso", ["Right Arm"] = "RightUpperArm", ["Left Arm"] = "LeftUpperArm",
	["Right Leg"] = "RightUpperLeg", ["Left Leg"] = "LeftUpperLeg", RightUpperArm = "RightUpperArm",
	LeftUpperArm = "LeftUpperArm", RightLowerArm = "RightLowerArm", LeftLowerArm = "LeftLowerArm",
	RightHand = "RightHand", LeftHand = "LeftHand", RightUpperLeg = "RightUpperLeg", LeftUpperLeg = "LeftUpperLeg",
	RightLowerLeg = "RightLowerLeg", LeftLowerLeg = "LeftLowerLeg", RightFoot = "RightFoot", LeftFoot = "LeftFoot",
}

local function strip(root)
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("LuaSourceContainer") then d:Destroy() end
	end
end

local function toColor(v)
	if typeof(v) == "Color3" then return v end
	return Color3.fromHex(tostring(v))
end

local function mapSeq(seq, f)
	local ks = {}
	for _, k in ipairs(seq.Keypoints) do table.insert(ks, ColorSequenceKeypoint.new(k.Time, f(k.Value))) end
	return ColorSequence.new(ks)
end

local function scaleNS(seq, s)
	local ks = {}
	for _, k in ipairs(seq.Keypoints) do
		table.insert(ks, NumberSequenceKeypoint.new(k.Time, k.Value * s, k.Envelope * s))
	end
	return NumberSequence.new(ks)
end

-- f(color) -> color applied to every colour an effect carries
local function eachColor(root, f)
	local all = root:GetDescendants()
	table.insert(all, root)
	for _, d in ipairs(all) do
		if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
			d.Color = mapSeq(d.Color, f)
		elseif d:IsA("Light") then
			d.Color = f(d.Color)
		elseif d:IsA("Highlight") then
			d.FillColor = f(d.FillColor)
			d.OutlineColor = f(d.OutlineColor)
		elseif d:IsA("Decal") then -- Texture too
			d.Color3 = f(d.Color3)
		elseif d:IsA("BasePart") and d.Transparency < 1 then
			d.Color = f(d.Color)
		end
	end
end

-- saturation-weighted mean hue of the piece (where its identity colour sits)
local function dominantHue(root)
	local x, y = 0, 0
	eachColor(root, function(c)
		local h, s, v = c:ToHSV()
		local w = s * v
		x += math.cos(h * 2 * math.pi) * w
		y += math.sin(h * 2 * math.pi) * w
		return c
	end)
	if x * x + y * y < 1e-6 then return nil end
	return (math.atan2(y, x) / (2 * math.pi)) % 1
end

-- Hue only: saturation and value stay as the artist made them, so white cores, dark partner layers and the colour
-- travel over a layer's life survive. "shift" rotates every hue by the same amount (keeps the piece's hue range);
-- "set" puts every saturated colour on the target hue.
local function tint(root, target, mode, strength)
	local th = toColor(target):ToHSV()
	local base = dominantHue(root)
	if base == nil then return end
	local dh = th - base
	strength = strength or 1
	eachColor(root, function(c)
		local h, s, v = c:ToHSV()
		if s < 0.12 then return c end
		local nh = if mode == "set" then th else (h + dh) % 1
		local d = ((nh - h + 0.5) % 1) - 0.5
		return Color3.fromHSV((h + d * strength) % 1, s, v)
	end)
end

local function isScaleAttr(k)
	return string.find(k, "Width") ~= nil or string.find(k, "CurveSize") ~= nil
end

local function scaleRoot(root, s)
	if s == 1 then return end
	local pivot = CFrame.new()
	if root:IsA("BasePart") then
		pivot = root.CFrame
	elseif root:IsA("Model") then
		local ok, cf = pcall(function() return root:GetBoundingBox() end)
		if ok then pivot = cf end
	end
	local all = root:GetDescendants()
	table.insert(all, root)
	for _, d in ipairs(all) do
		if d:IsA("BasePart") then
			local rel = pivot:ToObjectSpace(d.CFrame)
			d.Size *= s
			d.CFrame = pivot * (CFrame.new(rel.Position * s) * rel.Rotation)
		elseif d:IsA("Attachment") then
			d.Position *= s
		elseif d:IsA("SpecialMesh") then
			d.Scale *= s
			d.Offset *= s
		elseif d:IsA("ParticleEmitter") then
			d.Size = scaleNS(d.Size, s)
			d.Speed = NumberRange.new(d.Speed.Min * s, d.Speed.Max * s)
			d.Acceleration *= s
		elseif d:IsA("Beam") then
			d.Width0 *= s
			d.Width1 *= s
			d.CurveSize0 *= s
			d.CurveSize1 *= s
			if d.TextureMode ~= Enum.TextureMode.Stretch then d.TextureLength *= s end
		elseif d:IsA("Trail") then
			d.MinLength *= s
			d.MaxLength *= s
		elseif d:IsA("Light") then
			pcall(function() d.Range = math.min(d.Range * s, 60) end)
		end
		for k, v in pairs(d:GetAttributes()) do
			if type(v) == "number" and isScaleAttr(k) then d:SetAttribute(k, v * s) end
		end
	end
end

local function speedRoot(root, sp)
	if sp == 1 then return end
	local all = root:GetDescendants()
	table.insert(all, root)
	for _, d in ipairs(all) do
		if d:IsA("ParticleEmitter") then
			local ex = d.TimeScale * sp
			if ex > 1 then
				-- TimeScale tops out at 1: run faster with shorter lives and quicker motion instead
				local k = ex -- TimeScale becomes 1; the rest of the speed-up goes into the particles
				d.Lifetime = NumberRange.new(d.Lifetime.Min / k, d.Lifetime.Max / k)
				d.Speed = NumberRange.new(d.Speed.Min * k, d.Speed.Max * k)
				d.Acceleration *= k * k
				d.RotSpeed = NumberRange.new(d.RotSpeed.Min * k, d.RotSpeed.Max * k)
				pcall(function() d.FlipbookFramerate = NumberRange.new(d.FlipbookFramerate.Min * k, d.FlipbookFramerate.Max * k) end)
			end
			d.TimeScale = math.clamp(ex, 0, 1)
			for _, k in ipairs({ "TimeScale_Start", "TimeScale_End" }) do
				local v = d:GetAttribute(k)
				if type(v) == "number" then d:SetAttribute(k, math.clamp(v * sp, 0, 1)) end
			end
		elseif d:IsA("Beam") then
			d.TextureSpeed *= sp
		end
	end
end

-- ===================================================================================== measure (scale to the scene first)
-- Pro pieces come at their artist's scale (battlegrounds moves are often 20-40 studs across); a brief says "knee
-- high spikes" or "a 12 stud blast". Measure every piece, then scale it to the brief's size BEFORE any styling.
-- The size is estimated from values (particles cannot be read back): per emitter its carrier position + the travel of
-- a typical particle (mid Speed over mid Lifetime with Drag, + |Acceleration| t^2 / 2) along its emission direction
-- (all round when the spread is wide) + half its largest Size; beams by their two attachments and width; visible parts
-- by their size; lights by Range.
local H = 5 -- studs per R15 character height

local function nsMax(seq)
	local m = 0
	for _, k in ipairs(seq.Keypoints) do m = math.max(m, k.Value + k.Envelope) end
	return m
end

local function travelOf(e)
	local v = (e.Speed.Min + e.Speed.Max) / 2
	local t = math.min((e.Lifetime.Min + e.Lifetime.Max) / 2, 6)
	local dr = e.Drag
	local dist = if dr > 1e-3 then v * (1 - 2 ^ (-dr * t)) / (dr * math.log(2)) else v * t
	return math.abs(dist) + 0.5 * e.Acceleration.Magnitude * t * t
end

local function measureRoot(root)
	local lo, hi = Vector3.one * math.huge, -Vector3.one * math.huge
	local n = 0
	local function add(p, r)
		lo = lo:Min(p - Vector3.one * r)
		hi = hi:Max(p + Vector3.one * r)
		n += 1
	end
	local largest, largestName, light = 0, "", 0
	local all = root:GetDescendants()
	table.insert(all, root)
	for _, d in ipairs(all) do
		if d:IsA("ParticleEmitter") then
			local c = d.Parent
			local cf = if c and c:IsA("Attachment") then c.WorldCFrame elseif c and c:IsA("BasePart") then c.CFrame else nil
			if cf then
				local sz = nsMax(d.Size)
				local tr = travelOf(d)
				local vol = if c:IsA("BasePart") then math.max(c.Size.X, c.Size.Y, c.Size.Z) / 2 else 0
				local spread = math.max(d.SpreadAngle.X, d.SpreadAngle.Y)
				if spread < 45 then
					local dir = cf:VectorToWorldSpace(Vector3.FromNormalId(d.EmissionDirection))
					add(cf.Position, sz / 2 + vol)
					add(cf.Position + dir * tr, sz / 2 + vol)
				else
					add(cf.Position, tr + sz / 2 + vol)
				end
				if sz > largest then largest, largestName = sz, d.Name end
			end
		elseif d:IsA("Beam") then
			local a0, a1 = d.Attachment0, d.Attachment1
			if a0 and a1 then
				local w = math.max(d.Width0, d.Width1)
				add(a0.WorldPosition, w / 2)
				add(a1.WorldPosition, w / 2)
				if w > largest then largest, largestName = w, d.Name end
			end
		elseif d:IsA("BasePart") and d.Transparency < 1 and not RIG[d.Name] then
			local m = math.max(d.Size.X, d.Size.Y, d.Size.Z)
			add(d.Position, m / 2)
			if m > largest then largest, largestName = m, d.Name end
		elseif d:IsA("Light") then
			local ok, r = pcall(function() return (d :: any).Range end)
			if ok and type(r) == "number" then light = math.max(light, r) end
		end
	end
	if n == 0 then return nil end
	local size = hi - lo
	return { width = math.max(size.X, size.Z), height = size.Y, depth = math.min(size.X, size.Z),
		largest = largest, largestName = largestName, light = light, layers = n }
end

-- never let a measurement break a build
local function safeMeasure(root)
	local ok, m = pcall(measureRoot, root)
	if not ok then
		warn("[VFXCompose] measure failed: " .. tostring(m))
		return nil
	end
	return m
end

local function fmtMeasure(m)
	if not m then return "nothing measurable (no emitters, beams or visible parts)" end
	return string.format("width %.1f studs (%.1f H), height %.1f (%.1f H), largest layer '%s' %.1f studs (%.1f H)%s",
		m.width, m.width / H, m.height, m.height / H, m.largestName, m.largest, m.largest / H,
		if m.light > 0 then string.format(", light range %.0f", m.light) else "")
end

local function matches(d, key)
	if key == "*" then return true end
	if string.sub(key, 1, 1) == "~" then
		return string.find(string.lower(d.Name), string.lower(string.sub(key, 2)), 1, true) ~= nil
	end
	return d.Name == key or d.ClassName == key
end

local function adapt(root, pc)
	for _, key in ipairs(pc.drop or {}) do
		for _, d in ipairs(root:GetDescendants()) do
			if d.Parent and matches(d, key) then d:Destroy() end
		end
	end
	for key, props in pairs(pc.set or {}) do
		local all = root:GetDescendants()
		table.insert(all, root)
		local n = 0
		for _, d in ipairs(all) do
			if matches(d, key) then
				n += 1
				for p, v in pairs(props) do
					local ok, err
					if string.sub(p, 1, 1) == "@" then
						ok, err = pcall(d.SetAttribute, d, string.sub(p, 2), v)
					else
						ok, err = pcall(function() (d :: any)[p] = v end)
					end
					if not ok then warn("[VFXCompose] set " .. key .. "." .. p .. ": " .. tostring(err)) end
				end
			end
		end
		if n == 0 then warn("[VFXCompose] set: nothing named " .. key .. " in " .. pc.file) end
	end
	-- scale to the scene first: size = the brief's studs for this piece's width (or sizeBy = "height" / "largest")
	local sc = pc.scale or 1
	if pc.size then
		local m = safeMeasure(root)
		local by = pc.sizeBy or "width"
		local have = m and (m :: any)[by]
		if type(have) == "number" and have > 1e-3 then
			pc.__fit = math.clamp(pc.size / have, 0.01, 50)
			sc *= pc.__fit
		else
			warn("[VFXCompose] size: could not measure " .. tostring(pc.file) .. " by " .. by .. "; scale left at " .. sc)
		end
	end
	if pc.tint then tint(root, pc.tint, pc.tintMode, pc.tintStrength) end
	scaleRoot(root, sc)
	speedRoot(root, pc.speed or 1)
	local all = root:GetDescendants()
	table.insert(all, root)
	for _, d in ipairs(all) do
		if pc.glow and pc.glow ~= 1 and (d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail")) then
			d.Brightness *= pc.glow
		end
		if pc.count and pc.count ~= 1 then
			local n = d:GetAttribute("EmitCount")
			if type(n) == "number" then d:SetAttribute("EmitCount", math.max(1, math.floor(n * pc.count + 0.5))) end
		end
	end
	-- rig parts some aura packs ship as carriers: never draw them
	local rig = 0
	for _, d in ipairs(all) do
		if d:IsA("BasePart") and RIG[d.Name] then rig += 1 end
	end
	if rig >= 2 then
		for _, d in ipairs(all) do
			if d:IsA("BasePart") and RIG[d.Name] then
				d.Transparency = 1
				for _, x in ipairs(d:GetChildren()) do
					if x:IsA("Decal") then x.Transparency = 1 end
				end
			end
		end
	end
end

local function workFolder(spec)
	local name = spec.folder or "VFXCompose"
	local f = Workspace:FindFirstChild(name)
	if not f then
		f = Instance.new("Folder")
		f.Name = name
		f.Parent = Workspace
	end
	return f
end

local function anchorAll(model)
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Anchored, d.CanCollide, d.CanQuery, d.CanTouch, d.CastShadow = true, false, false, false, false
		end
	end
end

-- plain grey R15 dummy, feet on origin, facing -Z (cached template)
local GREY = Color3.fromRGB(163, 162, 165)
local function blockDummy()
	local m = Instance.new("Model")
	m.Name = "Dummy"
	local function p(name, size, y, x)
		local b = Instance.new("Part")
		b.Name, b.Size, b.Color = name, size, GREY
		b.Material = Enum.Material.SmoothPlastic
		b.CFrame = CFrame.new(x or 0, y, 0)
		b.Parent = m
		return b
	end
	p("LeftFoot", Vector3.new(1, 0.3, 1), 0.15, -0.5); p("RightFoot", Vector3.new(1, 0.3, 1), 0.15, 0.5)
	p("LeftLowerLeg", Vector3.new(1, 1.1, 1), 0.85, -0.5); p("RightLowerLeg", Vector3.new(1, 1.1, 1), 0.85, 0.5)
	p("LeftUpperLeg", Vector3.new(1, 1.0, 1), 1.9, -0.5); p("RightUpperLeg", Vector3.new(1, 1.0, 1), 1.9, 0.5)
	p("LowerTorso", Vector3.new(2, 0.4, 1), 2.6)
	p("UpperTorso", Vector3.new(2, 1.6, 1), 3.6)
	p("LeftUpperArm", Vector3.new(1, 1.0, 1), 3.9, -1.5); p("RightUpperArm", Vector3.new(1, 1.0, 1), 3.9, 1.5)
	p("LeftLowerArm", Vector3.new(1, 0.9, 1), 2.95, -1.5); p("RightLowerArm", Vector3.new(1, 0.9, 1), 2.95, 1.5)
	p("LeftHand", Vector3.new(1, 0.3, 1), 2.35, -1.5); p("RightHand", Vector3.new(1, 0.3, 1), 2.35, 1.5)
	p("Head", Vector3.new(1.2, 1.2, 1.2), 5.0)
	local hrp = p("HumanoidRootPart", Vector3.new(2, 2, 1), 2.8)
	hrp.Transparency = 1
	m.PrimaryPart = hrp
	Instance.new("Humanoid").Parent = m
	return m
end

local function dummyTemplate()
	if S.dummyTpl and S.dummyTpl.Parent == nil then return S.dummyTpl end
	local m
	local ok = pcall(function()
		local hd = Instance.new("HumanoidDescription")
		hd.HeadColor, hd.TorsoColor, hd.LeftArmColor, hd.RightArmColor, hd.LeftLegColor, hd.RightLegColor =
			GREY, GREY, GREY, GREY, GREY, GREY
		m = game:GetService("Players"):CreateHumanoidModelFromDescription(hd, Enum.HumanoidRigType.R15)
	end)
	if not ok or not m or not m:FindFirstChild("HumanoidRootPart") then m = blockDummy() end
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Accessory") or d:IsA("Clothing") then d:Destroy() end
	end
	m.Name = "Dummy"
	anchorAll(m)
	-- feet on y = 0, centred on x/z = 0
	local cf, size = m:GetBoundingBox()
	m:PivotTo(m:GetPivot() + Vector3.new(-cf.Position.X, size.Y / 2 - cf.Position.Y, -cf.Position.Z))
	S.dummyTpl = m
	return m
end

-- One piece on the stage. "auto" anchor: the median layer carrier over the origin and the lowest (10th percentile)
-- one on the floor (pro files are authored anywhere in their place); "pivot": the piece's own pivot at the origin.
local function spawnPiece(tpl, origin, pc, spec, dummy, parent)
	local model = Instance.new("Model")
	model.Name = "Piece_" .. tostring(pc.file)
	local inst = tpl:Clone()
	if inst:IsA("Attachment") or inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail") then
		local carrier = Instance.new("Part")
		carrier.Name = "Carrier"
		carrier.Transparency, carrier.Size = 1, Vector3.one * 0.2
		carrier.CFrame = if inst:IsA("Attachment") then inst.WorldCFrame else CFrame.new()
		carrier.Parent = model
		inst.Parent = carrier
		if inst:IsA("Attachment") then inst.CFrame = CFrame.new() end
	else
		inst.Parent = model
	end
	anchorAll(model)
	local pivot
	if inst:IsA("BasePart") then
		pivot = inst.CFrame
	elseif inst:IsA("Model") and inst.PrimaryPart then
		pivot = inst.PrimaryPart.CFrame
	else
		local ok, cf = pcall(function() return model:GetBoundingBox() end)
		pivot = if ok then cf else CFrame.new()
	end
	model.WorldPivot = pivot
	model:PivotTo(CFrame.new(origin) * (pivot - pivot.Position))
	if pc.on == "dummy" and dummy then
		-- rig-carried layers: put the piece's root/torso on the dummy's, then snap every rig part onto its match
		local key
		for _, n in ipairs({ "HumanoidRootPart", "Torso", "UpperTorso" }) do
			key = model:FindFirstChild(n, true)
			if key and key:IsA("BasePart") then break end
			key = nil
		end
		local dr = dummy:FindFirstChild("HumanoidRootPart")
		if key and dr then
			local target = dummy:FindFirstChild(RIG[key.Name] or key.Name) or dr
			model:PivotTo(target.CFrame * key.CFrame:ToObjectSpace(model:GetPivot()))
			for _, d in ipairs(model:GetDescendants()) do
				if d:IsA("BasePart") and RIG[d.Name] then
					local m = dummy:FindFirstChild(RIG[d.Name])
					if m then d.CFrame = m.CFrame end
				end
			end
		elseif dr then
			model:PivotTo(CFrame.new(dr.Position) * (pivot - pivot.Position))
		end
	elseif (pc.anchor or "auto") == "auto" then
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
			model:PivotTo(model:GetPivot() + (origin - Vector3.new(xs[mid], low, zs[mid])))
		end
	end
	-- placement in effect space: yaw of the whole effect, then the piece's offset and rotation, about the origin
	if pc.on ~= "dummy" then
		local r = pc.rot or Vector3.zero
		local T = CFrame.new(origin) * CFrame.Angles(0, math.rad(spec.yaw or 0), 0) * CFrame.new(pc.at or Vector3.zero)
			* CFrame.fromOrientation(math.rad(r.X), math.rad(r.Y), math.rad(r.Z))
		model:PivotTo(T * (CFrame.new(origin):Inverse() * model:GetPivot()))
	end
	model.Parent = parent
	return model
end

function C.build(spec)
	assert(type(spec) == "table" and type(spec.pieces) == "table", "spec needs pieces")
	C.stop()
	S.spec = spec
	S.templates = {}
	S.dummyTpl = nil
	local summary = { name = spec.name, pieces = {} }
	for i, pc in ipairs(spec.pieces) do
		local url = "rbxasset://vfxlib/" .. tostring(pc.file) .. ".rbxmx"
		local ok, objs = pcall(function() return game:GetObjects(url) end)
		if not ok or not objs or not objs[1] then
			error("[VFXCompose] cannot load " .. url .. " - run: python3 -I kit/scripts/compose.py --cut "
				.. string.gsub(tostring(pc.file), "^fx_", "") .. "  (" .. tostring(objs) .. ")")
		end
		local root = objs[1]
		if root:IsA("LuaSourceContainer") then error("root is a script: " .. url) end
		strip(root)
		adapt(root, pc)
		S.templates[i] = root
		local n = { emitters = 0, beams = 0, trails = 0, parts = 0 }
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("ParticleEmitter") then n.emitters += 1
			elseif d:IsA("Beam") then n.beams += 1
			elseif d:IsA("Trail") then n.trails += 1
			elseif d:IsA("BasePart") then n.parts += 1 end
		end
		local m = safeMeasure(root)
		summary.pieces[i] = { file = pc.file, n = n, fit = pc.__fit, size = m and {
			width = math.floor(m.width * 10 + 0.5) / 10, height = math.floor(m.height * 10 + 0.5) / 10,
			largest = math.floor(m.largest * 10 + 0.5) / 10, largestName = m.largestName } }
	end
	if spec.dummy then dummyTemplate() end
	local pending = true
	task.spawn(function()
		pcall(function() game:GetService("ContentProvider"):PreloadAsync(S.templates) end)
		pending = false
	end)
	local t0 = os.clock()
	while pending and os.clock() - t0 < 25 do task.wait(0.2) end
	return HttpService:JSONEncode(summary)
end

function C.layers(i)
	local root = S.templates and S.templates[i]
	assert(root, "no piece " .. tostring(i) .. " (C.build first)")
	local out = {}
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
			local h = d.Color.Keypoints[1].Value:ToHex()
			table.insert(out, string.format("%s %s | tex %s | #%s | Br %.3g LE %.3g | EmitCount %s Delay %s",
				d.ClassName, d.Name, tostring(d.Texture), h, d.Brightness, d.LightEmission,
				tostring(d:GetAttribute("EmitCount")), tostring(d:GetAttribute("EmitDelay"))))
		elseif d:IsA("BasePart") and d.Transparency < 1 then
			table.insert(out, string.format("%s %s | size %s", d.ClassName, d.Name, tostring(d.Size)))
		end
	end
	return table.concat(out, "\n")
end

function C.measure(i)
	assert(S.templates, "C.build(spec) first")
	local out = {}
	for k, root in ipairs(S.templates) do
		if i == nil or i == k then
			local pc = S.spec.pieces[k]
			table.insert(out, string.format("piece %d %s: %s%s", k, tostring(pc.file), fmtMeasure(safeMeasure(root)),
				if pc.__fit then string.format(" | fitted x%.3g to size %s by %s", pc.__fit, tostring(pc.size),
					pc.sizeBy or "width") else ""))
		end
	end
	table.insert(out, "dummy: 5 studs = 1 H. Fault: more than 30% off the brief's size (guide section 6).")
	return table.concat(out, "\n")
end

-- how much of the frame the largest layer of each piece covers at its biggest, seen from camPos (default: the
-- current camera; the standard capture camera is origin + (14, 7, -16))
function C.coverage(origin, camPos)
	assert(S.templates, "C.build(spec) first")
	origin = origin or Vector3.zero
	local cam = Workspace.CurrentCamera
	local eye = camPos or cam.CFrame.Position
	local tanh = math.tan(math.rad(if camPos then 70 else cam.FieldOfView) / 2)
	local out = {}
	for k, root in ipairs(S.templates) do
		local pc = S.spec.pieces[k]
		local m = safeMeasure(root)
		if m then
			local at = pc.at or Vector3.zero
			local dist = math.max(1, (eye - (origin + at + Vector3.new(0, m.height / 2, 0))).Magnitude)
			local frac = m.largest / (2 * dist * tanh)
			local whole = math.max(m.width, m.height) / (2 * dist * tanh)
			table.insert(out, string.format("piece %d %s: largest layer '%s' covers %.0f%% of the frame height, the piece %.0f%%%s",
				k, tostring(pc.file), m.largestName, frac * 100, whole * 100,
				if frac > 0.6 then "  <- FAULT unless the brief wants a screen-filling flash" else ""))
		end
	end
	return table.concat(out, "\n")
end

function C.stop()
	S.playId = (S.playId or 0) + 1
	if S.conn then S.conn:Disconnect() S.conn = nil end
	for _, h in ipairs(S.handles or {}) do pcall(h.stop) end
	S.handles = {}
	if S.holder then pcall(game.Destroy, S.holder) S.holder = nil end
	return "stopped"
end

function C.play(origin, freezeAt)
	assert(S.spec and S.templates, "C.build(spec) first")
	C.stop()
	local spec = S.spec
	local id = S.playId
	origin = origin or Vector3.zero
	local holder = Instance.new("Folder")
	holder.Name = "Play"
	holder.Parent = workFolder(spec)
	S.holder = holder
	local dummy
	if spec.dummy then
		dummy = dummyTemplate():Clone()
		dummy:PivotTo(CFrame.new(origin) * CFrame.Angles(0, math.rad(spec.yaw or 0), 0) * dummy:GetPivot())
		dummy.Parent = holder
	end
	local gspeed = spec.speed or 1
	local handles, born = {}, {}
	S.handles = handles
	local clock, frozen, frames = 0, false, 0
	local pending, movers = {}, {}
	for i, pc in ipairs(spec.pieces) do table.insert(pending, i) end
	local function stepMovers()
		for _, m in ipairs(movers) do
			if m.model.Parent then
				local u = math.clamp((clock - m.t0) / math.max(m.time, 1e-3), 0, 1)
				local e = u + (1 - (1 - u) * (1 - u) - u) * m.ease -- blend linear -> quad ease-out
				local up = Vector3.new(0, 4 * m.arc * e * (1 - e), 0)
				m.model:PivotTo(m.base + m.by * e + up)
			end
		end
	end
	local function spawnDue()
		local k = 1
		while k <= #pending do
			local i = pending[k]
			local pc = spec.pieces[i]
			if (pc.delay or 0) <= clock then
				table.remove(pending, k)
				local ok, err = pcall(function()
					local model = spawnPiece(S.templates[i], origin, pc, spec, dummy, holder)
					local h = drive(model, pc.seed or (7 + i), (pc.speed or 1) * gspeed, 0)
					table.insert(handles, h)
					born[h] = frames
					if pc.move then
						-- travel: the piece flies from where it was placed by move.by (effect space) over move.time s,
						-- easing out by move.ease (0 = linear) with an optional arc height; frozen with the clock
						local mv = pc.move
						local by = CFrame.Angles(0, math.rad(spec.yaw or 0), 0):VectorToWorldSpace(mv.by or Vector3.zero)
						table.insert(movers, { model = model, base = model:GetPivot(), by = by, time = mv.time or 0.5,
							t0 = pc.delay or 0, arc = mv.arc or 0, ease = mv.ease or 0 })
					end
				end)
				if not ok then warn("[VFXCompose] piece " .. i .. ": " .. tostring(err)) end
			else
				k += 1
			end
		end
	end
	spawnDue()
	S.conn = RunService.Heartbeat:Connect(function(dt)
		if frozen then return end
		frames += 1
		clock += dt * gspeed
		spawnDue()
		stepMovers()
	end)
	if freezeAt then
		-- run until the effect clock reaches freezeAt, with every live piece at least 2 frames old (a particle
		-- frozen on its emit frame shows at age 0), then hold everything still
		while S.playId == id do
			local young = false
			for _, h in ipairs(handles) do
				if frames - born[h] < 2 then young = true end
			end
			if clock >= freezeAt and not young then break end
			RunService.Heartbeat:Wait()
		end
		if S.playId ~= id then return "stopped" end
		frozen = true
		for _, h in ipairs(handles) do h.freeze(true) end
		RunService.Heartbeat:Wait()
		return string.format("frozen at %.3f s (%d pieces live)", clock, #handles)
	end
	local life = (spec.length or 4) / gspeed + 4
	task.delay(life, function()
		if S.playId == id then C.stop() end
	end)
	return "playing"
end

function C.camera(origin, o)
	o = o or {}
	local spec = S.spec or {}
	local dist = o.dist or spec.viewDist or 22
	local yaw = math.rad(o.yaw or 25)
	local look = (origin or Vector3.zero) + Vector3.new(0, o.height or spec.viewHeight or 2.5, 0)
	local pos = look + Vector3.new(math.sin(yaw) * dist, dist * (o.pitch or 0.28), -math.cos(yaw) * dist)
	if o.top then -- straight down (motion-path and caster-space check)
		look = origin or Vector3.zero
		pos = look + Vector3.new(0, dist * 1.4, 0.01)
	end
	local cam = Workspace.CurrentCamera
	cam.FieldOfView = 70
	cam.CFrame = CFrame.lookAt(pos, look)
	cam.Focus = CFrame.new(look)
	return "camera set"
end

return C
