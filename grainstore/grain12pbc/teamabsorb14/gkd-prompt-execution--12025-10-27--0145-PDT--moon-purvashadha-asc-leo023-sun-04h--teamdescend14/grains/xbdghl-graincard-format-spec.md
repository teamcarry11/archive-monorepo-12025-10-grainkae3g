# Graincard xbdghl - Graincard Format Specification

**Live**: https://kae3g.github.io/grainkae3g/grainscript/xbdghl

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghl                                              grain 3 of 1.2M │
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
│ THE EXACT DIMENSIONS:                                                        │
│ Total file: 116 lines                                                       │
│   Lines 1-4:   Header (title, blank, live link, blank)                      │
│   Line 5:      Opening ``` (markdown code fence)                            │
│   Lines 6-115: 110-line ASCII box (80 chars wide)                           │
│   Line 116:    Closing ``` (markdown code fence)                            │
│                                                                              │
│ THE 110-LINE BOX STRUCTURE:                                                  │
│   Line 6:      Top border ┌────...────┐                                     │
│   Lines 7-106: Content (100 lines, 78 chars + 2 for │ borders)              │
│   Line 107:    Separator ├────...────┤                                      │
│   Lines 108-   Footer metadata (grainbook, card #, next link)               │
│   Line 115:    Bottom border └────...────┘                                  │
│                                                                              │
│ THE WILD → EASTERN TEACHING:                                                 │
│ In the wild forest: scattered knowledge, no structure, beautiful chaos.     │
│ The search begins: How do we organize? What container holds wisdom?         │
│ The meltdown: Constraints ENABLE creativity. 80×110 isn't limitation—       │
│ it's liberation. One format. Infinite content. Like haiku. Like sonnet.     │
│ The eastern capital: Form and emptiness dance. The box teaches by being     │
│ exactly what it is. Not too big. Not too small. Just right. 80×110.         │
│                                                                              │
│ THE VALIDATION:                                                              │
│ Location: grainstore/grain12pbc/teamrebel10/graincard-spec/             │
│ Validator: graincard-validator.bb (Babashka)                                │
│ Checks:                                                                      │
│   ✓ Total lines = 116                                                       │
│   ✓ Line 5 = ```                                                            │
│   ✓ Lines 6-115 = 110 lines (borders included)                              │
│   ✓ Line 116 = ```                                                          │
│   ✓ Each content line ≤ 80 chars                                            │
│   ✓ Footer has card number + > next button                                  │
│                                                                              │
│ USAGE EXAMPLE:                                                               │
│ $ bb graincard-validator.bb grains/                                          │
│ ✅ xbdghj-*.md - VALID                                                       │
│ ✅ xbdghk-*.md - VALID                                                       │
│ ❌ xbdghl-*.md - INVALID (only 62 lines, needs +48!)                         │
│                                                                              │
│ THE PHILOSOPHY:                                                              │
│ Every graincard is a momento. A snapshot. A teaching frozen in time.        │
│ 80×110 means it works EVERYWHERE: Your terminal. Your phone in airplane     │
│ mode over the Pacific. Your E Ink reader in the cabin. Your tablet in       │
│ landscape "MOVIE MODE". It's democratic technology. No app required.        │
│ Just markdown. Just monospace. Just teaching.                                │
│                                                                              │
│ DOES THIS MAKE SENSE?                                                        │
│ Each graincard is a teaching moment. A knowledge capsule. A temporal        │
│ snapshot of wisdom that works on any device, any terminal, any reader.      │
│ From your phone in the forest to your tablet in the desert to your          │
│ E Ink reader in the cabin. Always 80×110. Always beautiful. Always yours.   │
│                                                                              │
│ This grain (xbdghl) teaches the format by BEING the format. Meta-teaching.  │
│ The grain about grains. The form teaching form. Now you know. 🌾            │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook Issue 1: Ember Harvest 🎃 (System Magazine)                       │
│ Grain: xbdghl (3 of 1,235,520)                                             > │
│                                                                              │
│ Next: [xbdghn](xbdghn-grainorder-alphabet-system.md) →                      │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
```

