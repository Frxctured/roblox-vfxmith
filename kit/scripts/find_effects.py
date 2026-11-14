#!/usr/bin/env python3
"""Find real effects in the library for a description ("light beam with an explosion", "dark purple slash",
"ice ground crack"). Prints the best matches with their card (layer values), frames (if captured) and source file.

    python3 -I kit/scripts/find_effects.py "light beam with an explosion" [-k 8] [--category beam] [--frames-only]

Searches library/index.jsonl (category, tags, file and instance names, layer names). Words are expanded with VFX
synonyms; effects with captured frames and more layers rank a little higher. Multi-part requests ("beam with an
explosion") are matched per part, so each part gets its own best references (printed as separate groups).
"""
import argparse
import json
import os
import re

SYN = {
    'beam': ['beam', 'laser', 'ray', 'cannon', 'kamehameha', 'blast', 'lance', 'pillar'],
    'light': ['light', 'holy', 'sacred', 'divine', 'angel', 'radiant', 'glow', 'sun', 'gold', 'white', 'heal'],
    'explosion': ['explosion', 'explode', 'boom', 'blast', 'nuke', 'kaboom', 'bomb', 'burst', 'atomic', 'detonat'],
    'slash': ['slash', 'cut', 'crescent', 'sword', 'blade', 'katana', 'swipe', 'claw', 'scythe', 'slice'],
    'impact': ['impact', 'hit', 'punch', 'kick', 'slam', 'smash', 'crater', 'ground', 'shock', 'stomp'],
    'aura': ['aura', 'charge', 'power', 'transform', 'haki', 'ssj', 'wings'],
    'projectile': ['projectile', 'fireball', 'orb', 'ball', 'shot', 'bullet', 'arrow', 'missile', 'meteor'],
    'lightning': ['lightning', 'electric', 'thunder', 'bolt', 'spark', 'zap', 'chidori', 'storm'],
    'fire': ['fire', 'flame', 'burn', 'blaze', 'pyro', 'ember', 'lava', 'molten', 'inferno'],
    'ice': ['ice', 'icy', 'frost', 'freeze', 'frozen', 'snow', 'glacier', 'crystal'],
    'water': ['water', 'aqua', 'splash', 'ocean', 'wave', 'bubble', 'wet'],
    'dark': ['dark', 'void', 'black', 'abyss', 'shadow', 'curse', 'demon', 'nebula'],
    'portal': ['portal', 'vortex', 'tornado', 'swirl', 'domain', 'galaxy', 'space', 'cosmic'],
    'smoke': ['smoke', 'dust', 'fog', 'cloud', 'mist'],
    'ring': ['ring', 'shockwave', 'wave', 'ripple'],
    'purple': ['purple', 'violet', 'magenta', 'pink'], 'blue': ['blue', 'cyan', 'azure'],
    'red': ['red', 'crimson', 'blood'], 'green': ['green', 'emerald', 'toxic'], 'gold': ['gold', 'yellow', 'orange'],
}
CAT_OF = {'beam': 'beam', 'explosion': 'explosion', 'slash': 'slash', 'impact': 'impact', 'aura': 'aura',
          'projectile': 'projectile', 'lightning': 'lightning', 'fire': 'fire', 'ice': 'icewater', 'water': 'icewater',
          'dark': 'darkportal', 'portal': 'darkportal', 'light': 'misc'}
STOP = {'a', 'an', 'the', 'with', 'and', 'of', 'cool', 'make', 'me', 'some', 'that', 'like', 'effect', 'vfx', 'for',
        'big', 'small', 'nice', 'really', 'very', 'want', 'into', 'in', 'on', 'to', 'it', 'be', 'i', 'my', 'awesome'}


def root():
    here = os.path.dirname(os.path.abspath(__file__))
    for up in (os.path.join(here, '..', '..'), os.path.join(here, '..')):
        if os.path.exists(os.path.join(up, 'library', 'index.jsonl')):
            return os.path.abspath(up)
    raise SystemExit('library/index.jsonl not found next to kit/')


def expand(word):
    w = word.lower()
    for k, vs in SYN.items():
        if w == k or w in vs or any(w.startswith(v) for v in vs if len(v) > 3):
            return k, set(vs) | {k}
    return w, {w}


def parts(query):
    # "light beam with an explosion" -> ["light beam", "explosion"]
    chunks = re.split(r'\b(?:with|and|plus|then|into|followed by|\+|,)\b', query.lower())
    out = []
    for c in chunks:
        words = [w for w in re.findall(r'[a-z]+', c) if w not in STOP]
        if words:
            out.append(words)
    return out or [[w for w in re.findall(r'[a-z]+', query.lower()) if w not in STOP]]


def score(rec, terms, cats):
    text = ' '.join([rec['category'], ' '.join(rec['tags']), os.path.basename(rec['file']), rec['path'], rec['names']]).lower()
    s = 0.0
    for key, words in terms:
        hit = sum(1 for w in words if re.search(r'\b' + re.escape(w), text))
        if hit:
            s += 2.0 + min(hit, 3) * 0.5
        if CAT_OF.get(key) == rec['category']:
            s += 2.5
    if rec['category'] in cats:
        s += 1.0
    s += 1.5 if rec.get('sheet') else 0
    s += min(rec['layers'], 40) / 40.0
    s += 0.5 if rec['driver'].startswith('EmitCount') else 0
    return s


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('query')
    ap.add_argument('-k', type=int, default=6)
    ap.add_argument('--category')
    ap.add_argument('--frames-only', action='store_true')
    a = ap.parse_args()
    R = root()
    recs = [json.loads(l) for l in open(os.path.join(R, 'library', 'index.jsonl'))]
    if a.category:
        recs = [r for r in recs if r['category'] == a.category]
    if a.frames_only:
        recs = [r for r in recs if r.get('sheet')]
    for words in parts(a.query):
        terms = [expand(w) for w in words]
        cats = {CAT_OF[k] for k, _ in terms if k in CAT_OF}
        ranked = sorted(recs, key=lambda r: -score(r, terms, cats))[:a.k]
        print('=== "%s"  (categories: %s)' % (' '.join(words), ', '.join(sorted(cats)) or '-'))
        for c in sorted(cats):
            print('    study notes: knowledge/categories/%s.md   starting recipe: knowledge/categories/%s_recipe.luau' % (c, c))
        for r in ranked:
            print('  %-12s %-10s %2d layers %-5s %s :: %s' % (r['id'], r['category'], r['layers'],
                                                           '%ss' % r['length'] if r['length'] else '', os.path.basename(r['file']), r['path'][-60:]))
            print('      card: %s%s' % (r['card'], ('   frames: ' + r['sheet']) if r.get('sheet') else ''))
    print('\nRead the cards (exact layer values) and LOOK at the frames before building. Combine parts by giving each '
          'part its own layers in one spec, offset in time (spec-format.md).')


if __name__ == '__main__':
    main()
