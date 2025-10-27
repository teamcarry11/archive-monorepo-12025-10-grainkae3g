# Graincard xbdghl - Graincard Format Specification

**Live**: https://kae3g.github.io/grainkae3g/grains/xbdghl

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghl                          Card 3 of 2 (Format Spec)          │
│ Spec: Graincard 80×110 Format                                                │
│ Purpose: Define the canonical graincard structure                            │
│ Author: kae3g (kj3x39, @risc.love)                                           │
│                                                                              │
│ Glow G2: Let me teach you what a graincard IS and why this format matters.  │
│                                                                              │
│ THE VISION:                                                                  │
│ 1,235,520 knowledge cards. Each one exactly 80×110 characters. Each one     │
│ teaching a single concept, script, or idea. Like flashcards but better.     │
│ Like documentation but beautiful. Like a grainbook you can carry forever.   │
│                                                                              │
│ THE FORMAT (80 chars wide × 110 lines tall):                                │
│                                                                              │
│ SECTION 1: METADATA (before codeblock)                                      │
│   - Title: # Graincard {code} - {title}                                     │
│   - File path: **File**: relative/path.ext                                  │
│   - Live URL: **Live**: https://github.com/...                              │
│   - Navigation: **Prev Card**: [code](file.md)  **Next Card**: [code]...    │
│                                                                              │
│ SECTION 2: CONTENT BOX (inside ``` markdown codeblock)                      │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ Header: Card code + card number (optional)                          │   │
│   │ Content: 78 chars max per line (2 char padding for │ borders)       │   │
│   │ Wrapped text preserving words                                       │   │
│   │ Glow G2 voice (patient teacher, asks questions)                     │   │
│   │ Code examples, explanations, hand-holding guidance                  │   │
│   ├─────────────────────────────────────────────────────────────────────┤   │
│   │ Footer: Grainbook name, card number, signature                      │   │
│   │ Signature: "now == next + 1 🌾" (temporal philosophy)               │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│ GRAINORDER CODES (xbdghjklmnsvz alphabet):                                  │
│ - 6 characters from 13-char alphabet                                        │
│ - NO duplicates (xbdghj ✓, xbdghh ✗)                                        │
│ - Lexicographic order (xbdghj, xbdghk, xbdghl, xbdghn, ...)                 │
│ - Total: 13!/(13-6)! = 1,235,520 unique codes                               │
│                                                                              │
│ WHY THIS FORMAT?                                                             │
│ - Monospace fits terminals, E Ink, mobile, tablets                          │
│ - 80 chars is classic terminal width (respects Unix tradition)              │
│ - 110 lines fits portrait mobile with scroll (MOVIE MODE landscape)         │
│ - ASCII borders work everywhere (no Unicode dependency)                     │
│ - Links at TOP (navigable on GitHub before fold)                            │
│ - Metadata at BOTTOM (doesn't clutter teaching content)                     │
│                                                                              │
│ DOES THIS MAKE SENSE?                                                        │
│ Each graincard is a teaching moment. A knowledge capsule. A temporal        │
│ snapshot of wisdom that works on any device, any terminal, any reader.      │
│ From your phone in the forest to your tablet in the desert to your          │
│ E Ink reader in the cabin. Always 80×110. Always beautiful. Always yours.   │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook Issue 1: Ember Harvest 🎃 (System Magazine)                       │
│ Grain: xbdghl (3 of 1,235,520)                                             > │
│                                                                              │
│ Next: [xbdghn](xbdghn-grainorder-alphabet-system.md) →                      │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
```

