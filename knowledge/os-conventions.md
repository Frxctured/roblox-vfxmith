# Attribute conventions in open-source Roblox VFX (for the Edit-mode replayer)

Reference for a player that replays open-source VFX in Studio Edit mode with every script stripped. It says which
instance carries which attribute, what each value means, the exact binary formats, the timing model, and gives
pseudo-code. Built 2026-11-13 by reading the runtimes and the decoded instance trees in
the pack (decoded with `kit/scripts/rbxdump.py`) (507 dumps; 303 of them use at least one convention below).

**Licence.** VFX Forge ("Emit Module", zilibobi, VFX-DL 1.0) only allows its code inside a running Roblox
experience and explicitly forbids plugins, editor extensions, command-line tools and test harnesses. Our player is a
dev tool, so it must not load, copy or ship Forge code. Everything below describes behaviour in my own words, so the
player can be a clean reimplementation. The other runtimes quoted are game utilities in the library; same rule: describe,
don't copy.

**Sources (module names cited as `gen1:<module>` / `gen2:<module>`).**
- Forge gen-1: `StarterPlayerScripts/Move/Packages/Forge` in `2026 OS Mar-April/kickbarrage.rbxl` (modules `Forge`,
  `particle`, `beam`, `mesh`, `spin`, `screen`, `bezier`, `camera_shake`, `tween_property`, `shockwave_ring/line/debris`,
  `mod/utility`, `mod/tween`, `mod/lerp`, `mod/shape`, `obj/Bezier`, `obj/Shake`). Same generation as the `EmitModule`
  copies in `Wukong.rbxl`, `Plasma.rbxl` and `SlammerHammerOS.rbxm`.
- Forge gen-2 (newest, a superset with legacy fallbacks): `ReplicatedStorage/Shared/GameService/VFXForge` in
  `2026 OS Mar-April/menumovement.rbxl` (`services/effects`, `services/enabled_effects`, `services/texture_loader`,
  `emitters`, `effects/*` incl. `tweener`, `randomizer`, `sound`, `lightning`, `mod/attributes`, `mod/common/bezier`,
  `mod/common/flipbook`, `mod/retime`, `mod/resize`). Older gen-2 copies: `ArtemisArrowRainOS (2).rbxl`
  (`Packages/EmitModule`), and decompiled copies in `STARCORE MAIN.rbxl` (`EffectUtility/forge-vfx`, `ForgeVFX`).
- Other runtimes (all in `STARCORE MAIN.rbxl` unless noted): `VfxMods/meshemit`, `Emitter/XMeshEmitter`,
  `EffectUtility/Bugo` (TweenParams meshes); `EffectUtility/Arc`, `AenoirUnused/AenoirEmitOld2` (light fades);
  `Emitter/Zstr_MeshEmitter`; `Workspace/Part_Icles` (`zeninmassacre.rbxl`); simple emit utils in `Voidstrike.rbxl`
  (`FXModules/Utility/ParticleEmitter`), `Ranked.rbxl` (`Modules/Utility`), `purple.rbxm` (`Emit/ParticleEmit`).
- No runtime exists in the library for `TimeBeforeReset`, `_EasyMeshEmitData`, `EmitType`, `BaseRate`,
  `Size_Curve` on emitters, or Trail `WidthScale_*`: their meaning below is inferred from data and marked so.

Counts: "files" = dump files with at least one instance, "inst" = instances (STARCORE MAIN alone is often 80-95 %).

---------------------------------------------------------------------------------------------------------------

## 1. Shared machinery (Forge, both generations)

### 1.1 Reading attributes
- Every attribute has a default; a missing attribute = the default. gen-1 also treats a value of the wrong type as
  missing (`mod/utility` getAttribute compares `typeof`); gen-2 (`mod/attributes`) does not type-check, except that
  NumberRange and enum reads validate.
- The Forge plugin writes the defaults back when it reads them (gen-1 always; gen-2 only in server/plugin context),
  so saved effects carry many default-valued attributes. Presence is not intent; compare to the defaults.
- `NumberRange` values (`EffectDuration`, `Duration`, `Lifetime`, `*_RotSpeed_*`, `Amount`, ...) are rolled once per
  emitted instance: uniform random in [Min, Max] (clamped to >= 0 where the module says so).
- Booleans/strings/Vector3 are used as is. Vector3 angles are degrees unless noted otherwise (see the quirks).
- gen-2 can move all attributes of an instance into a Lua-side cache and leave only an attribute `U` (a number id).
  Saved files never contain this (it is a runtime optimisation); ignore `U` if you meet it.

### 1.2 Curve format: every `*_Curve` string attribute (also `Easing_Curve`, `Path_Curve`, `Weight_Curve`)
A Forge curve is a binary string (the bytes of a Luau `buffer`) holding a 2-D cubic Bezier path drawn in a
unit box with **UI orientation**: x = normalised time 0..1, y = 1 - value (y = 1 is the start value, y = 0 is the end
value). Layout, little-endian float32, **24 bytes per anchor point, N anchors = 24·N bytes**:

```
record i (i = 0 .. N-1), offset 24*i:
  f32 ax, f32 ay        anchor i
  f32 ox, f32 oy        outgoing handle of anchor i      (absolute position, not relative)
  f32 nx, f32 ny        incoming handle of anchor i+1    (absolute)
the last record has only the anchor; its 16 handle bytes are zero padding
```
(The editor writes anchor, right handle, [left handle of next, anchor, right handle] ... which lands every anchor on a
24-byte boundary; the buffer is allocated at 24·N so the tail is zero.)

Expanded point list = A0, O0, N1, A1, O1, N2, A2, ..., A(N-1): segment k is the cubic (A_k, O_k, N_k+1, A_k+1).

**Evaluation** (`mod/tween` + `obj/Bezier` getEase, done every frame by every tween):
1. t = clamp(elapsed / duration, 0, 1).
2. Pick the segment whose anchor x-range satisfies `A_k.x <= t < A_k+1.x`; if none (t = 1), use the last segment at
   its end. Start guess u = (t - A_k.x) / (A_k+1.x - A_k.x).
3. Newton on the x-polynomial: up to 5 iterations, stop when the step < 0.001, clamp u to [0,1], stop if dx/du = 0.
4. y = Bezier_y(u); **alpha = 1 - y**. alpha is NOT clamped (except for particle TimeScale): handles outside the box
   overshoot (alpha < 0 or > 1), and the end anchor need not be at y = 0 (a curve can return to the start value).
5. The animated property = lerp(start, end, alpha).

Defaults (`mod/utility`): `default_bezier` = "out cubic" (used by almost every `*_Curve`), `linear_bezier` (used by
`Easing_Curve`, `Flipbook_Change_Curve`, `Path_Curve`, `Weight_Curve`).

Real example 1, hand-decoded: `Part_CFrame_Curve` of `kickbarrage.rbxl` `.../Assets/Slam/WindFlipForward`
(also the default curve; 3,590 of the library's 6,203 curves are exactly this):
```
00000000 0000803f | f6285c3e 14aec73e | 90c2b53e 00000000 | 0000803f 00000000 | 16 x 00
A0=(0, 1)           O0=(0.215, 0.39)    N1=(0.355, 0)       A1=(1, 0)           padding   -> 48 bytes, N = 2
```
In value space (alpha = 1 - y) the handles are (0.215, 0.61) and (0.355, 1): CSS `cubic-bezier(.215,.61,.355,1)`,
easeOutCubic. alpha at t = .25/.5/.75 = 0.600/0.875/0.976.

Real example 2: linear, `SlammerHammerOS.rbxm` `HAMMER/Highlight2/FillTransparency` `Easing_Curve`:
`00000000 0000803f | 00000000 0000803f | 0000803f 00000000 | 0000803f 00000000 | 16 x 00`: handles sit on the
anchors, so alpha = t.

Real example 3 (3 anchors, 72 bytes, returns to start): `flame2.rbxm` `FLAME/Part/PointLight/Range` `Easing_Curve`:
```
A0=(0,1)  O0=(0.0484,1.0236)  N1=(0.528,0.7458) | A1=(0.528,0.7458) O1=A1  N2=(0.9577,0.9992) | A2=(1,1) + pad
```
alpha rises 0 -> 0.254 at t = 0.528 and falls back to 0 at t = 1 (samples t=.1..1: .028 .076 .128 .182 .238 .212
.155 .098 .044 0). With `_END_VALUE = 2` the light's Range only travels a quarter of the way and comes back.

Decoding from our dumps: `rbxdump` stored the bytes as text (utf-8 if valid, else latin-1). Recover with
`s.encode('latin-1')`, falling back to `s.encode('utf-8')`; keep the candidate whose length is a multiple of 24
(curves) or 8 (flipbooks). In Studio, `GetAttribute` returns the raw string; `buffer.fromstring` reads it.

### 1.3 Flipbook format: `FlipbookTextures` string attribute
Binary string of little-endian **float64** asset ids, 8 bytes each, in play order. Used together with
`FlipbookEnabled = true` (both on a Decal, or on a Beam in gen-2). Texture string = `rbxassetid://<id>`
(`rbxtemp://<id>` only for Studio-local flipbooks tagged `_local_flipbook_*`).
Example, `kickbarrage.rbxl` `.../Slam/WindFlipForward/Start/Decal`: 248 bytes = 31 frames; first 8 bytes
`40f0a86ee7e6dd42` = 0x42DDE6E76EA8F040 = 131510249890753 -> `rbxassetid://131510249890753`.
Legacy source (still converted at runtime by `mod/utility` getMeshDecals): Decal children of a Start decal, sorted
by the first number in their Name; each id = the first number in its Texture string; the children are destroyed and
the two attributes written.

### 1.4 Clock model (`mod/tween`)
Every animated value is a "tween": (curve, duration, animator). Each frame (RenderStepped, or BindToRenderStep at
priority `Camera + 1 + depth` for movers):
- While its clock is still 0 a step first pre-advances it by that frame's dt (so t = 0 is never shown), except where
  "start at zero" is requested (Bezier particles).
- Each step evaluates alpha at the current clock and applies it. Then, if the clock had already reached the duration
  (or the animator returned nil) it stops, so the last applied value is the exact end value; otherwise it advances the
  clock by the animator's return value, `dt` (real time) or `dt x speed` (scaled time), clamped to [0, duration].
  It never stops while its "await" tween (the effect's speed ramp) is still running.
- duration 0: jumps to the end value on the first frame.
A "timer" is the same without a curve; the emitting thread waits on it; when it ends, the effect's scope is cleaned
(clones destroyed, pooled parts returned = vanish, connections dropped, reset callbacks run).

**Speed (`Speed_Start`, `Speed_End`, `Speed_Curve`, `Speed_Duration`)** on beams, meshes, beziers, tweeners, camera
shakes is a playback-rate multiplier, not a travel speed: a ramp from Start to End over `Speed_Duration` real seconds
(default 0.1, curve default out-cubic), and every other tween of that effect advances by `dt x speed`. If the speed
ends at 0 the effect stops and is cleaned up as soon as the ramp is done. Particles use `TimeScale_*` instead (2.1).

### 1.5 The emit walk (`gen2:services/effects`, `gen2:emitters`; `gen1:Forge` emit)
`emit(root...)` starts every handled instance in the same frame, each in its own thread, and returns when all are
finished. Dispatch by instance:

| Instance | Handler | Cloned or in place |
|---|---|---|
| ParticleEmitter | 2.1 | in place if under workspace; else its BasePart/Attachment ancestry is rebuilt (property copies, no children) under workspace(.Terrain), shared by all emitters of that call, destroyed when the last one ends |
| Beam | 2.2 | clone into workspace.Terrain (gen-1: workspace), same attachments; destroyed at the end. gen-2 skips beams without both attachments |
| Trail | `Enabled = true` on the original, never turned off by Forge | in place |
| Model with BasePart children `Start` and `End` | mesh 2.3 | spawns copies of Start |
| other Model | spin 2.4 (no-op unless it has spin/scale attributes) | in place |
| Attachment tagged `BezierParticle` | 2.5 | spawns pooled parts |
| BasePart with attribute `Enabled = true` | screen 2.6 | in place, restored |
| RayValue tagged `CameraShake` | 2.7 | camera |
| Part in a folder named `Rings` / `Lines` / `Debris` under an Attachment tagged `Shockwave` | 2.8 | spawns pooled parts |
| any other RayValue (gen-2: also tag `PropertyTweener` / `AttributeTweener`) | tweener 2.9 | in place |
| Sound (gen-2 only) | 2.10 | clone |
| Attachment tagged `LightningBolt` (gen-2 only) | lightning 2.10 | spawns |

Recursion: the walk visits all descendants, **except** below a Beam, a BezierParticle, a LightningBolt, a mesh Model,
a shockwave Part, or anything tagged `__forge_excludeFromEmit`; those handlers emit their own (cloned) children later.
So the particles inside a mesh's Start part never fire at the template; they fire inside each spawned copy.
- Nested children start when their parent handler emits them, so **nested EmitDelays add up** (a particle with
  EmitDelay 0.2 inside a mesh with EmitDelay 0.3 fires at 0.5 s).
- A Folder named `EmitOnFinish` inside a spawned part (mesh Start, bezier Part, shockwave part; gen-2 also a Beam) is
  detached at spawn; when that instance's animation ends its children are moved into the spawned part and emitted,
  and the instance is kept until they finish. Debris also has `EmitOnImpact` (gen-2: emitted on the first Touched).
- gen-1 handles screen parts at any depth; gen-2 only when the part itself is passed to emit (nested ones are just
  containers). Screen parts inside a non-static spin Model are skipped in both.
- `depth` (nesting level) only orders BindToRenderStep priorities so parents move before children.
- `emit(number, ...)` (gen-1 only): the number is a scale applied to beam widths and mesh sizes. gen-2 ignores it.

**Continuous mode (`ConstantVFX` tag)** (`gen2:services/enabled_effects`, `gen1:Forge` init) works for mesh Models,
BezierParticles and lightning only. While the instance is under workspace (or its parent has tag `AllowEmitting`)
and its attribute `Enabled` is true (default true when missing!), it fires one normal emission (EmitCount copies)
every `1 / (Rate x SpeedOverride)` seconds (`Rate` default 5 per second). Emitting such an instance with
`EmitDuration > 0` turns `Enabled` on for EmitDuration seconds, ramping SpeedOverride Speed_Start -> Speed_End;
a plain emit of an instance whose Enabled is true first switches it off, then does one burst.
`LoadVFXTextures` (tag) only preloads decal/emitter/flipbook textures. Pool parts (Folder
`DO_NOT_REMOVE_ForgeSharedPartCache`) start anchored, invisible and non-colliding; the copied template properties
(list in 2.3) then decide their look and collision. gen-1 quirk: a ConstantVFX mesh with an `Enabled` attribute went
into continuous mode whenever its rolled EffectDuration was > 0 (gen-2 requires `EmitDuration > 0`).

---------------------------------------------------------------------------------------------------------------

## 2. Conventions

### 2.0 The generic particle emit (EmitCount / EmitDelay / EmitDuration): the de-facto standard
294 files, 196,949 emitters (of these, only 51 files carry other Forge signatures). Forge, every simple game util in
the library (`Voidstrike`, `Ranked`, `purple`, `Arc`, `Bugo`, `Part_Icles`) and the Forge plugin all agree:

| Attribute (on ParticleEmitter; some utils also on Beam/Trail) | Type | Default | Meaning |
|---|---|---|---|
| `EmitCount` | number | 1 (gen-1 always; gen-2 in edit/plugin context; gen-2 in a live game skips emitters without it) | particles for `:Emit(n)` |
| `EmitDelay` | number, s | 0 | wait before the burst |
| `EmitDuration` | number, s | 0 | after the burst keep `Enabled = true` (authored `Rate`) for this long, then false |

Data notes: 481 EmitCounts in 7 files are strings ("2"): use `tonumber`. 3,518 are fractional (density-scaled, e.g.
16.2): the API takes an integer, so truncate (check the engine's rounding in Studio once). Some utils fall back to
`emitter.Rate` (Bugo) or `tonumber(Name)` (STARCORE Client Tasks) when EmitCount is missing. On Beams the generic
utils read `EmitDelay`/`EmitDuration` as "enable the beam for EmitDuration after EmitDelay" (2,000+ STARCORE beams,
`Ranked.rbxl` `.../Kaisel Beam/End/Beam` = EmitDelay 2, EmitDuration 3). Forge's beam handler ignores `EmitDuration`.

Examples: `190 OS (Oct 2024-Mar 2026)/Hado90.rbxm` `Hado90/smoke`; `190 OS/Bankai.rbxl` `Workspace/Part/5`;
`2026 OS Mar-April/Voidstrike.rbxl` (ships its own util) any emitter under `ReplicatedStorage/Assets/Particles/Voidstrike`.

### 2.1 Forge particle: TimeScale ramp (`gen2:effects/particle`, `gen1:particle`)
TimeScale_* in 42 files / 13,645 emitters, but Start != End only in STARCORE (180 emitters).

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| EmitCount / EmitDelay / EmitDuration | | | as 2.0 |
| `TimeScale_Start` / `TimeScale_End` | number | the emitter's TimeScale | if different: TimeScale ramps Start -> End (replaces the property) |
| `TimeScale_Duration` | number, real s | 0.1 | ramp length |
| `TimeScale_Curve` | curve | out-cubic | ramp shape; **alpha clamped to 0..1** here |

Pseudo-code:
```
particleEmit(template, live):            -- live = template if in workspace, else a clone in a rebuilt ancestry
  template.Enabled = false               -- permanent: the template is switched off
  wait(EmitDelay)
  if EmitDuration > 0: live.Enabled = true
  if TS_Start != TS_End: start ramp(live.TimeScale, TS_Start -> TS_End, TS_Duration, TS_Curve, real time)
  elif TS_Start != live.TimeScale: live.TimeScale = TS_Start
  live:Emit(EmitCount)
  if EmitDuration > 0: wait(EmitDuration); live.Enabled = false
  wait until Lifetime.Max has passed in particle time (dt x template.TimeScale per frame; ends at once if TimeScale 0
       and no ramp)
  cleanup: clone ancestry destroyed (particles vanish); in-place emitter left alone
```
Editor-only attributes on emitters (no runtime reads them; the authored NumberSequences already hold the result):
`Size_Start`/`Size_End`/`Size_Envelope`/`Size_Curve` and `Transparency_Start`/`_End`/`_Curve` (30/19 files; the curve
is in the 1.2 format and was baked into Size/Transparency, e.g. `ChildEmporerVFX.rbxm` `.../Main Beam/Lightingb`
has 19 keypoints placed along the curve's x), `Squash_*`, `SMOOTHSEQUENCE_*`, `_vfxEditorGraph*`, `_vfxEditorScale`,
`Size_Smoothness`. Treat them as documentation.

Examples (TimeScale): `190 OS/SunOS.rbxm` `OS Sun/Sun/0dots`; `2026 OS Jan-April (part 2)/Charge Up.rbxm`
`Part/Load/Flash/Filled circle`; ramp Start 0.1 -> End 1 over 0.9 s: `STARCORE MAIN.rbxl`
`ReplicatedStorage/Resources/Frozen Warrior/VFX/Awakening/Cryostasis Crash/Hit2/Attachment/ParticleEmitter`.

### 2.2 Forge Beam (`gen2:effects/beam`, `gen1:beam`)
New attribute set in 21 files / 1,092 beams; legacy set (`Width0`, `Width1`, `Duration`, `EmitDelay`) in 49 files /
1,778 beams. The beam's own properties are the base; attributes **replace** widths/curve sizes/TextureLength/
TextureSpeed and **scale** the Transparency sequence.

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| `EmitDelay` | number s | 0 | wait before the clone is enabled |
| `EffectDuration` | NumberRange s | (Duration, Duration) | lifetime of the clone, rolled per emit |
| `Duration` (legacy) | number s | 1 | used only when EffectDuration is missing |
| `Width0_Start` / `Width0_End` | number | `StartWidth0` attr, else property Width0 / `Width0` attr, else property | Width0 lerp over the lifetime |
| `Width1_Start` / `Width1_End` | number | same with 1 | Width1 lerp |
| `Width0_Curve`, `Width1_Curve` | curve | out-cubic | |
| `CurveSize0_Start/_End`, `CurveSize1_Start/_End`, `CurveSize0_Curve`, `CurveSize1_Curve` | number / curve | property / out-cubic | gen-2 only |
| `Transparency_Scale_Start` / `_End` | number | 1 / `EndTransparencyScale` attr (legacy, default 1) | scale s applied to every Transparency keypoint v: s <= 1: v x s; s > 1: v + (1 - v)(s - 1). 1 = authored, 2 = invisible, 0 = opaque. Start 1 -> End 2 = fade out (243 of 262 fades) |
| `Transparency_Scale_Curve` | curve | out-cubic | |
| `Length_Scale_Start` / `_End` | NumberRange | (1,1) | gen-2: moves both attachments symmetrically about their midpoint (k x half-offset), on temporary attachment clones; rolled per emit |
| `Length_Scale_Curve` | curve | out-cubic | |
| `Length_Texture_Start` / `_End`, `Length_Texture_Curve` | number / curve | TextureLength / out-cubic | gen-2 |
| `Speed_Texture_Start` / `_End`, `Speed_Texture_Curve` | number / curve | TextureSpeed / out-cubic | gen-2: TextureSpeed lerp over the lifetime in real time |
| `Speed_Start` / `_End` / `_Curve` / `_Duration` | | 1 / 1 / out-cubic / 0.1 | playback rate (1.4); also multiplies TextureSpeed |
| `FlipbookEnabled`, `FlipbookTextures`, `Flipbook_Change_Duration`, `Flipbook_Change_Curve`, `SyncDuration` | | | gen-2: swaps `Texture` like the decal flipbook in 2.3 (0 files use it) |
| `EmitDuration` | | | written by the plugin, not read by the beam handler (generic utils use it, 2.0) |

Pseudo-code:
```
beamEmit(template):
  clone = copy(template) under Terrain; (gen-2, Length_Scale != 1: clone gets duplicated attachments)
  roll life = EffectDuration; roll lenStart, lenEnd
  wait(EmitDelay); clone.Enabled = true
  emit the clone's children (nested)
  speed ramp; for each pair Start != End: tween(property, Start -> End, life, its curve, dt x speed)
     else set Start (Width0/Width1 are always set; CurveSize keeps the authored value when equal)
  Transparency: if TS_Start != TS_End tween the scale, elif TS_Start != 1 set it once
  flipbook (gen-2) as 2.3
  wait max(life, flipbook length) in scaled time; run EmitOnFinish; destroy clone, restore attachments
```
Note the template is never disabled: authors keep templates `Enabled = false`. Legacy data: 1,580 of the 1,778
legacy beams have `Width0 = 0` and `Duration = 0` (defaults from an older tool); through Forge's fallback those show
one frame at end width 0 (invisible), and 637 of them are `Enabled = true` persistent beams. Heuristic for the player
(not runtime-verified): legacy beams with Duration 0 keep their authored state.

Examples: `2026 OS Jan-April (part 2)/Charge Up.rbxm` `Part/Load/BeamSpin/Start/Beam/attachment0-2/Beam1` (CurveSize,
Width0 1 -> 0, inside a spinning mesh); `190 OS/takebeams.rbxl` `Workspace/GutsSlam/YesBeams/Start/Attachment/Beams/
A0/windbeams` (Transparency_Scale 1 -> 2.5 over 4.5 s); `takebeams.rbxl` `Workspace/GutsSlam/GroundBeams/Left`
(Speed 2 -> 0.5).

### 2.3 Forge mesh: Model { Start, End } (`gen2:effects/mesh`, `gen1:mesh`, `mod/utility` assembleMeshVFX)
28 files / 1,056 models. A Model qualifies when it has BasePart children named `Start` and `End`. End is only a pose:
Start -> End interpolates CFrame (as an offset), Size, SpecialMesh Scale, decal Transparency/Color.

| Attribute (on the Model) | Type | Default | Meaning |
|---|---|---|---|
| `EmitCount` | number | 1 | copies per emit, all spawned at once, each with its own rolls |
| `EmitDelay` | number s | 0 | |
| `EffectDuration` | NumberRange s | (Duration, Duration) | life of each copy |
| `Duration` (legacy) | number | 1 | |
| `DestroyDelay` | number s | 0 | gen-2: copy holds its final state this long before removal |
| `Speed_Start/_End/_Curve/_Duration` | | 1/1/out-cubic/0.1 | playback rate (1.4) |
| `Part_CFrame_Curve` | curve | out-cubic | offset identity -> Start⁻¹·End (CFrame:Lerp) |
| `Part_Size_Curve` | curve | out-cubic | Size Start.Size -> End.Size (only if different) |
| `Mesh_Scale_Curve` | curve | out-cubic | SpecialMesh Scale Start -> End (both need a SpecialMesh; if End has none, the copy's SpecialMesh is removed for the effect) |
| `Part_Transparency_Start` / `_End` | number | `Mesh_StartTransparency` / `Mesh_EndTransparency`, else 1 if Start has a Decal else 0 | part Transparency (values > 1 occur, e.g. 1.8 -> 1: invisible until it drops below 1) |
| `Part_Transparency_Curve` | curve | out-cubic | |
| `Part_RotSpeed_Start` / `_End` | NumberRange | (0,0) | spin rate in **radians per second**, rolled; ramps Start -> End over the life with `Part_RotSpeed_Curve` |
| `MinInitRot` / `MaxInitRot` | Vector3 deg | 0 | initial rotation, rolled per axis; **its sign per axis also selects which axes spin** (an axis with init 0 never spins) |
| `RotAroundOrigin` | bool | false | true: the rotation also swings the Start -> End offset around the origin |
| `SpreadAngle` | Vector3 deg | 0 | random pitch (±X) and yaw (±Y) of the whole path at the origin; Z unused |
| `SyncPosition` | bool | false | follow the origin every frame |
| `Rate`, `Enabled` + tag `ConstantVFX` | | 5 / true | continuous mode (1.5) |
| `EmitDuration` | number s | 0 | continuous for this long when emitted (needs the tag) |
| `Flipbook`, `FlipbookFadeOffset`, `Decal_StartTransparency`, `Decal_EndTransparency` (legacy) | | false/0/0/1 | see decals |
| `StartTransparency` / `EndTransparency` (stone age) | | | renamed on read to `Decal_*` (Start has a Decal) or `Mesh_*` |

On the Start part's **Decals** (each needs a Decal of the same Name in End):

| Attribute (on Start's Decal) | Default | Meaning |
|---|---|---|
| `Transparency_Start` / `_End` / `_Curve` | Decal_StartTransparency (0) / Decal_EndTransparency (1) / out-cubic | decal Transparency |
| `Color_Curve` | out-cubic | Color3 Start decal -> End decal, blended in Oklab (only when the colours differ) |
| `FlipbookEnabled`, `FlipbookTextures` | | frames (1.3) |
| `Flipbook_Change_Duration` | effect life | flipbook length (`SyncDuration = true` forces the effect life) |
| `Flipbook_Change_Curve` | linear | frame index = max(round(frames x alpha), 1) |

Origin and pose (the part of the semantics that is easy to get wrong):
- origin = WorldCFrame of the nearest **Attachment ancestor** of the Model if there is one (then Start's own position is
  ignored, only the Start -> End offset matters), else Start's CFrame. gen-2 adds origin attributes on that
  Attachment: `PositionScale` (Vector3; shifts by parentPart.Size/2 x PositionScale along world axes, only when the
  attachment's parent is a BasePart) and `OverrideWorldRotation` + `WorldRotation` (deg; replace the rotation).
- each frame: `pose = origin · spread · offset(alpha) · R · R` (RotAroundOrigin: `origin · spread · R · offset · R`),
  where R = the accumulated rotation (start = MinInitRot..MaxInitRot in degrees, then += sign(init) x rotSpeed x dt
  radians). R is applied **twice**, so a single-axis spin turns at 2 x Part_RotSpeed rad/s and starts at 2 x the rolled
  angle. Reproduce this literally; it is what authors tuned against.
- The copy: if Start is exactly class `Part`, a pooled Part gets Start's look/physics properties (CastShadow, Color,
  Material, MaterialVariant, Reflectance, Shape, surfaces, Size, Transparency, CustomPhysicalProperties, CanCollide,
  CanQuery, CanTouch, CollisionGroup) and clones of Start's children; otherwise (MeshPart, Union...) a full Start
  clone goes to workspace.Terrain. Either way the children (particles, beams, attachments, decals) come along and are
  emitted as nested effects inside the moving copy.

Pseudo-code:
```
meshEmit(model):                                   -- repeated EmitCount times in parallel
  roll life, rotSpeedStart/End, initRot, spread
  wait(EmitDelay)
  if model tagged ConstantVFX and EmitDuration > 0 and not continuous tick: run continuous mode; return
  copy = spawn(Start); detach copy.EmitOnFinish
  bind per-frame pose update (above), first update immediately
  emit copy's children (nested)
  speed ramp; tweens over life at dt x speed: offset, rotSpeed, part Transparency, Size, Mesh Scale,
     per decal: Transparency, Color (Oklab), flipbook (own duration)
  wait max(life, longest flipbook) + FlipbookFadeOffset + DestroyDelay (scaled time)
  wait nested children; emit EmitOnFinish children into the copy and wait; remove copy
```
Legacy `Flipbook = true` on the Model: every Decal on Start is a frame (sorted by the number in its Name); one new
Decal shows frame max(round(N x alpha), 1) on the default out-cubic over the life; its transparency goes
Decal_StartTransparency -> Decal_EndTransparency (over life + FlipbookFadeOffset when the offset > 0).
STARCORE stores `Flipbook` as a JSON string `{"Textures":[],"Enabled":false,"Fps":"60"}` (another tool); gen-2 would
read any string as true. Treat non-boolean `Flipbook` as false.

Examples: `kickbarrage.rbxl` `StarterPlayer/StarterPlayerScripts/Move/Assets/Slam/WindFlipForward` (31-frame decal
flipbook, Part Transparency 1.8 -> 1, MaxInitRot Y 360, ConstantVFX Rate 20); `Charge Up.rbxm` `Part/Load/BeamSpin`
(Part_RotSpeed 20 -> 0 rad/s on Y, RotAroundOrigin, beams inside Start); `SlammerHammerOS.rbxm`
`HAMMER/FloorFx/Slam/SoftBurst`.

### 2.4 Forge spin Model (`gen2:effects/spin`, `gen1:spin`)
10 files / 46 models. Any Model that is not a mesh; does nothing when it is "static" (SpinRotation 0, Scale_Start =
Scale_End = 1, and gen-2 also SyncPosition false). Used in place via PivotTo/ScaleTo.

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| `SpinRotation` | Vector3 deg/s | 0 | total turn = SpinRotation x SpinDuration (Euler XYZ via fromOrientation, from the start pivot) |
| `SpinDuration` | number s | 0.5 | |
| `SpinSpeed_Start` / `_End` / `_Duration` / `_Curve` | | 0 / 1 / 0.1 / out-cubic | time-warp ramp: the spin starts frozen and reaches full rate in 0.1 s |
| `Scale_Start` / `_End` / `Scale_Curve` | number | 1 / 1 / out-cubic | Model:ScaleTo (absolute scale factor) over SpinDuration in real time |
| `EmitDelay` | number s | 0 | |
| `SyncPosition` | bool | false | base pivot = the nearest Attachment/BasePart ancestor's CFrame each frame (snaps the pivot onto it) |
| `ResetOnFinish` | bool | true | gen-2: restore pivot (to that ancestor's CFrame, or the original pivot) and scale at the end |
| `ResetDelay` | number s | 0 | gen-2: hold the end pose this long before the reset |

Pseudo-code: `wait(EmitDelay); ramp speed; scale tween; each frame (scaled clock c, capped at SpinDuration):
model:PivotTo(base · fromOrientation(rad(SpinRotation) x c)); after SpinDuration + ResetDelay: reset`. Its
descendants are emitted normally in the same call, so particles inside ride along.
Examples: `190 OS/christmaswowwowow.rbxl` `Workspace/SpinModel` (150 deg/s Y for 60 s); `kickbarrage.rbxl`
`.../Assets/M1s/First/Rizzmeshes`; `2026 OS Mar-April/Wukong.rbxl` `Workspace/Fx/Wukong/InitialSpin`.

### 2.5 Forge BezierParticle: Attachment shape/path emitter (`gen2:effects/bezier` + `mod/common/bezier`, `gen1:bezier`, `mod/shape`)
13 files / 40 emitters. Attachment tagged `BezierParticle`, children: `Points` (Attachment) holding Attachments named
`1`, `2`, ... (sorted by number), each optionally with child Attachments `T0` (outgoing handle) and `T1` (incoming
handle); optional `End` Attachment (optional `T1`); the first child of class `Part` = template of each particle.
Path control points = Points-local positions, expanded like 1.2 (a missing handle = the anchor itself).

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| `EmitCount`, `EmitDelay` | | 1, 0 | particles per emit, all at once |
| `Duration` | NumberRange s | (1,1) | travel time, rolled per particle |
| `Easing_Curve` | curve | linear | time -> path position (alpha); starts at t = 0 exactly |
| `ArcSpace` | bool | false | true: alpha = fraction of arc length; false: alpha splits evenly between segments |
| `FacePath` | bool | false | orient along travel (look at the position 1/60 s ahead) |
| `Shape` | Box/Cylinder/Sphere/Disc | Box | spawn region when the Bezier's parent is a BasePart (its Size) |
| `ShapeStyle` | Volume/Surface | Volume | inside or on the surface |
| `ShapePartial` | number 0..1 | 1 | sphere: polar cap; cylinder/disc: radius band |
| `EmissionDirection` | Top/Bottom/Left/Right/Front/Back | Top | face/axis; with an Attachment parent the spawn CFrame looks along this local direction |
| `ShapeFace` | Outward/Inward/InAndOut | Outward | Inward flips 180° about Y; InAndOut picks randomly |
| `SpreadAngle` | Vector3 deg | 0 | ±X about the emission normal, ±Y about the pitch axis |
| `MirrorPaths` / `MirrorRotation` | bool / Vector3 deg | true / (0,0,180) | with End: if the spawn point lies on the End's right side, rotate by MirrorRotation (symmetric arcs) |
| `MinInitRot` / `MaxInitRot` | Vector3 | 0 | initial rotation; **used as radians** (no conversion); signs select spin axes |
| `RotSpeed_Start` / `_End` / `RotSpeed_Curve` | NumberRange deg/s | 0 | spin rate (here degrees), ramps over Duration |
| `Speed_*` | | | playback rate (1.4) |
| `SyncPosition` | bool | false | path follows the origin's motion |
| `ProjectileEnabled`, `ProjectileSpeed` (30), `ProjectileLifetime` (1,1), `MatchEndDirection` | | | after the path, fly straight at ProjectileSpeed along the last velocity (or End's LookVector) for the rolled lifetime; the lifetime also cuts the path phase short |
| `HitboxEnabled`, `HitboxCollisionGroup`, `HitboxFilterTag`, `HitboxFilterType`, `HitboxIgnoreCanCollide` | | false... | stop at the first overlap (GetPartsInPart). 0 of 40 use it |
| `DestroyDelay` | number s | 0 | wait after all particles finished before removal |
| `EmitDuration`, `Rate`, `Enabled`, tag `ConstantVFX` | | 0, 5, true | continuous mode; 34 of 40 beziers carry the tag, 27 of them with EmitDuration > 0 (a stream for EmitDuration s); the 6 untagged ones have EmitDuration 0 (a bezier with EmitDuration > 0 but no tag would spawn nothing) |

Origin: parent BasePart -> a random point from the shape (Box Volume: anywhere inside, facing EmissionDirection;
Box Surface: on that face; Sphere/Cylinder: LookVector radial outward; Disc: in the plane of that face); parent
Attachment -> its WorldCFrame turned toward EmissionDirection; parent of another class -> the Bezier attachment
itself. Path per particle: each point p -> spawnCF * (p - p1) (the path's local axes follow the spawn CFrame; local
-Z goes along the emission direction). With `End`: the last point becomes End's world position and the one before it
End.T1 (or End), so all particles converge.

Pseudo-code:
```
bezierEmit(att):
  wait(EmitDelay); if EmitDuration > 0 and not a continuous tick: continuous mode for EmitDuration; return
  for i in 1..EmitCount (parallel):
    roll duration, rot speeds, initRot (radians as stored), projectile life
    spawnCF = shapePoint · spread · (Inward flip) · (mirror)
    path = transformed control points (+ End convergence)
    part = pooled copy of the Part template (+ cloned children); detach EmitOnFinish; emit its children
    tween over duration with Easing_Curve (scaled time): position = path(alpha) [arc-length if ArcSpace],
        rotation = FacePath look-ahead then · R, R += sign(init) x rad(rotSpeed) x dt
    optional projectile phase; then EmitOnFinish children; then resolve
  wait all; wait(DestroyDelay); free parts
```
Examples: `190 OS/os (1).rbxm` `skele boy/inwardbezier/Bezier` (Sphere Surface, End convergence, ease-in-out
`cubic-bezier(.42,0,.58,1)`, ArcSpace, Rate 40 for 0.4 s); `christmaswowwowow.rbxl` `Workspace/christmasprojectile/
Bezier` (EmitOnFinish burst); `2026 OS Jan-April (part 2)/coolosgoldblue.rbxm` `CoolAttackYEWAH/Shot/Bezier/
Attachment/SharedEndBezier`.

### 2.6 Forge screen part (`gen2:effects/screen`, `gen1:screen`)
Authored in 8 files, but `Enabled = true` (the switch) only in 2 (`hakariOSby mmy.rbxm` `ScreenEffect`; STARCORE
`.../IchigoEffect/WorldSpaceEffects/ScreenEffect`); the others carry the defaults with Enabled false (= plain
container). A BasePart with attribute `Enabled = true`, not inside a shockwave and not inside a non-static spin Model.

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| `Enabled` | bool | | the switch |
| `PartDistance` | number studs | 1.5 | distance in front of the camera |
| `PartScale` | Vector3 | (1,1,1) | x/y multiply the full-viewport size at that distance; z multiplies the part's own Size.Z |
| `OffsetPosition` | Vector3 studs | 0 | camera-space offset after moving forward |
| `OffsetRotation` | Vector3 deg | 0 | extra rotation |

Each frame (after the camera): height = 2·tan(FOV/2)·distance, width = height·aspect; Size = (width, height, Size.Z)
x PartScale; CFrame = camera · (0,0,-distance) · OffsetPosition · rot. Its children are emitted; when they all finish,
Size/CFrame/CollisionGroup are restored. (The examples above; third: `Wukong.rbxl` `Workspace/Fx/Wukong/InitialSpin/Beam`
shows the Enabled-false container case.)

### 2.7 Forge camera shake: RayValue tagged `CameraShake` (`gen2:effects/camera_shake` + `pkg/Shake`)
8 files / 10. Shake is Sleitnick's RbxUtil Shake (MIT): offset = (noise(x,0), noise(0,x), noise(x,x)) / 2 x Amplitude
x envelope with x = (time + random offset) / Frequency.

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| `Amplitude` | number | 2.5 | studs (position) / radians (rotation) before influence |
| `Frequency` | number s | 0.2 | noise period: **smaller = faster** |
| `FadeInTime` / `SustainTime` / `FadeOutTime` | number s | 0.3 / 1 / 2 | linear envelope in, hold, linear out |
| `EmitDuration` | number s | 0 | > 0: hold (sustain) until EmitDuration, then fade out |
| `PositionInfluence` / `RotationInfluence` | Vector3 | (1,1,1) / (0.2,0.2,0.2) | per-axis multipliers; rotation applied as CFrame.Angles (radians) |
| `Falloff` | number studs | 30 | if the RayValue has an Attachment/BasePart ancestor: x (1 - clamp(dist(camera, it)/Falloff, 0, 1)) |
| `EmitDelay`, `Speed_*` | | 0 / 1 | speed warps the shake's own clock |

All active shakes sum (positions added, rotations composed) and are applied as `camera.CFrame *= offset` after
everything else (priority Last + 1). In Edit mode the module first removes last frame's offset and zeroes the roll
(Studio's camera keeps its CFrame). Examples: `SlammerHammerOS.rbxm` `HAMMER/CameraShake` (Amp 0.5, Freq 0.15, fade
out 0.375, Speed 0.25 -> 1); `Plasma.rbxl` `Workspace/Plasma/CameraShake`; `DoomSlayer.rbxl` `Workspace/DoomSlayer/
Bonus/CameraShake`.

### 2.8 Forge shockwaves: Attachment tagged `Shockwave` + Folder `Rings` / `Lines` / `Debris` + template Part
7 files (Rings 5, Debris 2, Lines 0). Origin attributes on the Attachment: `RayDirection` (Vector3, origin-local,
default (0,-50,0)), `RayCollisionGroup` ("Default"), `FilterTag` (instances with that CollectionService tag are the
filter list), `FilterType` ("Exclude"; Exclude also excludes Terrain), `IgnoreWater` (true), `IgnoreCanCollide`
(false), gen-2 `PositionScale`/`OverrideWorldRotation`/`WorldRotation` (2.3). Pieces are pooled Parts with the
template's properties and cloned children (emitted nested); they take the hit surface's Color, Material and
Transparency (Transparency 0 -> `Transparency_Start`).

**Ring** (`effects/shockwave_ring`): `Segments` (7) points evenly round a circle of `Radius` (5) in the origin's XZ
plane; each casts RayDirection; a hit spawns one rock of random size (x,y,z in `MinSize`..`MaxSize`, defaults
(2,1,2)..(3,2,3)), up = surface normal, facing the centre, tilted back by atan(height/length). Grow from size x
`SizeScaleStart` (0) to size over `Size_Start_Duration` (0.5, `Size_Start_Curve`); world offset `Offset_Start` ->
`BaseOffset` over `Offset_Start_Duration` (0.5, `Offset_Start_Curve`). After a rolled `Lifetime` ((2,3) s): shrink to
size x `SizeScaleEnd` (0) over `Size_End_Duration` (`Size_End_Curve`), offset -> `Offset_End`, transparency ->
`Transparency_End` over `Transparency_Duration` (0.5, `Transparency_Curve`). Ends after Lifetime.Max + max(size/offset
end durations) (the transparency fade may be cut). Legacy: `PartOffset`, `Size_Curve`, `Size_Duration`. All real time.

**Debris** (`effects/shockwave_debris`): `Amount` (NumberRange (5,10), integer roll) unanchored pieces at the origin,
CanCollide true, group `ForgeDebris` (debris don't collide with each other); random size; optional look inherited
from a random visible part within `InheritanceRadius` (5; `InheritanceEnabled` true, `InheritanceMaxResults` 5);
ballistic impulse so the piece would reach origin + dir x `LinearMagnitude` ((15,25) studs) in `Airtime` ((0.5,0.5) s):
v0 = d/t + (0, g·t/2, 0), dir = random per axis in `MinDirection`..`MaxDirection` (origin-local, normalised);
angular impulse = random unit x `AngularMagnitude` ((5,15)) x mass. After `Lifetime` ((2,3)): shrink to size x
`SizeScaleEnd` over `Size_Duration` (0.5, `Size_Curve`), `Transparency_Start` (0) -> `Transparency_End` (1) over
`Transparency_Duration` (0.5). **Edit mode has no physics**: Forge steps it with `workspace:StepPhysics` (plugin only);
the player must integrate v0 + gravity itself (or step physics if it runs as a plugin).

**Line** (`effects/shockwave_line`, 0 files): over `Duration` (1) lays pieces along `Direction` ((0,0,-1), origin-local)
up to `Length` (50) at `Rate_Start`->`Rate_End` per second (30; `FixedAmount` > 0 = that many in total); piece k sits at
Length x ease(`Path_Curve`, k/total); random yaw from `Rotation` (NumberRange (-180,180), used as radians);
`Scale_Start/_End/_Curve` scale the sizes; then as Ring.

Examples: `kickbarrage.rbxl` `.../Assets/Slam/Ring` (56 segments, R 15); `2026 OS Jan-April (part 2)/YujiThings.rbxm`
`FinalHitModel/FinalHit/Ring`; `2026 OS Jan-April (part 2)/Fire explosion.rbxm` `Model/Debris` (2-5 rocks, 20 studs,
0.5 s airtime). (`cool water emit (1).rbxm` Water Explosion/Debris has Amount 0..0: spawns nothing.)

### 2.9 Forge property tweener: RayValue named after a property (`gen2:effects/tweener`, `gen1:tween_property`)
11 files / 132. Target = the Value of an ObjectValue child (gen-2), else the first non-Folder ancestor (gen-1: the
Parent). gen-2 tag `AttributeTweener` tweens an attribute of that name instead (0 files).

| Attribute | Type | Default | Meaning |
|---|---|---|---|
| `_END_VALUE` | same type as the property | required | target value |
| `_START_VALUE` | same | current property value | override of the start |
| `Duration` | NumberRange s | (1,1) | rolled |
| `Easing_Curve` | curve | linear | |
| `EmitDelay` | number s | 0 | the start value is read after the delay |
| `ResetOnFinish` | bool | true | put the start value back at the end |
| `Speed_*` | | 1 | (1.4) |

Interpolation by type (`mod/lerp`): number, Vector2/3, CFrame, UDim/UDim2, NumberRange, Rect, PhysicalProperties:
linear; Color3: in Oklab; NumberSequence: keypoints merged from both (missing ones interpolated), each lerped, capped
at 20 keypoints; ColorSequence: at the end sequence's keypoint times, linear RGB; anything else (bool, enum,
string): start while alpha < 0.5, end from 0.5. Examples: `SlammerHammerOS.rbxm` `HAMMER/Highlight2/FillTransparency`
(0 -> 1 in 0.5 s, no reset); `flame2.rbxm` `FLAME/Part/PointLight/{Range,Brightness,Color,Enabled}` (pulse curve,
example 3; note `Enabled` never reaches alpha 0.5 so it keeps its start value); `takebeams.rbxl` `.../A0/windbeams/
TextureSpeed`. (gen-2 `PropertyRandomizer`/`AttributeRandomizer` RayValues set the target to lerp(_START_VALUE,
_END_VALUE, weighted random from `Weight_Curve`) right before it emits and reset it next frame: 0 files.)

### 2.10 Forge runtime features no library file uses
`LightningBolt` attachments (`effects/lightning`: Segments, Jaggedness, RefreshRate, Width_Start/End, Fade_In/Out,
Dissipate_*, Fill_*), Sound attributes (`effects/sound`: EmitCount/EmitInterval/RepeatCount/RepeatInterval,
Volume_*/Speed_*/RollOff_* tweens over TimeLength, SoundPoolTag/Weight), randomizers, attribute tweeners, beam
flipbooks. A player can skip them; extend only if a new file needs them.

### 2.11 TweenParams mesh Model (older community "mesh emitter"; `VfxMods/meshemit`, `Emitter/XMeshEmitter`, `EffectUtility/Bugo`)
18 files / 2,809 models (STARCORE 2,724). Same Start/End structure, driven by TweenService.

| Attribute (Model) | Type | Meaning |
|---|---|---|
| `Duration` | number s | tween time and lifetime (must be a number or nothing tweens; missing -> lifetime 0.1) |
| `StartTransparency` | number or numeric string, default 0 | set on Start if it is a MeshPart, else on Start's child `Decal` |
| `Part_TweenParams` | string `"<EasingStyle>,<EasingDirection>"` | e.g. `"Cubic,Out"` = TweenInfo(Duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out); missing half -> Linear / In |
| `Mesh_TweenParams` | same | enables Start.Mesh.Scale -> End.Mesh.Scale (children named `Mesh`) |
| `Decal_TweenParams` | same | enables Start.Decal.Transparency -> 1 |

Values seen: Part `Cubic,Out` 1,906, `Quint,Out` 346, `Sine,Out` 211, `Quad,Out`, `Exponential,Out`, `Cubic,In`,
`Linear,Out`, `Circular,Out`, `Back,Out` (decals). Behaviour (meshemit/XMeshEmitter): the Model (XMeshEmitter: a clone)
goes under workspace.CurrentCamera; Start tweens to {CFrame = End.CFrame (world), Size = End.Size, Transparency = 1};
the Mesh and Decal tweens **reuse the Part's TweenInfo** (their own params only switch them on); the Model is
destroyed after Duration. No delay, no count. Variant (Bugo): CFrames relative to a caller CFrame (root · Start.CFrame),
`EndTransparency`, separate Mesh/Decal TweenInfos, `Welded`, `Distortion`, `RepeatCount`/`RepeatDelay`.
Pseudo-code: `clone model; apply StartTransparency; info = parse(Part_TweenParams); tween Start (CFrame, Size, ->1);
if Mesh_TweenParams: tween Mesh.Scale with info; if Decal_TweenParams: tween Decal.Transparency -> 1 with info;
after Duration destroy`. Examples: `190 OS/Cinnamon.rbxl` `Workspace/FX/Effects/Push` (0.3 s, Cubic/Sine/Quint Out);
`190 OS/abyss dragon.rbxl` `Workspace/Assets/ShockWave` (1.7 s Exponential Out); `190 OS/garou vfx and meshs.rbxm`
`Shockwave`.

**`_EasyMeshEmitData`** (13 files / 814): editor state of the "EasyMesh" plugin that also writes the flat attributes
above. A JSON **string literal containing JSON** (decode twice). Keys: `General/Tween Duration`,
`General/Transparency/Start`, `General/Transparency/End`, `Part|Mesh|Decal/Tween Information/Easing Style`,
`.../Easing Direction`, `Features/Random Angle/{Enable,X,Y,Z}`, `Features/Flipbook/{Enable,Fps}`,
`Features/Emitter/{Rate,Duration}`. Example (`Sandevistan_AFTERIMAGES.rbxl`): `"{\"General/Transparency/Start\":0,
\"Part/Tween Information/Easing Direction\":\"InOut\",\"Part/Tween Information/Easing Style\":\"Linear\",
\"General/Transparency/End\":1,\"General/Tween Duration\":0.5}"`. Where both exist the flat attributes were edited
later (Duration agrees 387 / disagrees 249; Part params agree 458 / 143), so the flat ones win; use the JSON only when
they are missing. 144 of these models are Forge meshes (Forge attributes present): Forge wins.

### 2.12 MeshPart `TimeBeforeReset` set (inert)
48 files / 5,801 parts (mostly the Start/End parts of mesh Models and loose meshes from one widely shared pack):
`CFrame`, `Duration`, `EmitDelay`, `Roation` (sic), `Size`, `TimeBeforeReset`, `Transparency`, all numbers.
5,800 of 5,801 are all zero (the exception: STARCORE `.../VFX_Utility/BubbleModule/Mesh` = Duration 1, Size 2,
TimeBeforeReset 1); no runtime in the library reads them (the BubbleModule script takes its values as arguments).
Inferred: per-property timing slots of some plugin. **Ignore**; play the parent Model's convention. Examples:
`190 OS/Chara Giveaway.rbxm` `Practice/Chara/Impact/Start`; `190 OS/Collapsing Nebula - Harlequin.rbxm`
`Collapsing Nebula/Wrath/Core`; `190 OS/Frozen Ripple (1).rbxm` (185 parts).

### 2.13 EnableDuration + light/beam fades (`EffectUtility/Arc`, `AenoirUnused/AenoirEmitOld2`)
1 file (STARCORE), 950 instances (894 emitters, 74 lights, trails). Applied to the descendants of an attachment that
is cloned and emitted; the clone is destroyed after the longest piece.

| Instance | Attributes | Meaning |
|---|---|---|
| ParticleEmitter | `EmitCount` (1), `EmitDelay` (0), `EnableDuration` (0) | Emit(EmitCount) after EmitDelay; Enabled for EnableDuration (Aenoir also accepts `EmitUptime`/`EmitDuration`) |
| Trail | `EnableDuration` | Enabled for that long |
| Light (PointLight/SpotLight/SurfaceLight) and Beam | `EnableDuration`, `Brightness` (target, default the property), `StartFade` (s), `StartFadeStyle` (EasingStyle name, "Cubic"), `EndFade` (s), `EndFadeStyle` ("Cubic") | Enabled; Brightness 0 -> target over StartFade (Direction Out); at EnableDuration, Brightness -> 0 over EndFade (Out), then disable and restore Brightness. Total = StartFade + EnableDuration + EndFade |
| Light (Aenoir) | `Brightness` as NumberSequence, `Lifetime` | Brightness = property x sequence(t / life) per frame |

Example: STARCORE `ReplicatedStorage/Resources/Emotes/CombatGodsMove/Attacker/HumanoidRootPart/28/PointLight`
(Brightness 5, EnableDuration 0.3, StartFade 0.01 Sine, EndFade 0.1 Quint), `.../30.5/Attachment/PointLight`
(0.9 s, 0.5/0.5 Cubic); trails: `ReplicatedStorage/Resources/Chara/Cursed Remedy/Windup/2/Attachment/Attachment/Beam97`.

### 2.14 Zstr mesh emitter (`Effects2/Emitter/Zstr_MeshEmitter`)
5 files / ~700 Models (STARCORE 692; also `ahhellnahbhhh.rbxm`, `SlammerHammerOS.rbxm`, `kick barrage.rbxm`,
`kickbarrage.rbxl`, where the same Models also carry Forge attributes: Forge wins there). Start/End Model:
`Lifetime` (s), `EasingStyle`/`EasingDirection` (names), `Movement` (bool: also tween to Start⁻¹·End), `Offset`
(Vector3, read by the callers, not by Emit), `RotationX/Y/Z` (NumberRange deg, random start angle; integer `math.random`), `RotationSpeed` (deg per
Heartbeat about Y, frame-rate dependent), `StartTransparency` (1), `Transparency` (end, 1),
`TransparencyEasingStyle`/`TransparencyEasingDirection` (decal fade), `FlipbookRate`, `Repeat`. A Start clone at the
caller's CFrame tweens Size (or SpecialMesh Scale) to End's and Transparency to `Transparency` over Lifetime; decal
variant also tweens Color3 to End's decal. Example: STARCORE `ReplicatedStorage/Emotes/VFX/VfxMods/FirstMoveRetrySend/
Move1/SwingKick/Mesh/BigSwing`; `ahhellnahbhhh.rbxm` `Gravity/MEsh/Shockwave`; `SlammerHammerOS.rbxm`
`HAMMER/FloorFx/Slam/WindImpact`.

### 2.15 Part_Icles: part-as-particle (`Workspace/Part_Icles` in `zeninmassacre.rbxl`, `MFX` in `Place1.rbxl`)
13 files / 122. A Part/MeshPart/Beam with attributes `IsEmitter = true`, `Transformed = true`, `EmitCount`,
`EmitDelay`, `EmitDuration`, and a child Folder `Factors` holding **ParticleEmitters used as data** (`Main` = Lifetime,
Speed (its Squash graph), Transparency, Shape/SpreadAngle/EmissionDirection/Acceleration; `Size/X,Y,Z` = Size graphs
per axis; `Rotation/X,Y,Z` = start angles; `RotationSpeed/X,Y,Z` = Squash graphs), optional `MeshFlipbooks`,
`TotalKeyFrames`, `VelocityVectored` (BoolValue). The part itself is cloned and moved like a particle. Data lives in
those child instances, not attributes; implement only if needed. Examples: `190 OS/OS with cool stuff in it.rbxl`
`Workspace/Meshflipbooks/Meshes/Mesh3`; `190 OS/QuakePunch.rbxm` `Punch/MeshUpSpin`; `zeninmassacre.rbxl`
`Workspace/MAKISLASHESAOE/FlashSlashes/SlashesDet`.

### 2.16 Minor attributes (no runtime or game-specific)
| Attribute / tag | Where | Files | Meaning / player action |
|---|---|---|---|
| `UseGroundColor`, `Use_Ground_Color`, `UseWallColor` | ParticleEmitter | 21 | game code sets Color to the ground (raycast hit) colour (`Zabuza/WallCombo`). Player: tint with the floor colour |
| `GroundOnly`, `Ground_Only` | ParticleEmitter | 16 | game emits only when grounded. Player: emit |
| `BaseRate`, `BaseEmitCount` | ParticleEmitter | 37 | pre-scaling originals from a density tool (Rate/BaseRate varies 0..2). Use the live Rate/EmitCount |
| `EmitType` = "attribute" / "name" | ParticleEmitter | 29 | which holds the count: the EmitCount attribute or the emitter's Name. "name" emitters still have EmitCount attrs; read EmitCount, else tonumber(Name) |
| `recolorable`, `ChangeColor`, `hakiColor`, `GrassColor`, `MaterialIgnore` | ParticleEmitter | 5-15 | game recolour hooks; ignore |
| tag `Emitters` (886 emitters), `AuraInstance` (810) | ParticleEmitter | 26 / 16 | grouping tags of emit/aura tools; ignore |
| tags `CircularBeam`, `CylindricalBeam` + `Height`, `Radius0/1`, `Rotation`, `Segments` | Attachment | 3 | beam-ring generator settings; the generated beams are already children |
| `WidthScale_Start/_End/_Curve` | Trail | few | editor bake metadata (1.2 curve format); Trail.WidthScale holds the result |
| `StartDelay`, `EndDelay` | Beam | 3 (STARCORE, `Claw_Slash.rbxm`, `Tap.rbxm`) | game scripts; no generic meaning |

---------------------------------------------------------------------------------------------------------------

## 3. Usage table (instances in the 507 dumps)

| Convention | Section | Files | Instances | Notes |
|---|---|---|---|---|
| particle EmitCount/EmitDelay/EmitDuration | 2.0 | 294 | 196,949 | 144 files have all three |
| particle TimeScale_* | 2.1 | 42 | 13,645 | ramp used only in STARCORE |
| particle editor curves (Size_/Transparency_Curve...) | 2.1 | 73 | 8,385 (with BaseRate/EmitType cluster) | ignore |
| Forge beam (new set) / legacy beam set | 2.2 | 21 / 49 | 1,092 / 1,778 | |
| Forge mesh Model | 2.3 | 28 | 1,056 | |
| Forge decal tweens / flipbooks | 2.3 | 18 / 7 | 296 / 95 | |
| ConstantVFX tag | 1.5 | 19 | 317 | |
| Forge spin Model | 2.4 | 10 | 46 | |
| BezierParticle | 2.5 | 13 | 40 | |
| screen part (attrs / Enabled true) | 2.6 | 8 / 2 | 17 / 5 | |
| CameraShake | 2.7 | 8 | 10 | |
| Shockwave origins (Rings / Debris / Lines) | 2.8 | 7 (5 / 2 / 0) | 8 | |
| RayValue tweener | 2.9 | 11 | 132 | |
| LoadVFXTextures tag | 1.5 | 7 | 62 | preload only |
| TweenParams Model | 2.11 | 18 | 2,809 | |
| _EasyMeshEmitData | 2.11 | 13 | 814 | |
| MeshPart TimeBeforeReset | 2.12 | 48 | 5,801 | inert |
| EnableDuration / light fades | 2.13 | 1 | 950 (74 lights) | |
| Zstr mesh emitter | 2.14 | 5 | ~700 | |
| Part_Icles | 2.15 | 13 | 122 | |
| Files with any Forge-only signature | | 51 | | runtime shipped in 7 (6 with the licence string + decompiled STARCORE copies) |

## 4. Player rules (precedence and Edit-mode notes)
1. Never run or embed the shipped runtimes; reimplement from this file. Walk the tree as in 1.5, start everything in
   the same frame, give every emitted instance its own thread and clock, and add nested delays.
2. A Model with Start/End: Forge mesh if it has any Forge-only key (`EffectDuration`, `Part_*`, `Speed_*`,
   `SpreadAngle`, `Min/MaxInitRot`, `RotAroundOrigin`, `Mesh_Scale_Curve`, `EmitCount`); else TweenParams if any
   `*_TweenParams`; else `_EasyMeshEmitData` mapped onto TweenParams; else Zstr if `Lifetime`+`EasingStyle`; else
   (only `Duration`/`StartTransparency`) Forge legacy (out-cubic over Duration, StartTransparency -> Decal_ or Mesh_).
3. Particles: generic 2.0 semantics plus 2.1 ramps. Emitters without any emit attribute: gen-1 Forge disables them
   and Emit(1)s them; gen-2 (live game) leaves them alone, so an Enabled one keeps running. Default to gen-2; the
   files that ship a gen-1 runtime (kickbarrage, Wukong, Plasma, SlammerHammerOS) were authored against gen-1.
4. Evaluate curves exactly as 1.2 (unclamped alpha, Newton on x, first frame skipped except Bezier paths). Cache the
   decoded curve per string.
5. Edit-mode specifics: RenderStepped/Heartbeat run in Edit mode; physics does not (integrate debris yourself);
   camera shakes must undo last frame's offset; shockwave rings need a surface to raycast against (keep a floor);
   pooled parts in a reimplementation can just be new anchored Parts parented to a scratch Folder, destroyed at end.
6. Restore everything you touch (template Enabled flags, spin pivots/scales, screen parts, tweened properties with
   ResetOnFinish, beam attachments) so the same effect can be replayed.
