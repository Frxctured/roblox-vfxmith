# VFXTimeline spec format

Runtime: `kit/runtime/VFXTimeline.luau` (this skill). One shared Heartbeat; every layer instance is created at its
start time, updated every frame from its tracks, destroyed at its end (emitters linger until their particles die).

```lua
return {
	name = "VoidRend",
	scale = 1,                                   -- optional base scale (opts.scale multiplies)
	palette = { white = "#FFF0FF", magenta = "#D24BFF", ink = "#000000" },  -- colour names usable anywhere
	textures = { Smoke = 125025427182492 },      -- texture names usable in props.Texture
	layers = { <layer>, ... },
}
```

## Common layer fields
| Field | Meaning |
|---|---|
| `id` | name (used in warnings and reviews) |
| `kind` | `part`, `beam`, `emitter`, `light`, `grade`, `custom` |
| `t`, `life` | start time and lifetime, seconds |
| `at`, `rot` | position (studs, scaled) and rotation (degrees XYZ) relative to the effect origin |
| `props` | static instance properties (plain values, see conversions) |
| `tracks` | `{ Prop = { {time, value, ease}, ... } }`, time from the layer start; the ease belongs to the segment ENDING at that key; before the first key = first value, after the last = last value |
| `copies` | `{ n, every, jitter, spread = {x,y,z}, rotSpread = {x,y,z}, yawEven }`: n instances, staggered, randomised by the seed |
| `enabled = false` | skip the layer (A/B tests) |

Eases: `linear step quadIn quadOut quadInOut cubicIn cubicOut quartOut quintOut expoIn expoOut sineIn sineOut sineInOut backIn backOut elasticOut`. `step` holds the previous value until the key (colour-by-age swaps).

Value conversions: colours `"#RRGGBB"`, palette names, `{r,g,b}` 0-255; vectors `{x,y,z}`; sequences
`{{t, v[, envelope]}, ...}` (0..1, endpoints added); ranges `{min, max}`; enums by item name (`"Neon"`,
`"VelocityPerpendicular"`); `FlipbookLayout = 4` -> Grid4x4; textures by number, numeric string or `textures` name.
Sizes, speeds, accelerations, beam widths/curves, TextureLength and light Range are multiplied by the scale.

## kind = "part"
`template = "VR_Crescent"` (clone from `ReplicatedStorage.VFXAssets`), or `props.Shape = "Ball"|"Cylinder"|"Block"`, or
`mesh = <id>` (SpecialMesh; `meshScale`, `meshSize`, `meshTexture`). `size` = base size (studs; default the template's).
`pivot` = the anchor point in the part's local box, normalised -0.5..0.5 (`{0,-0.5,0}` = bottom centre: scales grow out
of the ground). `spin = {x,y,z}` deg/s. `decal = { Texture, Face = "Top", Color3, Transparency }`.
Tracks: `Scale` (number or vector), `Offset` (vector, layer space), `Rot` (degrees), `Color`, `Transparency`,
`DecalColor`, `DecalTransparency`. Default material Neon. Flat disc: `Shape = "Cylinder", rot = {0,0,90}, size = {0.08, d, d}`.

## kind = "beam"
`a`, `b` endpoints (layer space), `axis = {0,1,0}` sets both attachments' Axis (CurveSize0 bends along it at a,
CurveSize1 against it at b: arches = `CurveSize0 = k, CurveSize1 = -k`, semicircle k ~ 1.33 r), defaults FaceCamera,
LightInfluence 0, Segments 1. Tracks: `A`, `B` (offsets), `Width` (multiplies Width0/1), `Color`, `Fade` (0 = as
authored, 1 = gone; keeps the Transparency shape), `CurveSize0/1`. A Beam runs its texture's HEIGHT along its length.

## kind = "emitter"
**Size is a half-width:** a particle of Size N is 2N studs across (measured; beam widths and part sizes are full
widths). ParticleEmitter on an invisible anchored part (`box = {x,y,z}` = emission volume, with `Shape = "Box"`). Rate defaults
0; `emit = { {t, count[, over]} }` (spread over `over` s), counts x `VFXTimeline.Quality`. Tracks: `Rate`, `Offset`.
Ground decal trick: `Orientation = "VelocityPerpendicular", EmissionDirection = "Top", Speed = 0.01` lies the sprite flat.
Dark ink sprite: `Color = "ink", LightEmission = 0`.

## kind = "light" / "grade" / "custom"
- light: PointLight (or `class = "SpotLight"`), tracks `Brightness`, `Range`, `Color`. One per effect, no shadows.
- grade: ColorCorrectionEffect in Lighting named `VFXGrade_<name>`, tracks any of `Contrast`, `TintColor`,
  `Brightness`, `Saturation`.
- custom: `start(ctx, L) -> state`, `update(ctx, L, state, lt, dt)`, `stop(ctx, L, state)`; `ctx.random` is seeded,
  `ctx.folder` is the effect's folder, `ctx.scale`, `ctx.origin`. Derive every value from the layer time `lt` (not by
  adding up `dt`) so a freeze holds exactly; put the instances you make under `ctx.folder`: its ParticleEmitters and
  Beams then freeze and resume with the effect (since 0.1.6-beta3). Destroy what you made in `stop`.

## Handle
`play` returns `{ stop(), time(), setSpeed(s) }` (0 freezes, 0.25 slow motion). `VFXTimeline.length(spec)`,
`VFXTimeline.preload(spec)` (call once when a game loads the spec: the first play otherwise misses textures),
`VFXTimeline.CullDistance` (260), `VFXTimeline.Quality` (1; 0.6 on touch).

## Check
`local report, problems, stats = VFXTimeline.check(spec, { length = 4 })` (or `C.check(name, { length = 4 })` in the
capture harness; `length` = the brief's total length in s, optional) sets every prop
on a scratch instance and reports **ERROR** (unknown property, bad enum or colour, unknown texture or palette name: the
value never reaches the instance), **WARN** (a key the layer's kind ignores, e.g. `Width0` outside `props`; a track the
kind ignores, e.g. `Transparency` on an emitter; an unknown ease; no Transparency anywhere, so the layer is opaque its
whole life and then cuts; an emit or key after the layer's life; an emitter that never emits; no Lifetime or Texture;
more than one light), then the peaks: live particles, elongated particles and the bright-white ones among them (white streaks and
needles: the clutter count), active layers, the widest particle in
studs, when the effect is last visible, and every texture id with the layers and LightEmission that use it. It also
WARNs on a near-white sprite over 8 studs across (reads as a flat white ball in daylight) and, given `length`, on an
effect visible more than 0.5 s longer or 0.6 s shorter than asked.
