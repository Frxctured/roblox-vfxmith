#!/usr/bin/env python3
"""Neutralise scripts inside a BINARY .rbxm/.rbxl without touching anything else (lossless: every other chunk is copied
byte for byte; only the PROP chunks holding script Source are rewritten, uncompressed).

    python3 -I rbxpatch.py <in> <out> --ref 54832 --ref 917 [--note "backdoor removed"]
    python3 -I rbxpatch.py <in> <out> --replace "https://discord.com/api/webhooks/" "<webhook removed>"

--ref R       : the script with referent R gets Source = "-- [removed: <note>]" (the instance stays, so paths and
                counts do not change) and, when the class has it, Disabled = true / Enabled = false.
--replace A B : in EVERY script Source, replace the substring A..(end of that quoted string) with B (for secrets such as
                webhook tokens).
Referents come from rbxdump.py / vfx_catalog.py (the number after the last "__" in extracted script names).
"""
import argparse
import re
import struct
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import rbxdump as rd  # noqa: E402

SCRIPT_CLASSES = {"Script", "LocalScript", "ModuleScript"}


def read_chunks(data):
    if data[:8] != b"<roblox!":
        raise SystemExit("not a binary Roblox file")
    head = data[:32]
    i = 32
    chunks = []
    while i < len(data):
        name = data[i:i + 4]
        clen, ulen = struct.unpack_from("<II", data, i + 4)
        raw = data[i + 16:i + 16 + (clen or ulen)]
        chunks.append([name, clen, ulen, raw])
        i += 16 + (clen or ulen)
        if name == b"END\0":
            break
    return head, chunks, data[i:]


def body(ch):
    name, clen, ulen, raw = ch
    if not clen:
        return raw
    if raw[:4] == b"\x28\xb5\x2f\xfd":
        import zstandard
        return zstandard.ZstdDecompressor().decompress(raw, max_output_size=ulen)
    return rd.lz4_block(raw, ulen)


def chunk_bytes(name, b):
    return name + struct.pack("<III", 0, len(b), 0) + b


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("src")
    ap.add_argument("out")
    ap.add_argument("--ref", action="append", type=int, default=[])
    ap.add_argument("--note", default="removed by pack cleanup")
    ap.add_argument("--replace", nargs=2, action="append", default=[])
    a = ap.parse_args()
    data = open(a.src, "rb").read()
    head, chunks, tail = read_chunks(data)
    classes = {}
    for ch in chunks:
        if ch[0] == b"INST":
            r = rd.R(body(ch))
            cid = r.u32(); cname = rd._s(r.string()); r.u8(); cnt = r.u32()
            classes[cid] = (cname, rd._refs(r, cnt))
    targets = set(a.ref)
    changed = 0
    out = [head]
    for ch in chunks:
        if ch[0] != b"PROP":
            out.append(ch[0] + struct.pack("<III", ch[1], ch[2], 0) + ch[3])
            continue
        b = body(ch)
        r = rd.R(b)
        cid = r.u32(); pname = rd._s(r.string()); typ = r.u8()
        cname, refs = classes.get(cid, ("?", []))
        if cname not in SCRIPT_CLASSES or (pname not in ("Source", "Disabled", "Enabled") ):
            out.append(ch[0] + struct.pack("<III", ch[1], ch[2], 0) + ch[3])
            continue
        hdr = b[:r.i]
        if pname == "Source" and typ == 0x01:
            vals = [r.string() for _ in refs]
            new = []
            for ref, v in zip(refs, vals):
                if ref in targets:
                    v = ("-- [%s]\n" % a.note).encode()
                    changed += 1
                for pat, rep in a.replace:
                    rx = re.compile(re.escape(pat.encode()) + rb"[^\"'\s]*")
                    v2 = rx.sub(rep.encode(), v)
                    if v2 != v:
                        changed += 1
                        v = v2
                new.append(v)
            nb = hdr + b"".join(struct.pack("<I", len(v)) + v for v in new)
            out.append(chunk_bytes(b"PROP", nb))
        elif pname in ("Disabled", "Enabled") and typ == 0x02 and targets & set(refs):
            vals = list(r.take(len(refs)))
            for k, ref in enumerate(refs):
                if ref in targets:
                    vals[k] = 1 if pname == "Disabled" else 0
            out.append(chunk_bytes(b"PROP", hdr + bytes(vals)))
        else:
            out.append(ch[0] + struct.pack("<III", ch[1], ch[2], 0) + ch[3])
    open(a.out, "wb").write(b"".join(out) + tail)
    # verify: re-read and confirm the targets are neutralised
    insts, _ = rd.load(a.out)
    idx = rd.index(insts)
    for ref in targets:
        o = idx.get(ref)
        src = o and o["props"].get("Source")
        ok = isinstance(src, str) and src.startswith("-- [")
        print(("ok   " if ok else "FAIL ") + str(ref), rd.path_of(o, idx) if o else "missing")
    print("changes:", changed, "->", a.out)


if __name__ == "__main__":
    main()
