-- VoidRend: void ground explosion, recreated from the reference "Styl_VoidRend_v2" (a third-party
-- reference video; its breakdown is summarised in log/LOG.md) as the first test of the VFX pipeline. Played by VFXTimeline; times in seconds.
-- Phases: strike 0-0.1, rise + charge 0.1-0.75, implode 0.75-0.95, burst 0.97-1.65, cool-down 1.5-1.95, linger to ~3.3.
-- v9 = final of the first run (4 blind review rounds; see log/LOG.md).
-- Scale: pillar ~15 studs tall, disc 9 -> 11 studs (opts.scale resizes everything). Templates: VR_CrescentSlim,
-- VR_SpikeCrown (kit/examples/VoidRend/meshes). Review history: log/LOG.md.
-- Orientation: the capture camera sits on the -Z side looking toward +Z, so world +X is screen LEFT. Layer ids say
-- screen sides (crescentL = left of the pillar on screen). "Toward the camera" = -Z.
return {
	name = "VoidRend",
	palette = {
		white = "#FFF0FF",
		lilac = "#E0B4FF",
		pink = "#FF3C9A",
		magenta = "#D24BFF",
		horn = "#8A5AA4", -- between v6 #8458A0 (rendered blue-purple) and v8 #A08CB8 (rendered pastel); target #BA3CD8
		violet = "#8A32E6",
		deepViolet = "#4A2A8A",
		indigo = "#3A2BD0",
		navy = "#120A35",
		ink = "#000000",
	},
	textures = { -- VFX Studio picks (textures/picks.json) + our own (textures/ids.json)
		ImpactSplash = 104479959935534, -- grid 4, one-shot jagged burst
		Shards = 95959360430420, -- grid 4
		Smoke = 125025427182492, -- grid 4
		SoftOrb = 2065086791, -- near-flat disc with a soft edge (ground glows)
		Haze = 867619398, -- very soft hazy blob (bokeh orbs)
		GroundSwirl = 10352554571,
		BeamBody = 14191603094,
		Lightning = 80308325487892,
		CrownFlash = 88765597194916,
		ShockRing = 100035775651006,
		StarCrater = 91421731156336, -- VR_StarCrater (ours)
		Curl = 115095839658434, -- VR_Curl (ours)
		SoftDisc = 108633958198160, -- VR_SoftDisc (ours)
		StarFlash = 12363773284,
		Sparkle4 = 120724457343104,
	},
	layers = {
		------------------------------------------------------------------ strike (0 - 0.1)
		{ -- white spike dropping onto the ground: thick head below, thin tail above
			id = "strike", kind = "beam", t = 0, life = 0.16,
			a = { 0, 5, 0 }, b = { 0, 11, 0 },
			props = { Width0 = 0.5, Width1 = 0, Color = "#FFF4D8", LightEmission = 1, Brightness = 4, Transparency = 0 },
			tracks = {
				A = { { 0, { 0, 0, 0 } }, { 0.07, { 0, -5, 0 }, "quadIn" } },
				B = { { 0, { 0, 0, 0 } }, { 0.07, { 0, 6, 0 }, "quadIn" } },
				Width = { { 0.07, 1 }, { 0.16, 0.5 } },
				Fade = { { 0.1, 0 }, { 0.16, 1 } },
			},
		},
		{ -- contact crown lying on the ground
			id = "crownFlat", kind = "emitter", t = 0.07, life = 0.05, at = { 0, 0.12, 0 },
			props = {
				Texture = "CrownFlash", Color = "white", LightEmission = 1, Brightness = 3,
				Orientation = "VelocityPerpendicular", Speed = 0.01, EmissionDirection = "Top",
				Size = { { 0, 2.5 }, { 1, 5 } }, Transparency = { { 0, 0 }, { 0.5, 0.1 }, { 1, 1 } },
				Lifetime = 0.18, Rotation = { 0, 360 },
			},
			emit = { { 0, 1 } },
		},
		{ -- contact crown: white star splash at the hit point
			id = "crown", kind = "emitter", t = 0.07, life = 0.05, at = { 0, 1.2, 0 },
			props = {
				Texture = "StarFlash", Color = "white", LightEmission = 1, Brightness = 3,
				Size = { { 0, 3 }, { 1, 5 } }, Transparency = { { 0, 0 }, { 0.6, 0.2 }, { 1, 1 } },
				Lifetime = 0.14, Speed = 0, Rotation = { 0, 360 },
			},
			emit = { { 0, 1 } },
		},
		------------------------------------------------------------------ pillar (0.08 - 0.86)
		{ -- wide cone: white -> pink-white -> lilac -> violet; a thin strand to ~0.78 s
			id = "pillar", kind = "beam", t = 0.08, life = 0.78,
			a = { 0, 0, 0 }, b = { 0, 15, 0 },
			props = {
				Width0 = 5.5, Width1 = 0.2, Color = "white", LightEmission = 1, Brightness = 1.2,
				Texture = "BeamBody", TextureMode = "Wrap", TextureLength = 9, TextureSpeed = 1.6,
				Transparency = { { 0, 0 }, { 0.7, 0.1 }, { 1, 1 } },
			},
			tracks = {
				Color = { { 0, "white" }, { 0.03, "#F5C8E0" }, { 0.12, "lilac" }, { 0.3, "#B070E8" } },
				Width = { { 0, 0.05 }, { 0.17, 1, "quadOut" }, { 0.55, 1 }, { 0.65, 0.4 }, { 0.78, 0, "quadIn" } },
			},
		},

		{ -- violet core; a thin strand survives into the quiet beat
			id = "pillarCore", kind = "beam", t = 0.15, life = 0.8, a = { 0, 0, 0 }, b = { 0, 18, 0 },
			props = { Width0 = 0.7, Width1 = 0.3, Color = "#A060F0", LightEmission = 1, Brightness = 1,
				Transparency = { { 0, 0.05 }, { 0.8, 0.25 }, { 1, 1 } } },
			tracks = { Width = { { 0, 0.2 }, { 0.1, 1, "quadOut" }, { 0.45, 1 }, { 0.6, 0.15 }, { 0.78, 0, "quadIn" } } },
		},

		{ -- white hairlines up the pillar (flicker by copies)
			id = "hairline", kind = "beam", t = 0.1, life = 0.18, a = { 0, 0, 0 }, b = { 0, 11, 0 },
			copies = { n = 6, every = 0.1, jitter = 0.05, spread = { 1.6, 0, 0.5 } },
			props = { Width0 = 0.08, Width1 = 0.05, Color = "white", LightEmission = 1, Brightness = 2,
				Transparency = { { 0, 0.1 }, { 1, 1 } } },
			tracks = { Fade = { { 0, 0 }, { 0.12, 0 }, { 0.18, 1 } } },
		},
		{ -- thin muted electric squiggle in front of the pillar (each copy a new shape for 2-4 frames)
			id = "squiggle", kind = "beam", t = 0.16, life = 0.09, a = { 0, 0.5, -1.2 }, b = { 0, 15, -1.2 },
			copies = { n = 9, every = 0.06, jitter = 0.03, spread = { 0.8, 0, 0.3 }, rotSpread = { 0, 30, 0 } },
			props = { Width0 = 1.6, Width1 = 1.0, Color = "#E070FF", LightEmission = 1, Brightness = 2,
				Texture = "Lightning", TextureMode = "Stretch", Transparency = 0 },
		},
		{ -- soft purple glow under the base, about horn-width, handing over to the swirl
			id = "pool", kind = "emitter", t = 0.14, life = 0.05, at = { 0, 0.15, 0 },
			props = {
				Texture = "SoftOrb", Color = "#7A30C0", LightEmission = 1, Brightness = 1.2,
				Orientation = "VelocityPerpendicular", Speed = 0.01, EmissionDirection = "Top",
				Size = { { 0, 4 }, { 0.3, 8.5 }, { 1, 9 } }, Transparency = { { 0, 0.3 }, { 0.5, 0.45 }, { 1, 1 } },
				Lifetime = 0.65,
			},
			emit = { { 0, 1 } },
		},

		{ -- dark-blue swirl ring on the ground during the charge
			id = "chargeRing", kind = "emitter", t = 0.15, life = 0.05, at = { 0, 0.1, 0 },
			props = {
				-- on screen ~ texture x Color x opacity: author ~2.5x the target #1A1268
				Texture = "GroundSwirl", Color = "#6A30D8", LightEmission = 0.1, Brightness = 1,
				Orientation = "VelocityPerpendicular", Speed = 0.01, EmissionDirection = "Top",
				Size = { { 0, 5 }, { 0.2, 6.5 }, { 1, 7 } }, Transparency = { { 0, 0.45 }, { 0.8, 0.55 }, { 1, 1 } },
				Lifetime = 0.8, RotSpeed = { 120, 120 },
			},
			emit = { { 0, 1 } },
		},
		------------------------------------------------------------------ horns (0.1 - 0.76), asymmetric
		{ -- screen-left horn: slim tusk standing on the front of the ring, early, bright until ~0.55 s
			id = "crescentL", kind = "part", template = "VR_CrescentSlim", t = 0.1, life = 0.65,
			at = { 2.4, -0.3, -1.5 }, rot = { 0, 90, -8 }, pivot = { 0, -0.5, -0.5 },
			props = { Material = "Neon", Color = "horn" },
			tracks = {
				Scale = { { 0, 0.05 }, { 0.1, 0.5, "quadOut" }, { 0.3, 0.7 }, { 0.5, 0.7 }, { 0.65, 0.25, "quadIn" } },
				Rot = { { 0, { 0, -10, 0 } }, { 0.65, { 0, 12, 0 } } },
				Color = { { 0.25, "horn" }, { 0.45, "deepViolet" }, { 0.65, "#2A1C70" } },
				Transparency = { { 0.52, 0 }, { 0.65, 1 } },
			},
		},


		{ -- screen-right horn: small at the base from 0.15 s, snaps big at ~0.37 s, leaning out
			id = "crescentR", kind = "part", template = "VR_CrescentSlim", t = 0.15, life = 0.61,
			at = { -3.2, -0.3, -2 }, rot = { 0, -90, 14 }, pivot = { 0, -0.5, -0.5 },
			props = { Material = "Neon", Color = "horn" },
			tracks = {
				Scale = { { 0, 0.05 }, { 0.05, 0.3, "quadOut" }, { 0.21, 0.35 }, { 0.27, 0.83, "quadOut" }, { 0.46, 0.85 },
					{ 0.61, 0.35, "quadIn" } },
				Rot = { { 0, { 0, 8, 0 } }, { 0.61, { 0, -10, 0 } } },
				Color = { { 0.36, "horn" }, { 0.5, "deepViolet" }, { 0.61, "#2A1C70" } },
				Transparency = { { 0.48, 0 }, { 0.61, 1 } },
			},
		},

		{ -- tall dark indigo spire behind the pillar, screen left (the cage's ink)
			id = "crescentBack", kind = "part", template = "VR_CrescentSlim", t = 0.18, life = 0.5,
			at = { 1.3, 0, 2 }, rot = { 0, -35, 0 }, pivot = { 0, -0.5, -0.5 },
			props = { Material = "Neon", Color = "#2A2090", Transparency = 0 },
			tracks = {
				Scale = { { 0, 0.05 }, { 0.2, 0.9, "backOut" }, { 0.5, 0.35, "quadIn" } },
				Transparency = { { 0.35, 0 }, { 0.5, 1 } },
			},
		},

		------------------------------------------------------------------ lasers (0.35 - 0.95)
		{ -- thin pink lines crossing low through the cage, each on for 3-6 frames
			id = "laser", kind = "beam", t = 0.35, life = 0.14, a = { -9, 2.8, 0 }, b = { 9, 2.8, 0 },
			copies = { n = 8, every = 0.065, jitter = 0.03, spread = { 1.5, 1.2, 2 }, rotSpread = { 0, 8, 7 } },
			props = { Width0 = 0.11, Width1 = 0.11, Color = "#E05AC8", LightEmission = 1, Brightness = 1.5,
				Transparency = { { 0, 1 }, { 0.15, 0 }, { 0.85, 0 }, { 1, 1 } } },
			tracks = { Fade = { { 0, 0 }, { 0.1, 0 }, { 0.14, 1 } } },
		},
		{ -- tiny sparkles packed low round the base, a last few in the implode
			id = "chargeSparkles", kind = "emitter", t = 0.2, life = 0.75, at = { 0, 3, 0 }, box = { 5, 4, 3 },
			props = {
				Texture = "Sparkle4", FlipbookLayout = 8, FlipbookMode = "OneShot", Color = "white", LightEmission = 1,
				Brightness = 2, Size = { { 0, 0.3 }, { 1, 0.1 } }, Lifetime = { 0.3, 0.6 }, Speed = { 0, 1 },
				Shape = "Box", Transparency = 0,
			},
			emit = { { 0, 30, 0.6 }, { 0.55, 8, 0.15 } },
		},

		{ -- tiny curl hooks packed low round the base, sinking inward
			id = "curls", kind = "emitter", t = 0.25, life = 0.7, at = { 0, 2.5, 0 }, box = { 4, 3, 3 },
			props = {
				Texture = "Curl", Color = { { 0, "lilac" }, { 1, "violet" } }, LightEmission = 1, Brightness = 2,
				Size = { { 0, 0.45 }, { 1, 0.25 } }, Lifetime = { 0.3, 0.5 }, Speed = { 0.2, 0.8 }, Shape = "Box",
				Acceleration = { 0, -1, 0 }, Rotation = { 0, 360 }, RotSpeed = { -300, 300 },
				Transparency = { { 0, 0 }, { 0.7, 0 }, { 1, 1 } },
			},
			emit = { { 0, 26, 0.7 } },
		},
		{ -- glowing indigo-violet soft puff beside the centre through the quiet beat
			id = "flankL", kind = "emitter", t = 0.8, life = 0.05, at = { 4, 2, 0 },
			props = { Texture = "Haze", Color = "#5A30D0", LightEmission = 0.6, Size = 5, Speed = 0, Lifetime = 0.45,
				Transparency = { { 0, 1 }, { 0.3, 0.4 }, { 1, 1 } } },
			emit = { { 0, 1 } },
		},

		{ -- glowing indigo-violet soft puff beside the centre through the quiet beat
			id = "flankR", kind = "emitter", t = 0.82, life = 0.05, at = { -4, 2, 0 },
			props = { Texture = "Haze", Color = "#5A30D0", LightEmission = 0.6, Size = 5, Speed = 0, Lifetime = 0.45,
				Transparency = { { 0, 1 }, { 0.3, 0.4 }, { 1, 1 } } },
			emit = { { 0, 1 } },
		},

		------------------------------------------------------------------ burst (0.97 - 1.6)
		{ -- milky pale-lilac half dome on the ground: grows over 3 frames, swells to ~1.17 s, gone by ~1.31 s
			id = "dome", kind = "part", t = 0.97, life = 0.34, at = { 0, 0, 0 },
			props = { Shape = "Ball", Material = "Neon", Color = "#F0DAFF" }, size = 7.5,
			tracks = {
				Scale = { { 0, 0.4 }, { 0.03, 0.65 }, { 0.07, 0.95, "quadOut" }, { 0.3, 1.12 } },
				Color = { { 0, "#F0DAFF" }, { 0.03, "#ACA0B8", "step" }, { 0.3, "#8A7A9C" } },
				Transparency = { { 0.03, 0 }, { 0.04, 0.12, "step" }, { 0.22, 0.12 }, { 0.34, 1 } },
			},
		},


		{ -- white needles through the centre
			id = "needle", kind = "beam", t = 0.97, life = 0.32, a = { -8, 3, 0 }, b = { 8, 3, 0 },
			copies = { n = 3, every = 0.02, jitter = 0.04, rotSpread = { 15, 60, 70 } },
			props = { Width0 = 0.08, Width1 = 0.02, Color = "white", LightEmission = 1, Brightness = 2,
				Transparency = { { 0, 1 }, { 0.3, 0 }, { 0.7, 0 }, { 1, 1 } } },
			tracks = { Fade = { { 0.2, 0 }, { 0.32, 1 } } },
		},
		{ -- crumpled spike fringe hugging the dome: small until ~1.1 s, full at ~1.25 s, hangs and fades by ~1.63 s
			id = "spikes", kind = "part", template = "VR_SpikeCrown", t = 1.03, life = 0.6, at = { 0, 0.6, 0 },
			pivot = { -0.053, -0.479, 0.039 },
			props = { Material = "Neon", Color = "#A498B2" }, size = { 11, 5, 11 },
			tracks = {
				Scale = { { 0, 0.3 }, { 0.08, 0.45 }, { 0.22, 0.95, "quadOut" }, { 0.45, 1.05 } },
				Rot = { { 0, { 0, 0, 0 } }, { 0.6, { 0, 18, 0 } } },
				Color = { { 0.05, "#A498B2" }, { 0.3, "#6E5884" }, { 0.5, "#3A2C60" } },
				Transparency = { { 0.3, 0 }, { 0.45, 0.4 }, { 0.6, 1 } },
			},
		},


		{ -- jagged toon splash round the ball (camera-facing flipbook)
			id = "splash", kind = "emitter", t = 0.98, life = 0.05, at = { 0, 1.8, 0 },
			props = {
				Texture = "ImpactSplash", FlipbookLayout = 4, FlipbookMode = "OneShot",
				Color = { { 0, "lilac" }, { 1, "violet" } }, LightEmission = 0.2, Brightness = 1,
				Size = { { 0, 5 }, { 1, 8 } }, Lifetime = 0.45, Rotation = { 0, 360 },
				Transparency = { { 0, 0.15 }, { 0.8, 0.2 }, { 1, 1 } },
			},
			emit = { { 0, 1 } },
		},
		{ -- ground disc: pale lilac-pink on its first frames, magenta, blue from ~1.5 s
			id = "disc", kind = "part", t = 1.03, life = 0.75, at = { 0, 0.04, 0 }, rot = { 0, 0, 90 },
			props = { Shape = "Cylinder", Material = "Neon", Color = "#A08CB0" }, size = { 0.08, 9, 9 },
			tracks = {
				Scale = { { 0, { 1, 0.7, 0.7 } }, { 0.27, { 1, 1.22, 1.22 }, "quadOut" } },
				Color = { { 0, "#A08CB0" }, { 0.1, "#7A4890" }, { 0.37, "#7A4890" }, { 0.48, "#3A2898" }, { 0.62, "#24187A" } },
				Transparency = { { 0.5, 0 }, { 0.75, 1 } },
			},
		},

		{
			id = "discRing", kind = "part", t = 1.03, life = 0.55, at = { 0, 0.07, 0 }, rot = { 0, 0, 90 },
			props = { Shape = "Cylinder", Material = "Neon", Color = "#8A5AA8" }, size = { 0.08, 6.5, 6.5 },
			tracks = {
				Scale = { { 0, { 1, 0.7, 0.7 } }, { 0.27, { 1, 1.22, 1.22 }, "quadOut" } },
				Color = { { 0.3, "#8A5AA8" }, { 0.45, "#6A3088" } },
				Transparency = { { 0.35, 0 }, { 0.55, 1 } },
			},
		},
		{
			id = "discInner", kind = "part", t = 1.03, life = 0.55, at = { 0, 0.1, 0 }, rot = { 0, 0, 90 },
			props = { Shape = "Cylinder", Material = "Neon", Color = "#8A4AA6" }, size = { 0.08, 5.2, 5.2 },
			tracks = {
				Scale = { { 0, { 1, 0.7, 0.7 } }, { 0.27, { 1, 1.22, 1.22 }, "quadOut" } },
				Transparency = { { 0.35, 0 }, { 0.55, 1 } },
			},
		},
		{ -- the black spiky crater star (the ink of the burst), growing with the disc
			id = "crater", kind = "emitter", t = 1.03, life = 0.05, at = { 0, 0.16, 0 },
			props = {
				Texture = "StarCrater", Color = "ink", LightEmission = 0,
				Orientation = "VelocityPerpendicular", Speed = 0.01, EmissionDirection = "Top",
				Size = { { 0, 3 }, { 0.5, 4.8 }, { 1, 4.8 } }, Rotation = { 0, 360 },
				Transparency = { { 0, 0 }, { 0.75, 0 }, { 1, 1 } }, Lifetime = 0.6, ZOffset = 1,
			},
			emit = { { 0, 1 } },
		},
		{ -- tall hoops from the disc rim over the dome
			id = "arch", kind = "beam", t = 1.12, life = 0.4, a = { -4.8, 0, 0 }, b = { 4.8, 0, 0 }, axis = { 0, 1, 0 },
			copies = { n = 4, rotSpread = { 0, 20, 0 }, yawEven = true },
			props = { Width0 = 0.35, Width1 = 0.35, CurveSize0 = 6, CurveSize1 = -6, Segments = 16, Color = "#A060E0",
				LightEmission = 1, Brightness = 1.2, Transparency = 0 },
			tracks = { Fade = { { 0.25, 0 }, { 0.4, 1 } } },
		},

		{ -- dim purple splatter that hangs and drifts up into the smoke
			id = "shards", kind = "emitter", t = 1.25, life = 0.1, at = { 0, 2, 0 },
			props = {
				Texture = "Shards", FlipbookLayout = 4, FlipbookMode = "OneShot",
				Color = { { 0, "#B080D8" }, { 0.5, "violet" }, { 1, "deepViolet" } }, LightEmission = 0.4, Brightness = 1.5,
				Size = { { 0, 2.5 }, { 1, 0.8 } }, Lifetime = { 0.6, 0.9 }, Speed = { 6, 12 }, Drag = 12,
				SpreadAngle = { 75, 75 }, Acceleration = { 0, 1, 0 }, Rotation = { 0, 360 }, RotSpeed = { -200, 200 },
				Transparency = { { 0, 0 }, { 0.7, 0 }, { 1, 1 } },
			},
			emit = { { 0, 24 } },
		},

		{ -- burst light
			id = "light", kind = "light", t = 0.97, life = 0.7, at = { 0, 4, 0 },
			props = { Color = "magenta", Range = 24, Brightness = 0 },
			tracks = { Brightness = { { 0, 0 }, { 0.03, 1.5 }, { 0.7, 0, "quadOut" } } },
		},
		------------------------------------------------------------------ cool-down + linger (1.3 - 3.3)
		{ -- filled navy disc left on the ground
			id = "coolDisc", kind = "emitter", t = 1.45, life = 0.05, at = { 0, 0.08, 0 },
			props = {
				Texture = "SoftDisc", Color = "#2A1470", LightEmission = 0,
				Orientation = "VelocityPerpendicular", Speed = 0.01, EmissionDirection = "Top",
				Size = 9.5, Transparency = { { 0, 0.2 }, { 0.7, 0.4 }, { 1, 1 } }, Lifetime = 1.2,
			},
			emit = { { 0, 1 } },
		},
		{ -- one dark-violet ring near disc size, lingering
			id = "coolRing", kind = "emitter", t = 1.55, life = 0.05, at = { 0, 0.12, 0 },
			props = {
				Texture = "ShockRing", Color = "#4A20A8", LightEmission = 0.2, Brightness = 1,
				Orientation = "VelocityPerpendicular", Speed = 0.01, EmissionDirection = "Top",
				Size = { { 0, 8 }, { 1, 10.5 } }, Transparency = { { 0, 0.1 }, { 1, 1 } }, Lifetime = 0.45,
			},
			emit = { { 0, 1 } },
		},


		{ -- purple smoke piling up over the disc
			id = "smoke", kind = "emitter", t = 1.3, life = 0.3, at = { 0, 1.5, 0 }, box = { 7, 2.5, 4 },
			props = {
				Texture = "Smoke", FlipbookLayout = 4, FlipbookMode = "OneShot",
				Color = { { 0, "#A048E0" }, { 0.4, "#7030C0" }, { 1, "#3A1890" } }, LightEmission = 0.15, Brightness = 1,
				Size = { { 0, 2.5 }, { 0.3, 3.5 }, { 1, 4 } }, Lifetime = { 1.6, 2.0 }, Speed = { 0.2, 0.5 }, Shape = "Box",
				Rotation = { 0, 360 }, RotSpeed = { -30, 30 }, Transparency = { { 0, 0.3 }, { 0.6, 0.45 }, { 1, 1 } },
			},
			emit = { { 0, 12, 0.3 } },
		},


		{ -- dim magenta-violet haze orbs, high and to the sides, fading
			id = "orbs", kind = "emitter", t = 1.35, life = 0.35, at = { 0, 5, 0 }, box = { 14, 5, 6 },
			props = {
				Texture = "Haze", Color = "#A040C0", LightEmission = 0.3, Brightness = 1,
				Size = { { 0, 2.5 }, { 1, 2.8 } }, Lifetime = { 1.4, 1.8 }, Speed = { 0.3, 0.8 }, Shape = "Box",
				Transparency = { { 0, 1 }, { 0.1, 0.7 }, { 0.4, 0.78 }, { 1, 1 } },
			},
			emit = { { 0, 5, 0.3 } },
		},


		{ -- fine pink-white twinkle dust
			id = "twinkles", kind = "emitter", t = 1.1, life = 1.6, at = { 0, 4, 0 }, box = { 16, 8, 8 },
			props = {
				Texture = "Sparkle4", FlipbookLayout = 8, FlipbookMode = "OneShot", Color = { { 0, "white" }, { 1, "#E090F0" } },
				LightEmission = 1, Brightness = 2, Size = { { 0, 0.3 }, { 1, 0.1 } }, Lifetime = { 0.3, 0.7 },
				Speed = { 0, 0.5 }, Shape = "Box",
			},
			emit = { { 0, 120, 1.6 } },
		},
		{ -- lilac curls on the smoke tops
			id = "smokeCurls", kind = "emitter", t = 1.5, life = 0.5, at = { 0, 2.5, 0 }, box = { 6, 2, 4 },
			props = {
				Texture = "Curl", Color = { { 0, "lilac" }, { 1, "violet" } }, LightEmission = 1, Brightness = 1.5,
				Size = { { 0, 0.45 }, { 1, 0.25 } }, Lifetime = { 0.4, 0.7 }, Speed = { 0.2, 0.6 }, Shape = "Box",
				Rotation = { 0, 360 }, RotSpeed = { -200, 200 }, Transparency = { { 0, 0 }, { 0.7, 0.2 }, { 1, 1 } },
			},
			emit = { { 0, 15, 0.5 } },
		},


		------------------------------------------------------------------ world grade (whole effect)
		{
			id = "grade", kind = "grade", t = 0, life = 3.0,
			props = { Contrast = 0, TintColor = "#FFFFFF", Brightness = 0 },
			tracks = {
				Contrast = { { 0, 0 }, { 0.06, 0.25 }, { 2.0, 0.25 }, { 3.0, 0, "sineInOut" } },
				TintColor = { { 0, "#FFFFFF" }, { 0.06, "#E2D2FF" }, { 2.0, "#E2D2FF" }, { 3.0, "#FFFFFF", "sineInOut" } },
				Brightness = { { 0, 0 }, { 0.06, -0.06 }, { 2.0, -0.06 }, { 3.0, 0, "sineInOut" } },
			},
		},
	},
}
