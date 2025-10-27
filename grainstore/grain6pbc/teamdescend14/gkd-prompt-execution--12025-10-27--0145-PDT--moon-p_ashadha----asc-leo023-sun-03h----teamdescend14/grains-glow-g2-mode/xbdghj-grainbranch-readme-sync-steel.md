# Graincard xbdghj - Symlink Automation with Steel

**Live**: https://kae3g.github.io/grainkae3g/grainscript/xbdghj

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghj                               grain 1 of 1,235,520 │
│ Symlink Automation: Repository Root → Grainbranch Depth                      │
│ Script: grainbranch-readme-sync.scm (Steel) | Author: kae3g (@risc.love)     │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ Glow G2: Imagine standing at the edge of a wild forest where countless       │
│ branches spread in every direction. Each branch tells its own story, each    │
│ path leads somewhere meaningful, yet you can only mark one trail at a time.  │
│ How do you help travelers find the current path when the forest keeps        │
│ growing new branches? Let me walk with you through this beautiful problem.   │
│                                                                              │
│ Your repository lives through many grainbranches, each one a temporal        │
│ snapshot capturing work from a specific moment. These branches live deep     │
│ in your directory structure, nested within folders that preserve their       │
│ astronomical timestamps. But GitHub shows only ONE README at the root.       │
│ When visitors arrive, they see only this surface. How do we make the         │
│ surface reflect the depths? How does the wild path become clearly marked?    │
│                                                                              │
│ The answer flows from Unix wisdom: symbolic links. Rather than copying       │
│ content or maintaining duplicates, we create an elegant pointer that says    │
│ "what you seek lives here, follow me." The root README becomes a living      │
│ signpost, always pointing to your current grainbranch, always showing what   │
│ matters now. When you switch branches, the symlink updates. The surface      │
│ stays synchronized with the depths. One command makes this magic happen.     │
│                                                                              │
│ ═══ THE CODE (Steel - Rust-Based Scheme) ══════════════════════════════════  │
│                                                                              │
│ ;; grainbranch-readme-sync.scm                                               │
│ ;; Purpose: Symlink root README to current grainbranch README                │
│ ;; Team: 02 (teamvault02 - Taurus ♉ / II. The High Priestess)                │
│                                                                              │
│ (require-builtin steel/process)                                              │
│                                                                              │
│ (define (shell cmd)                                                          │
│   "Execute shell command and return output"                                  │
│   (command cmd))                                                             │
│                                                                              │
│ (define (get-current-branch)                                                 │
│   "Get current git branch name"                                              │
│   (trim (shell "git branch --show-current")))                                │
│                                                                              │
│ (define (find-grainbranch-readme branch-name)                                │
│   "Build path to grainbranch README"                                         │
│   (string-append "grainstore/grain6pbc/teamdescend14/"                       │
│                  branch-name "/README.md"))                                  │
│                                                                              │
│ (define (create-symlink target link-name)                                    │
│   "Create symbolic link from link-name to target"                            │
│   (shell (string-append "rm -f " link-name))                                 │
│   (shell (string-append "ln -sf " target " " link-name))                     │
│   (displayln (string-append "✅ Synced: " link-name " → " target)))          │
│                                                                              │
│ (define (sync-readme)                                                        │
│   "Main function: sync root README to grainbranch README"                    │
│   (let ([branch (get-current-branch)]                                        │
│         [target (find-grainbranch-readme branch)])                           │
│     (create-symlink target "README.md")))                                    │
│                                                                              │
│ ;; Run it!                                                                   │
│ (sync-readme)                                                                │
│                                                                              │
│ ═══ WHY STEEL? ════════════════════════════════════════════════════════════  │
│                                                                              │
│ Steel brings the elegance of Scheme (a Lisp dialect) with the power of      │
│ Rust underneath. Think of it as the spiritual successor to what we wanted    │
│ from scripting languages but couldn't get until now:                         │
│                                                                              │
│ • **Rust-based**: Compiles to native code, no JVM needed                     │
│ • **Fast startup**: Bytecode VM optimized for scripting                      │
│ • **Redox OS ready**: Works on microkernel systems                           │
│ • **R5RS Scheme**: Full standard compliance with modern extensions           │
│ • **Package manager**: `forge` for dependency management                     │
│ • **LSP support**: Language server for IDE integration                       │
│ • **Active development**: Commits from 3 days ago (October 2025)             │
│                                                                              │
│ ═══ WATCH THE BOUNDARY DISSOLVE ═══════════════════════════════════════════  │
│                                                                              │
│ When you run this script, something beautiful happens. The boundary between  │
│ root and branch begins to dissolve like morning mist. Outer and inner        │
│ unify into a single coherent expression. Visitors to your repository root    │
│ see the grainbranch README as if it were the root itself. One truth          │
│ expresses itself in two locations simultaneously. The symlink reveals        │
│ rather than duplicates, pointing with quiet precision to the living work.    │
│                                                                              │
│ It reminds me of looking into perfectly still water and seeing your own      │
│ reflection. You recognize yourself clearly, yet you understand you're        │
│ standing on the shore, above the water. The reflection shows truth without   │
│ creating separation. Unity without confusion. Two paths, one destination.    │
│                                                                              │
│ ═══ THE EASTERN CAPITAL: WHERE FORM MEETS EMPTINESS ═══════════════════════  │
│                                                                              │
│ The ancient Zen masters taught that form is emptiness and emptiness is       │
│ form. The Unix philosophers echo this when they say everything is a file,    │
│ even the links pointing to files. In grainscript we discover: the root is    │
│ the branch, the branch is the root. The symlink teaches non-duality,         │
│ showing how two names point to one essential content, how different paths    │
│ lead to the same home.                                                       │
│                                                                              │
│ This grain stands first in our sequence for a reason. It demonstrates how    │
│ the system points to itself, how teaching contains itself, like a quine      │
│ that generates its own source code, like the Ouroboros serpent completing    │
│ the eternal circle. You're reading this grain because the root README is     │
│ a symlink pointing here. The grain explains the mechanism that brought you   │
│ to the grain itself. Meta-teaching. Self-reference. Beautiful recursion.     │
│                                                                              │
│ ═══ STEEL'S SCHEME ELEGANCE ═══════════════════════════════════════════════  │
│                                                                              │
│ Notice the syntax. `(define (function-name args) body)` creates functions.   │
│ `(let ([var value]) body)` binds variables locally. Everything is an         │
│ expression. Data and code share the same structure. Parentheses aren't       │
│ syntax noise - they're the visible structure of computation itself.          │
│                                                                              │
│ Steel extends Scheme with Rust's power: you can call Rust functions via      │
│ FFI, use Rust data structures directly, and compile to native binaries.      │
│ It's the marriage of Lisp's expressiveness with Rust's performance and       │
│ safety. The best of both worlds flowing together like two rivers joining.    │
│                                                                              │
│ ═══ THE PATTERN EVERYWHERE ════════════════════════════════════════════════  │
│                                                                              │
│ Once you see this pattern, you'll find it throughout grainscript. The        │
│ outer points to inner through symlinks. The surface reveals depth through    │
│ graintime in branch names. One becomes many through grainorder permutations. │
│ The form teaches emptiness when code explains itself. This grain teaches     │
│ you the meta-pattern: how systems point to themselves, how teaching          │
│ contains itself, how the wild path marks itself as you walk it.              │
│                                                                              │
│ Run it. Watch the symlink form. Then read grain **xbdghk** to explore        │
│ Steel's full power: package management, contracts, macros, and the           │
│ ecosystem that makes it production-ready. One language, infinite potential.  │
│                                                                              │
│ grain: xbdghj (1 of 1,235,520)                                             > │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```
