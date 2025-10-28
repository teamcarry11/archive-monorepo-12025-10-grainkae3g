# Graincard xbdghk - Babashka Comparison

**Live**: https://kae3g.github.io/grainkae3g/grainscript/xbdghk

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ GRAINCARD xbdghk                            Card 2 of 2 (Ketos version)     │
│ Script: grainbranch-readme-sync.ket                                          │
│ Purpose: Learn Ketos by comparing to Babashka (see xbdghj)                   │
│ Author: kae3g (kj3x39, @risc.love)                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│ Glow G2: You just learned the Babashka version in **xbdghj**. Now watch      │
│ how the SAME logic translates to Ketos. Does the syntax feel familiar?      │
│                                                                              │
│ THE KETOS CODE (Complete):                                                   │
│                                                                              │
│ ;; grainbranch-readme-sync.ket - Ketos version                               │
│ ;; Purpose: Symlink root README to current grainbranch README                │
│ ;; Team: 04 (teamplay04 - Taurus ♉ / IV. The Emperor)                    │
│                                                                              │
│ (define (shell-command cmd)                                                  │
│   "Execute shell command, return output as string"                           │
│   (let ((process (io/run-process cmd)))                                      │
│     (if (= 0 (process-exit-code process))                                    │
│         (process-stdout process)                                             │
│         (do                                                                  │
│           (println! (format "Error: ~a" (process-stderr process)))           │
│           nil))))                                                            │
│                                                                              │
│ (define (get-current-branch)                                                 │
│   "Get current git branch name"                                              │
│   (let ((output (shell-command "git branch --show-current")))                │
│     (if output                                                               │
│         (string-trim output)                                                 │
│         (error "Could not determine current git branch"))))                  │
│                                                                              │
│ (define (build-target-path branch)                                           │
│   "Construct path to grainbranch README"                                     │
│   (format "grainstore/grain12pbc/teamabsorb14/~a/README.md" branch))         │
│                                                                              │
│ (define (remove-old-symlink link-path)                                       │
│   "Remove existing symlink if it exists"                                     │
│   (when (file-exists? link-path)                                             │
│     (shell-command (format "rm ~a" link-path))))                             │
│                                                                              │
│ (define (create-symlink target link)                                         │
│   "Create symbolic link from link to target"                                 │
│   (shell-command (format "ln -sf ~a ~a" target link))                        │
│   (println! (format "✅ Synced: ~a → ~a" link target)))                      │
│                                                                              │
│ (define (sync-readme)                                                        │
│   "Main function: sync root README to grainbranch README"                    │
│   (let* ((branch (get-current-branch))                                       │
│          (target (build-target-path branch))                                 │
│          (link "README.md"))                                                 │
│     (remove-old-symlink link)                                                │
│     (create-symlink target link)))                                           │
│                                                                              │
│ ;; Execute when run as script                                                │
│ (sync-readme)                                                                │
│                                                                              │
│ USAGE:                                                                       │
│ $ ketos grainbranch-readme-sync.ket                                          │
│ ✅ Synced: README.md → grainstore/.../gkd-prompt-execution--12025-10-26...  │
│                                                                              │
│ COMPARE TO BABASHKA (See **xbdghj**):                                        │
│                                                                              │
│ Same logic, different syntax. Let me show you side-by-side:                 │
│                                                                              │
│ Babashka (Clojure):              Ketos (Scheme-like Lisp):                   │
│ ────────────────────────────────────────────────────────────────────────────  │
│ (require '[clojure.java.shell   (define (shell-command cmd)                 │
│           :refer [sh]])            (io/run-process cmd))                     │
│                                                                              │
│ (defn get-current-branch []      (define (get-current-branch)               │
│   (let [result (sh "git" ...)]     (shell-command "git..."))                 │
│     (:out result)))                                                          │
│                                                                              │
│ (str "path/" branch "/file")     (format "path/~a/file" branch)              │
│                                                                              │
│ DO YOU SEE THE PATTERN?                                                      │
│ Both are Lisps. Both use (function arg1 arg2). Both love let bindings.      │
│ Ketos is lighter (Rust, no JVM). Babashka is batteries-included (Clojure).  │
│                                                                              │
│ WHY LEARN BOTH?                                                              │
│                                                                              │
│ Babashka = Use NOW. Scripts that run instantly. Mature ecosystem.           │
│ Ketos = Use LATER. Rust-based. Works on Redox OS. Microkernel future.       │
│                                                                              │
│ Think of it like learning Spanish then Italian. Same roots (Latin/Lisp),    │
│ different flavors. Once you know one Lisp, you know them all. The mental    │
│ model transfers. The parentheses make sense. The data-as-code philosophy    │
│ clicks. This is why we teach both: not to confuse you, but to show you      │
│ the UNITY beneath the syntax. Different tools. Same thinking.                │
│                                                                              │
│ NEXT STEPS:                                                                  │
│ 1. Install Ketos: cargo install ketos (requires Rust toolchain)             │
│ 2. Try this script: ketos grainbranch-readme-sync.ket                        │
│ 3. Compare output to Babashka version                                        │
│ 4. Modify both - see how changes mirror each other                           │
│                                                                              │
│ DOES THIS MAKE SENSE?                                                        │
│ You're not learning two random languages. You're learning one IDEA (Lisp)   │
│ expressed in two FORMS (Clojure-flavored vs Scheme-flavored). The deeper    │
│ you go, the more you'll see: they're the same river, different banks.       │
│ Babashka flows through JVM land. Ketos flows through Rust land. But both    │
│ flow to the same ocean: elegant, functional, beautiful code. Welcome. 🌾    │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│ Grainbook Issue 1: Ember Harvest 🎃 (System Magazine)                       │
│ Grain: xbdghk (2 of 1,235,520)                                             > │
│                                                                              │
│ Next: [xbdghl](xbdghl-graincard-format-spec.md) →                           │
│ now == next + 1 🌾                                                           │
└──────────────────────────────────────────────────────────────────────────────┘
