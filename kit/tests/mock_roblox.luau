--!nocheck
-- A tiny stand-in for the Roblox API, enough to run kit/stage.luau and a final.luau under the plain `luau` CLI
-- (no Studio). Fake clock: RunService.Heartbeat:Wait() advances os.clock() by 1/60 s and fires Heartbeat.
-- Used by kit/tests/run.sh. Not shipped into games.

local EPS = 1e-9
_G = {} -- the CLI's own _G is read-only; Studio's is shared between scripts
local function settype(t, name, mt)
	mt.__type = name
	return setmetatable(t, mt)
end
local rawtypeof = typeof
typeof = function(v)
	local mt = type(v) == "table" and getmetatable(v)
	if mt and mt.__type then return mt.__type end
	return rawtypeof(v)
end

-- ===================================================================================== Vector3 / Vector2
local V3 = {}
local function v3(x, y, z) return settype({ X = x or 0, Y = y or 0, Z = z or 0 }, "Vector3", V3) end
V3.__index = function(v, k)
	if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) end
	if k == "Unit" then
		local m = math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z)
		if m < EPS then return v3(0 / 0, 0 / 0, 0 / 0) end
		return v3(v.X / m, v.Y / m, v.Z / m)
	end
	if k == "Dot" then return function(a, b) return a.X * b.X + a.Y * b.Y + a.Z * b.Z end end
	if k == "Cross" then return function(a, b) return v3(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X) end end
	if k == "Lerp" then return function(a, b, u) return a + (b - a) * u end end
	return nil
end
V3.__add = function(a, b) return v3(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
V3.__sub = function(a, b) return v3(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
V3.__unm = function(a) return v3(-a.X, -a.Y, -a.Z) end
V3.__mul = function(a, b)
	if type(a) == "number" then return v3(b.X * a, b.Y * a, b.Z * a) end
	if type(b) == "number" then return v3(a.X * b, a.Y * b, a.Z * b) end
	return v3(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
V3.__div = function(a, b)
	if type(b) == "number" then return v3(a.X / b, a.Y / b, a.Z / b) end
	return v3(a.X / b.X, a.Y / b.Y, a.Z / b.Z)
end
V3.__eq = function(a, b) return a.X == b.X and a.Y == b.Y and a.Z == b.Z end
V3.__tostring = function(a) return string.format("%.3f, %.3f, %.3f", a.X, a.Y, a.Z) end
Vector3 = { new = v3, zero = v3(0, 0, 0), one = v3(1, 1, 1), xAxis = v3(1, 0, 0), yAxis = v3(0, 1, 0), zAxis = v3(0, 0, 1) }

local V2 = {}
V2.__index = V2
Vector2 = { new = function(x, y) return settype({ X = x or 0, Y = y or 0 }, "Vector2", V2) end }

-- ===================================================================================== CFrame
-- r = {{m11,m12,m13},{m21,m22,m23},{m31,m32,m33}}; columns = Right, Up, Back
local CF = {}
local function cf(p, r) return settype({ p = p, r = r }, "CFrame", CF) end
local I3 = { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } }
local function mm(a, b)
	local o = {}
	for i = 1, 3 do
		o[i] = {}
		for j = 1, 3 do o[i][j] = a[i][1] * b[1][j] + a[i][2] * b[2][j] + a[i][3] * b[3][j] end
	end
	return o
end
local function mv(r, v)
	return v3(r[1][1] * v.X + r[1][2] * v.Y + r[1][3] * v.Z, r[2][1] * v.X + r[2][2] * v.Y + r[2][3] * v.Z,
		r[3][1] * v.X + r[3][2] * v.Y + r[3][3] * v.Z)
end
local function tr(r)
	return { { r[1][1], r[2][1], r[3][1] }, { r[1][2], r[2][2], r[3][2] }, { r[1][3], r[2][3], r[3][3] } }
end
local function col(r, j) return v3(r[1][j], r[2][j], r[3][j]) end
local function fromCols(x, y, z) return { { x.X, y.X, z.X }, { x.Y, y.Y, z.Y }, { x.Z, y.Z, z.Z } } end
CF.__index = function(c, k)
	if k == "Position" then return c.p end
	if k == "X" then return c.p.X end
	if k == "Y" then return c.p.Y end
	if k == "Z" then return c.p.Z end
	if k == "LookVector" then return -col(c.r, 3) end
	if k == "RightVector" then return col(c.r, 1) end
	if k == "UpVector" then return col(c.r, 2) end
	if k == "Inverse" then
		return function(a)
			local rt = tr(a.r)
			return cf(-mv(rt, a.p), rt)
		end
	end
	if k == "ToObjectSpace" then return function(a, b) return a:Inverse() * b end end
	if k == "ToWorldSpace" then return function(a, b) return a * b end end
	if k == "PointToWorldSpace" then return function(a, v) return a * v end end
	if k == "PointToObjectSpace" then return function(a, v) return a:Inverse() * v end end
	if k == "VectorToWorldSpace" then return function(a, v) return mv(a.r, v) end end
	if k == "Lerp" then
		return function(a, b, u)
			local r = {}
			for i = 1, 3 do
				r[i] = {}
				for j = 1, 3 do r[i][j] = a.r[i][j] + (b.r[i][j] - a.r[i][j]) * u end
			end
			-- Gram-Schmidt so the result stays a rotation (good enough for tests)
			local x = col(r, 1).Unit
			local y = col(r, 2)
			y = (y - x * x:Dot(y)).Unit
			local z = x:Cross(y)
			return cf(a.p + (b.p - a.p) * u, fromCols(x, y, z))
		end
	end
	return nil
end
CF.__mul = function(a, b)
	if typeof(b) == "Vector3" then return a.p + mv(a.r, b) end
	return cf(a.p + mv(a.r, b.p), mm(a.r, b.r))
end
CF.__add = function(a, v) return cf(a.p + v, a.r) end
CF.__sub = function(a, v) return cf(a.p - v, a.r) end
CF.__tostring = function(a) return "CFrame(" .. tostring(a.p) .. ")" end
local function rx(t) local c, s = math.cos(t), math.sin(t) return { { 1, 0, 0 }, { 0, c, -s }, { 0, s, c } } end
local function ry(t) local c, s = math.cos(t), math.sin(t) return { { c, 0, s }, { 0, 1, 0 }, { -s, 0, c } } end
local function rz(t) local c, s = math.cos(t), math.sin(t) return { { c, -s, 0 }, { s, c, 0 }, { 0, 0, 1 } } end
CFrame = {
	new = function(x, y, z)
		if x == nil then return cf(v3(), I3) end
		if typeof(x) == "Vector3" then return cf(x, I3) end
		return cf(v3(x, y, z), I3)
	end,
	Angles = function(a, b, c) return cf(v3(), mm(mm(rx(a), ry(b)), rz(c))) end,
	fromAxisAngle = function(axis, ang)
		local u = axis.Unit
		local c, s, t = math.cos(ang), math.sin(ang), 1 - math.cos(ang)
		return cf(v3(), {
			{ t * u.X * u.X + c, t * u.X * u.Y - s * u.Z, t * u.X * u.Z + s * u.Y },
			{ t * u.X * u.Y + s * u.Z, t * u.Y * u.Y + c, t * u.Y * u.Z - s * u.X },
			{ t * u.X * u.Z - s * u.Y, t * u.Y * u.Z + s * u.X, t * u.Z * u.Z + c },
		})
	end,
	lookAt = function(at, target, up)
		up = up or v3(0, 1, 0)
		local back = (at - target).Unit
		local right = up:Cross(back).Unit
		local u2 = back:Cross(right)
		return cf(at, fromCols(right, u2, back))
	end,
	fromMatrix = function(p, x, y, z)
		z = z or x:Cross(y)
		return cf(p, fromCols(x, y, z))
	end,
}
CFrame.identity = CFrame.new()

-- ===================================================================================== small value types
local function valtype(name) return function(t) return settype(t, name, { __index = {} }) end end
local C3 = {}
C3.__index = { Lerp = function(a, b, u) return Color3.new(a.R + (b.R - a.R) * u, a.G + (b.G - a.G) * u, a.B + (b.B - a.B) * u) end }
C3.__tostring = function(c) return string.format("%.2f,%.2f,%.2f", c.R, c.G, c.B) end
Color3 = {
	new = function(r, g, b) return settype({ R = r or 0, G = g or 0, B = b or 0 }, "Color3", C3) end,
	fromRGB = function(r, g, b) return Color3.new((r or 0) / 255, (g or 0) / 255, (b or 0) / 255) end,
}
NumberRange = { new = function(a, b) return valtype("NumberRange")({ Min = a, Max = b or a }) end }
NumberSequenceKeypoint = { new = function(t, v, e) return valtype("NumberSequenceKeypoint")({ Time = t, Value = v, Envelope = e or 0 }) end }
NumberSequence = {
	new = function(a, b)
		if type(a) == "number" then
			return valtype("NumberSequence")({ Keypoints = { NumberSequenceKeypoint.new(0, a), NumberSequenceKeypoint.new(1, b or a) } })
		end
		return valtype("NumberSequence")({ Keypoints = a })
	end,
}
ColorSequenceKeypoint = { new = function(t, c) return valtype("ColorSequenceKeypoint")({ Time = t, Value = c }) end }
ColorSequence = {
	new = function(a, b)
		if typeof(a) == "Color3" then
			return valtype("ColorSequence")({ Keypoints = { ColorSequenceKeypoint.new(0, a), ColorSequenceKeypoint.new(1, b or a) } })
		end
		return valtype("ColorSequence")({ Keypoints = a })
	end,
}
Enum = setmetatable({}, {
	__index = function(_, a)
		return setmetatable({}, { __index = function(_, b) return "Enum." .. a .. "." .. b end })
	end,
})
Random = {
	new = function(seed)
		local s = (seed or 1) % 2147483647
		if s <= 0 then s += 2147483646 end
		local function nxt()
			s = (s * 16807) % 2147483647
			return s / 2147483647
		end
		return {
			NextNumber = function(_, a, b) a = a or 0 b = b or 1 return a + (b - a) * nxt() end,
			NextInteger = function(_, a, b) return a + math.floor(nxt() * (b - a + 1)) end,
		}
	end,
}

-- ===================================================================================== clock + signals
local now = 1000
_G.__mockClock = function() return now end
local rawos = os
os = setmetatable({ clock = function() return now end }, { __index = rawos })
local function signal()
	local s = { conns = {} }
	function s:Connect(fn)
		local c = { fn = fn, connected = true }
		function c:Disconnect() self.connected = false end
		table.insert(s.conns, c)
		return c
	end
	function s:Fire(...)
		local list = table.clone(s.conns)
		for _, c in ipairs(list) do
			if c.connected then c.fn(...) end
		end
		local keep = {}
		for _, c in ipairs(s.conns) do
			if c.connected then table.insert(keep, c) end
		end
		s.conns = keep
	end
	return s
end
local Heartbeat = signal()
function Heartbeat:Wait()
	now += 1 / 60
	Heartbeat:Fire(1 / 60)
	return 1 / 60
end
_G.__heartbeats = function(n) for _ = 1, n do Heartbeat:Wait() end end
task = { wait = function() return Heartbeat:Wait() end }

-- ===================================================================================== Instances
local CLASS_BASE = {
	Part = "BasePart", MeshPart = "BasePart", Motor6D = "JointInstance", Weld = "JointInstance",
}
local DEFAULTS = {
	Part = function() return { Size = v3(4, 1, 2), CFrame = CFrame.new(), Transparency = 0, Anchored = false } end,
	ParticleEmitter = function() return { Rate = 5, Enabled = true, TimeScale = 1, Emitted = 0 } end,
	Attachment = function() return { Position = v3(), CFrame = CFrame.new() } end,
	Motor6D = function() return { C0 = CFrame.new(), C1 = CFrame.new(), Enabled = true } end,
	Model = function() return {} end,
	Decal = function() return { Transparency = 0 } end,
	Beam = function() return { TextureSpeed = 1 } end,
}
local Inst = {}
local function isInst(v) return type(v) == "table" and getmetatable(v) == Inst end
local methods = {}
Inst.__index = function(o, k)
	local m = methods[k]
	if m then return m end
	local props = rawget(o, "_p")
	if k == "Position" and props.CFrame then return props.CFrame.p end
	if k == "WorldPosition" and o.ClassName == "Attachment" then
		local par = props.Parent
		return (par and par.CFrame or CFrame.new()) * props.Position
	end
	if k == "WorldCFrame" and o.ClassName == "Attachment" then
		local par = props.Parent
		return (par and par.CFrame or CFrame.new()) * props.CFrame
	end
	local v = props[k]
	if v == nil and o._kids then
		for _, c in ipairs(o._kids) do
			if c.Name == k then return c end
		end
	end
	return v
end
Inst.__newindex = function(o, k, v)
	local props = rawget(o, "_p")
	if k == "Parent" then
		local old = props.Parent
		if old == v then return end
		if old then
			for i, c in ipairs(old._kids) do
				if c == o then table.remove(old._kids, i) break end
			end
		end
		props.Parent = v
		if v then table.insert(v._kids, o) end
		return
	end
	if k == "Position" and props.CFrame and o.ClassName ~= "Attachment" then
		props.CFrame = cf(v, props.CFrame.r)
		return
	end
	if k == "WorldPosition" then
		local par = props.Parent
		props.Position = (par and par.CFrame or CFrame.new()):Inverse() * v
		props.CFrame = cf(props.Position, props.CFrame.r)
		return
	end
	if k == "WorldCFrame" then
		local par = props.Parent
		props.CFrame = (par and par.CFrame or CFrame.new()):Inverse() * v
		props.Position = props.CFrame.p
		return
	end
	if props._destroyed then error("set " .. k .. " on a destroyed instance") end
	props[k] = v
end
Inst.__tostring = function(o) return o.Name end
local function new(class)
	local props = DEFAULTS[class] and DEFAULTS[class]() or {}
	props.ClassName = class
	props.Name = class
	local o = setmetatable({ _p = props, _kids = {} }, Inst)
	return o
end
methods.IsA = function(o, c)
	return o.ClassName == c or CLASS_BASE[o.ClassName] == c or c == "Instance"
end
methods.GetChildren = function(o) return table.clone(o._kids) end
methods.GetDescendants = function(o)
	local out = {}
	local function walk(x)
		for _, c in ipairs(x._kids) do
			table.insert(out, c)
			walk(c)
		end
	end
	walk(o)
	return out
end
methods.FindFirstChild = function(o, n)
	for _, c in ipairs(o._kids) do
		if c.Name == n then return c end
	end
	return nil
end
methods.FindFirstChildOfClass = function(o, n)
	for _, c in ipairs(o._kids) do
		if c.ClassName == n then return c end
	end
	return nil
end
methods.Destroy = function(o)
	for _, c in ipairs(o:GetChildren()) do c:Destroy() end
	o.Parent = nil
	rawget(o, "_p")._destroyed = true
end
methods.Clone = function(o)
	local map = {}
	local function copy(x)
		local n = new(x.ClassName)
		map[x] = n
		for k, v in pairs(rawget(x, "_p")) do
			if k ~= "Parent" then rawget(n, "_p")[k] = v end
		end
		for _, c in ipairs(x._kids) do
			local cc = copy(c)
			cc.Parent = n
		end
		return n
	end
	local root = copy(o)
	for _, n in pairs(map) do
		local p = rawget(n, "_p")
		for k, v in pairs(p) do
			if k ~= "Parent" and isInst(v) and map[v] then p[k] = map[v] end
		end
	end
	return root
end
methods.Emit = function(o, n) rawget(o, "_p").Emitted += (n or 1) end
methods.Clear = function(o) rawget(o, "_p").Emitted = 0 end
methods.GetPivot = function(o)
	local pp = o.PrimaryPart
	return pp and pp.CFrame or CFrame.new()
end
methods.PivotTo = function(o, target)
	local d = target * o:GetPivot():Inverse()
	for _, x in ipairs(o:GetDescendants()) do
		if x:IsA("BasePart") then x.CFrame = d * x.CFrame end
	end
end
methods.GetService = function(o, name) return o._services[name] end
methods.BulkMoveTo = function(_, parts, cfs)
	for i, p in ipairs(parts) do p.CFrame = cfs[i] end
end
methods.SetAttribute = function(o, k, v) rawget(o, "_p")["@" .. k] = v end
methods.GetAttribute = function(o, k) return rawget(o, "_p")["@" .. k] end
Instance = { new = function(class, parent)
	local o = new(class)
	if parent then o.Parent = parent end
	return o
end }

-- ===================================================================================== services
game = new("DataModel")
workspace = new("Workspace")
workspace.Parent = game
workspace.CurrentCamera = new("Camera")
local ServerStorage = new("ServerStorage"); ServerStorage.Parent = game
local ReplicatedStorage = new("ReplicatedStorage"); ReplicatedStorage.Parent = game
local Players = new("Players")
local mockPlayersMode = "fail"
_G.__mockPlayers = function(mode) mockPlayersMode = mode end
local playersApi = setmetatable({}, { __index = function(_, k)
	if k == "CreateHumanoidModelFromDescription" then
		return function()
			if mockPlayersMode == "fail" then error("CreateHumanoidModelFromDescription is not available in the mock") end
			return nil
		end
	end
	return Players[k]
end })
local RunService = { Heartbeat = Heartbeat }
rawset(game, "_services", {
	Workspace = workspace, RunService = RunService, Players = playersApi, ServerStorage = ServerStorage,
	ReplicatedStorage = ReplicatedStorage,
})
