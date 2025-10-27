# Graincard xbdghk - Grainbranch README Sync (Ketos)

**File**: `grainbarrel/scripts/grainbranch-readme-sync.ket`  
**Live**: https://kae3g.github.io/grainkae3g/grainscript/xbdghk  
**Previous Card**: [xbdghj](xbdghj-grainbranch-readme-sync-babashka.md) (Babashka version)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghk                            Card 2 of 2 (Ketos version)     │
│ Script: grainbranch-readme-sync.ket                                          │
│ Purpose: Learn Ketos by comparing to Babashka (see xbdghj)                   │
│ Author: kae3g (kj3x39, @risc.love)                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ Glow G2: This is the SAME script as xbdghj, but written in Ketos instead    │
│ of Babashka. Why both? To learn through comparison.                          │
│                                                                              │
│ KETOS CODE:                                                                  │
│                                                                              │
│ ;; grainbranch-readme-sync.ket                                               │
│                                                                              │
│ (define (get-current-branch)                                                 │
│   "Get current git branch name via Rust FFI"                                 │
│   (let ((result (run-command "git branch --show-current")))                  │
│     (if (:success result)                                                    │
│       (:output result)                                                       │
│       nil)))                                                                 │
│                                                                              │
│ (define (create-symlink grainbranch-name)                                    │
│   "Create symlink from root to grainbranch README"                           │
│   (let ((target (concat "grainstore/grain6pbc/teamdescend14/"                │
│                        grainbranch-name "/README.md"))                       │
│         (link "README.md"))                                                  │
│     (run-command (concat "rm " link))                                        │
│     (run-command (concat "ln -sf " target " " link))))                       │
│                                                                              │
│ (define (main args)                                                          │
│   "Entry point - sync README symlink"                                        │
│   (let ((branch (or (first args) (get-current-branch))))                     │
│     (create-symlink branch)))                                                │
│                                                                              │
│ USAGE:                                                                       │
│ $ ketos grainbranch-readme-sync.ket                                          │
│                                                                              │
│ LEARNING COMPARISON (Babashka vs Ketos):                                     │
│                                                                              │
│ Babashka:                         Ketos:                                     │
│ - Clojure syntax                  - Lisp syntax (similar!)                   │
│ - JVM-based (heavier)             - Rust-based (lighter)                     │
│ - Works now (installed)           - Learning (needs install)                 │
│ - :keywords in maps               - Keywords TBD                             │
│                                                                              │
│ BOTH: Solve the same problem, teach through comparison.                      │
│                                                                              │
│ Question: Which is better? Answer: Both! Use Babashka now, learn Ketos for   │
│ Redox OS future. The code is almost identical - that's the beauty of Lisp.   │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook Issue 1: Ember Harvest 🎃 (System Magazine)                       │
│ Grain: xbdghk (2 of 1,235,520)                                             > │
│                                                                              │
│ Next: [xbdghl](xbdghl-graincard-format-spec.md) →                           │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
```
