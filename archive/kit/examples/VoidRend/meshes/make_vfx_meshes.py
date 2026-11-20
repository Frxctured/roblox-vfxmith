"""VFX pipeline example meshes for the void ground explosion (reference: the reference video Styl_VoidRend_v2 (third-party, not included), frames f545,
f566, f571, day_t22.4s, day_t23.0s). Three smooth, vertex-coloured, single-material meshes, tinted in Roblox by
MeshPart.Color with Neon (Neon multiplies vertex colours by Color, so they are white / grey here):

  VR_Crescent   the crescent "horn" that rises out of the ground beside the pillar: a crescent-moon blade standing
                on its lower tip. Arc in the Blender YZ plane, 156 deg, ~10 studs tall, outer edge on a circle,
                thickest in the middle (1.1 in the arc plane, 0.5 across X), tapering to sharp points at both ends.
                Concave side faces Blender -Y (= Roblox -Z, the part's LookVector), convex back bulges to +Y.
                Up = Blender +Z. Pivot (origin) = the bottom tip; the top tip is straight above it.
                Vertex colour: white at the top, grey 0.45 at the bottom tip.
  VR_SpikeCrown the jagged splash crown around the burst dome: 17 flat diamond-section blades of uneven length radiating
                out and up from the dome (bases on a radius-1 hemisphere, tips 2.2-4 studs from the centre, 15-70 deg
                above horizontal, several bent or kinked). Up = Blender +Z. Pivot = base centre. White.
  VR_Arch       a thin half-ring arch: ring radius 1, tube radius 0.12, 180 deg in the Blender XZ plane, both ends
                standing on z = 0 at x = +-1. Pivot = ring centre on the ground. White.

Run headless from the repo root:
  blender -b --factory-startup --python make_vfx_meshes.py [-- --no-render]
Outputs: out/VR_*.glb, out/report.json (tris, gate, bbox, Roblox pivot offset), review/*.png (gitignored).
Upload: python3 ../../../scripts/rbx_assets.py upload out/<Name>.glb --ids ids.json
"""
import json
import math
import os
import random
import sys

import bpy
import bmesh
from mathutils import Vector, Matrix

# OPTIONAL dependency: the LihFolk Blender helpers (lihfolk_bpy, lihfolk_curves) from the LihFolk plugin's
# roblox-blender-modeling skill. Only needed to REGENERATE these meshes; the exported GLBs are already in out/.
# Point LIHFOLK_BLENDER at that skill's scripts folder (default: the usual plugin location).
import glob as _glob
SKILL = os.environ.get("LIHFOLK_BLENDER") or next(iter(sorted(_glob.glob(os.path.expanduser(
    "~/.claude/plugins/cache/lihfolk/lihfolk/*/skills/roblox-blender-modeling/scripts")))), "")
sys.path.insert(0, SKILL)
try:
    import lihfolk_bpy as lf  # noqa: E402
    import lihfolk_curves as lc  # noqa: E402
except ImportError:
    raise SystemExit("This generator needs the optional LihFolk Blender helpers (set LIHFOLK_BLENDER). "
                     "The finished meshes are in out/ already.")

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "out")
REVIEW = os.path.join(HERE, "review")
argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
RENDER = "--no-render" not in argv


# ------------------------------------------------------------------------------------------------ helpers

def new_object(name, bm):
    me = bpy.data.meshes.new(name)
    bm.normal_update()
    bm.to_mesh(me)
    bm.free()
    ob = bpy.data.objects.new(name, me)
    bpy.context.scene.collection.objects.link(ob)
    return ob


def ring_verts(bm, centre, a_dir, b_dir, a, b, n, phase=0.0):
    """n verts on an ellipse (semi-axes a along a_dir, b along b_dir) around centre."""
    out = []
    for k in range(n):
        t = phase + 2 * math.pi * k / n
        out.append(bm.verts.new(centre + a_dir * (a * math.cos(t)) + b_dir * (b * math.sin(t))))
    return out


def bridge(bm, r0, r1):
    n = len(r0)
    for k in range(n):
        bm.faces.new((r0[k], r0[(k + 1) % n], r1[(k + 1) % n], r1[k]))


def fan(bm, ring, apex, reverse=False):
    n = len(ring)
    for k in range(n):
        f = (ring[k], ring[(k + 1) % n], apex)
        bm.faces.new(tuple(reversed(f)) if reverse else f)


def cap(bm, ring, reverse=False):
    """Flat cap triangulated in place (no n-gons, no extra vertex)."""
    f = bm.faces.new(tuple(reversed(ring)) if reverse else tuple(ring))
    bmesh.ops.triangulate(bm, faces=[f])


def smoothstep(e0, e1, x):
    t = min(1.0, max(0.0, (x - e0) / (e1 - e0)))
    return t * t * (3 - 2 * t)


def finish_mesh(ob, smooth_angle):
    """Outward normals, transforms applied, smooth shading (Smooth by Angle), one vertex-colour material."""
    lf.cleanup(ob)
    lf.finish(ob, style="smooth", smooth_angle=smooth_angle)
    return ob


def bbox(ob):
    bm = lf._eval_bm(ob)
    lo, hi = lf._bounds([v.co for v in bm.verts])
    bm.free()
    return lo, hi


def roblox_info(ob):
    """Blender (x, y, z) -> Roblox (-x, z, y) (glTF Y-up export + Roblox's import mirror, AGENTS.md).
    MeshPart.Size = bbox size; the part's CFrame sits at the bbox centre, so PivotOffset = -centre."""
    lo, hi = bbox(ob)
    rb = lambda v: Vector((-v.x, v.z, v.y))  # noqa: E731
    a, b = rb(lo), rb(hi)
    rlo = Vector((min(a.x, b.x), min(a.y, b.y), min(a.z, b.z)))
    rhi = Vector((max(a.x, b.x), max(a.y, b.y), max(a.z, b.z)))
    c = (rlo + rhi) / 2
    return {"blender_bbox": [[round(x, 3) for x in lo], [round(x, 3) for x in hi]],
            "roblox_size": [round(x, 3) for x in (rhi - rlo)],
            "roblox_pivot_offset": [round(-x, 3) for x in c]}


# ------------------------------------------------------------------------------------------------ 1. crescent

def make_crescent(name="VR_Crescent", W=1.1, D=0.5, low=0.45):
    """W = max thickness in the arc plane (radial), D = max thickness across (X). VR_CrescentThick (W 2.3, D 0.75)
    matches the reference's chunky horns (thickness ~0.22 of the height)."""
    ARC = math.radians(156.0)   # arc span (brief: 150-170)
    H = 10.0                    # tip-to-tip height (chord, vertical)
    N = 46                      # stations tip..tip (0 and N are the tip points)
    M = 12                      # verts around the cross-section
    half = ARC / 2
    R = H / (2 * math.sin(half))                      # outer-edge radius
    yc, zc = -R * math.cos(half), R * math.sin(half)  # circle centre: bottom tip lands on the origin
    cos_t = math.cos(half)

    def prof(phi):
        """Crescent-moon thickness: outer circle minus an offset inner circle ~ (cos phi - cos tip) / (1 - cos tip)."""
        return max(0.0, (math.cos(phi) - cos_t) / (1 - cos_t))

    bm = bmesh.new()
    X = Vector((1, 0, 0))
    rings = []
    tips = []
    for i in range(N + 1):
        u = i / N
        s = 0.5 * u + 0.5 * (0.5 - 0.5 * math.cos(math.pi * u))   # denser near the tips, even in the middle
        theta = -half + ARC * s
        radial = Vector((0, math.cos(theta), math.sin(theta)))
        outer = Vector((0, yc, zc)) + radial * R
        if i in (0, N):
            tips.append(bm.verts.new(outer))
            continue
        p = prof(theta)
        w = W * p
        d = D * p ** 0.7                                  # stays rounder than the radial width near the points
        centre = outer - radial * (w / 2)
        rings.append(ring_verts(bm, centre, radial, X, w / 2, d / 2, M))
    for r0, r1 in zip(rings, rings[1:]):
        bridge(bm, r0, r1)
    fan(bm, rings[0], tips[0], reverse=True)
    fan(bm, rings[-1], tips[1])
    ob = new_object(name, bm)
    finish_mesh(ob, smooth_angle=80)

    def colour(info):
        g = low + (1 - low) * smoothstep(0.0, 0.92, info.co.z / H)
        return (g, g, g)
    lc.paint(ob, colour, per="corner")
    lc.vertex_color_material(ob)
    lf.set_origin(ob, "point", at=(0, 0, 0))
    return ob


# ------------------------------------------------------------------------------------------------ 2. spike crown

def blade(bm, path, stations, w0, t0, roll, side_ref, taper_exp=1.4):
    """One closed diamond-section blade along path(s), s in [0, 1]: broad side along side_ref (made perpendicular to
    the path), rolled by `roll` about the path, width and thickness tapering to a point at s = 1. Returns the frames."""
    rings, frames = [], []
    for s in stations:
        c = path(s)
        T = (path(min(1.0, s + 0.02)) - path(max(0.0, s - 0.02))).normalized()
        Wd = (side_ref - T * side_ref.dot(T)).normalized()
        Nd = T.cross(Wd).normalized()
        Wr = Wd * math.cos(roll) + Nd * math.sin(roll)
        Nr = T.cross(Wr).normalized()
        taper = (1 - s) ** taper_exp          # concave sides: spiky, comic-splash triangles
        w, t = w0 * taper, t0 * (0.35 + 0.65 * taper)
        rings.append([bm.verts.new(c + Wr * (w / 2)), bm.verts.new(c + Nr * (t / 2)),
                      bm.verts.new(c - Wr * (w / 2)), bm.verts.new(c - Nr * (t / 2))])
        frames.append((c, T, Wr, Nr, w, t))
    tip = bm.verts.new(path(1.0))
    for r0, r1 in zip(rings, rings[1:]):
        bridge(bm, r0, r1)
    fan(bm, rings[-1], tip)
    cap(bm, rings[0], reverse=True)
    return frames


def make_spike_crown():
    rng = random.Random(7)
    COUNT = 17
    STATIONS = [0.0, 0.16, 0.33, 0.5, 0.66, 0.82]  # + the tip at 1.0
    bm = bmesh.new()
    Z = Vector((0, 0, 1))
    blades = []
    for i in range(COUNT):
        az = 2 * math.pi * i / COUNT + rng.uniform(-0.12, 0.12)
        long_one = (i % 3 != 1) if rng.random() > 0.25 else rng.random() > 0.5
        reach = rng.uniform(3.1, 4.0) if long_one else rng.uniform(2.2, 2.9)   # tip distance from the pivot
        e_start = math.radians(rng.uniform(15, 66))
        bend = math.radians(rng.choice([0, 0, rng.uniform(-22, -8), rng.uniform(10, 26)]))  # some droop, some curl up
        e_end = max(math.radians(12), min(math.radians(74), e_start + bend))
        yaw_bend = math.radians(rng.uniform(-14, 14)) if rng.random() < 0.4 else 0.0
        barb = rng.random() < 0.4            # a side notch (small barb) like the jagged comic splash in f571
        w0 = rng.uniform(0.62, 0.95)
        t0 = rng.uniform(0.18, 0.26)
        roll = math.radians(rng.uniform(-28, 28))
        z0 = rng.uniform(0.0, 0.45)
        r0 = math.sqrt(max(0.0, 1 - z0 * z0)) * 0.92        # base on (just inside) a radius-1 dome
        z0 = max(z0, t0 / 2 + 0.02)
        radial = Vector((math.cos(az), math.sin(az), 0))
        tang = Vector((-math.sin(az), math.cos(az), 0))
        base = radial * r0 + Z * z0

        def direction(s):
            e = e_start + (e_end - e_start) * s
            a = az + yaw_bend * s
            return Vector((math.cos(e) * math.cos(a), math.cos(e) * math.sin(a), math.sin(e)))

        # integrate the bent spine, then scale it so the tip lands `reach` studs from the pivot
        samples, p = [Vector(base)], Vector(base)
        n_int = 40
        for k in range(n_int):
            p = p + direction((k + 0.5) / n_int) * (1.0 / n_int)
            samples.append(Vector(p))
        unit_tip = samples[-1] - base
        # solve |base + L*unit_tip| = reach for L (quadratic, positive root)
        a_, b_, c_ = unit_tip.dot(unit_tip), 2 * base.dot(unit_tip), base.dot(base) - reach * reach
        L = (-b_ + math.sqrt(b_ * b_ - 4 * a_ * c_)) / (2 * a_)

        def spine(s):
            idx = s * n_int
            k = min(int(idx), n_int - 1)
            f = idx - k
            return base + ((samples[k] - base) * (1 - f) + (samples[k + 1] - base) * f) * L

        frames = blade(bm, spine, STATIONS, w0, t0, roll, tang)
        if barb:
            # a short straight barb leaving the blade's broad side at 35-50 deg, from inside the blade at s ~ 0.33-0.5
            k = rng.choice([2, 3])
            c, T, Wr, Nr, w, t = frames[k]
            side = rng.choice([-1, 1])
            ang = math.radians(rng.uniform(35, 50))
            d = (T * math.cos(ang) + Wr * (side * math.sin(ang))).normalized()
            start = c + Wr * (side * w * 0.15)
            blen = L * rng.uniform(0.3, 0.42)
            blade(bm, lambda s, a=start, d=d, n=blen: a + d * (n * s), [0.0, 0.45], w * 0.6, t * 0.8, roll, Wr, 1.2)
        tip_v = spine(1.0)
        blades.append({"az_deg": round(math.degrees(az) % 360, 1), "reach": round(reach, 2),
                       "elev_deg": round(math.degrees(math.asin((tip_v - base).normalized().z)), 1),
                       "bent": bool(bend or yaw_bend), "barb": barb})
    ob = new_object("VR_SpikeCrown", bm)
    finish_mesh(ob, smooth_angle=30)
    lc.paint(ob, lambda info: (1, 1, 1))
    lc.vertex_color_material(ob)
    lf.set_origin(ob, "point", at=(0, 0, 0))
    return ob, blades


# ------------------------------------------------------------------------------------------------ 3. arch

def make_arch():
    RING, TUBE, K, M = 1.0, 0.12, 20, 8
    bm = bmesh.new()
    Y = Vector((0, 1, 0))
    rings = []
    for i in range(K + 1):
        th = math.pi * i / K
        u = Vector((math.cos(th), 0, math.sin(th)))
        rings.append(ring_verts(bm, u * RING, u, Y, TUBE, TUBE, M))
    for r0, r1 in zip(rings, rings[1:]):
        bridge(bm, r0, r1)
    cap(bm, rings[0], reverse=True)
    cap(bm, rings[-1])
    ob = new_object("VR_Arch", bm)
    finish_mesh(ob, smooth_angle=60)
    lc.paint(ob, lambda info: (1, 1, 1))
    lc.vertex_color_material(ob)
    lf.set_origin(ob, "point", at=(0, 0, 0))
    return ob


# ------------------------------------------------------------------------------------------------ review renders

def render_extra(ob, name, direction, size=640, light="STUDIO", single=None, bg=None, target=None, dist_mul=2.6):
    s = bpy.context.scene
    s.render.engine = "BLENDER_WORKBENCH"
    s.render.resolution_x = s.render.resolution_y = size
    sh = s.display.shading
    sh.light = light
    sh.color_type = "SINGLE" if single else "VERTEX"
    if single:
        sh.single_color = single
    sh.show_cavity = False
    sh.show_object_outline = True
    if s.world is None:
        s.world = bpy.data.worlds.new("VR_World")
    s.world.color = bg or (0.18, 0.18, 0.2)
    lo, hi = bbox(ob)
    ctr = target if target is not None else (lo + hi) / 2
    rad = max((hi - lo).length / 2, 1e-3)
    others = [o for o in s.objects if o is not ob and o.type == "MESH" and not o.hide_render]
    for o in others:
        o.hide_render = True
    cd = bpy.data.cameras.new("VR_Cam"); cd.lens = 50
    cam = bpy.data.objects.new("VR_Cam", cd); s.collection.objects.link(cam); s.camera = cam
    cam.location = ctr + Vector(direction).normalized() * rad * dist_mul
    cam.rotation_euler = (ctr - cam.location).to_track_quat("-Z", "Y").to_euler()
    path = os.path.join(REVIEW, f"{name}.png")
    s.render.filepath = path
    bpy.ops.render.render(write_still=True)
    bpy.data.objects.remove(cam, do_unlink=True)
    for o in others:
        o.hide_render = False
    return path


def composite_preview(crescent, crown, arch):
    """The three meshes arranged like the reference (f545 cage + f571 burst), flat-shaded on a dark ground, so the shapes
    can be judged against the frames. Copies only; the exported objects are not touched."""
    s = bpy.context.scene
    made = []

    def place(src, mat_world, colour):
        o = src.copy(); o.data = src.data.copy(); o.matrix_world = mat_world
        o.color = colour + (1,)
        s.collection.objects.link(o); made.append(o)
        return o
    # cage: two crescents facing the centre (concave side = local -Y), 3.2 studs out
    for side in (-1, 1):
        pos = Vector((side * 3.2, 0, 0))
        # local -Y must point at the centre: rotate about Z so -Y -> -side*X
        rot = Matrix.Rotation(math.radians(-90 * side), 4, "Z")
        place(crescent, Matrix.Translation(pos) @ rot, (0.85, 0.3, 1.0))
    # back crescent (indigo), arc plane facing the camera
    place(crescent, Matrix.Translation(Vector((-1.0, 4.0, 0))) @ Matrix.Rotation(math.radians(90), 4, "Z")
          @ Matrix.Scale(0.8, 4), (0.3, 0.2, 0.85))
    # burst group to the right: crown + arches
    off = Vector((12, 0, 0))
    place(crown, Matrix.Translation(off) @ Matrix.Scale(1.4, 4), (0.9, 0.7, 1.0))
    for k in range(4):
        place(arch, Matrix.Translation(off) @ Matrix.Rotation(math.radians(45 * k), 4, "Z") @ Matrix.Scale(1.7, 4),
              (1.0, 0.55, 1.0))
    ground = bpy.data.meshes.new("VR_Ground")
    bmg = bmesh.new()
    bmesh.ops.create_circle(bmg, cap_ends=True, segments=48, radius=3.0)
    bmg.to_mesh(ground); bmg.free()
    g = bpy.data.objects.new("VR_Ground", ground); g.location = off + Vector((0, 0, 0.01)); g.color = (0.85, 0.25, 0.9, 1)
    s.collection.objects.link(g); made.append(g)

    sc = bpy.context.scene
    sc.render.engine = "BLENDER_WORKBENCH"
    sc.render.resolution_x, sc.render.resolution_y = 1280, 560
    sh = sc.display.shading
    sh.light = "FLAT"; sh.color_type = "OBJECT"; sh.show_cavity = False; sh.show_object_outline = False
    if sc.world is None:
        sc.world = bpy.data.worlds.new("VR_World")
    sc.world.color = (0.02, 0.01, 0.04)
    for o in (crescent, crown, arch):
        o.hide_render = True
    cd = bpy.data.cameras.new("VR_Cam"); cd.lens = 35
    cam = bpy.data.objects.new("VR_Cam", cd); sc.collection.objects.link(cam); sc.camera = cam
    paths = []
    for name, loc, tgt in (("composite_flat", Vector((5, -30, 5.5)), Vector((5, 0, 4.5))),
                           ("composite_burst", off + Vector((0, -15, 4.0)), off + Vector((0, 0, 1.6)))):
        cam.location = loc
        cam.rotation_euler = (tgt - loc).to_track_quat("-Z", "Y").to_euler()
        sc.render.filepath = os.path.join(REVIEW, f"{name}.png")
        bpy.ops.render.render(write_still=True)
        paths.append(sc.render.filepath)
    sh.light = "STUDIO"; sh.show_cavity = True
    sc.render.filepath = os.path.join(REVIEW, "composite_studio.png")
    bpy.ops.render.render(write_still=True)
    paths.append(sc.render.filepath)
    bpy.data.objects.remove(cam, do_unlink=True)
    for o in made:
        bpy.data.objects.remove(o, do_unlink=True)
    for o in (crescent, crown, arch):
        o.hide_render = False
    return paths


# ------------------------------------------------------------------------------------------------ main

def main():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    lf.setup_scene()
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(REVIEW, exist_ok=True)
    crescent = make_crescent()
    thick = make_crescent("VR_CrescentThick", W=2.3, D=0.75)
    mid = make_crescent("VR_CrescentMid", W=1.5, D=0.6, low=0.85)  # review round 1: thinner, bright to the tip
    slim = make_crescent("VR_CrescentSlim", W=0.85, D=0.45, low=0.85)  # review round 2: ~0.09 of the height
    crown, blades = make_spike_crown()
    arch = make_arch()

    report = {}
    for ob, cls in ((crescent, "small"), (thick, "small"), (mid, "small"), (slim, "small"), (crown, "small"),
                    (arch, "small")):  # arch: 332 tris, over tiny's 300
        passed, fails, r = lf.gate(ob, cls)
        info = roblox_info(ob)
        report[ob.name] = {"class": cls, "passed": passed, "fails": fails, "tris": r["tris"],
                           "budget_note": r["budget_note"], "self_intersections": r.get("self_intersections"),
                           "cross_shell_overlaps": r.get("cross_shell_overlaps"), "flipped": r.get("flipped_faces"),
                           "boundary_edges": r["boundary_edges"], "non_manifold": r["non_manifold_edges"],
                           "materials": r["materials"], **info}
        print(f"[gate] {ob.name}: {'PASS' if passed else 'FAIL'} tris={r['tris']} {fails}")
        lf.export_glb(ob, os.path.join(OUT, f"{ob.name}.glb"))
    report["VR_SpikeCrown"]["blades"] = blades
    report["orientation"] = {
        "VR_Crescent": "Blender: arc in the YZ plane, up +Z, concave side faces -Y, convex back bulges to +Y, "
                       "pivot at the bottom tip, top tip straight above. Roblox: up +Y, concave side faces -Z "
                       "(LookVector), back bulges to +Z.",
        "VR_SpikeCrown": "Blender: up +Z, radially symmetric-ish ring around the Z axis, pivot at the base centre.",
        "VR_Arch": "Blender: half ring in the XZ plane, up +Z, ends at x=+-1 on z=0, pivot at the ring centre. "
                   "Roblox: arch spans the X axis, flat sides face +-Z.",
    }

    if RENDER:
        renders = {}
        for ob in (crescent, crown, arch):
            renders[ob.name] = lf.render_review(ob, REVIEW)
        renders["VR_Crescent"]["side"] = render_extra(crescent, "VR_Crescent_side_X", (1, 0, 0.05))
        renders["VR_Crescent"]["side_34"] = render_extra(crescent, "VR_Crescent_34", (1, -0.6, 0.25))
        renders["VR_SpikeCrown"]["low"] = render_extra(crown, "VR_SpikeCrown_low", (0.3, -1, 0.25), target=Vector((0, 0, 0.8)))
        renders["VR_Arch"]["side"] = render_extra(arch, "VR_Arch_34", (0.5, -1, 0.4))
        renders["composite"] = composite_preview(crescent, crown, arch)
        report["renders"] = renders
    with open(os.path.join(OUT, "report.json"), "w") as f:
        json.dump(report, f, indent=2)
    print("[done]", json.dumps({k: (v["tris"], v["passed"]) for k, v in report.items() if isinstance(v, dict) and "tris" in v}))


main()
