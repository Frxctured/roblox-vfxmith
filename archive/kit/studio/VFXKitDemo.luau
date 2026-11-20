-- VFXKit demo: a horizontal slash (sprite stroke), a two-handed rising cut (mesh slash fitted to the blade) and a
-- heavy two-handed overhead cut with a lightning strike, ~85 lines of effect code.
-- Load kit/studio/VFXKit.luau first (it sets _G.VFXKit), then this file, both with kit/scripts/kit_push.py.
-- Builds workspace.LAB_kit (or the name in _G.VFXKitDemoName); _G.kitfx is the effect. The caster frame is turned 35 degrees on purpose: everything
-- below is caster space, so nothing may skew. An example of the block calls, not a template for your effect.
local K = _G.VFXKit
local V3 = Vector3.new
local G = K.Guard
local fx = K.new(_G.VFXKitDemoName or "LAB_kit", CFrame.new(300, 0.5, 300) * CFrame.Angles(0, math.rad(35), 0), K.Palettes.Storm)
fx.mark = 10 -- strike distance on the look line (bird's-eye guide)
fx:Stage(); fx:Caster(); fx:Katana()

fx:Pose({
	K.Key(0.00, G.Mid), -- two-handed middle guard: every hit starts from and returns to a guard, never a T-pose
	-- slash 1 (one-handed): coil -> swing right-to-left with a step -> held follow-through (8 frames), free fist tucked
	K.Key(0.07, G.Tuck, { wy = 40, wp = 3, ra = { 118, 12 }, eb = 5, bl = { 128, 16 }, dr = 0.35, fz = -0.2, e = "out" }),
	{ t = 0.25, wy = -40, wp = -5, ra = { -112, 2 }, eb = 20, bl = { -122, 6 }, dr = 0.45, fz = 1.1, st = 1, hy = -15, e = "fast" },
	{ t = 0.38, wy = -42, wp = -6, ra = { -115, 0 }, eb = 24, bl = { -126, 3 }, e = "out" },
	-- slash 2 (two-handed): dip low-left with both hands on the hilt, rising cut to high-right, held
	{ t = 0.47, wy = 30, wp = -8, ra = { -15, -48 }, eb = 28, bl = { -45, -40 }, dr = 0.68, two = 1, hy = 0, e = "out" },
	{ t = 0.63, wy = -30, wp = 6, ra = { 15, 45 }, eb = 18, bl = { 35, 55 }, dr = 0.35, fz = 1.4, st = 0.6, hy = -12, e = "fast" },
	{ t = 0.76, wy = -32, wp = 7, ra = { 17, 43 }, eb = 22, bl = { 37, 55 }, dr = 0.38, e = "out" },
	-- raise overhead through the high guard (az stays ~0, el goes past 90: the blade travels OVER the top)
	K.Key(1.00, G.High, { fz = 1.2, st = 0.3, hy = 0, e = "out" }),
	K.Key(1.30, G.High, { ra = { 12, 86 }, eb = 37, bl = { 0, 135 }, la = { -12, 84 }, lb = 37, dr = 0.2, st = 0.4, e = "inout" }),
	-- heavy cut down the look line, two-handed, stepping into a lunge, held; then back to the guard
	{ t = 1.42, wp = -16, ra = { 6, -22 }, eb = 8, bl = { 0, -42 }, dr = 0.85, fz = 2.0, st = 1.3, e = "fast" },
	{ t = 1.80, wp = -17, ra = { 6, -25 }, eb = 9, bl = { 0, -45 }, dr = 0.88, e = "out" },
	K.Key(2.75, G.Mid, { fz = 2.0, st = 0.6, e = "inout" }),
})

-- slash 1: plane, centre and size come from the pose
local s1 = fx:Stroke({ name = "S1", t = 0.12, swing = { 0.07, 0.25 } })
fx:Crackle({ t = 0.12, pts = fx:ArcPoints(s1.c, s1.n, s1.mid, s1.size * 0.45, { -55, 0, 55 }) })
fx:Contact({ t = 0.14, p = s1.c + s1.mid * s1.size * 0.42, dir = V3(-1, 0, 0.2) })
fx:Shake(0.13, 0.15, 0.1)

-- slash 2: a mesh slash. The pose leads; the meshes are fitted to the blade's real path and turn with it.
-- Its plane is seen partly edge-on from behind, so the Band is tall (height 2); tail = an eroding flipbook on top.
local s2 = fx:MeshSlash({ name = "S2", swing = { 0.47, 0.63 }, height = 2, fade = 0.12, tail = true })
fx:Contact({ t = 0.56, p = s2.c + s2.mid * s2.R, dir = V3(0.6, 0.6, -0.3) })
fx:Shake(0.55, 0.17, 0.1)

-- wind-up: the charge lives on the blade
fx:Charge({ t0 = 0.80, t1 = 1.34, atts = fx.bladeAtts, follow = fx.blade, tip = fx.bladeAtts[1], size = 1.2 })
local bladeLight = Instance.new("PointLight"); bladeLight.Color = fx.pal.main; bladeLight.Range = 10; bladeLight.Brightness = 0; bladeLight.Parent = fx.blade
fx:OnUpdate(function(T)
	local heat = (T > 0.80 and T < 1.45) and math.clamp((T - 0.80) / 0.5, 0, 1) or 0
	fx.edge.Transparency = 0.55 - 0.55 * heat; bladeLight.Brightness = heat * 3; bladeLight.Range = 4 + 6 * heat
end)

-- heavy cut: exactly vertical in the caster's look plane, biggest + brightest, fan + ghosts + side sparks = volume edge-on
local hc, nF, midF, IMP = V3(0, 4, -2.8), V3(-1, 0, 0), V3(0, 0.5, -0.87), 1.40
fx:Stroke({ name = "Heavy", t = IMP - 0.05, c = hc, n = nF, mid = midF, size = 15.2, life = 0.3, br = 60, fan = 10 })
fx:Ghosts({ windows = { { 1.30, 1.42 } } })
for _, p in fx:ArcPoints(hc, nF, midF, 6.3, { -25, 15, 50 }) do
	for _, side in { 1, -1 } do
		fx:Needles({ t = IMP - 0.04, p = p, dir = V3(side, 0, 0), n = 4, speed = { 30, 60 }, spread = 35, drag = 14, size = 0.45, br = 28 })
		fx:Dots({ t = IMP - 0.04, p = p, dir = V3(side, 0, 0), n = 3, speed = { 18, 40 }, spread = 40, drag = 16, gravity = -20, size = 0.4, life = 0.3 })
	end
end

-- payoff: impact frame first, the strike appears as it ends (anything emitted under the white frame is hidden)
local P = V3(0, 0, -fx.mark)
local STR = IMP + 0.07
local bolt = fx:Bolt({ t = STR, to = P + V3(0, 0.1, 0) })
local sil = fx:ArcSilhouette(hc, nF, midF, 6, -60, 70)
for _, p in bolt.coreParts do table.insert(sil, p) end
fx:ImpactFrame({ t = IMP, parts = sil, focus = P })
fx:Strike({ t = STR, p = P })
fx:GroundScar({ t = IMP, from = V3(0, 0.05, -3.4), to = V3(0, 0.05, -fx.mark - 0.4) })
fx:Shake(IMP - 0.04, 0.25, 0.12); fx:Shake(STR, 0.6, 0.35)

_G.kitfx = fx
return fx:Build() .. "\n" .. fx:Lint()
