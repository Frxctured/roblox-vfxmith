---
name: vfx-make
description: Build a Roblox VFX effect from a description ("frost nova", "holy smite", "purple aura on the player") in Roblox Studio, with a thin optional kit - one effect clock with an exact freeze and a posable R15 dummy, textures drawn in code, a short texture list and pro effects as read-only references. Use for "make a VFX", "improve this effect", any new effect.
---

# Make a Roblox effect

`ROOT` = `<base directory>/../..` (`${CLAUDE_PLUGIN_ROOT}`); quote it. Read `ROOT/START.md` (one page) and use
whatever in it helps. The design is yours: build the whole scene in code if it tells the moment better (characters,
props, ground, shapes and textures you draw), drive it from one effect clock, judge the frames by eye and keep
reworking until it looks great.

If the user is around, ask what you need in one message, show them frames along the way and ask what they think
(`vfx-feedback`). If they said "just do it", decide everything yourself.
