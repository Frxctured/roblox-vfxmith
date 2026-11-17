-- VFXKit demo: one horizontal slash + one heavy overhead cut with a lightning strike, ~70 lines of effect code.
-- Load kit/studio/VFXKit.luau first (it sets _G.VFXKit), then this file, both with kit/scripts/kit_push.py.
-- Builds workspace.LAB_kit; _G.kitfx is the effect. The caster frame is turned 35 degrees on purpose: everything
-- below is caster space, so nothing may skew. An example of the block calls, not a template for your effect.
local K = _G.VFXKit
local V3 = Vector3.new
local fx = K.new("LAB_kit", CFrame.new(300, 0.5, 300) * CFrame.Angles(0, math.rad(35), 0), K.Palettes.Storm)
fx.mark = 10 -- strike distance on the look line (bird's-eye guide)
fx:Stage(); fx:Caster(); fx:Katana()

fx:Pose({
	{ t = 0.00, wy = 10, ra = { 55, -45 }, eb = 30, bl = { 40, -5 }, la = { -30, -55 }, dr = 0.3 },
	-- slash 1: anticipation -> swing right-to-left -> held follow-through (8 frames)
	{ t = 0.07, wy = 40, wp = 3, ra = { 118, 12 }, eb = 5, bl = { 128, 16 }, la = { -40, -40 }, dr = 0.35, e = "out" },
	{ t = 0.25, wy = -40, wp = -5, ra = { -112, 2 }, eb = 0, bl = { -122, 6 }, la = { 20, -55 }, dr = 0.45, e = "fast" },
	{ t = 0.38, wy = -42, wp = -6, ra = { -115, 0 }, eb = 2, bl = { -126, 3 }, e = "out" },
	-- raise overhead (az stays 0, el goes past 90: the blade travels OVER the top, not round the side)
	{ t = 0.62, wy = 0, wp = 14, ra = { 0, 80 }, eb = 25, bl = { 0, 125 }, la = { 0, 80 }, dr = 0.2, e = "out" },
	{ t = 0.95, wp = 18, ra = { 0, 84 }, eb = 30, bl = { 0, 132 }, la = { 0, 84 }, dr = 0.15, e = "inout" },
	-- heavy cut, crouched follow-through, held
	{ t = 1.07, wp = -36, ra = { 4, -25 }, eb = 2, bl = { 0, -45 }, la = { -4, -25 }, dr = 1.05, e = "fast" },
	{ t = 1.45, wp = -38, ra = { 4, -28 }, eb = 3, bl = { 0, -48 }, la = { -4, -28 }, dr = 1.1, e = "out" },
	{ t = 2.40, wy = 5, wp = -8, ra = { 30, -45 }, eb = 25, bl = { 30, -30 }, la = { -20, -50 }, dr = 0.5, e = "inout" },
})

-- slash 1: plane, centre and size come from the pose
local s1 = fx:Stroke({ name = "S1", t = 0.12, swing = { 0.07, 0.25 } })
fx:Crackle({ t = 0.12, pts = fx:ArcPoints(s1.c, s1.n, s1.mid, s1.size * 0.45, { -55, 0, 55 }) })
fx:Contact({ t = 0.14, p = s1.c + s1.mid * s1.size * 0.42, dir = V3(-1, 0, 0.2) })
fx:Shake(0.13, 0.15, 0.1)

-- wind-up: the charge lives on the blade
fx:Charge({ t0 = 0.42, t1 = 0.99, atts = fx.bladeAtts, follow = fx.blade, tip = fx.bladeAtts[1], size = 1.2 })
local bladeLight = Instance.new("PointLight"); bladeLight.Color = fx.pal.main; bladeLight.Range = 10; bladeLight.Brightness = 0; bladeLight.Parent = fx.blade
fx:OnUpdate(function(T)
	local heat = (T > 0.42 and T < 1.1) and math.clamp((T - 0.42) / 0.5, 0, 1) or 0
	fx.edge.Transparency = 0.55 - 0.55 * heat; bladeLight.Brightness = heat * 3; bladeLight.Range = 4 + 6 * heat
end)

-- heavy cut: exactly vertical in the caster's look plane, biggest + brightest, fan + ghosts + side sparks = volume edge-on
local hc, nF, midF, IMP = V3(0, 4, -0.8), V3(-1, 0, 0), V3(0, 0.5, -0.87), 1.05
fx:Stroke({ name = "Heavy", t = IMP - 0.05, c = hc, n = nF, mid = midF, size = 15.2, life = 0.3, br = 60, fan = 10 })
fx:Ghosts({ windows = { { 0.95, 1.07 } } })
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
fx:GroundScar({ t = IMP, from = V3(0, 0.05, -1.4), to = V3(0, 0.05, -fx.mark - 0.4) })
fx:Shake(IMP - 0.04, 0.25, 0.12); fx:Shake(STR, 0.6, 0.35)

_G.kitfx = fx
return fx:Build() .. "\n" .. fx:Lint()
