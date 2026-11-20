--!nocheck
-- vfxmith stage (1.0.0-alpha4): one effect clock for a whole scene, BlindTestPlay/BlindTestStop with an exact
-- freeze, driven sprites (particles that hold any moment, even where Edit-mode particles never age) and a posable
-- grey R15 dummy. Optional: use any part of it, change it, or ignore it.
--
-- Use: paste this whole file at the top of your final.luau (or `cat kit/stage.luau mine.luau > final.luau`); it
-- defines `local Stage`. Then:
--
--   local stage = Stage.define({
--       name = "LAB_my_effect",            -- folder in Workspace that holds every play
--       length = 3.0,                      -- seconds; a free play ends here
--       build = function(S) ... end,       -- runs at the start of every play: make parts, props, dummies, sprites
--       update = function(S, t) ... end,   -- optional: called every frame with the effect time t
--   })                                     -- also sets _G.BlindTestPlay(origin, freezeAt?) and _G.BlindTestStop()
--
-- In build: S.origin (Vector3), S.cf (CFrame at origin, facing -Z), S.root (this play's folder),
--   S:part(props), S:add(class, props, parent?), S:on(function(t) end), S:at(time, function(t) end),
--   S:emitter(parent, props) (a normal ParticleEmitter), S:sprite(texture, opts) (driven), S:decal(texture, opts),
--   S:dummy(opts) (rig with :pose and :keys), S.rng (Random seeded per play, same every play).
-- Outside build: Stage.cleanLab(keep?), Stage.camera(from, at, fov?), Stage.light("dark" | "day", opts?).
-- Every value you compute from t is exact at any freezeAt. Normal emitters freeze with TimeScale 0 (their particles
-- are as old as real time made them); driven sprites and parts are exact.

local Stage = (function()
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")

	local M = {}

	-- ============================================================================================ small math
	function M.clamp01(x) return math.clamp(x, 0, 1) end
	function M.lerp(a, b, u) return a + (b - a) * u end
	function M.smooth(x) x = math.clamp(x, 0, 1) return x * x * (3 - 2 * x) end
	function M.easeOut(x, p) x = math.clamp(x, 0, 1) return 1 - (1 - x) ^ (p or 2) end
	function M.easeIn(x, p) x = math.clamp(x, 0, 1) return x ^ (p or 2) end
	function M.backOut(x, s)
		x = math.clamp(x, 0, 1)
		s = s or 1.70158
		local y = x - 1
		return 1 + (s + 1) * y * y * y + s * y * y
	end
	-- 0 before a, rises to 1 over `rise`, stays 1, falls to 0 over `fall` ending at b
	function M.window(t, a, b, rise, fall)
		local up = (rise and rise > 0) and M.smooth((t - a) / rise) or (t >= a and 1 or 0)
		local down = (fall and fall > 0) and (1 - M.smooth((t - (b - fall)) / fall)) or (t <= b and 1 or 0)
		return math.min(up, down)
	end
	-- deterministic noise in -1..1 (same t and seed give the same value)
	function M.noise(t, seed, speed) return math.noise(t * (speed or 1), (seed or 0) * 1.37 + 0.5, 0.71) * 2 end
	function M.deg(x, y, z) return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0)) end
	-- a CFrame standing at pos and facing dir (flattened to the ground plane)
	function M.facing(pos, dir)
		local d = Vector3.new(dir.X, 0, dir.Z)
		if d.Magnitude < 1e-4 then d = Vector3.new(0, 0, -1) end
		return CFrame.lookAt(pos, pos + d.Unit)
	end
	function M.NS(...) -- NS(0.5) or NS({0, 0}, {0.3, 2, 0.2}, {1, 0}) -> NumberSequence
		local a = { ... }
		if #a == 1 and type(a[1]) == "number" then return NumberSequence.new(a[1]) end
		local k = {}
		for _, v in ipairs(a) do table.insert(k, NumberSequenceKeypoint.new(v[1], v[2], v[3] or 0)) end
		return NumberSequence.new(k)
	end
	function M.CS(...) -- CS(color) or CS({0, c0}, {1, c1}) -> ColorSequence
		local a = { ... }
		if #a == 1 and typeof(a[1]) == "Color3" then return ColorSequence.new(a[1]) end
		local k = {}
		for _, v in ipairs(a) do table.insert(k, ColorSequenceKeypoint.new(v[1], v[2])) end
		return ColorSequence.new(k)
	end

	-- ============================================================================================ studio helpers
	-- delete LAB_* folders left by earlier tests (Workspace, ServerStorage, ReplicatedStorage), except `keep`
	function M.cleanLab(keep)
		local n = 0
		for _, svc in ipairs({ workspace, game:GetService("ServerStorage"), game:GetService("ReplicatedStorage") }) do
			for _, c in ipairs(svc:GetChildren()) do
				if c.Name:sub(1, 4) == "LAB_" and c.Name ~= keep then
					c:Destroy()
					n += 1
				end
			end
		end
		return n
	end
	-- Lighting: the place's own day scene or a dark stage. Match the reference's lighting before comparing (the
	-- gallery sheets were shot on a dark stage, which flatters additive layers); check the final in daylight after.
	-- Stage.light("dark", opts?) saves the place's Lighting once and sets ClockTime 21 (opts.clock, opts.brightness,
	-- opts.ambient, opts.exposure override); Stage.light("day") puts the saved values back. Survives re-running final.luau.
	local LIGHT_PROPS = { "ClockTime", "Brightness", "Ambient", "OutdoorAmbient", "ExposureCompensation" }
	function M.light(mode, opts)
		opts = opts or {}
		local Lighting = game:GetService("Lighting")
		if mode == "dark" then
			if not _G.__vfxmithDayLight then
				local saved = {}
				for _, k in ipairs(LIGHT_PROPS) do saved[k] = Lighting[k] end
				_G.__vfxmithDayLight = saved
			end
			Lighting.ClockTime = opts.clock or 21
			if opts.brightness then Lighting.Brightness = opts.brightness end
			if opts.ambient then
				Lighting.Ambient = opts.ambient
				Lighting.OutdoorAmbient = opts.ambient
			end
			if opts.exposure then Lighting.ExposureCompensation = opts.exposure end
			return "dark stage (ClockTime " .. Lighting.ClockTime .. ")"
		elseif mode == "day" then
			local saved = _G.__vfxmithDayLight
			if not saved then return "day: already the place's own lighting" end
			for k, v in pairs(saved) do Lighting[k] = v end
			_G.__vfxmithDayLight = nil
			return "day: place lighting restored"
		end
		error("Stage.light: mode is \"dark\" or \"day\"")
	end

	-- point the Edit camera (screen_capture also takes camera_position / look_at_position directly)
	function M.camera(from, at, fov)
		local cam = workspace.CurrentCamera
		cam.FieldOfView = fov or 70
		cam.CFrame = CFrame.lookAt(from, at)
		cam.Focus = CFrame.new(at)
	end

	-- ============================================================================================ R15 dummy
	-- Joints are posed by forward kinematics on anchored parts: part1 = part0 * C0 * rotation * C1:Inverse().
	-- Joint names are the R15 Motor6D names: Root, Waist, Neck, Left/Right Shoulder, Elbow, Wrist, Hip, Knee, Ankle.
	local GREY = Color3.fromRGB(163, 162, 165)
	local BLOCK = { -- name, size, centre (rig standing on y = 0, facing -Z; its right hand is on +X)
		{ "HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(0, 3.0, 0) },
		{ "LowerTorso", Vector3.new(2, 0.4, 1), Vector3.new(0, 2.4, 0) },
		{ "UpperTorso", Vector3.new(2, 1.6, 1), Vector3.new(0, 3.4, 0) },
		{ "Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 4.8, 0) },
	}
	local BLOCK_JOINTS = {
		{ "Root", "HumanoidRootPart", "LowerTorso", Vector3.new(0, 2.4, 0) },
		{ "Waist", "LowerTorso", "UpperTorso", Vector3.new(0, 2.6, 0) },
		{ "Neck", "UpperTorso", "Head", Vector3.new(0, 4.2, 0) },
	}
	for _, s in ipairs({ { "Left", -1 }, { "Right", 1 } }) do
		local n, x = s[1], s[2]
		table.insert(BLOCK, { n .. "UpperArm", Vector3.new(1, 1.2, 1), Vector3.new(1.5 * x, 3.6, 0) })
		table.insert(BLOCK, { n .. "LowerArm", Vector3.new(1, 1.0, 1), Vector3.new(1.5 * x, 2.5, 0) })
		table.insert(BLOCK, { n .. "Hand", Vector3.new(1, 0.4, 1), Vector3.new(1.5 * x, 1.8, 0) })
		table.insert(BLOCK, { n .. "UpperLeg", Vector3.new(1, 0.95, 1), Vector3.new(0.5 * x, 1.725, 0) })
		table.insert(BLOCK, { n .. "LowerLeg", Vector3.new(1, 0.95, 1), Vector3.new(0.5 * x, 0.775, 0) })
		table.insert(BLOCK, { n .. "Foot", Vector3.new(1, 0.3, 1), Vector3.new(0.5 * x, 0.15, 0) })
		table.insert(BLOCK_JOINTS, { n .. "Shoulder", "UpperTorso", n .. "UpperArm", Vector3.new(1.5 * x, 4.0, 0) })
		table.insert(BLOCK_JOINTS, { n .. "Elbow", n .. "UpperArm", n .. "LowerArm", Vector3.new(1.5 * x, 3.0, 0) })
		table.insert(BLOCK_JOINTS, { n .. "Wrist", n .. "LowerArm", n .. "Hand", Vector3.new(1.5 * x, 2.0, 0) })
		table.insert(BLOCK_JOINTS, { n .. "Hip", "LowerTorso", n .. "UpperLeg", Vector3.new(0.5 * x, 2.2, 0) })
		table.insert(BLOCK_JOINTS, { n .. "Knee", n .. "UpperLeg", n .. "LowerLeg", Vector3.new(0.5 * x, 1.25, 0) })
		table.insert(BLOCK_JOINTS, { n .. "Ankle", n .. "LowerLeg", n .. "Foot", Vector3.new(0.5 * x, 0.3, 0) })
	end

	local function blockRig(color)
		local m = Instance.new("Model")
		m.Name = "Dummy"
		local parts = {}
		for _, b in ipairs(BLOCK) do
			local p = Instance.new("Part")
			p.Name = b[1]
			p.Size = b[2]
			p.CFrame = CFrame.new(b[3])
			p.Color = color
			p.Material = Enum.Material.SmoothPlastic
			p.TopSurface = Enum.SurfaceType.Smooth
			p.BottomSurface = Enum.SurfaceType.Smooth
			p.Parent = m
			parts[b[1]] = p
		end
		parts.HumanoidRootPart.Transparency = 1
		local hm = Instance.new("SpecialMesh")
		hm.MeshType = Enum.MeshType.Head
		hm.Parent = parts.Head
		local face = Instance.new("Decal")
		face.Name = "face"
		face.Texture = "rbxasset://textures/face.png"
		face.Face = Enum.NormalId.Front
		face.Parent = parts.Head
		for _, j in ipairs(BLOCK_JOINTS) do
			local p0, p1 = parts[j[2]], parts[j[3]]
			local pivot = CFrame.new(j[4])
			local mo = Instance.new("Motor6D")
			mo.Name = j[1]
			mo.Part0 = p0
			mo.Part1 = p1
			mo.C0 = p0.CFrame:ToObjectSpace(pivot)
			mo.C1 = p1.CFrame:ToObjectSpace(pivot)
			mo.Parent = p1
		end
		local hum = Instance.new("Humanoid")
		hum.RigType = Enum.HumanoidRigType.R15
		hum.Parent = m
		m.PrimaryPart = parts.HumanoidRootPart
		return m
	end

	local templates = {}
	local function rigTemplate(color)
		local key = tostring(color)
		if templates[key] and templates[key].Parent ~= nil then return templates[key] end
		local m
		local ok = pcall(function()
			local d = Instance.new("HumanoidDescription")
			d.HeadColor, d.TorsoColor = color, color
			d.LeftArmColor, d.RightArmColor = color, color
			d.LeftLegColor, d.RightLegColor = color, color
			m = Players:CreateHumanoidModelFromDescription(d, Enum.HumanoidRigType.R15)
		end)
		if not ok or not m or not m:FindFirstChild("HumanoidRootPart") then
			m = blockRig(color) -- same joint names, so poses work on both
		end
		m.Name = "Dummy"
		local anim = m:FindFirstChild("Animate")
		if anim then anim:Destroy() end
		local hum = m:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			pcall(function() hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff end)
		end
		for _, x in ipairs(m:GetDescendants()) do
			if x:IsA("BasePart") then
				x.Anchored = true
				x.CanCollide = false
				x.CanQuery = false
				x.CanTouch = false
			end
		end
		-- the template stays out of the world: in ServerStorage, under a LAB_ folder
		local ss = game:GetService("ServerStorage")
		local f = ss:FindFirstChild("LAB_stage_rigs") or Instance.new("Folder")
		f.Name = "LAB_stage_rigs"
		f.Parent = ss
		m.Parent = f
		templates[key] = m
		return m
	end

	local Rig = {}
	Rig.__index = Rig

	local function newRig(parent, opts)
		opts = opts or {}
		local m = rigTemplate(opts.color or GREY):Clone()
		m.Name = opts.name or "Dummy"
		local hrp = m:FindFirstChild("HumanoidRootPart")
		local parts, motors, kids = {}, {}, {}
		for _, x in ipairs(m:GetDescendants()) do
			if x:IsA("BasePart") then parts[x.Name] = x end
		end
		for _, x in ipairs(m:GetDescendants()) do
			if x:IsA("Motor6D") and x.Part0 and x.Part1 then
				local j = { name = x.Name, p0 = x.Part0, p1 = x.Part1, c0 = x.C0, c1i = x.C1:Inverse() }
				motors[x.Name] = j
				kids[x.Part0] = kids[x.Part0] or {}
				table.insert(kids[x.Part0], j)
				x.Enabled = false -- every part is placed directly; the joint only keeps its rest data
			end
		end
		-- the root's offset from the ground point between the feet, measured in the rest pose
		local bottom, top = math.huge, -math.huge
		for _, p in pairs(parts) do
			if p ~= hrp then
				bottom = math.min(bottom, p.Position.Y - p.Size.Y / 2)
				top = math.max(top, p.Position.Y + p.Size.Y / 2)
			end
		end
		local size = Vector3.new(0, top - bottom, 0)
		local h = hrp.CFrame
		local ground = CFrame.new(h.Position.X, bottom, h.Position.Z) * (h - h.Position)
		local self = setmetatable({
			model = m, parts = parts, motors = motors, kids = kids, hrp = hrp,
			rootOffset = ground:ToObjectSpace(h), height = size.Y,
		}, Rig)
		m.Parent = parent
		self:pose(opts.at or CFrame.new())
		return self
	end

	-- pose(groundCF, joints): groundCF = the point between the feet, facing its LookVector (a dummy at CFrame.new(p)
	-- faces -Z). joints = { RightShoulder = Stage.deg(90, 0, 0), ... } rotations in the joint's own frame; missing = rest.
	function Rig:pose(groundCF, joints)
		joints = joints or {}
		local list, cfs = {}, {}
		local root = groundCF * self.rootOffset
		local placed = { [self.hrp] = root }
		table.insert(list, self.hrp)
		table.insert(cfs, root)
		local queue, qi = { self.hrp }, 1
		while qi <= #queue do
			local p0 = queue[qi]
			qi += 1
			for _, j in ipairs(self.kids[p0] or {}) do
				if not placed[j.p1] then
					local cf = placed[p0] * j.c0 * (joints[j.name] or CFrame.new()) * j.c1i
					placed[j.p1] = cf
					table.insert(list, j.p1)
					table.insert(cfs, cf)
					table.insert(queue, j.p1)
				end
			end
		end
		local ok = pcall(function() workspace:BulkMoveTo(list, cfs, Enum.BulkMoveMode.FireCFrameChanged) end)
		if not ok then
			for i, p in ipairs(list) do p.CFrame = cfs[i] end
		end
		self.ground = groundCF
		return self
	end

	-- keys({ {t = 0, at = CFrame, j = {...}, ease = "smooth"|"linear"|"out"|"in"}, ... }) -> function(t) that poses
	-- the rig between the keys (each key's `ease` shapes the blend INTO it). `at` missing = the previous key's.
	function Rig:keys(list)
		table.sort(list, function(a, b) return a.t < b.t end)
		local last = list[1].at or CFrame.new()
		for _, k in ipairs(list) do
			k.at = k.at or last
			k.j = k.j or {}
			last = k.at
		end
		local E = { linear = function(u) return u end, smooth = M.smooth, out = M.easeOut, ["in"] = M.easeIn }
		return function(t)
			local a, b = list[1], list[#list]
			if t <= a.t then return self:pose(a.at, a.j) end
			if t >= b.t then return self:pose(b.at, b.j) end
			for i = 1, #list - 1 do
				if t >= list[i].t and t <= list[i + 1].t then
					a, b = list[i], list[i + 1]
					break
				end
			end
			local u = (E[b.ease or "smooth"] or M.smooth)((t - a.t) / math.max(b.t - a.t, 1e-6))
			local j = {}
			for n, c in pairs(a.j) do j[n] = c:Lerp(b.j[n] or CFrame.new(), u) end
			for n, c in pairs(b.j) do
				if not a.j[n] then j[n] = CFrame.new():Lerp(c, u) end
			end
			return self:pose(a.at:Lerp(b.at, u), j)
		end
	end

	-- world position of a part's point (e.g. the right hand), useful to attach effects to a moving dummy
	function Rig:point(partName, offset)
		local p = self.parts[partName]
		return p.CFrame * (offset or Vector3.zero)
	end

	-- ============================================================================================ play context
	local Ctx = {}
	Ctx.__index = Ctx

	local function prop(inst, props)
		for k, v in pairs(props or {}) do
			if k ~= "Parent" then inst[k] = v end
		end
		return inst
	end

	function Ctx:add(class, props, parent)
		local i = Instance.new(class)
		prop(i, props)
		i.Parent = parent or (props and props.Parent) or self.root
		if i:IsA("ParticleEmitter") then table.insert(self.emitters, i) end
		return i
	end

	function Ctx:part(props)
		local p = Instance.new("Part")
		p.Anchored = true
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.CastShadow = false
		p.Material = Enum.Material.SmoothPlastic
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Size = Vector3.new(1, 1, 1)
		prop(p, props)
		p.Parent = (props and props.Parent) or self.root
		return p
	end

	-- every frame: fn(t). Return nothing.
	function Ctx:on(fn) table.insert(self.updaters, fn) end
	-- once, when the clock passes `time`: fn(t). In a jump to freezeAt every event up to it fires, in order.
	function Ctx:at(time, fn)
		table.insert(self.events, { t = time, fn = fn })
		table.sort(self.events, function(a, b) return a.t < b.t end)
	end

	-- a normal ParticleEmitter (Rate, Emit, Enabled as usual). Freezes with TimeScale 0. Plays with these make the
	-- clock run in real time up to freezeAt, so the particles have their real age there.
	function Ctx:emitter(parent, props)
		local e = Instance.new("ParticleEmitter")
		e.Rate = 0
		prop(e, props)
		e.Parent = parent
		table.insert(self.emitters, e)
		self.live = true
		return e
	end

	-- driven sprite: one particle placed by code every frame (position, size, transparency, colour, rotation), so it
	-- shows the same at any t, also where Edit-mode particles never age. Flipbooks show their first cell.
	-- opts: lightEmission, brightness, lightInfluence (0), zOffset, color, flat (lies in the plane of opts.cf / set{cf}),
	-- squash (number), orientation (Enum.ParticleOrientation).
	local Sprite = {}
	Sprite.__index = Sprite
	function Ctx:sprite(texture, opts)
		opts = opts or {}
		local a = Instance.new("Attachment")
		a.Parent = self.anchor
		local e = Instance.new("ParticleEmitter")
		e.Texture = texture
		e.Rate = 0
		e.Lifetime = NumberRange.new(20)
		e.Speed = NumberRange.new(opts.flat and 0.001 or 0)
		e.SpreadAngle = Vector2.new(0, 0)
		e.Drag = 0
		e.Acceleration = Vector3.zero
		e.RotSpeed = NumberRange.new(0)
		e.LightEmission = opts.lightEmission or 0
		e.LightInfluence = opts.lightInfluence or 0
		e.Brightness = opts.brightness or 1
		e.ZOffset = opts.zOffset or 0
		e.Color = ColorSequence.new(opts.color or Color3.new(1, 1, 1))
		e.EmissionDirection = Enum.NormalId.Top
		if opts.squash then e.Squash = NumberSequence.new(opts.squash) end
		if opts.flat then
			e.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		elseif opts.orientation then
			e.Orientation = opts.orientation
		end
		e.Parent = a
		table.insert(self.emitters, e)
		if opts.cf then a.WorldCFrame = opts.cf end
		return setmetatable({ a = a, e = e, vis = false }, Sprite)
	end
	-- s:set({ pos = Vector3 | cf = CFrame, size = number, transparency = 0..1, color = Color3, rotation = degrees,
	--          brightness = number, lightEmission = number })
	function Sprite:set(o)
		local tr = o.transparency or 0
		local size = o.size or 1
		if tr >= 0.995 or size <= 0.01 then return self:hide() end
		local e = self.e
		if o.cf then self.a.WorldCFrame = o.cf elseif o.pos then self.a.WorldPosition = o.pos end
		e.Size = NumberSequence.new(size)
		e.Transparency = NumberSequence.new(math.clamp(tr, 0, 1))
		if o.color then e.Color = ColorSequence.new(o.color) end
		e.Rotation = NumberRange.new(o.rotation or 0)
		if o.brightness then e.Brightness = o.brightness end
		if o.lightEmission then e.LightEmission = o.lightEmission end
		e:Clear()
		e:Emit(1)
		self.vis = true
		return self
	end
	function Sprite:hide()
		if self.vis then
			self.e:Clear()
			self.vis = false
		end
		return self
	end

	-- decal on an invisible plate: a flat image on the ground (or any plane) that never tilts or clips.
	-- opts: color, face (Enum.NormalId.Top). d:set({ cf = CFrame (plate centre; image on its top face), size =
	-- number | Vector2, transparency = 0..1, color = Color3, rotation = degrees about the plate's up axis })
	local Plate = {}
	Plate.__index = Plate
	function Ctx:decal(texture, opts)
		opts = opts or {}
		local p = self:part({ Name = "Plate", Size = Vector3.new(1, 0.05, 1), Transparency = 1 })
		local d = Instance.new("Decal")
		d.Texture = texture
		d.Face = opts.face or Enum.NormalId.Top
		d.Color3 = opts.color or Color3.new(1, 1, 1)
		d.Transparency = 1
		d.Parent = p
		return setmetatable({ p = p, d = d }, Plate)
	end
	function Plate:set(o)
		local size = o.size or 1
		local sx, sz = size, size
		if typeof(size) == "Vector2" then sx, sz = size.X, size.Y end
		self.p.Size = Vector3.new(math.max(sx, 0.01), 0.05, math.max(sz, 0.01))
		local cf = o.cf or CFrame.new(o.pos or self.p.Position)
		self.p.CFrame = cf * CFrame.Angles(0, math.rad(o.rotation or 0), 0)
		self.d.Transparency = math.clamp(o.transparency or 0, 0, 1)
		if o.color then self.d.Color3 = o.color end
		return self
	end

	function Ctx:dummy(opts)
		local r = newRig(self.root, opts)
		table.insert(self.rigs, r)
		return r
	end

	local function freeze(S)
		for _, d in ipairs(S.root:GetDescendants()) do
			if d:IsA("ParticleEmitter") then
				d.TimeScale = 0
				if d.Rate > 0 then d.Enabled = false end
			elseif d:IsA("Beam") or d:IsA("Trail") then
				pcall(function() d.TextureSpeed = 0 end)
			end
		end
	end

	-- ============================================================================================ define
	function M.define(def)
		assert(type(def) == "table" and type(def.build) == "function", "Stage.define{ name, length, build }")
		local name = def.name or "LAB_stage"
		local length = def.length or 3
		local playG, stopG = def.play or "BlindTestPlay", def.stop or "BlindTestStop"
		if type(_G[stopG]) == "function" then pcall(_G[stopG]) end -- a previous run of the file
		local home = workspace:FindFirstChild(name)
		if not home then
			home = Instance.new("Folder")
			home.Name = name
			home.Parent = workspace
		end
		for _, c in ipairs(home:GetChildren()) do
			if c.Name == "Play" then c:Destroy() end
		end

		local stage = { name = name, length = length, home = home, token = 0 }

		function stage.stop()
			stage.token += 1
			if stage.conn then
				stage.conn:Disconnect()
				stage.conn = nil
			end
			for _, c in ipairs(home:GetChildren()) do
				if c.Name == "Play" then c:Destroy() end
			end
			stage.S = nil
		end

		local function step(S, t)
			S.t = t
			while S.nextEvent <= #S.events and S.events[S.nextEvent].t <= t do
				local ev = S.events[S.nextEvent]
				S.nextEvent += 1
				ev.fn(t)
			end
			for _, fn in ipairs(S.updaters) do fn(t) end
			if def.update then def.update(S, t) end
		end

		-- play(origin, freezeAt?): with freezeAt, returns once everything holds still at exactly that effect time
		function stage.play(origin, freezeAt)
			stage.stop()
			local token = stage.token
			origin = origin or Vector3.zero
			local root = Instance.new("Folder")
			root.Name = "Play"
			root.Parent = home
			local anchor = Instance.new("Part")
			anchor.Name = "SpriteAnchor"
			anchor.Anchored = true
			anchor.CanCollide = false
			anchor.CanQuery = false
			anchor.CanTouch = false
			anchor.CastShadow = false
			anchor.Transparency = 1
			anchor.Size = Vector3.new(0.2, 0.2, 0.2)
			anchor.CFrame = CFrame.new()
			anchor.Parent = root
			local S = setmetatable({
				origin = origin, cf = CFrame.new(origin), root = root, anchor = anchor, length = length,
				updaters = {}, events = {}, nextEvent = 1, emitters = {}, rigs = {}, live = false, t = 0,
				rng = Random.new(def.seed or 20261119), stage = stage,
			}, Ctx)
			stage.S = S
			def.build(S)
			if def.live ~= nil then S.live = def.live end

			if freezeAt and not S.live then
				-- every layer is a function of t: jump straight to the moment
				step(S, math.max(0, freezeAt))
				freeze(S)
				RunService.Heartbeat:Wait()
				RunService.Heartbeat:Wait()
				return S
			end

			local done = false
			local t0 = os.clock()
			local speed = def.speed or 1
			step(S, 0)
			stage.conn = RunService.Heartbeat:Connect(function()
				if stage.token ~= token then return end
				local t = (os.clock() - t0) * speed
				if freezeAt and t >= freezeAt then
					step(S, freezeAt)
					freeze(S)
					stage.conn:Disconnect()
					stage.conn = nil
					done = true
				elseif not freezeAt and t >= length then
					step(S, length)
					stage.conn:Disconnect()
					stage.conn = nil
					if not def.keep then stage.stop() end
				else
					step(S, t)
				end
			end)
			if freezeAt then
				local limit = os.clock() + freezeAt / speed + 30
				while not done and stage.token == token and os.clock() < limit do
					RunService.Heartbeat:Wait()
				end
				RunService.Heartbeat:Wait()
			end
			return S
		end

		-- jump(t): show effect time t at once (no real-time run, even with normal emitters). Handy for quick looks.
		function stage.jump(origin, t)
			local live = def.live
			def.live = false
			local ok, S = pcall(stage.play, origin, t)
			def.live = live
			if not ok then error(S, 0) end
			return S
		end

		_G[playG] = function(origin, freezeAt) stage.play(origin, freezeAt) end
		_G[stopG] = function() stage.stop() end
		return stage
	end

	return M
end)()
