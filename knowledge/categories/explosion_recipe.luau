-- OSExplosion: one generic explosion for VFXTimeline, built from the 7 open-source explosions studied in
-- explosion.md (same folder). UNTESTED draft: valid Luau, not yet played in Studio.
-- Source effects, named per layer:
--   burst  = d0bab8f5b533 (ExplosionPack/LightingBurst)   ice  = 8f69477f9552 (IceExplosion)
--   jing   = f8b7b6d9d087 (Jingliu IceExplosion)          fire = acb7087801ae (Fire explosion)
--   cinn   = b65c89df275e (Cinnamon Explosion)            cid  = c5645c4c7d50 (Cid Slashes3)
--   big    = f9ef4f62abcb (BigExplosion; data only)
-- Scale: D = 24 studs = peak Size of the main ring (explosion.md b: every size is a multiple of D; opts.scale
-- resizes everything). Burst centre 3 studs above the origin; ground layers at y 0.1-0.3.
-- Timing: like every studied effect, ALL layers fire at t = 0 as single bursts; lifetimes alone make the phases:
--   flash 0-0.09 | peak 0.03-0.15 | break-up 0.15-0.45 | linger 0.45-1.6 (crack), embers to ~2.8.
-- Three tones: white core (flashCore, flashStar, pillar, crossFlare, ringWhip, sparks, streaks),
--   saturated orange body (glow, ringFlat, ringShell, spikyShock, flames, fireBlobs, embers),
--   dark ink (blackFlash, streakInk, darkSmoke, crack ends black).
-- Deliberate departures from the evidence (explosion.md e): flash about 1 D, not a 371-stud card (e.1/e.2); one solid
-- (LE 0) core shape instead of stacked additive flashes (e.1); crack lives 1.6 s, not 14-16 s (e.8); 2-8 particles per
-- body layer instead of 1 (e.9). Negative LightEmission is used on one layer only (spikyShock) and marked; embers use
-- LE 1 instead of fire's LE -2 Br 200. Every layer gets LightInfluence 0 from the runtime.
-- Check in Studio first: some ids may not load in another experience (asset permissions).
return {
	name = "OSExplosion",
	palette = {
		white = "#FFF6EA",
		hot = "#FFD27A", -- yellow-white core tint
		orange = "#FF7A2E",
		red = "#E8341C",
		ember = "#8A1A0C",
		smokeBrown = "#A6623C", -- fire's dark-smoke start colour
		smokeMid = "#090503", -- fire's dark-smoke middle colour
		crackHot = "#F35529", -- fire's crack colour
		ink = "#000000",
	},
	textures = {
		StarFlash = 18118762332, -- spiky starburst flash (jing, 1-frame flash)
		SpikyStar = 11187665050, -- spiky starburst (burst ImpactFrame)
		Glow = 14045123768, -- big soft glow (burst, ice)
		PillarFlash = 15294279094, -- flash used with Squash 0 -> 10.6 (cinn)
		Cross = 17391818367, -- thin 4-point cross (fire Star102)
		BlackFlash = 8133065785, -- spiky hit burst, used at Brightness 0 = black (fire "Black Flash")
		TwoArcRing = 18527700887, -- two-arc wind ring (jing)
		ThinRing = 15269685466, -- decay16 ring (ice)
		SpikyRing = 14538969234, -- ragged spiky shock ring (burst Red'pikeyShockwave)
		Lines = 7136536841, -- vertical line streaks (burst "black" sparks)
		FlameShard = 15413764911, -- toon flame tongue 4x4 (cid; same art as ice's 14005903992)
		ToonPuff = 16867383201, -- stylised smoke 4x4 (fire, big)
		Spark = 15431912045, -- white diamond spark streak (cid)
		Ember = 16171528032, -- off-centre sharp dot (fire embers, ice specks)
		Crack = 130848219849162, -- ground cracks (fire)
	},
	layers = {
		------------------------------------------------------------------ flash (0 - 0.09): white core
		{ -- additive starburst popping at full size and shrinking to 0 (anatomy 1; d.1, d.2)
			-- jing 18118762332 51 -> 0 in 0.0153 s; library flash median 1.1 D, life 0.12; here 1.15 D for 3-4 frames
			id = "flashCore", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "StarFlash", Color = "white", LightEmission = 1, Brightness = 6,
				Size = { { 0, 28 }, { 1, 0 } }, Transparency = 0, Lifetime = 0.06,
				Speed = 0, Rotation = { 0, 360 }, ZOffset = 3,
			},
			emit = { { 0, 1 } },
		},
		{ -- SOLID (LE 0) hot star under it: reads as a toon shape and never bloom-washes (d.3)
			-- jing B2 18601496949 LE 0 Br 5 0.057 s; burst ImpactFrame 11187665050 88 -> 0 (0.9 D) in 0.087 s
			id = "flashStar", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "SpikyStar", Color = "hot", LightEmission = 0, Brightness = 6,
				Size = { { 0, 22 }, { 1, 0 } }, Transparency = 0, Lifetime = 0.09,
				Speed = 0, Rotation = { 0, 360 }, ZOffset = 2,
			},
			emit = { { 0, 1 } },
		},
		{ -- thin vertical light pillar for the first frames (d.13)
			-- cinn Flash 15294279094: FacingCameraWorldUp, 20.5 -> 0, Squash 0 -> 10.6 over 0.095 s, LE 1 Br 15
			-- (seen in the first capture only; the recapture's 0.03 and 0.10 stills fall either side of it)
			id = "pillar", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "PillarFlash", Color = "hot", LightEmission = 1, Brightness = 15,
				Orientation = "FacingCameraWorldUp", Size = { { 0, 19 }, { 1, 0 } },
				Squash = { { 0, 0 }, { 1, 10.6 } }, Transparency = 0, Lifetime = 0.095, Speed = 0, ZOffset = 2.5,
			},
			emit = { { 0, 1 } },
		},
		{ -- 4-point cross flare in front of everything (anatomy 1; flares at ZOffset 15 in burst)
			-- fire Star102 17391818367: 25 -> 0 (0.7 D) in 0.086 s, LE 0.5 Br 20; here additive white, 2 crossed
			id = "crossFlare", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "Cross", Color = "white", LightEmission = 1, Brightness = 10,
				Size = { { 0, 26 }, { 1, 0 } }, Transparency = 0, Lifetime = { 0.08, 0.12 },
				Speed = 0, Rotation = { -8, 8 }, ZOffset = 5,
			},
			emit = { { 0, 2 } },
		},
		------------------------------------------------------------------ ink frame behind the flash
		{ -- black burst behind the core: the flash gets a dark silhouette at once (d.4; anatomy 4)
			-- fire "Black Flash" 8133065785: LE -8 Br 0, 0 -> 37 (1 D) in 0.15 s; Brightness 0 renders black
			id = "blackFlash", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "BlackFlash", Color = "ink", LightEmission = 0, Brightness = 0,
				Size = { { 0, 8 }, { 0.25, 26 }, { 1, 30 } }, Transparency = { { 0, 0.15 }, { 0.6, 0.3 }, { 1, 1 } },
				Lifetime = 0.18, Speed = 0, Rotation = { 0, 360 }, ZOffset = -2,
			},
			emit = { { 0, 1 } },
		},
		------------------------------------------------------------------ body (0 - 0.45): saturated orange
		{ -- big soft bloom, soft start so it never covers the core (anatomy 3)
			-- burst 14045123768 0 -> 185 (1.9 D) Tr 0.69; ice 0 -> 40 (0.8 D); library glow 1.16 D
			id = "glow", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "Glow", Color = "orange", LightEmission = 1, Brightness = 3,
				Size = { { 0, 10 }, { 0.3, 36 }, { 1, 40 } }, Transparency = { { 0, 0.7 }, { 1, 1 } },
				Lifetime = 0.25, Speed = 0, ZOffset = -1,
			},
			emit = { { 0, 1 } },
		},
		{ -- 2-3 frame whip-spinning ring at the start (d.11)
			-- jing 18527700887: RotSpeed +-3510, life 0.026-0.049, 0 -> 29 (0.73 D), LE 1 Br 15, flat on the ground
			id = "ringWhip", kind = "emitter", t = 0, life = 0.05, at = { 0, 0.3, 0 },
			props = {
				Texture = "TwoArcRing", Color = "white", LightEmission = 1, Brightness = 15,
				Orientation = "VelocityPerpendicular", EmissionDirection = "Top", Speed = 0.02, SpreadAngle = { 0, 0 },
				Size = { { 0, 0 }, { 1, 18 } }, Transparency = 0, Lifetime = { 0.03, 0.05 },
				Rotation = { 0, 360 }, RotSpeed = { -3500, 3500 }, ZOffset = 1,
			},
			emit = { { 0, 2 } },
		},
		{ -- main ground ring = D, slowly spinning, colour cooling (d.10)
			-- jing 18527700887 0 -> 36.7 (0.9 D), life 0.36-0.69, RotSpeed +-249, spread 15, LE 1 Br 1
			id = "ringFlat", kind = "emitter", t = 0, life = 0.05, at = { 0, 0.3, 0 },
			props = {
				Texture = "TwoArcRing", Color = { { 0, "hot" }, { 0.4, "orange" }, { 1, "red" } },
				LightEmission = 1, Brightness = 2,
				Orientation = "VelocityPerpendicular", EmissionDirection = "Top", Speed = 0.02, SpreadAngle = { 10, 10 },
				Size = { { 0, 4 }, { 1, 24 } }, Transparency = { { 0, 0 }, { 0.6, 0.3 }, { 1, 1 } },
				Lifetime = { 0.35, 0.6 }, Rotation = { 0, 360 }, RotSpeed = { -250, 250 }, ZOffset = 0.5,
			},
			emit = { { 0, 2 } },
		},
		{ -- gyroscope shell: thin rings tilted every way around the core (d.9; anatomy 6)
			-- ice decay16 15269685466 0 -> 41-45 (0.85 D), life 0.07-0.36, spread (360,-360), LE 1 Br 3;
			-- soft start like burst's rings (Tr 0.35-0.81 -> 1, d.23)
			id = "ringShell", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "ThinRing", Color = { { 0, "hot" }, { 1, "orange" } }, LightEmission = 1, Brightness = 3,
				Orientation = "VelocityPerpendicular", EmissionDirection = "Top", Speed = 0.005, SpreadAngle = { 360, -360 },
				Size = { { 0, 0 }, { 1, 22 } }, Transparency = { { 0, 0.4 }, { 1, 1 } },
				Lifetime = { 0.12, 0.3 }, Rotation = { 0, 360 }, RotSpeed = { -150, 150 }, ZOffset = 1,
			},
			emit = { { 0, 4 } },
		},
		{ -- ragged spiky shock on the ground, red-hot rim (anatomy 7). NEGATIVE LE: verify in Studio, else LE 1 Br 3
			-- burst 14538969234 LE -2 Br 55, 0 -> 69 (0.7 D), life 0.38-0.75; milder here. Recapture evidence (d.28):
			-- LE -1 at Br 45 renders a dark #78080F crescent vivid red (big), so expect a saturated rim, not a dark one
			id = "spikyShock", kind = "emitter", t = 0, life = 0.05, at = { 0, 0.2, 0 },
			props = {
				Texture = "SpikyRing", Color = { { 0, "orange" }, { 1, "ember" } }, LightEmission = -1, Brightness = 25,
				Orientation = "VelocityPerpendicular", EmissionDirection = "Top", Speed = 0.02, SpreadAngle = { 0, 0 },
				Size = { { 0, 0 }, { 1, 17 } }, Transparency = { { 0, 0 }, { 0.7, 0.2 }, { 1, 1 } },
				Lifetime = { 0.3, 0.5 }, Rotation = { 0, 360 }, ZOffset = 0.2,
			},
			emit = { { 0, 1 } },
		},
		{ -- squash-morph needle sparks: wide -> needle -> wide (d.14; anatomy 8)
			-- burst 7136536841: FacingCameraWorldUp, swell 0 -> 18 @9 %, Squash -3 -> +1 @9 % -> -2, Speed 18-62,
			-- spread 3555, life 0.13-0.42, LE 1 Br 35, x15-36; sizes here 0.18 D
			id = "streaks", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "Lines", Color = "hot", LightEmission = 1, Brightness = 20,
				Orientation = "FacingCameraWorldUp", EmissionDirection = "Top", SpreadAngle = { 180, 180 },
				Speed = { 20, 45 }, Size = { { 0, 0 }, { 0.09, 4.4 }, { 1, 0 } },
				Squash = { { 0, -3 }, { 0.09, 1 }, { 1, -2 } }, Transparency = 0,
				Lifetime = { 0.15, 0.3 }, ZOffset = 3,
			},
			emit = { { 0, 20 } },
		},
		{ -- the black twin of the streaks: same motion, Brightness 0, a hair behind (d.5)
			-- burst 7136536841 LE 0 Br 0 copies (4+4), ZOffset 2.98 vs 2.99
			id = "streakInk", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "Lines", Color = "ink", LightEmission = 0, Brightness = 0,
				Orientation = "FacingCameraWorldUp", EmissionDirection = "Top", SpreadAngle = { 180, 180 },
				Speed = { 25, 50 }, Size = { { 0, 0 }, { 0.09, 4.8 }, { 1, 0 } },
				Squash = { { 0, -3 }, { 0.09, 1 }, { 1, -2 } }, Transparency = 0,
				Lifetime = { 0.15, 0.3 }, ZOffset = 2.9,
			},
			emit = { { 0, 12 } },
		},
		{ -- toon flame tongues thrown out and stopped, stretching then thinning (anatomy 9)
			-- cid 15413764911 LE 0.45 Br 7, Squash 0.3 -> 1.39 @45 % -> 0, Drag 6.7; ice 14005903992 (same art)
			-- 0 -> 19 (0.38 D), Speed 44-197, Drag 8.56 -> travel ~0.45 D
			id = "flames", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "FlameShard", FlipbookLayout = 4, FlipbookMode = "OneShot",
				Color = { { 0, "hot" }, { 0.4, "orange" }, { 1, "red" } }, LightEmission = 0.45, Brightness = 8,
				Orientation = "VelocityParallel", EmissionDirection = "Top", SpreadAngle = { 180, 180 },
				Speed = { 20, 80 }, Drag = 8, Size = { { 0, 3 }, { 0.3, 9 }, { 1, 9 } },
				Squash = { { 0, 0.3 }, { 0.45, 1.4 }, { 1, 0 } }, Transparency = 0,
				Lifetime = { 0.35, 0.7 }, ZOffset = 1,
			},
			emit = { { 0, 8 } },
		},
		{ -- orange toon fire puffs: the saturated mass of the break-up (anatomy 12)
			-- big Flame1 16867383201 LE 1 Br 5; fire 16867383201 0 -> 9.8 (0.26 D); here 0.5 D, Speed/Drag ~0.4 D
			id = "fireBlobs", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "ToonPuff", FlipbookLayout = 4, FlipbookMode = "OneShot",
				Color = { { 0, "hot" }, { 0.3, "orange" }, { 0.7, "red" }, { 1, "ember" } },
				LightEmission = 0.3, Brightness = 6,
				Speed = { 15, 45 }, Drag = 6.5, SpreadAngle = { 180, 180 }, EmissionDirection = "Top",
				Size = { { 0, 2 }, { 0.2, 10 }, { 1, 12 } }, Transparency = { { 0, 0 }, { 0.8, 0.1 }, { 1, 1 } },
				Lifetime = { 0.4, 0.8 }, Rotation = { 0, 360 }, RotSpeed = { -60, 60 }, ZOffset = 0.5,
			},
			emit = { { 0, 7 } },
		},
		{ -- white-hot spark streaks with a little gravity (anatomy 8/11; d.19)
			-- cid 15431912045 VelocityParallel, swell 0 -> 4.25 @5 % -> 0, Drag 9.58, LE 1 Br 15, x25;
			-- speed lowered so travel ~ 140/8 = 0.7 D (cid's reached 1.6 D)
			id = "sparks", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "Spark", Color = { { 0, "white" }, { 0.5, "hot" }, { 1, "orange" } },
				LightEmission = 1, Brightness = 15,
				Orientation = "VelocityParallel", EmissionDirection = "Top", SpreadAngle = { 180, 180 },
				Speed = { 50, 140 }, Drag = 8, Acceleration = { 0, -20, 0 },
				Size = { { 0, 0 }, { 0.05, 1.4 }, { 1, 0 } }, Transparency = 0,
				Lifetime = { 0.3, 0.6 }, ZOffset = 2,
			},
			emit = { { 0, 25 } },
		},
		{ -- a few hot embers that drift and orbit, carrying the linger alone (d.18)
			-- fire 16171528032: Size 2.69 -> 0, Speed 22-79, Drag 3.24, RotSpeed 97-162, life 1.85-3.7, x4,
			-- LE -2 Br 200 there; LE 1 Br 25 here (safer), test the original in Studio
			id = "embers", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "Ember", Color = { { 0, "hot" }, { 0.5, "orange" }, { 1, "red" } },
				LightEmission = 1, Brightness = 25,
				EmissionDirection = "Top", SpreadAngle = { 120, 120 }, Speed = { 10, 30 }, Drag = 3.2,
				Acceleration = { 0, 2, 0 }, Size = { { 0, 1.2 }, { 1, 0 } }, Transparency = 0,
				Lifetime = { 1.5, 2.8 }, Rotation = { 0, 360 }, RotSpeed = { 97, 162 }, ZOffset = 1.5,
			},
			emit = { { 0, 5 } },
		},
		------------------------------------------------------------------ ink smoke + ground (0.1 - 2.8)
		{ -- dark smoke rising behind the fire, ramping to black (d.6, d.8; anatomy 13)
			-- fire flipbooks #A6623C -> #090503 -> #000000, LE -1 Br 5, Speed 20-170, Drag 6.5-9, life 0.86-2;
			-- LE 0 Br 1.5 here (same ramp, no negative LE), 0.58 D, rises
			id = "darkSmoke", kind = "emitter", t = 0, life = 0.05, at = { 0, 3, 0 },
			props = {
				Texture = "ToonPuff", FlipbookLayout = 4, FlipbookMode = "OneShot",
				Color = { { 0, "smokeBrown" }, { 0.35, "smokeMid" }, { 1, "ink" } },
				LightEmission = 0, Brightness = 1.5,
				EmissionDirection = "Top", SpreadAngle = { 70, 70 }, Speed = { 8, 30 }, Drag = 6.5,
				Acceleration = { 0, 3, 0 }, Size = { { 0, 3 }, { 0.3, 11 }, { 1, 14 } },
				Transparency = { { 0, 0.1 }, { 0.7, 0.3 }, { 1, 1 } },
				Lifetime = { 0.9, 1.6 }, Rotation = { 0, 360 }, RotSpeed = { -40, 40 }, ZOffset = -1,
			},
			emit = { { 0, 8 } },
		},
		{ -- ground crack: pops to full in ~6 % of its life, glows orange, cools to black (anatomy 14)
			-- fire 130848219849162 #F35529 -> #000000, LE 0 Br 15, 0 -> 17.8 (0.48 D), life 1.82 (not 14-16 s)
			id = "crack", kind = "emitter", t = 0, life = 0.05, at = { 0, 0.1, 0 },
			props = {
				Texture = "Crack", Color = { { 0, "crackHot" }, { 0.5, "ember" }, { 1, "ink" } },
				LightEmission = 0, Brightness = 15,
				Orientation = "VelocityPerpendicular", EmissionDirection = "Top", Speed = 0.01, SpreadAngle = { 0, 0 },
				Size = { { 0, 6 }, { 0.06, 11 }, { 1, 12 } }, Transparency = { { 0, 0 }, { 0.34, 0 }, { 1, 1 } },
				Lifetime = 1.6, Rotation = { 0, 360 }, ZOffset = 0.1,
			},
			emit = { { 0, 1 } },
		},
	},
}
