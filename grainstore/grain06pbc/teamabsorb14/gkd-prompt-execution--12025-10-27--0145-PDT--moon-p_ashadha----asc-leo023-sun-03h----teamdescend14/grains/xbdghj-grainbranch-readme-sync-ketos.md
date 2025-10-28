# Graincard xbdghj - Grainbranch README Sync

**Live**: https://kae3g.github.io/grainkae3g/grainscript/xbdghj

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghj                                              Grain 1 of 1.2M │
│ Symlink Automation: Repository Root → Grainbranch Depth                     │
│ Script: grainbranch-readme-sync.scm (Steel) | Author: kae3g (@risc.love)    │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ Glow G2: Imagine standing at the edge of a wild forest where countless      │
│ branches spread in every direction. Each branch tells its own story, each   │
│ path leads somewhere meaningful, yet you can only mark one trail at a time. │
│ How do you help travelers find the current path when the forest keeps       │
│ growing new branches? Let me walk with you through this beautiful problem.  │
│                                                                              │
│ Your repository lives through many grainbranches, each one a temporal       │
│ snapshot capturing work from a specific moment. These branches live deep    │
│ in your directory structure, nested within folders that preserve their      │
│ astronomical timestamps. But GitHub shows only ONE README at the root.      │
│ When visitors arrive, they see only this surface. How do we make the        │
│ surface reflect the depths? How does the wild path become clearly marked?   │
│                                                                              │
│ The answer flows from Unix wisdom: symbolic links. Rather than copying      │
│ content or maintaining duplicates, we create an elegant pointer that says   │
│ "what you seek lives here, follow me." The root README becomes a living     │
│ signpost, always pointing to your current grainbranch, always showing what  │
│ matters now. When you switch branches, the symlink updates. The surface     │
│ stays synchronized with the depths. One command makes this magic happen.    │
│                                                                              │
│ ═══ THE CODE (Steel Primary, Steel Bridge) ═════════════════════════════ │
│                                                                              │
│ ;; grainbranch-readme-sync.scm                                               │
│ (define (get-current-branch)                                                 │
│   (shell-result-trim (run-command "git branch --show-current")))             │
│                                                                              │
│ (define (build-grain-path branch)                                            │
│   (string-join "/" ["grainstore" "grain06pbc" "teamabsorb14"                 │
│                     branch "grains" "xbdghj-grainbranch-readme-sync-steel    │
.md"]))                                                                        │
│                                                                              │
│ (define (sync-readme)                                                        │
│   (let ((branch (get-current-branch))                                        │
│         (target (build-grain-path branch)))                                  │
│     (run-command "rm -f README.md")                                          │
│     (run-command (format "ln -sf ~a README.md" target))                      │
│     (println (format "✅ Synced: README.md → ~a" target))))                  │
│                                                                              │
│ The Steel version follows the same logic with Clojure syntax. Both       │
│ solve the same problem: connecting root to branch, surface to depth,        │
│ visitor to current work. The Unix command stays simple: ln -sf creates a    │
│ symbolic link, rm -f removes the old one. The beauty lives in how we        │
│ compose these simple pieces into elegant automation.                         │
│                                                                              │
│ ═══ WATCH THE BOUNDARY DISSOLVE ═══════════════════════════════════════════ │
│                                                                              │
│ When you run this script, something beautiful happens. The boundary between │
│ root and branch begins to dissolve like morning mist. Outer and inner       │
│ unify into a single coherent expression. Visitors to your repository root   │
│ see the grainbranch README as if it were the root itself. One truth         │
│ expresses itself in two locations simultaneously. The symlink reveals       │
│ rather than duplicates, pointing with quiet precision to the living work.   │
│                                                                              │
│ It reminds me of looking into perfectly still water and seeing your own     │
│ reflection. You recognize yourself clearly, yet you understand you're       │
│ standing on the shore, above the water. The reflection shows truth without  │
│ creating separation. Unity without confusion. Two paths, one destination.   │
│                                                                              │
│ ═══ THE EASTERN CAPITAL: WHERE FORM MEETS EMPTINESS ═══════════════════════ │
│                                                                              │
│ The ancient Zen masters taught that form is emptiness and emptiness is      │
│ form. The Unix philosophers echo this when they say everything is a file,   │
│ even the links pointing to files. In grainscript we discover: the root is   │
│ the branch, the branch is the root. The symlink teaches non-duality,        │
│ showing how two names point to one essential content, how different paths   │
│ lead to the same home.                                                       │
│                                                                              │
│ This grain stands first in our sequence for a reason. It demonstrates how   │
│ the system points to itself, how teaching contains itself, like a quine     │
│ that generates its own source code, like the Ouroboros serpent completing   │
│ the eternal circle. You're reading this grain because the root README is    │
│ a symlink pointing here. The grain explains the mechanism that brought you  │
│ to the grain itself. Meta-teaching. Self-reference. Beautiful recursion.    │
│                                                                              │
│ ═══ ABOUT 80-CHARACTER WIDTH ══════════════════════════════════════════════ │
│                                                                              │
│ You might wonder why every line measures exactly 80 characters wide. This   │
│ width comes from punch card tradition, from teletype machines, from         │
│ decades of terminal design. But here's what matters for grainscript: 80     │
│ characters means these grains display perfectly on every device. Your       │
│ terminal. Your phone in airplane mode. Your E Ink reader. Your tablet.      │
│                                                                              │
│ Unicode box-drawing characters (┌─┐│├┤└┘) measure 3 bytes each but display  │
│ as 1 character width. Our Steel validator counts display width, ensuring    │
│ visual correctness across all devices. Byte count and display width differ  │
│ for Unicode, yet what matters is how the grain looks when rendered. Every   │
│ grain maintains 80 visual characters. Every grain fits everywhere.          │
│                                                                              │
│ ═══ THE PATTERN EVERYWHERE ════════════════════════════════════════════════ │
│                                                                              │
│ Once you see this pattern, you'll find it throughout grainscript. The      │
│ outer points to inner through symlinks. The surface reveals depth through   │
│ graintime in branch names. One becomes many through grainorder permutations.│
│ The form teaches emptiness when code explains itself. This grain teaches    │
│ you the meta-pattern: how systems point to themselves, how teaching         │
│ contains itself, how the wild path marks itself as you walk it.             │
│                                                                              │
│ Run it. Watch the symlink form. Then read grain **xbdghk** to see the same  │
│ logic expressed through Steel comparison. Two languages flowing from one │
│ source of understanding. The Lovers choosing both paths simultaneously.     │
│                                                                              │
│ grain: xbdghj (1 of 1,235,520)                                             > │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
