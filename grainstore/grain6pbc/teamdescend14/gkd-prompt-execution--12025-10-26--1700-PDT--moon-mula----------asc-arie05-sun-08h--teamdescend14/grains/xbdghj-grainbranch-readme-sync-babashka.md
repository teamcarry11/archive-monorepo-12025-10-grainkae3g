# Graincard xbdghj - Grainbranch README Sync (Babashka)

**Live**: https://kae3g.github.io/grainkae3g/grains/xbdghj

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghj                                                  Grain 1/1.2M │
│ THE WILD WITHIN                                                              │
│ Script: grainbranch-readme-sync.bb (Babashka)                                │
│ Author: kae3g (kj3x39, @risc.love) | Copyright © 3x39                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ Glow G2: You're standing at the edge. The forest, untamed. Branches          │
│ everywhere - which one leads home? Let me teach you the path.               │
│                                                                              │
│ ═══ THE WILD ═══════════════════════════════════════════════════════════════ │
│                                                                              │
│ Your repository has many grainbranches. Deep folders. Nested paths.         │
│ Each grainbranch: a temporal snapshot. A moment captured. But GitHub        │
│ only shows ONE README - the root. How do you make the surface reflect       │
│ the depths? How does the wild path become the marked trail?                 │
│                                                                              │
│ ═══ THE SEARCH ═════════════════════════════════════════════════════════════ │
│                                                                              │
│ You search for connection. Root to branch. Outside to inside. The answer:   │
│ SYMBOLIC LINKS. Not copies. Not duplicates. A pointer. A reference.         │
│ The root README doesn't contain content - it POINTS to content.              │
│                                                                              │
│ Like a signpost in the wild: "This way to the current work."                │
│                                                                              │
│ ═══ THE CODE (Babashka) ════════════════════════════════════════════════════ │
│                                                                              │
│ #!/usr/bin/env bb                                                            │
│ (require '[clojure.java.shell :refer [sh]]                                   │
│          '[clojure.string :as str])                                          │
│                                                                              │
│ ;; Get current grainbranch name                                              │
│ (defn get-current-branch []                                                  │
│   (let [result (sh "git" "branch" "--show-current")]                         │
│     (when (zero? (:exit result))                                             │
│       (str/trim (:out result)))))                                            │
│                                                                              │
│ ;; Build path to grainbranch README                                          │
│ (defn grain-readme-path [branch]                                             │
│   (str "grainstore/grain6pbc/teamdescend14/"                                 │
│        branch "/grains/xbdghj-grainbranch-readme-sync-babashka.md"))        │
│                                                                              │
│ ;; Create the symlink                                                        │
│ (defn sync-readme []                                                         │
│   (let [branch (get-current-branch)                                          │
│         target (grain-readme-path branch)                                    │
│         link "README.md"]                                                    │
│     (sh "rm" "-f" link)          ; Remove old                                │
│     (sh "ln" "-sf" target link)  ; Create new                                │
│     (println "✅ Synced:" link "→" target)))                                 │
│                                                                              │
│ (sync-readme)                                                                │
│                                                                              │
│ ═══ THE MELTDOWN ═══════════════════════════════════════════════════════════ │
│                                                                              │
│ What happens? The boundary dissolves. Root and branch merge. Outer and      │
│ inner unify. Visit the root - you see the grainbranch. One truth, two       │
│ locations. The symlink doesn't duplicate - it REVEALS.                       │
│                                                                              │
│ Like looking into still water: you see yourself, but you're not in the      │
│ water. Reflection without separation.                                        │
│                                                                              │
│ ═══ THE EASTERN WISDOM ═════════════════════════════════════════════════════ │
│                                                                              │
│ In Zen: "Form is emptiness, emptiness is form."                             │
│ In Unix: "Everything is a file, even links to files."                       │
│ In grainscript: "The root is the branch, the branch is the root."           │
│                                                                              │
│ The symlink teaches non-duality. Two paths, one destination. Different      │
│ names, same content. This is the first grain because it shows you: the      │
│ system points to itself. Like a quine. Like Ouroboros.                       │
│                                                                              │
│ ═══ WHY BABASHKA? ══════════════════════════════════════════════════════════ │
│                                                                              │
│ - Millisecond startup (JVM would take seconds)                               │
│ - Clojure syntax (readable, functional, beautiful)                           │
│ - Works NOW (no compilation needed)                                          │
│ - Script-like (run it, it works, done)                                       │
│                                                                              │
│ Compare with **xbdghk** (Ketos version) to learn Rust Lisp.                 │
│                                                                              │
│ ═══ USAGE ══════════════════════════════════════════════════════════════════ │
│                                                                              │
│ $ bb grainbranch-readme-sync.bb                                              │
│                                                                              │
│ That's it. One command. The wild becomes navigable. The search succeeds.    │
│ The root reflects the branch. The system knows itself.                       │
│                                                                              │
│ ═══ THE PATTERN ════════════════════════════════════════════════════════════ │
│                                                                              │
│ This pattern appears everywhere in grainscript:                              │
│ - Outer points to inner (symlinks)                                           │
│ - Surface reveals depth (graintime in branch names)                          │
│ - One becomes many (grainorder permutations)                                 │
│ - Form teaches emptiness (the code explains itself)                          │
│                                                                              │
│ Does this make sense? You're not just learning a script. You're learning    │
│ how systems point to themselves. Meta-knowledge. The grain that teaches      │
│ grains. The wild path that marks itself.                                     │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook Issue 1: Ember Harvest 🎃 (System Magazine)                       │
│ Grain: xbdghj (1 of 1,235,520)                                             > │
│                                                                              │
│ Next: [xbdghk](xbdghk-grainbranch-readme-sync-ketos.md) →                   │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
```
