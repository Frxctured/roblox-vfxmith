--[[
	ICE SLAM VFX  (house example: ice-slam-no-plugin)
	Run once in Edit mode (command bar / execute_luau) in any place. It rebuilds the whole effect
	from code: the ground decal textures are drawn into EditableImages, the ice crystals are built
	as EditableMesh MeshParts, particles use Studio's built-in sparkle/smoke textures.
	Nothing is uploaded and no files outside this script are needed.

	Defines:
	  _G.BlindTestPlay(origin: Vector3, freezeAt: number?)
	      Plays the slam once with its base (the ground under the hit) at origin.
	      freezeAt (seconds of effect time, 0..2.5): the whole effect holds still at exactly that
	      time until _G.BlindTestStop(); the call yields until the pose is locked.
	      Calling it again stops the previous play first.
	  _G.BlindTestStop()  stops and removes the current play.

	Timeline: 0.00-0.25 wind-up (frost gathers, ring closes in, fist streak comes down)
	          0.25 impact (white flash, star, shock rings, speed lines, chips, cracks, frost)
	          0.27-0.40 ice spikes burst out in a ~15 stud ring (tallest ~7 studs)
	          0.96-1.12 spikes flash white and shatter into shards
	          1.1-2.5 frost, cracks, small ground crystals and mist linger, then fade by 2.5
]]

if _G.BlindTestStop then pcall(_G.BlindTestStop) end
if _G.IceSlamT then
	for _, img in pairs(_G.IceSlamT) do pcall(function() img:Destroy() end) end
end
if _G.IceSlamM then
	for _, list in pairs(_G.IceSlamM) do
		for _, mp in ipairs(list) do pcall(function() mp:Destroy() end) end
	end
end

local A = (function()
-- ICE SLAM: procedural assets (textures via EditableImage, crystal meshes via EditableMesh)
local AssetService = game:GetService("AssetService")

local A = {}

local function clamp01(x) if x < 0 then return 0 elseif x > 1 then return 1 end return x end
local function smooth(e0, e1, x) local t = clamp01((x - e0) / (e1 - e0)); return t * t * (3 - 2 * t) end
A.clamp01, A.smooth = clamp01, smooth

local function makeNoise(seed, n)
	local r = Random.new(seed)
	local g = table.create(n * n)
	for i = 1, n * n do g[i] = r:NextNumber() end
	return function(x, y)
		local xi, yi = math.floor(x), math.floor(y)
		local fx, fy = x - xi, y - yi
		local x0, y0 = xi % n, yi % n
		local x1, y1 = (x0 + 1) % n, (y0 + 1) % n
		local a, b = g[y0 * n + x0 + 1], g[y0 * n + x1 + 1]
		local c, d = g[y1 * n + x0 + 1], g[y1 * n + x1 + 1]
		local ux, uy = fx * fx * (3 - 2 * fx), fy * fy * (3 - 2 * fy)
		local top = a + (b - a) * ux
		local bot = c + (d - c) * ux
		return top + (bot - top) * uy
	end
end
local function fbm(noise, x, y, oct)
	local s, amp, f, tot = 0, 0.5, 1, 0
	for _ = 1, oct do s += amp * noise(x * f, y * f); tot += amp; amp *= 0.5; f *= 2 end
	return s / tot
end

local function writeImage(w, h, fn)
	local ei = AssetService:CreateEditableImage({ Size = Vector2.new(w, h) })
	local buf = buffer.create(w * h * 4)
	local i = 0
	for y = 0, h - 1 do
		local v = (y + 0.5) / h
		for x = 0, w - 1 do
			local r, g, b, a = fn((x + 0.5) / w, v)
			buffer.writeu8(buf, i, math.floor(clamp01(r) * 255 + 0.5))
			buffer.writeu8(buf, i + 1, math.floor(clamp01(g) * 255 + 0.5))
			buffer.writeu8(buf, i + 2, math.floor(clamp01(b) * 255 + 0.5))
			buffer.writeu8(buf, i + 3, math.floor(clamp01(a) * 255 + 0.5))
			i += 4
		end
		if y % 96 == 95 then task.wait() end
	end
	ei:WritePixelsBuffer(Vector2.zero, Vector2.new(w, h), buf)
	return ei
end

local function writeRGBA(w, h, R, G, B, Al)
	local ei = AssetService:CreateEditableImage({ Size = Vector2.new(w, h) })
	local buf = buffer.create(w * h * 4)
	for k = 1, w * h do
		local i = (k - 1) * 4
		buffer.writeu8(buf, i, math.floor(clamp01(R[k]) * 255 + 0.5))
		buffer.writeu8(buf, i + 1, math.floor(clamp01(G[k]) * 255 + 0.5))
		buffer.writeu8(buf, i + 2, math.floor(clamp01(B[k]) * 255 + 0.5))
		buffer.writeu8(buf, i + 3, math.floor(clamp01(Al[k]) * 255 + 0.5))
	end
	ei:WritePixelsBuffer(Vector2.zero, Vector2.new(w, h), buf)
	return ei
end

function A.buildTextures()
	local T = {}
	local noise = makeNoise(7, 64)

	-- soft round glow
	T.glow = writeImage(128, 128, function(u, v)
		local x, y = u * 2 - 1, v * 2 - 1
		local r = math.sqrt(x * x + y * y)
		local a = clamp01(1 - r)
		return 1, 1, 1, a * a
	end)

	-- shockwave ring: crisp leading edge, soft trailing inside
	T.ring = writeImage(256, 256, function(u, v)
		local x, y = u * 2 - 1, v * 2 - 1
		local r = math.sqrt(x * x + y * y)
		local a = smooth(0.985, 0.955, r) * clamp01((r - 0.72) / 0.235) ^ 1.6
		return 1, 1, 1, a
	end)

	-- thin crisp ring (telegraph)
	T.ringThin = writeImage(256, 256, function(u, v)
		local x, y = u * 2 - 1, v * 2 - 1
		local r = math.sqrt(x * x + y * y)
		local a = smooth(0.84, 0.92, r) * smooth(0.985, 0.955, r)
		return 1, 1, 1, a
	end)

	-- ground frost patch
	T.frost = writeImage(384, 384, function(u, v)
		local x, y = u * 2 - 1, v * 2 - 1
		local r = math.sqrt(x * x + y * y)
		local ang = math.atan2(y, x)
		local ca, sa = math.cos(ang), math.sin(ang)
		local en = fbm(noise, ca * 1.6 + 20, sa * 1.6 + 20, 3)
		local edgeR = 0.8 + (en - 0.5) * 0.36
		local mask = smooth(edgeR + 0.012, edgeR - 0.012, r)
		local spots = smooth(0.6, 0.66, fbm(noise, x * 5 + 31, y * 5 + 7, 2)) * smooth(0.98, 0.85, r)
		mask = math.max(mask, spots)
		local au = (ang / (2 * math.pi) + 0.5) * 64
		local fb = fbm(noise, au, r * 3 + 40, 2)
		local streak = smooth(0.52, 0.72, fb)
		local n2 = fbm(noise, x * 4 + 50, y * 4 + 50, 3)
		local centre = smooth(0.4, 0.0, r)
		local edgeT = smooth(edgeR - 0.25, edgeR, r)
		local R = 0.74 + 0.22 * streak + 0.2 * centre - 0.18 * edgeT
		local G = 0.9 + 0.08 * streak + 0.1 * centre - 0.05 * edgeT
		local B = 1
		local a = mask * clamp01(0.5 + 0.3 * n2 + 0.3 * streak + 0.3 * centre + 0.15 * edgeT)
		return R, G, B, a
	end)

	-- radial ice cracks (deep blue fissures with a cyan rim)
	do
		local W = 512
		local core, halo = table.create(W * W, 0), table.create(W * W, 0)
		local rnd = Random.new(42)
		local function stamp(x0, y0, x1, y1, rc, rh)
			local minx = math.max(0, math.floor(math.min(x0, x1) - rh - 1))
			local maxx = math.min(W - 1, math.ceil(math.max(x0, x1) + rh + 1))
			local miny = math.max(0, math.floor(math.min(y0, y1) - rh - 1))
			local maxy = math.min(W - 1, math.ceil(math.max(y0, y1) + rh + 1))
			local dx, dy = x1 - x0, y1 - y0
			local ll = dx * dx + dy * dy
			for py = miny, maxy do
				for px = minx, maxx do
					local t = ll > 0 and clamp01(((px - x0) * dx + (py - y0) * dy) / ll) or 0
					local qx, qy = x0 + dx * t - px, y0 + dy * t - py
					local d = math.sqrt(qx * qx + qy * qy)
					local k = py * W + px + 1
					local c = clamp01(rc + 0.5 - d)
					if c > core[k] then core[k] = c end
					local h = clamp01(1 - d / rh)
					if h > halo[k] then halo[k] = h end
				end
			end
		end
		local C = W / 2
		local function crack(x, y, ang, steps, thick, depth)
			local radialBias = depth == 0 and 0.5 or 0.15
			for s = 1, steps do
				local rad = math.atan2(y - C, x - C)
				local diff = (rad - ang + math.pi) % (2 * math.pi) - math.pi
				ang += diff * radialBias * 0.3 + rnd:NextNumber(-0.42, 0.42)
				local len = rnd:NextNumber(7, 13)
				local nx, ny = x + math.cos(ang) * len, y + math.sin(ang) * len
				local th = thick * (1 - (s - 1) / steps * 0.75)
				stamp(x, y, nx, ny, th, th + 4.5)
				x, y = nx, ny
				local dist = math.sqrt((x - C) ^ 2 + (y - C) ^ 2)
				if dist > W * 0.47 then break end
				if depth < 2 and s > 2 and rnd:NextNumber() < 0.16 then
					local side = rnd:NextNumber() < 0.5 and -1 or 1
					crack(x, y, ang + side * rnd:NextNumber(0.45, 0.9), math.floor(steps * rnd:NextNumber(0.25, 0.45)), th * 0.7, depth + 1)
				end
			end
		end
		local N = 11
		for k = 1, N do
			local a = (k - 1) / N * 2 * math.pi + rnd:NextNumber(-0.2, 0.2)
			crack(C + math.cos(a) * 10, C + math.sin(a) * 10, a, rnd:NextInteger(17, 24), 2.6, 0)
			task.wait()
		end
		-- a few jagged concentric arcs
		for _, ringR in ipairs({ 0.3, 0.55 }) do
			for _ = 1, 4 do
				local a0 = rnd:NextNumber(0, 2 * math.pi)
				local span = rnd:NextNumber(0.35, 0.8)
				local segs = math.floor(span * 12)
				local px, py
				for s = 0, segs do
					local a = a0 + span * s / segs
					local rr = ringR * C * rnd:NextNumber(0.96, 1.04)
					local x, y = C + math.cos(a) * rr, C + math.sin(a) * rr
					if px then stamp(px, py, x, y, 1.2, 4) end
					px, py = x, y
				end
			end
		end
		local R, G, B, Al = table.create(W * W), table.create(W * W), table.create(W * W), table.create(W * W)
		for k = 1, W * W do
			local c, h = core[k], halo[k]
			local hc = h * h
			R[k] = 0.5 * (1 - c) + 0.08 * c
			G[k] = 0.88 * (1 - c) + 0.24 * c
			B[k] = 1 * (1 - c) + 0.62 * c
			Al[k] = math.max(c * 0.95, hc * 0.7)
		end
		T.cracks = writeRGBA(W, W, R, G, B, Al)
	end
	return T
end

-- crystal meshes ------------------------------------------------------------
local DEEP = Color3.fromRGB(22, 64, 160)
local MID = Color3.fromRGB(60, 150, 240)
local CYAN = Color3.fromRGB(140, 225, 255)
local WHITE = Color3.fromRGB(240, 252, 255)

local function heightColour(y) -- y in [-0.5, 0.5]
	if y < -0.25 then return DEEP:Lerp(MID, (y + 0.5) / 0.25)
	elseif y < 0.1 then return MID:Lerp(CYAN, (y + 0.25) / 0.35)
	else return CYAN:Lerp(WHITE, clamp01((y - 0.1) / 0.4)) end
end

local function finishMesh(em, tris, verts, lift)
	-- normalise into the unit cube so MeshPart.Size maps 1:1
	local mn = Vector3.new(math.huge, math.huge, math.huge)
	local mx = -mn
	for _, p in ipairs(verts) do mn = mn:Min(p); mx = mx:Max(p) end
	local size = mx - mn
	local centre = (mx + mn) / 2
	local norm = {}
	for i, p in ipairs(verts) do
		local q = (p - centre) / size
		norm[i] = q
	end
	local ids = {}
	for i, p in ipairs(norm) do ids[i] = em:AddVertex(p) end
	local function corner(i, tone)
		local c = heightColour(lift and (norm[i].Y * 0.55 + 0.2) or norm[i].Y)
		if tone > 0 then c = c:Lerp(WHITE, tone) elseif tone < 0 then c = c:Lerp(DEEP, -tone) end
		return em:AddColor(c, 1)
	end
	for _, t in ipairs(tris) do
		local a, b, c = norm[t[1]], norm[t[2]], norm[t[3]]
		local n = (b - a):Cross(c - a)
		local centroid = (a + b + c) / 3
		local axisPt = Vector3.new(0, centroid.Y, 0)
		if t.out then axisPt = Vector3.zero end
		local i1, i2, i3 = t[1], t[2], t[3]
		if n:Dot(centroid - axisPt) < 0 then i2, i3 = i3, i2; n = -n end
		local f = em:AddTriangle(ids[i1], ids[i2], ids[i3])
		local nid = em:AddNormal(n.Unit)
		em:SetFaceNormals(f, { nid, nid, nid })
		local tone = t.tone or 0
		em:SetFaceColors(f, { corner(i1, tone), corner(i2, tone), corner(i3, tone) })
	end
end
local TONES = { 0.34, -0.14, 0.16, -0.3, 0.06, -0.08 }

-- tall spike: base ring, shoulder ring, tip; open bottom (always buried)
function A.buildSpikeMesh(seed, sides)
	local r = Random.new(seed)
	local em = AssetService:CreateEditableMesh()
	local verts, tris = {}, {}
	local shY = r:NextNumber(-0.05, 0.12)
	local shR = r:NextNumber(0.6, 0.75)
	for i = 0, sides - 1 do
		local a = (i + r:NextNumber(-0.18, 0.18)) / sides * 2 * math.pi
		local rb = 0.5 * r:NextNumber(0.82, 1)
		verts[#verts + 1] = Vector3.new(math.cos(a) * rb, -0.5, math.sin(a) * rb)
	end
	for i = 0, sides - 1 do
		local b = verts[i + 1]
		local rs = shR * r:NextNumber(0.88, 1.06)
		verts[#verts + 1] = Vector3.new(b.X * rs, shY + r:NextNumber(-0.07, 0.07), b.Z * rs)
	end
	verts[#verts + 1] = Vector3.new(r:NextNumber(-0.05, 0.05), 0.5, r:NextNumber(-0.05, 0.05))
	local tip = #verts
	for i = 1, sides do
		local j = i % sides + 1
		local b1, b2, s1, s2 = i, j, sides + i, sides + j
		local tone = TONES[(i - 1) % #TONES + 1]
		tris[#tris + 1] = { b1, b2, s2, tone = tone }
		tris[#tris + 1] = { b1, s2, s1, tone = tone }
		tris[#tris + 1] = { s1, s2, tip, tone = math.min(0.6, tone + 0.2) }
	end
	finishMesh(em, tris, verts)
	return em
end

-- shard: irregular bipyramid
function A.buildShardMesh(seed, sides)
	local r = Random.new(seed)
	local em = AssetService:CreateEditableMesh()
	local verts, tris = {}, {}
	local midY = r:NextNumber(-0.25, 0.05)
	for i = 0, sides - 1 do
		local a = (i + r:NextNumber(-0.2, 0.2)) / sides * 2 * math.pi
		local rr = 0.5 * r:NextNumber(0.7, 1)
		verts[#verts + 1] = Vector3.new(math.cos(a) * rr, midY + r:NextNumber(-0.08, 0.08), math.sin(a) * rr)
	end
	verts[#verts + 1] = Vector3.new(r:NextNumber(-0.1, 0.1), 0.5, r:NextNumber(-0.1, 0.1))
	verts[#verts + 1] = Vector3.new(r:NextNumber(-0.1, 0.1), -0.5, r:NextNumber(-0.1, 0.1))
	local top, bot = sides + 1, sides + 2
	for i = 1, sides do
		local j = i % sides + 1
		local tone = TONES[(i - 1) % #TONES + 1]
		tris[#tris + 1] = { i, j, top, out = true, tone = tone + 0.1 }
		tris[#tris + 1] = { j, i, bot, out = true, tone = -tone * 0.3 }
	end
	finishMesh(em, tris, verts, true)
	return em
end

function A.buildMeshParts()
	local M = { spikes = {}, shards = {} }
	for k = 1, 6 do
		local em = A.buildSpikeMesh(100 + k, (k % 2 == 0) and 6 or 5)
		local mp = AssetService:CreateMeshPartAsync(Content.fromObject(em), { CollisionFidelity = Enum.CollisionFidelity.Box })
		M.spikes[k] = mp
	end
	for k = 1, 5 do
		local em = A.buildShardMesh(200 + k, (k % 2 == 0) and 4 or 5)
		local mp = AssetService:CreateMeshPartAsync(Content.fromObject(em), { CollisionFidelity = Enum.CollisionFidelity.Box })
		M.shards[k] = mp
	end
	for _, list in pairs(M) do
		for _, mp in ipairs(list) do
			mp.Anchored = true; mp.CanCollide = false; mp.CanQuery = false; mp.CanTouch = false
			mp.Color = Color3.new(1, 1, 1); mp.Material = Enum.Material.SmoothPlastic
		end
	end
	return M
end

return A
end)()

local T = A.buildTextures()
local M = A.buildMeshParts()
_G.IceSlamT, _G.IceSlamM = T, M

-- ICE SLAM: effect timeline (expects T = decal textures, M = crystal mesh templates)
local RunService = game:GetService("RunService")

local TEX_SPARKLE = "rbxasset://textures/particles/sparkles_main.dds"
local TEX_SMOKE = "rbxasset://textures/particles/smoke_main.dds"

local COL = {
	white = Color3.fromRGB(255, 255, 255),
	pale = Color3.fromRGB(205, 240, 255),
	cyan = Color3.fromRGB(95, 215, 255),
	mid = Color3.fromRGB(55, 145, 240),
	deep = Color3.fromRGB(22, 58, 155),
}
local IMPACT = 0.25
local DURATION = 2.5
local GRAVITY = 62

local function clamp01(x) if x < 0 then return 0 elseif x > 1 then return 1 end return x end
local function lerp(a, b, t) return a + (b - a) * t end
local function k01(t, a, b) return clamp01((t - a) / (b - a)) end
local function outCubic(x) return 1 - (1 - x) ^ 3 end
local function outQuart(x) return 1 - (1 - x) ^ 4 end
local function inQuad(x) return x * x end
local function outBack(x) local c1 = 1.9; local c3 = c1 + 1; return 1 + c3 * (x - 1) ^ 3 + c1 * (x - 1) ^ 2 end

local function NS(points)
	local k = {}
	for _, p in ipairs(points) do k[#k + 1] = NumberSequenceKeypoint.new(p[1], p[2], p[3] or 0) end
	return NumberSequence.new(k)
end
local function CS(points)
	local k = {}
	for _, p in ipairs(points) do k[#k + 1] = ColorSequenceKeypoint.new(p[1], p[2]) end
	return ColorSequence.new(k)
end
local function frameUp(pos, up, twist)
	local ref = math.abs(up.Y) < 0.98 and Vector3.yAxis or Vector3.xAxis
	local right = ref:Cross(up).Unit
	return CFrame.fromMatrix(pos, right, up) * CFrame.Angles(0, twist or 0, 0)
end
local function randUnit(rnd)
	local z = rnd:NextNumber(-1, 1)
	local a = rnd:NextNumber(0, 2 * math.pi)
	local r = math.sqrt(1 - z * z)
	return Vector3.new(r * math.cos(a), z, r * math.sin(a))
end
local function noPhys(p)
	p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
	return p
end

local function build(origin)
	local fx = { t = 0 }
	local rnd = Random.new(1337)
	local folder = Instance.new("Folder")
	folder.Name = "IceSlamVFX"
	fx.folder = folder

	local anchor = noPhys(Instance.new("Part"))
	anchor.Name = "Anchor"; anchor.Transparency = 1; anchor.Size = Vector3.new(0.2, 0.2, 0.2)
	anchor.CFrame = CFrame.new(origin); anchor.Parent = folder

	-- particle emitters: burst-only, one attachment each, re-aimed per burst ---------
	local emitters = {}
	local function emitter(name, tex, props)
		local att = Instance.new("Attachment")
		att.Name = name; att.Parent = anchor
		local pe = Instance.new("ParticleEmitter")
		pe.Name = name
		pe.Rate = 0
		pe.Texture = tex
		pe.LightInfluence = 0
		pe.EmissionDirection = Enum.NormalId.Top
		for k, v in pairs(props) do pe[k] = v end
		pe.Parent = att
		emitters[name] = { pe = pe, att = att }
	end
	local function emit(name, pos, dir, n, speed)
		local e = emitters[name]
		local up = dir.Magnitude > 1e-4 and dir.Unit or Vector3.yAxis
		local ref = math.abs(up.Y) < 0.98 and Vector3.yAxis or Vector3.xAxis
		e.att.WorldCFrame = CFrame.fromMatrix(pos, ref:Cross(up).Unit, up)
		if speed then e.pe.Speed = NumberRange.new(speed) end
		e.pe:Emit(n or 1)
	end
	fx.emitters = emitters

	emitter("Gather", TEX_SPARKLE, {
		Lifetime = NumberRange.new(0.2), Speed = NumberRange.new(20),
		Size = NS({ { 0, 0.5 }, { 0.6, 1.2 }, { 1, 0.3 } }),
		Transparency = NS({ { 0, 0.5 }, { 0.4, 0 }, { 1, 0 } }),
		Color = CS({ { 0, COL.cyan }, { 1, COL.white } }), LightEmission = 1,
		Rotation = NumberRange.new(0, 45), ZOffset = 0.5,
	})
	emitter("ImpactStar", TEX_SPARKLE, {
		Lifetime = NumberRange.new(0.15), Speed = NumberRange.new(0),
		Size = NS({ { 0, 6 }, { 0.2, 16 }, { 1, 0 } }),
		Transparency = NS({ { 0, 0 }, { 0.7, 0 }, { 1, 0.4 } }),
		Color = CS({ { 0, COL.white }, { 1, COL.pale } }), LightEmission = 1,
		Rotation = NumberRange.new(0), ZOffset = 5,
	})
	emitter("ImpactStar2", TEX_SPARKLE, {
		Lifetime = NumberRange.new(0.24), Speed = NumberRange.new(0),
		Size = NS({ { 0, 4 }, { 0.25, 11 }, { 1, 0 } }),
		Transparency = NS({ { 0, 0.1 }, { 1, 0.6 } }),
		Color = CS({ { 0, COL.cyan }, { 1, COL.mid } }), LightEmission = 1,
		Rotation = NumberRange.new(22), ZOffset = 4.5,
	})
	emitter("MistBurst", TEX_SMOKE, {
		Lifetime = NumberRange.new(0.8, 1.15), Speed = NumberRange.new(16, 26), Drag = 3.5,
		Acceleration = Vector3.new(0, 1.5, 0), SpreadAngle = Vector2.new(8, 8),
		Size = NS({ { 0, 2.0 }, { 1, 5.5 } }),
		Transparency = NS({ { 0, 0.15 }, { 0.4, 0.4 }, { 1, 1 } }),
		Color = CS({ { 0, COL.white }, { 1, COL.pale } }), LightEmission = 0.15,
		Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-40, 40),
	})
	emitter("Puff", TEX_SMOKE, {
		Lifetime = NumberRange.new(0.5, 0.75), Speed = NumberRange.new(3, 7), Drag = 2,
		SpreadAngle = Vector2.new(30, 30),
		Size = NS({ { 0, 1.2 }, { 1, 3.2 } }),
		Transparency = NS({ { 0, 0.25 }, { 1, 1 } }),
		Color = CS({ { 0, COL.white }, { 1, COL.pale } }), LightEmission = 0.15,
		Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-30, 30),
	})
	emitter("Glint", TEX_SPARKLE, {
		Lifetime = NumberRange.new(0.28, 0.4), Speed = NumberRange.new(0),
		Size = NS({ { 0, 0 }, { 0.3, 2.2 }, { 1, 0 } }),
		Transparency = NS({ { 0, 0 }, { 1, 0 } }),
		Color = CS({ { 0, COL.white }, { 1, COL.white } }), LightEmission = 1,
		Rotation = NumberRange.new(0, 40), ZOffset = 1.5,
	})
	emitter("IceDust", TEX_SPARKLE, {
		Lifetime = NumberRange.new(0.7, 1.1), Speed = NumberRange.new(2, 8), Drag = 1.5,
		SpreadAngle = Vector2.new(70, 70), Acceleration = Vector3.new(0, -3, 0),
		Size = NS({ { 0, 0.55, 0.2 }, { 1, 0 } }),
		Transparency = NS({ { 0, 0 }, { 1, 0.2 } }),
		Color = CS({ { 0, COL.white }, { 1, COL.cyan } }), LightEmission = 1,
		Rotation = NumberRange.new(0, 90), RotSpeed = NumberRange.new(-90, 90),
	})
	emitter("LingerMist", TEX_SMOKE, {
		Lifetime = NumberRange.new(1.0, 1.2), Speed = NumberRange.new(0.3, 1.2),
		SpreadAngle = Vector2.new(40, 40), Acceleration = Vector3.new(0, 0.6, 0),
		Size = NS({ { 0, 2.2 }, { 1, 4.2 } }),
		Transparency = NS({ { 0, 1 }, { 0.3, 0.5 }, { 1, 1 } }),
		Color = CS({ { 0, COL.white }, { 1, COL.pale } }), LightEmission = 0.1,
		Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-20, 20),
	})

	-- ground decal layers -----------------------------------------------------------
	local function decalPart(name, tex, y)
		local p = noPhys(Instance.new("Part"))
		p.Name = name; p.CastShadow = false; p.Transparency = 1; p.Size = Vector3.new(1, 0.05, 1)
		local d = Instance.new("Decal")
		d.Face = Enum.NormalId.Top; d.TextureContent = Content.fromObject(T[tex]); d.Transparency = 1; d.Parent = p
		p.Parent = folder
		return { part = p, decal = d, y = y, rot = CFrame.Angles(0, rnd:NextNumber(0, 2 * math.pi), 0) }
	end
	local function setDecal(L, size, transp, colour)
		L.part.Size = Vector3.new(size, 0.05, size)
		L.part.CFrame = CFrame.new(origin + Vector3.new(0, L.y, 0)) * L.rot
		L.decal.Transparency = transp
		if colour then L.decal.Color3 = colour end
	end
	local frost = decalPart("Frost", "frost", 0.03)
	local cracks = decalPart("Cracks", "cracks", 0.06)
	local charge = decalPart("Charge", "glow", 0.09)
	local tele = decalPart("Telegraph", "ringThin", 0.11)
	local ringB = decalPart("ShockCyan", "ring", 0.13)
	local ringA = decalPart("ShockWhite", "ring", 0.15)
	local ringC = decalPart("ShatterRing", "ringThin", 0.17)

	-- impact domes (neon shells) -------------------------------------------------------
	local function dome(name, colour)
		local p = noPhys(Instance.new("Part"))
		p.Name = name; p.Material = Enum.Material.Neon; p.Color = colour; p.CastShadow = false
		p.Transparency = 1; p.Size = Vector3.new(1, 1, 1); p.CFrame = CFrame.new(origin)
		local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
		p.Parent = folder
		return p
	end
	local domeA = dome("FlashDome", COL.white)
	local domeB = dome("ColdDome", COL.cyan)

	-- downward slam streak (the fist's path) -------------------------------------------
	local headAtt = Instance.new("Attachment"); headAtt.Name = "StreakHead"; headAtt.Parent = anchor
	local tailAtt = Instance.new("Attachment"); tailAtt.Name = "StreakTail"; tailAtt.Parent = anchor
	local function streakBeam(name, w0, transp, colour)
		local b = Instance.new("Beam")
		b.Name = name; b.Attachment0 = headAtt; b.Attachment1 = tailAtt
		b.FaceCamera = true; b.Segments = 1; b.LightEmission = 1; b.LightInfluence = 0
		b.Width0 = w0; b.Width1 = 0.05; b.Transparency = transp; b.Color = colour; b.Enabled = false
		b.Parent = anchor
		return b
	end
	local beamOuter = streakBeam("StreakGlow", 1.5, NS({ { 0, 0.35 }, { 0.6, 0.6 }, { 1, 1 } }), CS({ { 0, COL.cyan }, { 1, COL.mid } }))
	local beamCore = streakBeam("StreakCore", 0.8, NS({ { 0, 0 }, { 0.5, 0.2 }, { 1, 1 } }), CS({ { 0, COL.white }, { 1, COL.pale } }))

	local function orb(name, colour, transp)
		local p = noPhys(Instance.new("Part"))
		p.Name = name; p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon; p.Color = colour
		p.CastShadow = false; p.Transparency = 1; p.Size = Vector3.new(1, 1, 1); p.Parent = folder
		return { part = p, transp = transp }
	end
	local orbCore = orb("FistCore", COL.white, 0)
	local orbGlow = orb("FistGlow", COL.cyan, 0.55)

	local light = Instance.new("PointLight")
	light.Color = COL.pale; light.Range = 12; light.Brightness = 0; light.Shadows = false
	local lightAtt = Instance.new("Attachment"); lightAtt.Position = Vector3.new(0, 2.5, 0); lightAtt.Parent = anchor
	light.Parent = lightAtt

	-- thin neon lines: inward gather streaks + outward impact speed lines ---------------
	local function neonLine(colour)
		local p = noPhys(Instance.new("Part"))
		p.Material = Enum.Material.Neon; p.Color = colour; p.CastShadow = false
		p.Transparency = 1; p.Size = Vector3.new(0.1, 0.1, 1); p.Parent = folder
		return p
	end
	local gathers, lines = {}, {}
	local gatherEnd = origin + Vector3.new(0, 0.8, 0)
	for i = 1, 12 do
		local a = i / 12 * 2 * math.pi + rnd:NextNumber(-0.2, 0.2)
		local rr = rnd:NextNumber(5.5, 7.5)
		gathers[i] = {
			part = neonLine(i % 3 == 0 and COL.white or COL.cyan),
			p0 = origin + Vector3.new(math.cos(a) * rr, rnd:NextNumber(0.6, 4.2), math.sin(a) * rr),
			t0 = rnd:NextNumber(0, 0.08), t1 = IMPACT - rnd:NextNumber(0, 0.025), w = rnd:NextNumber(0.07, 0.11),
		}
	end
	for i = 1, 22 do
		local a = i / 22 * 2 * math.pi + rnd:NextNumber(-0.1, 0.1)
		local el = math.rad(rnd:NextNumber(3, 36))
		lines[i] = {
			part = neonLine(i % 2 == 0 and COL.white or COL.pale),
			dir = Vector3.new(math.cos(a) * math.cos(el), math.sin(el), math.sin(a) * math.cos(el)),
			t0 = IMPACT + rnd:NextNumber(0, 0.015), dur = rnd:NextNumber(0.12, 0.18),
			d1 = rnd:NextNumber(8, 12), L0 = rnd:NextNumber(2.5, 4), w = rnd:NextNumber(0.1, 0.15),
		}
	end

	-- crystal geometry ------------------------------------------------------------------
	local spikes, stubs, bodies = {}, {}, {}
	local function newMesh(list, castShadow)
		local mp = list[rnd:NextInteger(1, #list)]:Clone()
		mp.Transparency = 1; mp.CastShadow = castShadow; mp.Material = Enum.Material.SmoothPlastic
		mp.Parent = folder
		return mp
	end
	local function addBody(tStart, p0, v, len, up, life)
		bodies[#bodies + 1] = {
			part = newMesh(M.shards, false), tStart = tStart, p0 = p0, v = v,
			size = Vector3.new(len * rnd:NextNumber(0.35, 0.55), len, len * rnd:NextNumber(0.35, 0.55)),
			rot0 = frameUp(Vector3.zero, up, rnd:NextNumber(0, 2 * math.pi)) * CFrame.Angles(rnd:NextNumber(-0.5, 0.5), 0, rnd:NextNumber(-0.5, 0.5)),
			axis = randUnit(rnd), spin = rnd:NextNumber(7, 16) * (rnd:NextNumber() < 0.5 and -1 or 1),
			life = life, shown = false, mat = Enum.Material.SmoothPlastic,
		}
	end
	local function addSpike(kind, ang, r, H, W, tilt, t0, dur, ts, nShards)
		local radial = Vector3.new(math.cos(ang), 0, math.sin(ang))
		local up = (Vector3.yAxis * math.cos(tilt) + radial * math.sin(tilt)).Unit
		local s = {
			kind = kind, part = newMesh(M.spikes, kind ~= "inner"), base = origin + radial * r, up = up, radial = radial,
			H = H, W = W, twist = rnd:NextNumber(0, 2 * math.pi), t0 = t0, dur = dur, ts = ts,
			seed = rnd:NextNumber(0, 100), shown = false, mat = Enum.Material.SmoothPlastic,
			stump = kind ~= "inner" and rnd:NextNumber(0.24, 0.32) or nil, tEnd = rnd:NextNumber(1.9, 2.15),
		}
		for i = 1, nShards do
			local f = ((i - 0.5) / nShards) * 0.8 + 0.04 + rnd:NextNumber(-0.04, 0.04)
			local lateral = randUnit(rnd)
			lateral = (lateral - up * lateral:Dot(up)) * W * 0.22
			local p0 = s.base + up * (H * 0.85 * f) + lateral
			local outward = radial * rnd:NextNumber(4, 14) * (rnd:NextNumber() < 0.15 and -0.5 or 1)
			local v = outward + Vector3.yAxis * rnd:NextNumber(8, 19) * (1.1 - f * 0.4) + randUnit(rnd) * 3.5 + up * rnd:NextNumber(0, 4)
			addBody(ts, p0, v, math.min(1.7, W * rnd:NextNumber(0.5, 0.95) * (1.15 - f * 0.4)), up, rnd:NextNumber(0.5, 0.78))
		end
		spikes[#spikes + 1] = s
		return s
	end

	local mainH = { 7.0, 5.3, 6.2, 4.9, 6.7, 5.6 }
	for k = 0, 11 do
		local ang = k / 12 * 2 * math.pi + rnd:NextNumber(-0.09, 0.09)
		local r = rnd:NextNumber(4.4, 5.3)
		local H = mainH[k % 6 + 1] * rnd:NextNumber(0.96, 1.0)
		local W = H * rnd:NextNumber(0.27, 0.33)
		local t0 = IMPACT + 0.02 + (r - 2.4) * 0.012 + rnd:NextNumber(0, 0.025)
		addSpike("main", ang, r, H, W, math.rad(rnd:NextNumber(20, 32)), t0, 0.11, 1.0 + rnd:NextNumber(0, 0.12), 7)
	end
	for k = 0, 9 do
		local ang = (k + 0.5) / 10 * 2 * math.pi + rnd:NextNumber(-0.12, 0.12)
		local r = rnd:NextNumber(5.9, 6.8)
		local H = rnd:NextNumber(2.4, 3.8)
		local t0 = IMPACT + 0.02 + (r - 2.4) * 0.012 + rnd:NextNumber(0.01, 0.035)
		addSpike("second", ang, r, H, H * rnd:NextNumber(0.34, 0.42), math.rad(rnd:NextNumber(32, 48)), t0, 0.1, 0.98 + rnd:NextNumber(0, 0.12), 4)
	end
	for k = 0, 6 do
		local ang = (k + rnd:NextNumber(0, 0.6)) / 7 * 2 * math.pi
		local r = rnd:NextNumber(2.4, 3.2)
		local H = rnd:NextNumber(1.6, 2.8)
		local t0 = IMPACT + 0.015 + rnd:NextNumber(0, 0.02)
		addSpike("inner", ang, r, H, H * rnd:NextNumber(0.38, 0.45), math.rad(rnd:NextNumber(28, 45)), t0, 0.08, 0.96 + rnd:NextNumber(0, 0.08), 3)
	end
	for _ = 1, 15 do
		local ang = rnd:NextNumber(0, 2 * math.pi)
		local r = rnd:NextNumber(1.5, 7.6)
		local radial = Vector3.new(math.cos(ang), 0, math.sin(ang))
		local tilt = math.rad(rnd:NextNumber(12, 55))
		local H = rnd:NextNumber(0.6, 1.5)
		stubs[#stubs + 1] = {
			part = newMesh(M.spikes, false), base = origin + radial * r,
			up = (Vector3.yAxis * math.cos(tilt) + radial * math.sin(tilt)).Unit,
			H = H, W = H * rnd:NextNumber(0.5, 0.7), twist = rnd:NextNumber(0, 2 * math.pi),
			t0 = IMPACT + 0.02 + r * 0.011, dur = 0.09, tEnd = rnd:NextNumber(1.95, 2.2), shown = false,
		}
	end
	-- impact chips thrown out of the hit point
	for _ = 1, 26 do
		local a = rnd:NextNumber(0, 2 * math.pi)
		local el = math.rad(rnd:NextNumber(30, 75))
		local dir = Vector3.new(math.cos(a) * math.cos(el), math.sin(el), math.sin(a) * math.cos(el))
		local p0 = origin + Vector3.new(math.cos(a) * 0.6, 0.5, math.sin(a) * 0.6)
		addBody(IMPACT, p0, dir * rnd:NextNumber(16, 32), rnd:NextNumber(0.3, 0.75), dir, rnd:NextNumber(0.45, 0.75))
	end

	-- particle schedule -------------------------------------------------------------------
	local events = {}
	local function at(time, fn) events[#events + 1] = { time = time, fn = fn } end
	local up = Vector3.yAxis
	for wave = 0, 1 do
		local te = wave * 0.07
		at(te, function()
			local life = IMPACT - te - 0.01
			emitters.Gather.pe.Lifetime = NumberRange.new(life)
			for i = 1, 8 do
				local a = (i + wave * 0.5) / 8 * 2 * math.pi + rnd:NextNumber(-0.2, 0.2)
				local rr = rnd:NextNumber(5, 7)
				local p = origin + Vector3.new(math.cos(a) * rr, rnd:NextNumber(0.4, 3.6), math.sin(a) * rr)
				local d = gatherEnd - p
				emit("Gather", p, d, 1, d.Magnitude / life)
			end
		end)
	end
	at(IMPACT, function()
		emit("ImpactStar", origin + Vector3.new(0, 1.4, 0), up, 1)
		emit("ImpactStar2", origin + Vector3.new(0, 1.3, 0), up, 1)
		for i = 1, 16 do
			local a = i / 16 * 2 * math.pi + rnd:NextNumber(-0.15, 0.15)
			local dir = Vector3.new(math.cos(a), math.rad(rnd:NextNumber(3, 14)), math.sin(a))
			emit("MistBurst", origin + Vector3.new(0, 0.9, 0), dir, 1)
		end
		emit("IceDust", origin + Vector3.new(0, 1, 0), up, 10)
	end)
	for _, s in ipairs(spikes) do
		at(s.t0, function()
			emit("Puff", s.base + Vector3.new(0, 0.4, 0), s.radial + Vector3.yAxis * 0.8, s.kind == "main" and 2 or 1)
		end)
		if s.kind == "main" then
			local tipT = s.t0 + s.dur + rnd:NextNumber(0.08, s.ts - s.t0 - s.dur - 0.08)
			at(tipT, function()
				emit("Glint", s.base + s.up * s.H * rnd:NextNumber(0.5, 0.75), up, 1)
			end)
		end
		at(s.ts, function()
			local mid = s.base + s.up * s.H * 0.4
			emit("IceDust", mid, Vector3.yAxis + s.radial * 0.5, s.kind == "main" and 6 or 3)
			emit("Puff", mid, s.radial + Vector3.yAxis * 0.5, s.kind == "main" and 2 or 1)
			if s.kind == "main" then emit("Glint", s.base + s.up * s.H * 0.6, up, 1) end
		end)
	end
	for i = 0, 15 do
		at(0.33 + i * 0.06, function()
			local a = rnd:NextNumber(0, 2 * math.pi)
			local r = math.sqrt(rnd:NextNumber(0.02, 1)) * 7.5
			emit("LingerMist", origin + Vector3.new(math.cos(a) * r, 0.5, math.sin(a) * r), up, 1)
		end)
	end
	table.sort(events, function(a, b) return a.time < b.time end)
	local nextEvent = 1
	function fx.fire(t)
		while nextEvent <= #events and events[nextEvent].time <= t do
			events[nextEvent].fn()
			nextEvent += 1
		end
	end

	-- per-frame pose: a pure function of effect time ---------------------------------------
	local moveParts, moveCFs = {}, {}
	local function show(obj, on)
		if obj.shown ~= on then
			obj.shown = on
			obj.part.Transparency = on and 0 or 1
		end
	end
	local function setMat(obj, mat)
		if obj.mat ~= mat then obj.mat = mat; obj.part.Material = mat end
	end
	local function place(part, cf)
		moveParts[#moveParts + 1] = part
		moveCFs[#moveCFs + 1] = cf
	end
	local groundY = origin.Y

	function fx.update(t)
		table.clear(moveParts); table.clear(moveCFs)

		-- telegraph ring closing in + charge glow
		if t < IMPACT then
			local k = t / IMPACT
			setDecal(tele, lerp(12, 2.4, inQuad(k)), lerp(0.85, 0.2, k), COL.cyan)
			setDecal(charge, lerp(0.6, 4, inQuad(k)), lerp(0.7, 0.1, k), COL.cyan)
		else
			setDecal(tele, 2.4, 1)
			local k = k01(t, IMPACT, IMPACT + 0.25)
			setDecal(charge, lerp(4, 10, outCubic(k)), lerp(0.05, 1, k), COL.white)
		end

		-- inward gather streaks
		for _, g in ipairs(gathers) do
			if t >= g.t0 and t < g.t1 then
				local k = k01(t, g.t0, g.t1)
				local d = gatherEnd - g.p0
				local head = g.p0 + d * inQuad(k)
				local L = math.min(lerp(0.4, 2.6, k), (head - g.p0).Magnitude + 0.3)
				local dirU = d.Unit
				g.part.Size = Vector3.new(g.w, g.w, L)
				g.part.Transparency = lerp(0.7, 0, clamp01(k * 2))
				place(g.part, CFrame.lookAt(head - dirU * (L / 2), head))
			elseif g.part.Transparency < 1 then
				g.part.Transparency = 1
			end
		end

		-- outward speed lines
		for _, l in ipairs(lines) do
			if t >= l.t0 and t < l.t0 + l.dur then
				local k = k01(t, l.t0, l.t0 + l.dur)
				local headD = lerp(1.2, l.d1, outQuart(k))
				local L = math.min(lerp(l.L0, 0.8, k), headD - 0.6)
				local w = l.w * (1 - k) ^ 0.6 + 0.01
				local base = origin + Vector3.new(0, 0.5, 0)
				l.part.Size = Vector3.new(w, w, math.max(L, 0.1))
				l.part.Transparency = 0
				place(l.part, CFrame.lookAt(base + l.dir * (headD - L / 2), base + l.dir * headD))
			elseif l.part.Transparency < 1 then
				l.part.Transparency = 1
			end
		end

		-- slam streak (fist path) 0.13 -> 0.31
		if t >= 0.13 and t < 0.31 then
			local headY, tailY
			if t < IMPACT then
				local k = k01(t, 0.13, IMPACT)
				headY = lerp(7.5, 0.3, inQuad(k))
				tailY = headY + lerp(1, 6.5, k)
			else
				local k = k01(t, IMPACT, 0.31)
				headY = 0.3
				tailY = lerp(6.8, 0.6, outCubic(k))
			end
			headAtt.Position = Vector3.new(0, headY, 0)
			tailAtt.Position = Vector3.new(0, tailY, 0)
			beamOuter.Enabled = true; beamCore.Enabled = true
		else
			beamOuter.Enabled = false; beamCore.Enabled = false
		end
		if t >= 0.13 and t < IMPACT then
			local k = k01(t, 0.13, IMPACT)
			local headPos = origin + Vector3.new(0, lerp(7.5, 0.3, inQuad(k)), 0)
			for _, o in ipairs({ orbCore, orbGlow }) do
				local d = (o == orbCore) and 0.85 or 1.6
				o.part.Size = Vector3.new(d, d, d) * lerp(0.6, 1, k)
				o.part.Transparency = o.transp
				place(o.part, CFrame.new(headPos))
			end
		else
			orbCore.part.Transparency = 1; orbGlow.part.Transparency = 1
		end

		-- impact flash domes + light
		if t >= IMPACT and t < IMPACT + 0.11 then
			local k = k01(t, IMPACT, IMPACT + 0.11)
			local e = outCubic(k)
			domeA.Size = Vector3.new(lerp(1.5, 8, e), lerp(1.2, 3.8, e), lerp(1.5, 8, e))
			domeA.Transparency = k < 0.18 and 0 or lerp(0, 1, ((k - 0.18) / 0.82) ^ 0.7)
			domeA.Color = COL.white:Lerp(COL.pale, k)
		else
			domeA.Transparency = 1
		end
		if t >= IMPACT + 0.01 and t < IMPACT + 0.26 then
			local k = k01(t, IMPACT + 0.01, IMPACT + 0.26)
			local e = outQuart(k)
			domeB.Size = Vector3.new(lerp(2, 14, e), lerp(1.5, 5, e), lerp(2, 14, e))
			domeB.Transparency = lerp(0.5, 1, k ^ 0.6)
		else
			domeB.Transparency = 1
		end
		if t >= IMPACT then
			light.Brightness = lerp(3, 0, k01(t, IMPACT, IMPACT + 0.3))
		else
			light.Brightness = lerp(0, 0.8, t / IMPACT)
		end

		-- shockwave rings
		if t >= IMPACT and t < IMPACT + 0.24 then
			local k = k01(t, IMPACT, IMPACT + 0.24)
			setDecal(ringA, lerp(2, 20, outQuart(k)), lerp(0, 1, k ^ 1.2), COL.white)
		else
			setDecal(ringA, 1, 1)
		end
		if t >= IMPACT + 0.02 and t < IMPACT + 0.55 then
			local k = k01(t, IMPACT + 0.02, IMPACT + 0.55)
			setDecal(ringB, lerp(2, 16, outCubic(k)), lerp(0.1, 1, k ^ 1.2), COL.cyan)
		else
			setDecal(ringB, 1, 1)
		end
		if t >= 1.0 and t < 1.4 then
			local k = k01(t, 1.0, 1.4)
			setDecal(ringC, lerp(9, 21, outCubic(k)), lerp(0.3, 1, k), COL.pale)
		else
			setDecal(ringC, 1, 1)
		end

		-- frost patch + cracks (linger)
		if t >= IMPACT then
			local g = outCubic(k01(t, IMPACT, IMPACT + 0.22))
			setDecal(frost, lerp(3, 17.5, g), lerp(0.05, 1, inQuad(k01(t, 1.8, DURATION))))
			local c = outQuart(k01(t, IMPACT, IMPACT + 0.08))
			setDecal(cracks, lerp(3, 16, c), lerp(0, 1, inQuad(k01(t, 1.7, 2.4))))
		else
			setDecal(frost, 1, 1); setDecal(cracks, 1, 1)
		end

		-- spikes: erupt (overshoot), hold, rumble, white-hot flash, break
		for _, s in ipairs(spikes) do
			if t >= s.t0 and t < s.ts then
				local k = k01(t, s.t0, s.t0 + s.dur)
				local len = math.max(0.05, s.H * outBack(k))
				local wid = s.W * lerp(0.45, 1, clamp01(k * 1.5))
				local jitter = Vector3.zero
				local rumble = k01(t, s.ts - 0.16, s.ts)
				if rumble > 0 then
					jitter = Vector3.new(math.sin(t * 97 + s.seed), 0, math.cos(t * 83 + s.seed)) * 0.09 * rumble
				end
				s.part.Size = Vector3.new(wid, len, wid)
				place(s.part, frameUp(s.base + s.up * (len * 0.35) + jitter, s.up, s.twist))
				show(s, true)
				setMat(s, (t >= s.ts - 0.045) and Enum.Material.Neon or Enum.Material.SmoothPlastic)
			elseif s.stump and t >= s.ts and t < DURATION then
				-- broken stump stays in the frost, then sinks away
				local sink = inQuad(k01(t, s.tEnd, s.tEnd + 0.3))
				local len = math.max(0.05, s.H * s.stump * (1 - sink))
				s.part.Size = Vector3.new(s.W * 0.92 * (1 - sink * 0.4), len, s.W * 0.92 * (1 - sink * 0.4))
				place(s.part, frameUp(s.base + s.up * (len * 0.3), s.up, s.twist))
				show(s, len > 0.06)
				setMat(s, (t < s.ts + 0.04) and Enum.Material.Neon or Enum.Material.SmoothPlastic)
			else
				show(s, false)
			end
		end

		-- ballistic shards (spike debris + impact chips)
		for _, b in ipairs(bodies) do
			local a = t - b.tStart
			if a >= 0 and a < b.life then
				local v = b.v
				local y0 = b.p0.Y - (groundY + 0.2)
				local disc = v.Y * v.Y + 2 * GRAVITY * y0
				local aHit = (v.Y + math.sqrt(math.max(0, disc))) / GRAVITY
				local aMove = math.min(a, aHit)
				local p = b.p0 + v * aMove + Vector3.new(0, -0.5 * GRAVITY * aMove * aMove, 0)
				local sc = a < b.life * 0.5 and 1 or (1 - inQuad(k01(a, b.life * 0.5, b.life)))
				b.part.Size = b.size * math.max(sc, 0.01)
				place(b.part, CFrame.new(p) * CFrame.fromAxisAngle(b.axis, b.spin * aMove) * b.rot0)
				show(b, true)
				setMat(b, a < 0.05 and Enum.Material.Neon or Enum.Material.SmoothPlastic)
			else
				show(b, false)
			end
		end

		-- lingering ground ice
		for _, s in ipairs(stubs) do
			if t >= s.t0 and t < DURATION then
				local k = k01(t, s.t0, s.t0 + s.dur)
				local sink = inQuad(k01(t, s.tEnd, s.tEnd + 0.28))
				local len = math.max(0.05, s.H * outBack(k) * (1 - sink))
				local wid = s.W * lerp(0.5, 1, clamp01(k * 1.5)) * (1 - sink * 0.5)
				s.part.Size = Vector3.new(wid, len, wid)
				place(s.part, frameUp(s.base + s.up * (len * 0.35), s.up, s.twist))
				show(s, len > 0.06)
			else
				show(s, false)
			end
		end

		if #moveParts > 0 then
			workspace:BulkMoveTo(moveParts, moveCFs, Enum.BulkMoveMode.FireCFrameChanged)
		end
	end

	function fx.setTimeScale(s)
		for _, e in pairs(emitters) do e.pe.TimeScale = s end
	end

	fx.update(0)
	folder.Parent = workspace
	return fx
end

-- player ----------------------------------------------------------------------------------
local current
local function stop()
	if current then
		local c = current
		current = nil
		if c.conn then c.conn:Disconnect() end
		if c.folder then c.folder:Destroy() end
	end
end

local function play(origin, freezeAt)
	stop()
	assert(typeof(origin) == "Vector3", "BlindTestPlay: origin must be a Vector3")
	if freezeAt then freezeAt = math.clamp(freezeAt, 0, DURATION) end
	local fx = build(origin)
	current = fx
	local t = 0
	local state = "running" -- running | landing | frozen
	-- the last 0.05 s before a freeze run at 1/5 speed so the stop lands within ~1-2 ms
	local SLOW_WINDOW, SLOW_RATE = 0.05, 0.2
	fx.fire(0)
	if freezeAt == 0 then
		fx.setTimeScale(0); state = "frozen"
	end
	fx.conn = RunService.Heartbeat:Connect(function(dt)
		if current ~= fx or state == "frozen" then return end
		if state == "landing" then
			fx.setTimeScale(0)
			state = "frozen"
			return
		end
		dt = math.min(dt, 1 / 15)
		local rate = 1
		if freezeAt and freezeAt - t <= SLOW_WINDOW then rate = SLOW_RATE end
		local step = dt * rate
		if freezeAt and t + step >= freezeAt then
			step = freezeAt - t
			state = "landing"
		end
		fx.setTimeScale(dt > 0 and math.clamp(step / dt, 0, 1) or 0)
		t += step
		fx.t = t
		fx.fire(t)
		fx.update(t)
		if not freezeAt and t >= DURATION + 0.1 then
			stop()
		end
	end)
	if freezeAt then
		-- yield until the pose is locked, so a caller can screenshot right after this returns
		local waited = 0
		while current == fx and state ~= "frozen" and waited < freezeAt + 3 do
			waited += task.wait()
		end
	end
	return fx
end

_G.BlindTestPlay = function(origin, freezeAt)
	play(origin, freezeAt)
end
_G.BlindTestStop = function()
	stop()
end
_G.IceSlamPlay = play
