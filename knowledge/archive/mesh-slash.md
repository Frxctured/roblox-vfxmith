# Mesh slashes: when a slash is a mesh, not a sprite

Most slashes in the library are flipbook sprites. The ones that shine in daylight and seem welded to the blade are
usually **meshes**. This note says how they are built, with the values the kit uses (`fx:MeshSlash` in
`kit/studio/VFXKit.luau`). It comes from reading the meshes under slash, swing, claw and blade paths in the studied
files and from rebuilding them in Studio.

## The technique
**An invisible Part + a SpecialMesh (FileMesh) + a Decal.** It is the most common build among the slash meshes we
read, ahead of plain Neon meshes and plain Plastic ones.
- The Part has Transparency 1. The Decal on it still renders and is wrapped over the mesh's UV map, so a painted
  slash lies on a curved 3D surface.
- **Decal.Color3 above 1 is the shine.** Values like (2, 7, 8.5) give a white-hot core, a saturated rim and real
  bloom in daylight without Neon. The texture's own dark brush edges stay dark, so one decal already gives core, rim
  and edge. `K.HDR(colour, gain)` makes such a colour; gains 4-10 work, pure white glows go far higher.
- Two identical decals on one part = denser. A black copy (Color3 0, 0, 0) = depth.
- A negative SpecialMesh Scale mirrors the swirl.
- **A Decal on a MeshPart did not wrap the mesh in our tests** (only scraps showed). Use Part + SpecialMesh.
  `SpecialMesh.Scale = wanted size / native size`; measure the native size once with
  `AssetService:CreateMeshPartAsync(...).MeshSize`.

## Shapes that recur (all in the open-source pack)
| Mesh | Native size | What it is | Decal used here |
|---|---|---|---|
| `6665452633` | 2 x 0.2 x 2 | flat ring (disc with a hole) | `120758508542035` thin white-hot crescent, ~170 deg (`K.Mesh.Hot`); `98079913503816` thick soft crescent, ~140 deg (`K.Mesh.Body`) |
| `17105621375` | 1 x 1 x 1 | squat cylinder | `18227621394` a slash wrapped round the wall, ~200 deg (`K.Mesh.Band`): the only one with HEIGHT edge-on |
| `8501563708` | 37.8 x 50 x 50 | hemisphere / dome | wind and swirl decals (`9581481497`, `16892231149`, `9572542664`): the swirl shell behind a hit, 35 files use it |
| `4681227436` | 11.1 x 8.7 x 11.3 | wispy twisted wind ring | none: plain Neon at Transparency 0.8-1, growing 5x in 1 s |
| `5694664025`, `5694663583` | ~11 x 0.1-0.4 x 10 | thin flat arcs | none: solid Neon colour, 0.1 thick |

## How they move
Authors keep a Start and an End copy of each mesh and tween between them, 0.08-0.25 s for a slash, up to 1 s for
wind:
- the part **grows 2-3x and turns 100-180 degrees** about its axis, so the swoosh sweeps round instead of popping on;
- the radius grows while the thickness shrinks (about 1.25x -> 0.75x): the band thins as it opens;
- the decal's Transparency goes to 1 with **Cubic Out** (most of the fade in the first third), its colour to the end
  colour; random roll about the axis per emit for wind shells.

The kit does the same from the effect clock instead of tweens, so a frozen frame equals a live frame, and it takes
the plane, centre and radius from the pose:
1. sample the tip of the blade (or hand, or foot) over the swing, fit a plane and a circle (`fx:FitArc`);
2. every frame, turn each layer so its arc's middle trails the tip by `lag` degrees (default: half the decal's span,
   so its head sits on the blade), grow the radius 0.92 -> 1.1, thin it, hold, then fade Cubic Out over 0.08-0.25 s.

**Fit the effect to the blade, never the arms to the effect.** Bending arms to reach a drawn plane gave hunched,
tangled poses; fitting the meshes to the real path needs no rotation calibration and survives any pose change.

## The stack
Band in the main colour (height) + Body in the deep colour + a black Body copy at 0.9x radius, Transparency 0.5,
a little behind and ending first + the white-hot Hot crescent on top, cooling to the main colour.
- The black copy must be smaller or behind: at 1.05x it covered the bright layers from the far side.
- An arc centred on the body that crosses "forward" is edge-on from behind, whatever its roll; flat meshes fail there
  too. The Band's wall faces the player camera exactly where the arc crosses the look line: make it tall (2-2.6
  studs, `height = 2`) for those cuts. Thin bands lose that face (keep the core >= 0.75 studs).
- Shorten from the tail: split the arc into layers with a growing `lag` (72 / 112 / 150) and give the bigger-lag
  pieces an earlier `off`; `col1` cools each one (white -> main -> deep).
- A chasing crescent for a spin: one Hot layer at ~0.7 of the fitted radius + a thin tail at a bigger lag + a dark
  outline. From above it never closes into a ring.

## Mesh or sprite
| Use a mesh when | Use a sprite when |
|---|---|
| the slash must shine in daylight (HDR decal, real bloom) | the shape should animate or erode (flipbook) |
| it must sit on the blade through the whole swing | the look is stylised ink, or shared across many moves |
| its plane is edge-on to the player and needs some height | it passes within a few studs of a camera |
| | many small hits (meshes cost a part each) |

A mesh layer fades as a whole, uniformly: for a tail that breaks up, put one flipbook sprite on the same plane
(`tail = true`) or stagger layers. Crackle, contact pops and sparks stay sprites either way.

## In the kit
```lua
local s = fx:MeshSlash({ name = "S2", swing = { 0.47, 0.63 }, height = 2, fade = 0.12, tail = true })
fx:Contact({ t = 0.56, p = s.c + s.mid * s.R, dir = V3(0.6, 0.6, -0.3) })
-- a punch or a kick: swing = { t0, t1, "RightHand" } / "RightFoot"; your own stack: layers = { { kind = "Hot", ... } }
```
Other meshes: add an entry to `K.Mesh` (native size, decal, span, where the arc's middle sits, radius factor).
The ids are other people's uploads from the open-source pack: fine while building, your call when you publish
(`THIRD_PARTY.md`).
