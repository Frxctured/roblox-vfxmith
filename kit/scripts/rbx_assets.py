#!/usr/bin/env python3
"""Upload VFX assets through Open Cloud and grant them to games. Project-independent.

    python3 rbx_assets.py upload <file|dir> ... --ids ids.json [--group <groupId>] [--prefix VFX_] [--force]
        PNG -> Image asset, GLB -> Model asset (MeshParts; load in Studio with InsertService:LoadAsset).
        ids.json maps file stem -> asset id; stems already in it are skipped unless --force.
    python3 rbx_assets.py push <file.luau> ... [--universe <universeId>]
        Packs .luau files as ModuleScripts (named by file stem) in a Folder "VFXPush", uploads it as a private Model and
        prints the asset id: the way to get dev modules into a Studio place without Rojo or pasting them. Install in
        Studio (execute_luau, Edit) with the snippet in SKILL.md ("Install the dev kit").
    python3 rbx_assets.py grant --universe <universeId> (--ids 1,2,3 | --from ids.json)
        Gives a game "Use" permission on restricted assets it does not own (needed when the uploader has Asset
        Privacy on and the game belongs to someone else, e.g. a group game). Grants are permanent.

Credentials: RBX_API_KEY (scopes: asset read/write, asset-permissions write) and RBX_USER_ID, from the environment or
~/.config/roblox/env (KEY=value lines). The key is never printed. Uploads go to the user unless --group is given.
"""
import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request
import uuid

API = "https://apis.roblox.com/assets/v1"
GRANT_URL = "https://apis.roblox.com/asset-permissions-api/v1/assets/permissions"


def env():
    vals = {}
    path = os.path.expanduser("~/.config/roblox/env")
    if os.path.exists(path):
        for line in open(path):
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                vals[k.strip()] = v.strip().strip('"').strip("'")
    for k in ("RBX_API_KEY", "RBX_USER_ID"):
        if os.environ.get(k):
            vals[k] = os.environ[k]
    if "RBX_API_KEY" not in vals:
        sys.exit("RBX_API_KEY not set (environment or ~/.config/roblox/env)")
    return vals


def request(req, retries=4):
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(req, timeout=90) as r:
                return json.load(r)
        except urllib.error.HTTPError as e:
            body = e.read().decode(errors="replace")[:300]
            if e.code in (429, 500, 502, 503, 504) and attempt < retries - 1:
                time.sleep(2 ** attempt * 2)
                continue
            raise RuntimeError(f"HTTP {e.code}: {body}") from None
        except urllib.error.URLError:
            if attempt < retries - 1:
                time.sleep(2 ** attempt * 2)
                continue
            raise


def upload(key, creator, path, name, description):
    ext = os.path.splitext(path)[1].lower()
    kind, ctype = {".png": ("Image", "image/png"), ".glb": ("Model", "model/gltf-binary")}.get(ext, (None, None))
    if not kind:
        raise ValueError(f"unsupported file type: {path}")
    meta = {"assetType": kind, "displayName": name[:50], "description": description,
            "creationContext": {"creator": creator}}
    boundary = uuid.uuid4().hex
    head = (f'--{boundary}\r\nContent-Disposition: form-data; name="request"\r\nContent-Type: application/json\r\n\r\n'
            f"{json.dumps(meta)}\r\n--{boundary}\r\nContent-Disposition: form-data; name=\"fileContent\"; "
            f'filename="{os.path.basename(path)}"\r\nContent-Type: {ctype}\r\n\r\n').encode()
    body = head + open(path, "rb").read() + f"\r\n--{boundary}--\r\n".encode()
    req = urllib.request.Request(f"{API}/assets", data=body, method="POST",
                                 headers={"x-api-key": key, "Content-Type": f"multipart/form-data; boundary={boundary}"})
    op = request(req)["path"]
    for _ in range(90):
        time.sleep(2)
        res = request(urllib.request.Request(f"{API}/{op}", headers={"x-api-key": key}))
        if res.get("done"):
            if "error" in res:
                raise RuntimeError(json.dumps(res["error"])[:300])
            return str(res["response"]["assetId"])
    raise RuntimeError("upload timed out")


def cmd_upload(a):
    e = env()
    creator = {"groupId": str(a.group)} if a.group else {"userId": str(e.get("RBX_USER_ID") or sys.exit("RBX_USER_ID not set"))}
    files = []
    for p in a.paths:
        if os.path.isdir(p):
            files += sorted(os.path.join(p, f) for f in os.listdir(p) if f.lower().endswith((".png", ".glb")))
        else:
            files.append(p)
    ids = json.load(open(a.ids)) if os.path.exists(a.ids) else {}
    for f in files:
        stem = os.path.splitext(os.path.basename(f))[0]
        if stem in ids and not a.force:
            print(f"skip {stem} ({ids[stem]})")
            continue
        ids[stem] = upload(e["RBX_API_KEY"], creator, f, a.prefix + stem, a.description)
        print(f"ok   {stem} -> {ids[stem]}")
        json.dump(ids, open(a.ids, "w"), indent=2)
    print("done")


def rbxmx(files):
    items = []
    for i, path in enumerate(files, 1):
        src = open(path, encoding="utf-8").read().replace("]]>", "]]]]><![CDATA[>")
        name = os.path.splitext(os.path.basename(path))[0]
        items.append(f'<Item class="ModuleScript" referent="RBX{i}"><Properties><string name="Name">{name}</string>'
                     f'<ProtectedString name="Source"><![CDATA[{src}]]></ProtectedString></Properties></Item>')
    return ('<roblox version="4"><Item class="Folder" referent="RBX0"><Properties><string name="Name">VFXPush</string>'
            '</Properties>' + "".join(items) + "</Item></roblox>").encode("utf-8")


def content_dir():
    """Studio's local content folder (rbxasset://...). Vinegar (Linux) first, then Windows/macOS installs."""
    import glob
    pats = [os.path.expanduser("~/.var/app/org.vinegarhq.Vinegar/data/vinegar/versions/*/content"),
            os.path.expanduser("~/.local/share/vinegar/versions/*/content"),
            os.path.expandvars(r"%LOCALAPPDATA%/Roblox/Versions/*/content"),
            "/Applications/RobloxStudio.app/Contents/Resources/content"]
    found = [d for p in pats for d in glob.glob(p) if os.path.isdir(d)]
    if not found:
        sys.exit("Studio content folder not found")
    return max(found, key=os.path.getmtime)


def cmd_local(a):
    """No upload: write the modules as <content>/vfxlib/<name>.rbxmx; Studio loads it with
    game:GetObjects("rbxasset://vfxlib/<name>.rbxmx")[1] (a Folder "VFXPush" holding the ModuleScripts)."""
    d = os.path.join(content_dir(), "vfxlib")
    os.makedirs(d, exist_ok=True)
    out = os.path.join(d, a.name + ".rbxmx")
    open(out, "wb").write(rbxmx(a.files))
    print("rbxasset://vfxlib/%s.rbxmx" % a.name)


def cmd_push(a):
    e = env()
    meta = {"assetType": "Model", "displayName": "VFXPush_" + str(int(time.time())), "description": "dev modules",
            "creationContext": {"creator": {"userId": str(e.get("RBX_USER_ID") or sys.exit("RBX_USER_ID not set"))}}}
    boundary = uuid.uuid4().hex
    body = (f'--{boundary}\r\nContent-Disposition: form-data; name="request"\r\nContent-Type: application/json\r\n\r\n'
            f"{json.dumps(meta)}\r\n--{boundary}\r\nContent-Disposition: form-data; name=\"fileContent\"; "
            f'filename="modules.rbxmx"\r\nContent-Type: model/x-rbxm\r\n\r\n').encode() + rbxmx(a.files) \
        + f"\r\n--{boundary}--\r\n".encode()
    req = urllib.request.Request(f"{API}/assets", data=body, method="POST",
                                 headers={"x-api-key": e["RBX_API_KEY"], "Content-Type": f"multipart/form-data; boundary={boundary}"})
    op = request(req)["path"]
    for _ in range(60):
        time.sleep(2)
        res = request(urllib.request.Request(f"{API}/{op}", headers={"x-api-key": e["RBX_API_KEY"]}))
        if res.get("done"):
            if "error" in res:
                raise RuntimeError(json.dumps(res["error"])[:300])
            aid = res["response"]["assetId"]
            print("asset id:", aid)
            if a.universe:  # a group game cannot LoadAsset a user's model until it is granted
                cmd_grant(argparse.Namespace(universe=a.universe, ids=str(aid), from_file=None))
            return
    raise RuntimeError("push timed out")


def cmd_grant(a):
    key = env()["RBX_API_KEY"]
    if a.from_file:
        ids = [int(v) for v in json.load(open(a.from_file)).values()]
    else:
        ids = [int(x) for x in a.ids.split(",") if x.strip().isdigit()]
    granted, errors = 0, {}
    for i in range(0, len(ids), 50):
        chunk = ids[i:i + 50]
        body = json.dumps({"subjectType": "Universe", "subjectId": str(a.universe), "action": "Use",
                           "requests": [{"assetId": x, "grantToDependencies": True} for x in chunk]}).encode()
        res = request(urllib.request.Request(GRANT_URL, data=body, method="PATCH",
                                             headers={"x-api-key": key, "Content-Type": "application/json"}))
        granted += len(res.get("successAssetIds") or [])
        for err in res.get("errors") or []:
            errors[err.get("code")] = errors.get(err.get("code"), 0) + 1
        time.sleep(0.8)
    print(f"{len(ids)} ids -> universe {a.universe}: granted {granted}; refused {errors}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    u = sub.add_parser("upload")
    u.add_argument("paths", nargs="+")
    u.add_argument("--ids", required=True)
    u.add_argument("--group")
    u.add_argument("--prefix", default="VFX_")
    u.add_argument("--description", default="VFX asset")
    u.add_argument("--force", action="store_true")
    p = sub.add_parser("push")
    p.add_argument("files", nargs="+")
    p.add_argument("--universe", help="also grant the pushed model to this universe")
    lo = sub.add_parser("local", help="no upload: write modules into Studio's content folder")
    lo.add_argument("files", nargs="+")
    lo.add_argument("--name", default="devkit")
    g = sub.add_parser("grant")
    g.add_argument("--universe", required=True)
    g.add_argument("--ids")
    g.add_argument("--from", dest="from_file")
    a = ap.parse_args()
    if a.cmd == "grant" and not (a.ids or a.from_file):
        ap.error("grant needs --ids or --from")
    {"upload": cmd_upload, "grant": cmd_grant, "push": cmd_push, "local": cmd_local}[a.cmd](a)


if __name__ == "__main__":
    main()
