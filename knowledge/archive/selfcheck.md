# Self-check: run this EVERY round before you report

Three passes. The 5-camera sheet finds shape and placement errors; the dense strips find motion errors (detached
pieces, dead time, 1-frame strokes, impact-frame length). Builds reported from one camera or from single frames each
needed another round for something these showed at once. Everything here works on Windows, macOS and Linux with only
the Studio MCP (`execute_luau`, `screen_capture`); a live recording is an optional extra (section 3).

`ROOT` = the plugin root. `fx` = your effect object, stored as `_G.kitfx`. Edit mode only.

## 0. Lint and the layer table (10 s)
`return _G.kitfx:Lint()`. Fix every WARN or write one line why it is intended. Read the gain line: a gain below ~0.6
means the effect leans on stacked additive glow; check the busiest moment for a white blob.
Then `return _G.kitfx:Layers()` and paste the table into `<effect>/LOG.md` under the version (every layer with its
values and its reason). A row whose `why` you cannot write is a layer you do not need.

## 1. Frozen contact sheet, 5 views
Cameras (`fx:Cam(name)`; all are placed in caster space, and the effect never reads them):
- **player**: behind the caster, 2.5 right, 6.5 up, 12 back, looking at (0, 3, -6). The one that counts.
- **side**: (23, 6, 3) looking at (0, 4, -4.5).
- **front**: 3/4 from ahead-left, (-14, 8, -24). Catches anything skewed toward the player camera.
- **bird**: top-down with guides: a yellow look line with an arrow head (forward = screen up) and a red bar at the
  target distance (`fx.mark`). Catches off-line payoffs, closed rings, planks, limbs swinging round the side.
- **night**: the player camera at ClockTime 0.3 (the shot's third field).

Shots: every beat's contact frame (+0.02 s), each wind-up's last frame, each impact-frame phase, the payoff +0.1 s and
the aftermath (+1.3 s) from the player camera; the beats and the payoff again from side, front and bird; one beat and
the payoff at night. 16-22 stills. For effects bigger or longer than a melee move, change `K.Cams` distances first
(same directions) so the whole effect fits.

One `execute_luau` stores the plan:
```lua
return _G.kitfx:Shots({ { "player", 0.14, "day" }, { "player", 1.05, "day" }, { "side", 0.14, "day" },
	{ "front", 1.05, "day" }, { "bird", 0.14, "day" }, { "bird", 1.05, "day" }, { "player", 1.05, "night" } })
```
Then loop. In ONE message send two tool calls in this order: `execute_luau` with `return _G.kitfx:NextShot()` and the
MCP `screen_capture`. NextShot sets light, guides and camera, plays to the time, freezes (emitters TimeScale 0, beams
stopped, clock stopped, shake off), waits 1.2 s for the viewport to redraw (`fx.shotWait`; raise it if a still shows
the previous shot) and returns a label such as `03 player_1.05_day (3/18)`. From the capture result take the image
file it names. Keep one line per still, `<label without the counter> <file>`, until the label is `done`. Do not look
at each still as it arrives beyond what the tool shows you: judge the sheet.

Write the lines to `<effect>/vN/shots.txt` with one Bash call, then:
```bash
python3 -I "ROOT/kit/scripts/kit_sheet.py" --out <effect>/vN --list <effect>/vN/shots.txt --title "<name> vN"
```
If your Studio MCP's `screen_capture` names no file, look at the stills directly and take fewer (the 8 that matter).
One frame by hand: `fx:Cam("bird"); fx:Play(1.05)`, wait a second, `screen_capture`.

LOOK at the sheet and answer `knowledge/checklist.md` 1-19 and 29-32. To find what causes a bad shape: freeze the frame and
hide one group at a time (its emitters' `Enabled`, or the folder's Parent).

## 2. Dense strips: motion from consecutive stills
For each beat (hit, payoff, the start of a loop) take every 2nd frame from 0.1 s before to 0.3 s after, from the
player camera, and the payoff once more from the side:
```lua
local fx = _G.kitfx
local rows = fx:Dense("player", 0.95, 1.35)                    -- every 1/30 s
for _, r in fx:Dense("side", 0.95, 1.35) do table.insert(rows, r) end
return fx:Shots(rows)
```
Same NextShot + `screen_capture` loop, then
`python3 -I "ROOT/kit/scripts/kit_sheet.py" --out <effect>/vN_dense --list ... --group cam` (one strip per camera).
Each still is a fresh play frozen at that time, so particle positions re-roll between stills: judge shapes, sizes,
brightness and timing across the strip, not single particles.

LOOK at the strips and answer checklist 20-28. Count stills: how many is each hero shape thick, how long is the impact
frame, how many pass with nothing new, does anything detach and drift.

Then play it live twice (`fx:Play()`, wait `fx.duration`, again) and read the Output for errors (checklist 28).

## 3. Optional: a live recording (if you can record the screen)
A 60 fps recording shows flicker and particle paths that frozen stills cannot. Only when the user has Studio visible
and is not typing elsewhere. `fx:LiveRun({ "player", "side", "front", "bird" })` plays once per camera and returns
the seconds it needs; `fx.liveLog[cam]` holds each play's start (`DateTime.now().UnixTimestampMillis`). Record with any
screen recorder; cut and tile with ffmpeg. `ROOT/kit/scripts/optional/README.md` has the ffmpeg lines and the helper
scripts for Linux with the niri compositor. Never block on this: the stills above are the check.

## 4. Report
Send: the sheet path, the strip paths, the Lint output, the checklist numbers that are still "no" with the reason,
and what changed since the last round. Then `fx:Stop()` and `K.Night(false)`.
