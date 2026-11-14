-- Dev-only capture harness for the VFX pipeline (skill roblox-vfx-pipeline). Lives in the place being worked on as
-- ServerStorage.VFXDev.VFXCapture, next to VFXDev.VFXTimeline (the runtime), VFXDev.Effects (spec ModuleScripts) and
-- VFXDev.Assets (template MeshParts). In a game that ships effects, the runtime/specs/assets can live in
-- ReplicatedStorage instead: the lookups below fall back to a search there. Runs in Studio EDIT mode through the MCP
-- execute_luau tool, no Play needed:
--
--   local C = require(game.ServerStorage.VFXDev.VFXCapture:Clone())
--   C.stage("void")                                   -- black box stage far above the map (or "day", or "none")
--   C.camera({ dist = 15.5, height = 3.7, lookUp = 2.75, fov = 70 })
--   C.playLater("VoidRend", 1.5)                      -- video: start the recorder now, the effect plays in 1.5 s
--   return C.stills("VoidRend", { times = {0.03, 0.1, ...}, hold = 2.5, gap = 0.3, lead = 8, seed = 7 })
--     -> start epoch ms + marker pixels; then run kit/scripts/stills.py with the SAME times/hold/gap and those values
--   C.hold("VoidRend", 0.3)                           -- ANY OS: freeze at t, then MCP screen_capture (see hold())
--   C.clear()                                         -- remove the stage, restore the camera
--
-- Stills schedule (shared with stills.py): play k starts at S_k (S_0 = start, S_k+1 = S_k + (t_k + hold + gap) s) and
-- freezes at effect time t_k for `hold` seconds; stills.py shoots during the hold until the marker cubes show k.
-- Specs and the runtime are required from CLONES so every call picks up the latest source.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local VFXCapture = {}
-- State that must survive between MCP calls (each call requires a fresh clone of this module).
_G.__VFXCapture = _G.__VFXCapture or {}
local S = _G.__VFXCapture
VFXCapture.Origin = Vector3.new(0, 3000, 0) -- void stage centre (far above the map)
VFXCapture.DayOrigin = Vector3.new(1200, 3000, 0)

local function fresh(module)
	return require(module:Clone())
end

local function dev()
	return game:GetService("ServerStorage"):FindFirstChild("VFXDev")
end

local function findModule(folder, name)
	local m = folder and folder:FindFirstChild(name, true)
	if m and m:IsA("ModuleScript") then return m end
	return nil
end

-- The runtime (VFXDev.VFXTimeline, else the first ModuleScript named VFXTimeline in ReplicatedStorage), with its
-- template folder pointed at VFXDev.Assets (else ReplicatedStorage.VFXAssets).
function VFXCapture.runtime()
	local m = findModule(dev(), "VFXTimeline") or findModule(ReplicatedStorage, "VFXTimeline")
	assert(m, "no VFXTimeline runtime in ServerStorage.VFXDev or ReplicatedStorage")
	local VFX = fresh(m)
	VFX.Assets = (dev() and dev():FindFirstChild("Assets")) or ReplicatedStorage:FindFirstChild("VFXAssets")
	return VFX
end

-- An effect spec by name (VFXDev.Effects.<name>, else a ModuleScript of that name in ReplicatedStorage) or a table.
function VFXCapture.spec(name)
	if type(name) == "table" then return name end
	local d = dev()
	local m = findModule(d and d:FindFirstChild("Effects"), name) or findModule(ReplicatedStorage, name)
	return fresh(m or error("no effect spec named " .. tostring(name)))
end

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

-- "void": a black box (floor, walls, ceiling) so only the effect shows, like a VFX showcase.
-- "day": a dark grey floor under the place's own sky and lighting (daylight readability check).
-- "none": no stage (play at a real spot in the map with C.origin = <Vector3>).
function VFXCapture.stage(kind)
	VFXCapture.clearStage()
	S.kind = kind
	if kind == "none" then return "no stage" end
	local folder = Instance.new("Folder")
	folder.Name = "VFXStage"
	if kind == "void" then
		-- Neon black renders black whatever the place's lighting is (SmoothPlastic picks up ambient and haze).
		local o, black, R = VFXCapture.Origin, Color3.new(0, 0, 0), 70
		block(folder, Vector3.new(2 * R, 2, 2 * R), CFrame.new(o - Vector3.new(0, 1, 0)), black, true)
		block(folder, Vector3.new(2 * R, 2, 2 * R), CFrame.new(o + Vector3.new(0, 70, 0)), black, true)
		for _, z in ipairs({ -R, R }) do
			block(folder, Vector3.new(2 * R, 140, 2), CFrame.new(o + Vector3.new(0, 35, z)), black, true)
		end
		for _, x in ipairs({ -R, R }) do
			block(folder, Vector3.new(2, 140, 2 * R), CFrame.new(o + Vector3.new(x, 35, 0)), black, true)
		end
		S.origin = o
	else
		local o = VFXCapture.DayOrigin
		block(folder, Vector3.new(600, 2, 600), CFrame.new(o - Vector3.new(0, 1, 0)), Color3.fromRGB(30, 30, 36))
		S.origin = o
	end
	folder.Parent = Workspace
	return "stage " .. kind .. " at " .. tostring(S.origin)
end

-- Camera looking at the effect origin from the front (-Z side by default).
function VFXCapture.camera(o)
	o = o or {}
	local cam = Workspace.CurrentCamera
	if not S.savedCamera then S.savedCamera = { cam.CFrame, cam.FieldOfView } end
	local origin = S.origin or VFXCapture.Origin
	local yaw = math.rad(o.yaw or 0)
	local dist = o.dist or 34
	local pos = origin + Vector3.new(math.sin(yaw) * dist, o.height or 4, -math.cos(yaw) * dist)
	cam.FieldOfView = o.fov or 70
	cam.CFrame = CFrame.lookAt(pos, origin + Vector3.new(0, o.lookUp or 6, 0))
	-- Studio's edit camera re-aims at Focus: put it on the look point or the view swings away after a moment
	cam.Focus = CFrame.new(origin + Vector3.new(0, o.lookUp or 6, 0))
	return "camera at " .. tostring(pos)
end

-- Plays `spec` once at full speed (for a quick look or a video capture). Returns the handle.
function VFXCapture.play(spec, o)
	o = o or {}
	local VFX = VFXCapture.runtime()
	return VFX.play(VFXCapture.spec(spec), CFrame.new(o.origin or S.origin or VFXCapture.Origin),
		{ important = true, seed = o.seed, scale = o.scale, speed = o.speed, noGrade = o.noGrade })
end

-- Video capture: returns at once and plays the effect `delay` seconds later (start the screen recorder in between).
function VFXCapture.playLater(spec, delay, o)
	local VFX = VFXCapture.runtime()
	local resolved = VFXCapture.spec(spec)
	VFX.preload(resolved)
	o = o or {}
	task.delay(delay or 1.5, function()
		VFX.play(resolved, CFrame.new(o.origin or S.origin or VFXCapture.Origin),
			{ important = true, seed = o.seed or 7, scale = o.scale, speed = o.speed, noGrade = o.noGrade })
	end)
	return "plays in " .. tostring(delay or 1.5) .. " s, lasts " .. string.format("%.2f", VFX.length(resolved)) .. " s"
end

local function waitUntil(ms)
	while DateTime.now().UnixTimestampMillis < ms do task.wait() end
end

-- Schedules the freeze-frame sequence (see the header) and returns immediately with the start time.
-- Five small cubes in the top-left corner of the view (outside the compare crop) show the still's number k (1-based,
-- binary, white = 1, black = 0; all black = the empty stage). A hidden Studio window only redraws about once a second,
-- so stills.py re-shoots until the cubes match k: a stale frame can never be saved as the wrong time.
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

function VFXCapture.stills(specName, o)
	local VFX = VFXCapture.runtime()
	local spec = VFXCapture.spec(specName)
	VFX.preload(spec)
	local times, hold, gap = o.times, o.hold or 2.5, o.gap or 0.3
	local start = DateTime.now().UnixTimestampMillis + math.floor((o.lead or 12) * 1000)
	local origin = CFrame.new(o.origin or S.origin or VFXCapture.Origin)
	local cubes, pixels = markers()
	S.running = true
	task.spawn(function()
		local s = start
		for k, t in ipairs(times) do
			waitUntil(s)
			local h = VFX.play(spec, origin, { important = true, seed = o.seed or 7, scale = o.scale, freezeAt = t, noGrade = o.noGrade })
			waitUntil(s + t * 1000)
			showIndex(cubes, k % 32)
			waitUntil(s + (t + hold) * 1000)
			h.stop()
			showIndex(cubes, 0)
			s += (t + hold + gap) * 1000
		end
		clearMarkers()
		S.running = false
	end)
	local total = 0
	for _, t in ipairs(times) do total += t + hold + gap end
	return HttpService:JSONEncode({ start = start, n = #times, ends = start + math.floor(total * 1000), markers = pixels })
end

-- Many specs in one run (for stills.py --follow, which needs no start time): items = { {name, times, view}, ... },
-- view = { look = Vector3 (offset from the stage origin), dist, yaw = deg, pitch = height/dist } (default from
-- it.radius / o.radius). The camera (and its Focus) is LOCKED to the view every frame while it runs. Each still k
-- (running index, 1-based) shows k % 32 on the marker cubes while frozen. Returns at once; S.batchDone turns true at
-- the end.
local function viewCF(v)
	local o = S.origin or VFXCapture.Origin
	local yaw = math.rad(v.yaw or 25)
	local look = o + (v.look or Vector3.zero)
	local pos = look + Vector3.new(math.sin(yaw) * v.dist, v.dist * (v.pitch or 0.25), -math.cos(yaw) * v.dist)
	return CFrame.lookAt(pos, look), CFrame.new(look)
end

function VFXCapture.defaultView(r)
	return { look = Vector3.new(0, r * 0.3, 0), dist = r / math.tan(math.rad(35)) * 1.1, yaw = 25, pitch = 0.25 }
end

function VFXCapture.batch(items, o)
	o = o or {}
	local VFX = VFXCapture.runtime()
	local hold, gap = o.hold or 1.9, o.gap or 0.3
	local cam = Workspace.CurrentCamera
	if not S.savedCamera then S.savedCamera = { cam.CFrame, cam.FieldOfView } end
	local specs = {}
	for _, it in ipairs(items) do
		specs[it.name] = VFXCapture.spec(it.name)
		VFX.preload(specs[it.name])
	end
	S.batchDone = false
	local wantCF, wantFocus
	local lock = game:GetService("RunService").Heartbeat:Connect(function()
		if wantCF then
			local c = Workspace.CurrentCamera
			if c.CFrame ~= wantCF then c.CFrame = wantCF end
			if c.Focus ~= wantFocus then c.Focus = wantFocus end
			if c.FieldOfView ~= 70 then c.FieldOfView = 70 end
		end
	end)
	S.runId = (S.runId or 0) + 1
	local myRun = S.runId
	task.spawn(function()
		local k = 0
		task.wait(o.lead or 3)
		for _, it in ipairs(items) do
			if S.runId ~= myRun then break end -- VFXCapture.stop() or a newer batch
			wantCF, wantFocus = viewCF(it.view or VFXCapture.defaultView(it.radius or o.radius or 10))
			cam.CFrame, cam.Focus, cam.FieldOfView = wantCF, wantFocus, 70
			task.wait(0.3)
			local cubes = markers()
			for _, t in ipairs(it.times) do
				if S.runId ~= myRun then break end
				k += 1
				local h = VFX.play(specs[it.name], CFrame.new(o.origin or S.origin or VFXCapture.Origin),
					{ important = true, seed = o.seed or 7, freezeAt = t, noGrade = o.noGrade })
				local t0 = os.clock()
				while h.time() < t and os.clock() - t0 < t + 5 do task.wait() end
				task.wait(0.05)
				showIndex(cubes, k % 32)
				task.wait(hold)
				h.stop()
				showIndex(cubes, 0)
				task.wait(gap)
			end
			clearMarkers()
		end
		wantCF = nil
		lock:Disconnect()
		S.batchDone = true
	end)
	return "batch started: " .. #items .. " specs"
end

-- Portable capture (any OS, Studio may be in the background): plays `spec` and FREEZES it at effect time t, and keeps
-- it frozen until the next hold() or clear(). Then take a screenshot with the Studio MCP tool `screen_capture` (it
-- returns the 3D viewport and saves it as a file you can pass to kit/scripts/compare.py). Typical loop:
--   for each t in {0.05, 0.15, 0.3, 0.6, 1.0, 1.6}: C.hold("Name", t) -> wait ~0.3 s -> screen_capture
-- Returns once the frame is built (yields until the effect clock reaches t).
function VFXCapture.hold(specName, t, o)
	o = o or {}
	if S.held then pcall(S.held.stop) S.held = nil end
	local VFX = VFXCapture.runtime()
	local spec = VFXCapture.spec(specName)
	VFX.preload(spec)
	local h = VFX.play(spec, CFrame.new(o.origin or S.origin or VFXCapture.Origin),
		{ important = true, seed = o.seed or 7, scale = o.scale, freezeAt = t, noGrade = o.noGrade })
	S.held = h
	local t0 = os.clock()
	while h.time() < t and os.clock() - t0 < t + 5 do task.wait() end
	task.wait(0.1) -- one more rendered frame at the frozen state
	return string.format("held %s at t=%.3f", tostring(specName), h.time())
end

function VFXCapture.clearStage()
	local old = Workspace:FindFirstChild("VFXStage")
	if old then old:Destroy() end
end

-- Removes the stage, any effect folders left behind, and restores the editor camera.
function VFXCapture.stop()
	S.runId = (S.runId or 0) + 1
	return "stopped"
end

function VFXCapture.clear()
	S.runId = (S.runId or 0) + 1
	if S.held then pcall(S.held.stop) S.held = nil end
	clearMarkers()
	VFXCapture.clearStage()
	for _, f in ipairs(Workspace:GetChildren()) do
		if f:IsA("Folder") and (string.sub(f.Name, 1, 4) == "VFX_" or f.Name == "VFXMarkers") then f:Destroy() end
	end
	for _, e in ipairs(game:GetService("Lighting"):GetChildren()) do
		if string.sub(e.Name, 1, 9) == "VFXGrade_" then e:Destroy() end
	end
	if S.savedCamera then
		local cam = Workspace.CurrentCamera
		cam.CFrame, cam.FieldOfView = S.savedCamera[1], S.savedCamera[2]
		S.savedCamera = nil
	end
	return "cleared"
end

return VFXCapture
