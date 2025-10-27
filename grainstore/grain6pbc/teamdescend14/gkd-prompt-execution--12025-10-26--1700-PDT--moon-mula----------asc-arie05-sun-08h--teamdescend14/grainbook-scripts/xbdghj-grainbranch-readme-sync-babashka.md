# Graincard xbdghj - Grainbranch README Sync (Babashka)

**Live**: https://github.com/kae3g/grainkae3g/tree/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/grainstore/grain6pbc/teamdescend14/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/grainbook-scripts/xbdghj-grainbranch-readme-sync-babashka.md

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghj                          Card 1 of 2 (Babashka version)    │
│ Script: grainbranch-readme-sync.bb                                           │
│ Purpose: Symlink root README to grainbranch README                           │
│ Author: kae3g (kj3x39, @risc.love)                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ Glow G2: Let me teach you what this script does and why it matters.         │
│                                                                              │
│ THE PROBLEM:                                                                 │
│ GitHub shows your root README.md by default. But your real work happens in   │
│ grainbranches - timestamped folders deep in the repository. How do we make   │
│ the outer (root) reflect the inner (grainbranch)?                            │
│                                                                              │
│ THE SOLUTION:                                                                │
│ Symbolic links. The root README becomes a pointer to the grainbranch README. │
│ As above, so below. Outer reflects inner. One source of truth.               │
│                                                                              │
│ BABASHKA CODE:                                                               │
│                                                                              │
│ #!/usr/bin/env bb                                                            │
│ (require '[clojure.java.shell :refer [sh]]                                   │
│          '[clojure.string :as str])                                          │
│                                                                              │
│ (defn get-current-branch []                                                  │
│   "Get current git branch name"                                              │
│   (let [result (sh "git" "branch" "--show-current")]                         │
│     (if (zero? (:exit result))                                               │
│       (str/trim (:out result))                                               │
│       nil)))                                                                 │
│                                                                              │
│ (defn create-symlink [grainbranch-name]                                      │
│   "Create symlink from root to grainbranch README"                           │
│   (let [target (str "grainstore/grain6pbc/teamdescend14/"                    │
│                    grainbranch-name "/README.md")                            │
│         link "README.md"]                                                    │
│     (sh "rm" link)           ; Remove old                                    │
│     (sh "ln" "-sf" target link)))  ; Create new symlink                      │
│                                                                              │
│ USAGE:                                                                       │
│ $ bb grainbranch-readme-sync.bb                                              │
│                                                                              │
│ This creates a symbolic link from your root README.md to the current         │
│ grainbranch's README. Change the grainbranch README, and the root changes    │
│ too. They're unified. As above, so below.                                    │
│                                                                              │
│ WHY BABASHKA?                                                                │
│ Fast startup (milliseconds), Clojure syntax, works now.                      │
│                                                                              │
│ See also: xbdghk for Ketos version (learning comparison).                    │
│                                                                              │
│ Does this make sense? The root README becomes a portal to your current work. │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook: Ember Harvest 🎃                                                  │
│ Card: xbdghj (1 of 1,235,520)                                                │
│ Next: [xbdghk](xbdghk-grainbranch-readme-sync-ketos.md) →                   │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
```

