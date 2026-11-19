#!/usr/bin/env python3
"""Put a .luau file where Studio can run it with loadstring (Windows, macOS, Linux/Vinegar; no HTTP, no upload).

    python3 -I kit_push.py kit/studio/VFXKit.luau      -> prints ONE Luau line: run it with MCP execute_luau (Edit mode)
    python3 -I kit_push.py <effect>/effect.luau         -> the same for your effect file (after the kit line)

The file is written into Studio's local content folder as <content>/vfxlib/kit_<stem>_<time>.rbxmx (a StringValue
holding the source). Old pushes of the same file are removed; every push gets a new name because GetObjects caches
by URL. --content <dir> names the content folder if it is not found.
"""
import argparse
import glob
import os
import re
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import rbx_assets  # noqa: E402  (content_dir)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("file")
    ap.add_argument("--content", help="Studio content folder (default: found automatically)")
    a = ap.parse_args()
    src = open(a.file, encoding="utf-8").read()
    if "]]>" in src:
        sys.exit("the file contains ']]>': split that string (it ends the XML block)")
    stem = re.sub(r"[^A-Za-z0-9]", "_", os.path.splitext(os.path.basename(a.file))[0]).lower()
    d = os.path.join(a.content or rbx_assets.content_dir(), "vfxlib")
    os.makedirs(d, exist_ok=True)
    for old in glob.glob(os.path.join(d, "kit_%s_*.rbxmx" % stem)):
        os.remove(old)
    name = "kit_%s_%d" % (stem, int(time.time()))
    with open(os.path.join(d, name + ".rbxmx"), "w", encoding="utf-8") as f:
        f.write('<roblox version="4"><Item class="StringValue" referent="R0"><Properties><string name="Name">src</string>'
                '<string name="Value"><![CDATA[' + src + "]]></string></Properties></Item></roblox>")
    print('return loadstring(game:GetObjects("rbxasset://vfxlib/%s.rbxmx")[1].Value)()' % name)


if __name__ == "__main__":
    main()
