#!/usr/bin/env python3
"""Get the cleaned open-source pack (the files the library cards come from) and tell the other tools where it is.

    python3 kit/scripts/get_pack.py                  download the release zip (~410 MB), check it, unpack it (~490 MB)
    python3 kit/scripts/get_pack.py --where          print the pack folder; exit 1 and say how to get it if missing
    python3 kit/scripts/get_pack.py --link <folder>  use a copy you already have (the folder holding "190 OS (...)" etc.)
    python3 kit/scripts/get_pack.py --zip <file>     unpack a zip you downloaded yourself (checked the same way)
      --dir <folder>                                 where to unpack (default ~/.vfxmith/pack)

The pack is optional. The cards, frames, studies and recipes work without it. With it, `rbxcut.py --id <card id>
--studio` cuts any library effect (scripts removed) into Studio, to watch it next to yours, and the files hold the
exact curves the cards shorten. Lookup order: $VFXMITH_PACK, then ~/.vfxmith/config.json ("pack"), then the default
folder. This script never opens a pack file: it downloads, checks the SHA-256 and unpacks. Python standard library only.
"""
import argparse
import hashlib
import json
import os
import shutil
import sys
import urllib.request
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
META = json.load(open(os.path.join(HERE, "..", "pack.json")))
HOME = os.path.join(os.path.expanduser("~"), ".vfxmith")
CONFIG = os.path.join(HOME, "config.json")
DEFAULT_DIR = os.path.join(HOME, "pack")


def looks_like_pack(d):
    return bool(d) and all(os.path.isdir(os.path.join(d, f)) for f in META["folders"])


def _config():
    try:
        return json.load(open(CONFIG))
    except (OSError, ValueError):
        return {}


def find_pack():
    """The pack folder (the one holding the period folders), or None."""
    for c in (os.environ.get("VFXMITH_PACK"), _config().get("pack"), DEFAULT_DIR):
        if not c:
            continue
        c = os.path.abspath(os.path.expanduser(c))
        for d in (c, os.path.join(c, META["root"])):
            if looks_like_pack(d):
                return d
    return None


def missing_text():
    return ("The pack is not installed (it is optional: cards, frames and recipes work without it).\n"
            "Get it: python3 kit/scripts/get_pack.py   (~%d MB download; ask the user first)\n"
            "Or use a copy they already have: python3 kit/scripts/get_pack.py --link <folder>" % (META["bytes"] // 10**6))


def _save(pack):
    os.makedirs(HOME, exist_ok=True)
    cfg = _config()
    cfg["pack"] = pack
    with open(CONFIG, "w") as fh:
        json.dump(cfg, fh, indent=2)


def _sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _download(dest):
    part = dest + ".part"
    req = urllib.request.Request(META["url"], headers={"User-Agent": "vfxmith-get-pack"})
    print("downloading", META["url"])
    done, step = 0, META["bytes"] // 10
    nxt = step
    with urllib.request.urlopen(req, timeout=60) as r, open(part, "wb") as out:
        for chunk in iter(lambda: r.read(1 << 20), b""):
            out.write(chunk)
            done += len(chunk)
            if done >= nxt:
                print("  %3d%%  %d MB" % (min(100, done * 100 // META["bytes"]), done // 10**6), flush=True)
                nxt += step
    os.replace(part, dest)


def _unpack(zpath, target):
    print("checking SHA-256 ...")
    got = _sha256(zpath)
    if got != META["sha256"]:
        sys.exit("checksum mismatch: %s (expected %s). The download is broken or not the release file; delete it "
                 "and try again." % (got, META["sha256"]))
    os.makedirs(target, exist_ok=True)
    base = os.path.realpath(target)
    with zipfile.ZipFile(zpath) as z:
        for info in z.infolist():
            name = info.filename
            dest = os.path.realpath(os.path.join(base, name))
            if name.startswith(("/", "\\")) or ":" in name or not dest.startswith(base + os.sep):
                sys.exit("refusing unsafe path in the zip: %r" % name)
        print("unpacking into", target)
        z.extractall(base)
    pack = os.path.join(base, META["root"])
    if not looks_like_pack(pack):
        sys.exit("unpacked, but %s does not look like the pack" % pack)
    return pack


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--where", action="store_true")
    ap.add_argument("--link")
    ap.add_argument("--zip")
    ap.add_argument("--dir", default=DEFAULT_DIR)
    ap.add_argument("--keep-zip", action="store_true", help="keep the downloaded zip after unpacking")
    ap.add_argument("--force", action="store_true", help="download again even if a pack is already installed")
    a = ap.parse_args()

    if a.where:
        p = find_pack()
        if not p:
            print(missing_text())
            sys.exit(1)
        print(p)
        return
    if a.link:
        d = os.path.abspath(os.path.expanduser(a.link))
        for c in (d, os.path.join(d, META["root"])):
            if looks_like_pack(c):
                _save(c)
                print("linked:", c)
                return
        sys.exit("%s does not look like the pack (expected folders: %s)" % (d, ", ".join(META["folders"])))

    have = find_pack()
    if have and not a.force and not a.zip:
        print("already installed:", have, "(--force downloads it again)")
        return
    target = os.path.abspath(os.path.expanduser(a.dir))
    if a.zip:
        pack = _unpack(os.path.abspath(a.zip), target)
    else:
        os.makedirs(target, exist_ok=True)
        if shutil.disk_usage(target).free < META["bytes"] * 2.4:
            sys.exit("not enough free space in %s (needs about %d MB)" % (target, META["bytes"] * 2.4 // 10**6))
        zpath = os.path.join(target, os.path.basename(META["url"]))
        _download(zpath)
        pack = _unpack(zpath, target)
        if not a.keep_zip:
            os.remove(zpath)
    _save(pack)
    print("installed:", pack)


if __name__ == "__main__":
    main()
