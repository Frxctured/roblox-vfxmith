---
title: Syncing effects to a character animation
tags: [vfx, timing, animation, attachments, technique]
type: technique
updated: 2026-11-18
source: https://www.youtube.com/watch?v=RKX4zPPAsAA (Hazaze, 00:27-05:58); https://www.youtube.com/watch?v=Rexby2jBmRY (ghxstying, 01:48-02:37, 09:59-17:59)
---
# Syncing effects to a character animation

> TL;DR
> - Pros split a move into beats and give each beat its own Attachment, named after the beat (BeforeFirstSlash, Slash1, Dash1, Ground, Impact, SmallHit1-7, Spin1-6).
> - All beat attachments live in a copy of the HumanoidRootPart (the "vfx root"), so the whole set is placed in body space and is cloned and welded onto the player in game.
> - Each beat fires on a marker in the animation (KeyframeMarker -> GetMarkerReachedSignal) on the frame the limb reaches the contact pose; anticipation groups fire a few frames before.
> - Bursts use Emit with a per-emitter count stored as an EmitCount attribute; lingering layers use Enabled on/off windows. Counts are small: 1-2 for the big sprites, 7-15 for shards and sparks.
> - Cues in a fast combo come every 4-11 frames at 60 fps (70-180 ms); one remote per move, the client plays the rest.

## Rig layout (Hazaze)
- Duplicate the character's HumanoidRootPart, keep it as an invisible part, put one Attachment per beat inside it (02:49-03:09). Attachments are made Visible while editing and hidden after (03:14).
- Placement is in body space: Slash1 sits at (-1.9, 0.3, -3.3) from the root, rotated (-19, -58, 172) so its sprites lie on the diagonal plane of the arm swing (02:10). Ground beats sit at the feet, grab/lock-in beats at the hands, impact beats on the victim.
- Effects on the victim go in a second root (FrigidRushVFXVictim) welded to the victim.
- One beat holds several emitters of different kinds: Slash1 = Alpha, Dots, 2 x ParticleEmitter, Swirl, Swirl2, Wind, Wind2, Wind3, bigslash (10 layers).
- Things that must ride a moving prop (a thrown kunai) are cloned into the prop at fire time and destroyed after 1 s.

## Firing (both videos)
- Marker named after the attachment; handler: for each ParticleEmitter under root[marker] do Emit(GetAttribute("EmitCount")).
- ghxstying names groups by mode: "chargeup" (Enabled: glowenable, inwards), "chargeup emit" (circleemit, flareemit, shards), "slash" (blackslash, darkerslash, redslash, shadowslash). Split a beat into an Enabled attachment and an Emit attachment rather than mixing them.
- Enabled windows: charge on ~10 frames in, aura added midway, charge switched off just before the release flare; embers enabled at the slash frame (Rate raised to 85).
- Emit counts read from the slash: shadow 1, darker 2, black 1, glow 1, ground glow 1, ground dark 1, shards 10, shards2 10, fire 7, sparks 15.
- Keep everything that fires on one frame together (same marker) so a beat is re-timed as a unit.

## Timing seen
- MoltenSlashes: markers near frames 8, 14, 25, 29, 36, 40, 45, 50 at 60 fps.
- FrigidRush: single cues every 5-15 frames, flurries of 6-8 cues within ~20 frames.
- Both artists re-time by eye: scrub to the contact frame, nudge the burst 1-3 frames earlier if it looks late. Effects that appear late read worse than slightly early ones (ghxstying 13:03, moved earlier).

## Runtime (ours)
- Play on the client; server sends one event with the characters, the move id and extra params when the hit lands (Hazaze 04:59-05:58).
- A move = data: { marker -> attachment group }, counts in attributes. A single generic player handles every move.
- Related: [[Anticipation, climax and dissipation]], [[Impact frames and colour-correction flashes]], [[Size effects against the character]].
