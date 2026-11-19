---
title: Projectile VFX - head, flight and surface impact
tags: [vfx, projectile, impact, scripting, client-server, technique]
type: technique
updated: 2026-11-18
source: https://www.youtube.com/watch?v=GtqFcyFgIXQ (veraktt part 1, 00:32-25:43); https://www.youtube.com/watch?v=V6ZQ4nNZCLA (veraktt part 2, 01:27-14:39); https://www.youtube.com/watch?v=MtAul-n9JmU (niitroxen, 34:22-39:48)
---
# Projectile VFX - head, flight and surface impact

> TL;DR
> - A projectile is three assets with separate lifetimes: the HEAD (visual, carries its trail), the FLIGHT (pure numbers stepped with dt), the IMPACT (separate prefab spawned at the end). The impact is never a child of the head.
> - The head is born on the hand at the animation's Spawn marker (Motor6D to the arm, C0 (0,-1,0) for R6) and released at the Throw marker from wherever the hand really is.
> - The head faces its velocity every step (`CFrame.new(pos, pos + vel.Unit)`), so an arcing shot noses over; setting only Position looks dead.
> - The impact is oriented by the hit normal and pushed 0.125 studs off the surface; build the prefab with its front face as the emit direction. One prefab then works on floors and walls.
> - Multiplayer: server sends beats (spawn, throw) to all clients; each client builds and flies its own copy; the server runs the same flight without visuals for hits.

## Flight (veraktt)
- Each RenderStepped/Heartbeat: `vel += gravity * dt`, `disp = vel * dt`, sweep a box `workspace:Blockcast(CFrame.new(pos), size, disp, params)`, move or end.
- Box, not ray: a fat fireball must hit a low wall that a centre ray would miss. Size taken from a hitbox part so it is tuned by eye.
- Exclude the caster and the FX folder from the cast.
- End on hit, on distance from origin > max (300 seen), or on lifetime (5 s seen); Cleanup disconnects the step.
- Numbers seen: speed 100 studs/s, gravity (0,-60,0), initial upward impulse 20 (a small hop before the arc reads as a lob).
- Point-blank: before the first step, overlap-test the hitbox at the origin; if inside geometry, play the impact at once (with surface-only layers off) and skip the flight.

## Impact placement
- `CFrame.new(hitPos, hitPos + (normal or Vector3.yAxis)) * CFrame.new(0, 0, -0.125)`; impact anchored, parented to the FX folder.
- Seen result: a flat orange fire starburst lying on a sloped wall and on a vertical face (00:15-00:17).
- Variants via attribute: layers tagged `Ground` are disabled when there is no real surface, then the remaining enabled emitters burst.
- Camera shake rides the projectile's end callback so it lands on the impact frame (Explosion preset).

## Simple tween version (niitroxen)
- No physics: tween the head's CFrame 10-15 studs forward in 0.5 s (Cubic = fast start), wait for Completed, burst. Good enough for short-range orbs that always detonate at a fixed distance.

## Server / client split (veraktt part 2)
- Server: plays the animation, listens to markers, `FireAllClients("FireballSpawn", {char})` then `"FireballThrow"`; runs the flight without instances; decides hits (clients can resize their own hitbox parts).
- Client: creates the head in the hand on Spawn, names it `Fireball_<char.Name>` and keeps it (and the weld) in an `activeFX` table; on Throw finds it by name, drops the weld, flies it. Missing head -> return quietly (cancelled cast).
- Optional range culling: fire only to clients near the caster.
- UNVERIFIED in the video: validation of the client-sent release data (he says to check origin distance and cooldown).

## For vfxmith
- Projectile specs need three parts with their own timelines: `head` (loop while flying, faces velocity), `trail` (attached to head, stops emitting on impact and lingers), `impact` (one-shot, oriented by a normal, with surface variants).
- Preview should fly the head along a real arc and hit both a floor and a wall, since orientation bugs only show on walls.
- Related: [[Scripted playback - clone, place, emit, clean]], [[Syncing effects to a character animation]], [[Direction through blur and stretch]], [[Impact burst - flash that breaks into streaks]].
