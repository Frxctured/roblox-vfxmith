---
effect: healing aura
request: "Make me a healing aura effect. A couple of players asked for auras." A buff on one player, tight around the character, start burst, calm pulses every ~2 s, soft end fade, green, soft and magical with restrained glow.
made_with: vfxmith 0.1.7-beta1 (one AI panel, then the owner's feedback)
rating: 7
cost_usd: 5.19
rater: owner
---

# Healing aura: owner's feedback

1. **Rating:** "7/10. There's room to improve but it's usable and looks good."
2. **Best moment:** "The pulses were nice."
3. **Professional or cool:** "The 3 rings ... at the start. They were pretty nice going up like that."
4. **Cheap or wrong:** "The + particles looked too pixely, for a healing effect like this I'd expect them to be soft."
5. **Main shapes:** "I can tell each segment apart. There's a sort of cut thing ... Not fully smooth." (the spiral
   ribbons)
6. **Colour and glow:** "Seems just right."
7. **Timing:** "pretty nice."
8. **In a game:** "I would use this in a game ... definitely in a game where healing spells could be used."

## Lessons (general, for any effect)
- Soft effects need soft particles: no pixelated or hard-edged sprites (check a texture's effective resolution against
  its size on screen; pick soft, high-resolution art).
- Curves must look continuous: a ribbon, spiral or trail built from visible straight segments reads as cheap. Use
  enough Beam segments (or curved Beams / Trails), overlap the joins, and check the joins up close.
- Rings that sweep up the body at the start and ground pulses during a hold work well for auras.
