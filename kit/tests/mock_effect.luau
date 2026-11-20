-- API smoke test for kit/stage.luau, NOT a design: a dummy steps forward and raises its right arm, a ball flies
-- from its hand, a glow sprite rides the ball, a ground mark grows, a one-shot event fires at 0.5 s.
-- kit/tests/run.sh appends this to kit/stage.luau to make a mock final.luau.

local TEX_GLOW = "rbxasset://textures/particles/explosion01_implosion_main.dds"
local TEX_MARK = "rbxasset://textures/particles/explosion01_smoke_main.dds"

_G.MockLog = {}

local stage = Stage.define({
	name = "LAB_mock_effect",
	length = 2.0,
	build = function(S)
		local O = S.origin
		local hero = S:dummy({ name = "Hero" })
		local pose = hero:keys({
			{ t = 0, at = S.cf, j = {} },
			{ t = 0.4, at = S.cf * CFrame.new(0, 0, -1.5), j = { RightShoulder = Stage.deg(90, 0, 0), Waist = Stage.deg(0, -15, 0) } },
			{ t = 2.0, j = { RightShoulder = Stage.deg(90, 0, 0) } },
		})
		local ball = S:part({ Name = "Ball", Shape = Enum.PartType.Ball, Size = Vector3.new(1, 1, 1), Material = Enum.Material.Neon })
		local glow = S:sprite(TEX_GLOW, { lightEmission = 1, color = Color3.fromRGB(255, 200, 90), zOffset = 1 })
		local mark = S:decal(TEX_MARK, { color = Color3.new(0, 0, 0) })
		S:at(0.5, function(t) table.insert(_G.MockLog, string.format("launch@%.3f", t)) end)
		S:on(function(t)
			pose(t)
			local fly = math.max(0, t - 0.5)
			local p = O + Vector3.new(0, 3.5 + 2 * fly - 2 * fly * fly, -3 - 12 * fly)
			ball.CFrame = CFrame.new(p)
			ball.Transparency = 1 - Stage.window(t, 0.5, 1.8, 0.05, 0.3)
			glow:set({ pos = p, size = 3 + math.sin(t * 20) * 0.5, transparency = ball.Transparency })
			mark:set({ cf = CFrame.new(O + Vector3.new(0, 0.03, -3)), size = 2 + 6 * Stage.easeOut(fly / 1.3),
				transparency = 1 - 0.7 * Stage.window(t, 0.5, 2.0, 0.1, 0.5) })
		end)
	end,
})
_G.MockStage = stage
print("[LAB_mock_effect] ready")
