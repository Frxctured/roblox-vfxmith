--!nocheck
-- Checks for kit/stage.luau + the mock final (run.sh: mock_roblox + stage + mock_effect + this file).
local fails = 0
local function ok(cond, msg)
	if cond then print("ok   " .. msg) else fails += 1 print("FAIL " .. msg) end
end
local function child(p, n)
	local c = p and p:FindFirstChild(n)
	assert(c, "missing child " .. n)
	return c
end
local function near(a, b, e) return math.abs(a - b) <= (e or 1e-6) end
local function vnear(a, b, e) return (a - b).Magnitude <= (e or 1e-6) end
local home = workspace:FindFirstChild("LAB_mock_effect")
local function plays() local n = 0 for _, c in ipairs(home:GetChildren()) do if c.Name == "Play" then n += 1 end end return n end

ok(type(_G.BlindTestPlay) == "function" and type(_G.BlindTestStop) == "function", "globals defined")
local O = Vector3.new(0, 0, 45)

-- 1. jump freeze (no normal emitters): exact values, returns after 2 heartbeats
local c0 = os.clock()
_G.BlindTestPlay(O, 0.8)
ok(near(os.clock() - c0, 2 / 60, 1e-6), "jump freeze returns after 2 frames")
local play = child(home, "Play")
local ball = child(play, "Ball")
local fly = 0.3
local want = O + Vector3.new(0, 3.5 + 2 * fly - 2 * fly * fly, -3 - 12 * fly)
ok(vnear(ball.Position, want), "ball exactly at its t = 0.8 position")
ok(#_G.MockLog == 1 and _G.MockLog[1] == "launch@0.800", "event fired once (" .. tostring(_G.MockLog[1]) .. ")")
local froze = true
for _, d in ipairs(play:GetDescendants()) do
	if d:IsA("ParticleEmitter") and d.TimeScale ~= 0 then froze = false end
end
ok(froze, "all emitters TimeScale 0")
local sprite
for _, d in ipairs(play:GetDescendants()) do
	if d:IsA("ParticleEmitter") then sprite = d end
end
ok(sprite.Emitted == 1, "driven sprite shows one particle")
ok(vnear(sprite.Parent.WorldPosition, want), "sprite at the ball")
_G.__heartbeats(30)
ok(vnear(ball.Position, want), "still frozen 30 frames later")

-- 2. dummy: feet on the ground at origin, stepped 1.5 forward, right arm raised forward
local hero = child(play, "Hero")
local low, hand, shoulderY = math.huge, nil, nil
for _, p in ipairs(hero:GetDescendants()) do
	if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then low = math.min(low, p.Position.Y - p.Size.Y / 2) end
end
ok(near(low, 0, 1e-6), "feet on the ground (lowest part bottom " .. low .. ")")
local rh, lh = child(hero, "RightHand"), child(hero, "LeftHand")
ok(rh.Position.Z < O.Z - 1.5 - 1.5, "right hand reaches forward (-Z): z " .. rh.Position.Z)
ok(rh.Position.Y > 3.2, "right hand at shoulder height: y " .. rh.Position.Y)
ok(near(lh.Position.Z, O.Z - 1.5, 0.5) and lh.Position.Y < 2.2, "left hand hangs at the side")
ok(rh.Position.X > O.X, "right hand on +X (the dummy faces -Z)")
local motorsOff = true
for _, m in ipairs(hero:GetDescendants()) do
	if m:IsA("Motor6D") and m.Enabled then motorsOff = false end
end
ok(motorsOff, "motors keep rest data only (disabled)")

-- 3. BlindTestPlay again replaces the previous play; Stop removes it
_G.BlindTestPlay(O, 0.1)
ok(plays() == 1, "one play at a time")
ok(child(child(home, "Play"), "Ball").Transparency == 1, "ball hidden before launch at t = 0.1")
_G.BlindTestStop()
ok(plays() == 0, "BlindTestStop clears the play")

-- 4. free play: runs in real time and cleans up after its length
_G.MockLog = {}
_G.BlindTestPlay(O)
ok(plays() == 1, "free play started")
_G.__heartbeats(60)
ok(#_G.MockLog == 1, "event fired during free play")
_G.__heartbeats(70)
ok(plays() == 0, "free play removed itself after its length")

-- 5. a stage with a normal emitter runs in real time up to freezeAt, values exact at freezeAt
local seen = {}
Stage.define({
	name = "LAB_mock_live",
	length = 1,
	build = function(S)
		local p = S:part({ Name = "Mover" })
		local e = S:emitter(p, { Rate = 50 })
		S:at(0.2, function() e:Emit(10) end)
		S:on(function(t)
			table.insert(seen, t)
			p.CFrame = CFrame.new(t * 10, 0, 0)
		end)
	end,
})
local c1 = os.clock()
_G.BlindTestPlay(Vector3.zero, 0.5)
local live = child(child(workspace, "LAB_mock_live"), "Play")
ok(os.clock() - c1 >= 0.5, "live freeze ran the clock in real time (" .. string.format("%.3f", os.clock() - c1) .. " s)")
ok(near(child(live, "Mover").Position.X, 5, 1e-9), "live freeze exact at t = 0.5")
ok(seen[#seen] == 0.5, "last update at exactly 0.5")
local em = child(live, "Mover"):FindFirstChildOfClass("ParticleEmitter")
ok(em.TimeScale == 0 and em.Enabled == false and em.Emitted == 10, "emitter frozen and stopped, event emitted")
_G.BlindTestStop()

-- 6. re-running a final.luau replaces the old globals cleanly
ok(#child(workspace, "LAB_mock_live"):GetChildren() == 0, "stop after redefine leaves nothing")

-- 7. cleanLab
local n = Stage.cleanLab("LAB_mock_live")
ok(workspace:FindFirstChild("LAB_mock_effect") == nil and workspace:FindFirstChild("LAB_mock_live") ~= nil, "cleanLab removed other LAB_ folders (" .. n .. ")")

print(fails == 0 and "ALL OK" or (fails .. " FAILED"))
if fails > 0 then error("stage tests failed") end
