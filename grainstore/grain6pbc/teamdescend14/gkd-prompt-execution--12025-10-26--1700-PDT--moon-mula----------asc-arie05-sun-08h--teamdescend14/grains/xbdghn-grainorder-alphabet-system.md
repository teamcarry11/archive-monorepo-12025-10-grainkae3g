# Graincard xbdghn - Grainorder Alphabet System

**Live**: https://kae3g.github.io/grainkae3g/grainscript/xbdghn

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghn                          Card 4 of 1,235,520                │
│ Topic: Grainorder - Universal Ordering System                               │
│ Team: 13 (teamascend13 - The Hanged Man ♆)                                  │
│ Author: kae3g (kj3x39, @risc.love)                                           │
│                                                                              │
│ Glow G2: Let me teach you how we order 1.2 million knowledge cards with     │
│ just 13 consonants. No vowels. No duplicates. Pure mathematical beauty.     │
│                                                                              │
│ THE PROBLEM:                                                                 │
│ You want to organize knowledge. Lots of it. Like, over a million cards.     │
│ You need a simple, memorable, sortable naming system that:                  │
│   1. Works in filenames (no special chars)                                  │
│   2. Sorts lexicographically (abc order just works)                         │
│   3. Avoids confusion (no vowels = no accidental words)                     │
│   4. Scales massively (need 1M+ unique codes)                               │
│                                                                              │
│ THE SOLUTION: GRAINORDER                                                     │
│                                                                              │
│ ALPHABET: xbdghjklmnsvz (13 consonants)                                     │
│ Why these? No vowels (x/y excluded). Visually distinct. Pronounceable       │
│ as individual letters. No cultural baggage. Pure, clean, mathematical.      │
│                                                                              │
│ CODE LENGTH: 6 characters                                                    │
│ Why 6? Because 13!/(13-6)! = 1,235,520 unique codes without duplicates.    │
│ That's enough for a lifetime of knowledge cards.                            │
│                                                                              │
│ NO DUPLICATES RULE:                                                          │
│ Each character appears AT MOST ONCE per code.                               │
│   ✓ xbdghj (all different)                                                  │
│   ✗ xbdghh (h appears twice)                                                │
│   ✓ zmnsvx (all different)                                                  │
│   ✗ xxxxxx (x repeats)                                                      │
│                                                                              │
│ LEXICOGRAPHIC ORDER:                                                         │
│ Cards sort naturally like words in a dictionary:                            │
│   xbdghj → xbdghk → xbdghl → xbdghm → xbdghn → xbdghs → ...                │
│                                                                              │
│ THE MATH:                                                                    │
│ How many 6-character codes from 13 letters without duplicates?              │
│                                                                              │
│   Position 1: 13 choices                                                    │
│   Position 2: 12 choices (can't repeat position 1)                          │
│   Position 3: 11 choices (can't repeat positions 1-2)                       │
│   Position 4: 10 choices                                                    │
│   Position 5: 9 choices                                                     │
│   Position 6: 8 choices                                                     │
│                                                                              │
│   Total = 13 × 12 × 11 × 10 × 9 × 8 = 1,235,520                            │
│                                                                              │
│ FIRST CODE: xbdghj (alphabetically first using our alphabet)                │
│ LAST CODE:  zmnsvx (alphabetically last)                                    │
│                                                                              │
│ IMPLEMENTATION (Clojure):                                                    │
│   (def grainorder-alphabet "xbdghjklmnsvz")                                 │
│   (defn valid-grainorder? [code]                                            │
│     (and (= 6 (count code))                                                 │
│          (every? #(str/includes? grainorder-alphabet %) code)               │
│          (apply distinct? code)))                                           │
│                                                                              │
│ WHY NO VOWELS?                                                               │
│ Vowels create accidental words. "xbdghj" is abstract. "abused" is not.     │
│ We want pure addressing, not semantic meaning in the codes themselves.      │
│ The CONTENT has meaning. The ADDRESS is just math.                          │
│                                                                              │
│ DOES THIS MAKE SENSE?                                                        │
│ Think of it like latitude/longitude. Pure coordinates. No meaning except    │
│ location. xbdghn doesn't "mean" anything—it just points to THIS card,       │
│ teaching you about the grainorder system itself. Meta! 🌾                   │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook Issue 1: Ember Harvest 🎃 (System Magazine)                       │
│ Grain: xbdghn (4 of 1,235,520)                                             > │
│                                                                              │
│ Next: [xbdghs](xbdghs-graintime-temporal-calculation.md) →                  │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
```

