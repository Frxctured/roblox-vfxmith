---
name: vfx-feedback
description: Ask the person who wanted a Roblox VFX effect what they liked and disliked about it, save their answers in their own words, and turn them into general rules the plugin learns from (archive/knowledge/archive/taste.md) and house examples (library/house). Use at the end of vfx-make when the user is present, or when the user says "rate this effect", "feedback", "here's what I think of it", "I liked / didn't like ...".
---

# Learn from the person's opinion

`ROOT` = `<base directory>/../..`. People see things AI reviewers miss (too much glow, a cheap stretched sprite, a
mark that vanishes too early). Their answers are the scale the plugin learns from, so every rated effect improves the
next one. Keep their words; never argue with their taste.

## 1. Show, then ask (one message)
Show the final effect first: a real-time recording if possible (`kit/scripts/record.sh`), otherwise the final contact
sheet. Then ask all questions in ONE message; short answers are fine and any can be skipped:
1. **Rating** from 1 to 10, and one sentence on why.
2. **Best moment:** the part you liked most.
3. **What looked professional or cool,** specifically (a shape, a colour, the timing, a detail)?
4. **What looked cheap, basic or wrong?**
5. **The main shape** (name it: the spikes, the beam, the slash...): right? What would make it better?
6. **Colour and glow:** too much, too little, or just right?
7. **Timing:** too fast, too slow, or just right? Did the big moment feel strong?
8. **In your game:** would you use it as it is? If not, what's the one change?
9. **Compared with** another version or effect they saw (if any): which is better, and why?
10. **Every future effect should always do ___ and never do ___.**

## 2. Save the answers
Write `ROOT/feedback/YYYY-MM-DD-<effect-slug>.md` (format: `feedback/README.md`): frontmatter (effect, request,
made_with, rating, cost_usd, rater), the answers in their words, any measurements you have (screen share of white or
glow, how long marks stay), then **Lessons (general, for any effect)**: 2-5 lines, each phrased for every effect type
(the effect is only the evidence).

## 3. Update the taste file
Merge the lessons into `ROOT/archive/knowledge/archive/taste.md`:
- Strengthen an existing rule (add the new evidence in its brackets) or add a new one under the right heading.
- Phrase it generally and give numbers where you have them (durations, LightEmission, screen shares).
- If it contradicts an existing rule, keep both pieces of evidence and write the rule that fits both (for example
  "saturation should suit the material" instead of "more saturation is better").
- Keep the file to about two pages: merge, don't append forever.

## 4. House examples (rating 8 or higher)
Ask whether the effect may become a house example. If yes, add `ROOT/library/house/<effect-slug>/`: `effect.luau`
(the self-contained effect file), `frames.jpg` (the final contact sheet), `note.md` (rating and the person's words,
what makes it work beat by beat with values and line numbers, caveats such as APIs that need a game setting), and a
line in `ROOT/library/house/INDEX.md`. Strip private paths and names first.

## 5. Act on it
- If they want changes to this effect, make them (vfx-make step 7) and show it again.
- Say in one line what you saved and which rules changed.
- The feedback, taste file and house examples are part of the plugin: they reach everyone when the maintainer commits
  them (or the user opens a pull request). Ask before committing or pushing anything.
