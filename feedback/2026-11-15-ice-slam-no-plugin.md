---
effect: ice slam
request: "Make me an ice slam effect." (heavy melee skill, fist lands at 0.25 s, frost lingers to ~2.5 s, crisp anime ice)
made_with: no plugin (Claude Opus 5.5 with Studio screenshots, blind test 5); compared with vfxmith 0.1.6
rating: 8
cost_usd: 9.78
rater: owner
house_example: library/house/ice-slam-no-plugin
---

# Ice slam (no plugin): owner's feedback

Answers in the owner's words (lightly trimmed):

1. **Rating:** 8 out of 10.
2. **Best moment:** "when the ice crystals exploded, when the thing disappeared."
3. **What looked cool:** "how it made the crystals disappear, the effects that popped out, everything like that."
4. **Cheap or wrong:** "I don't think anything looked cheap about it. It looked pretty well made."
5. **Ice spikes:** "very good."
6. **Colour and glow:** "The color was also really nice. The glow was basically perfect. The 0.1.6 version had too much
   glow." Later: "Saturated color can be bad. In this case, it wasn't. Although the ice animation, I think being a
   little less saturated would make it even better."
7. **Timing:** "really nice" (both had the same timing from the same brief).
8. **In a game:** "in some fighting game, I would use it as is."
9. **Against 0.1.6:** "really on par with each other." No plugin was better on two things: "the glow being a little bit
   less, and the ice residue, like the snow on the floor ... the plugin got rid of it faster. I liked how it stayed a
   bit there."
10. **Always / never:** "Future effects should not use as much glow."
11. **Added later, from a side-by-side still:** 0.1.6 "has tons of glow. Which I don't like, but what I do like is the
    VFX flipbook thingy I used for the circular aura thingy that expands. On the left is a simple fading out circle. On
    the right, it's this textured, like, ring with like animated frames and stuff, which I really preferred." (0.1.6's
    ring: the VFX Studio flipbook `circleFlipbook2`, 4x4, id 126034245450101, played OneShot while it grows.)

Measured on the same recording (24 fps, same camera): at the hit 0.1.6 changed 52% of the screen (its light floods the
floor) against 21%, with 8.3% pure white against 4.1%; at 0.5 s 49% against 9%. The no-plugin frost was still 3-4% of
the frame at 2.0-2.24 s; 0.1.6's was gone by 2.24 s.

## Lessons (general, for any effect)
- Less glow: light pools, halos and long white blooms read as "too much glow"; shapes should carry the look.
- Residue stays: what an effect leaves on the ground holds through the asked linger, then fades at the end.
- The break / disappearance is a highlight: objects that come apart with small pieces and pops are the moment people
  remember.
- Saturation should suit the effect; more is not automatically better (this ice could be a little less saturated).
- Rings and shockwaves: an animated, textured flipbook ring beats a plain fading disc (0.1.6 did this better).
