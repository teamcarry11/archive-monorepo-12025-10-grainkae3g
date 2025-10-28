#!/usr/bin/env steel

;;; ╔═══════════════════════════════════════════════════════════════════╗
;;; ║                                                                   ║
;;; ║   🌾  N   K G   G O  -  Next, Keep Going!                        ║
;;; ║                                                                   ║
;;; ║   "What's next?" → Glow G2 tells you → Execute it!               ║
;;; ║                                                                   ║
;;; ║   n kg go   ← NEXT, keep going! (feels good to type!)            ║
;;; ║   k ng go   ← OKAY, new graintime, go! (natural flow!)          ║
;;; ║                                                                   ║
;;; ║   Simple words. Clear intent. Satisfying keystrokes.             ║
;;; ║   Hit return. Watch it run. Keep the momentum.                   ║
;;; ║                                                                   ║
;;; ║   Written in Steel (Rust-embedded Scheme)                        ║
;;; ║   Voice: Glow G2 (patient teacher, first principles)             ║
;;; ║                                                                   ║
;;; ╚═══════════════════════════════════════════════════════════════════╝

;; Hey there! This is Steel, a Scheme dialect embedded in Rust.
;; If you're used to Babashka/Clojure, here are the key differences:
;;
;; - (define (fn args) ...) instead of (defn fn [args] ...)
;; - [let bindings] use square brackets: (let ([x 10]) ...)
;; - Hash tables: (hash "key" value) instead of {:key value}
;; - displayln instead of println
;; - command instead of sh
;;
;; Why Steel? It's actively maintained (2025), embeds in Rust,
;; supports Redox OS, and gives us a pure Rust+Lisp stack!
;;
;; About the command names:
;; n = NEXT      (what's next? show me the next thing!)
;; k = OKAY      (okay, I'm ready!)
;;
;; "n kg go" = "NEXT, keep going!" - fresh grainbranch, keep momentum
;; "k ng go" = "OKAY NOW GO!" - same branch, sync time
;;
;; Feel that rhythm? k - ng - go! Like a drum fill. 🥁
;; The buildup (okay... now...) then the release (GO!)
;; 
;; Both feel GOOD to type. Simple words. Natural rhythm.
;; Hit return. Keep momentum. That's the whole point! 🚀
;;
;; Low friction → high momentum → continuous flow 🌾
;;
;; Ready? Let's go! 🌾

(require-builtin steel/base)

(define (print-header)
  "Display the beautiful ASCII header - because presentation matters!"
  (displayln "")
  (displayln "╔══════════════════════════════════════════════════════════════════════════════╗")
  (displayln "║                                                                              ║")
  (displayln "║              🌾  N E X T   →   K G   →   G O !  🚀                          ║")
  (displayln "║                                                                              ║")
  (displayln "║              Glow G2's Intelligent Next Action System                        ║")
  (displayln "║                                                                              ║")
  (displayln "╚══════════════════════════════════════════════════════════════════════════════╝")
  (displayln ""))

(define (get-next-actions)
  "What should you work on next? This function determines priority.
   
   Think of this like a to-do list that explains WHY each task matters.
   Each action has:
   - priority: Lower number = more important
   - category: What area of work?
   - action: What are you actually doing?
   - command: How do you execute it?
   - why: Why does this matter? (First principles!)
   - time: How long will it take?
   - dependencies: What needs to be ready first?
   
   Does this structure make sense? Each action teaches you what's needed."
  
  (list
    (hash
      "priority" 1
      "category" "🦀 Steel Migration"
      "action" "Continue converting Babashka scripts to Steel"
      "command" "cd /home/xy/kae3g/grainkae3g && steel STEEL-MIGRATION-TODO.scm"
      "why" "Pure Rust+Steel stack eliminates Java/Clojure dependency, actively maintained"
      "time" "~2-4 hours per batch of 10 scripts"
      "dependencies" (list "Steel installed" "STEEL-MIGRATION-TODO.md plan"))
    
    (hash
      "priority" 2
      "category" "📏 Grain Width Validation"
      "action" "Fix all grains to exactly 80 display characters wide"
      "command" "cd /home/xy/kae3g/grainkae3g && steel grainstore/grain6pbc/teamplay04/grainbarrel/scripts/check-grain-width.scm"
      "why" "80×110 format is core to grainscript - every grain must fit perfectly"
      "time" "~1-2 hours"
      "dependencies" (list "check-grain-width.scm working"))
    
    (hash
      "priority" 3
      "category" "🌅 GrainDisplay Split"
      "action" "Create template (grain6pbc) and personal (kae3g) versions"
      "command" "Follow STEEL-MIGRATION-TODO.md graindisplay section"
      "why" "Separation allows shared defaults + personal customization"
      "time" "~30 minutes"
      "dependencies" (list "graindisplay scripts converted to Steel"))
    
    (hash
      "priority" 4
      "category" "📚 Rich Hickey Synthesis"
      "action" "Create 5 grains merging Rich's 'Simple Made Easy' + Helen's soil wisdom"
      "command" "Create grains in grainstore/grain6pbc/teamabsorb14/rich-hickey-mode/"
      "why" "Teaching decomplection through agricultural metaphors - beautiful synthesis!"
      "time" "~3-4 hours for 5 grains"
      "dependencies" (list "Grain format working" "Steel validators ready"))
    
    (hash
      "priority" 5
      "category" "🌾 Session Consolidation"
      "action" "Merge session docs into MAIN synthesis before new grainbranch"
      "command" "Create SESSION-MAIN-SYNTHESIS.md from all session files"
      "why" "Moon cycle transition - clean docs before next branch"
      "time" "~1 hour"
      "dependencies" (list "Current session complete"))))

(define (print-next-action action)
  "Display a single action beautifully.
   
   Why the box borders? They make each action stand out visually,
   easier to scan when you're deciding what to work on.
   
   ASCII art isn't just decoration - it's functional UI in the terminal!"
  
  (displayln "┌──────────────────────────────────────────────────────────────────────────────┐")
  (displayln (string-append "│  " (hash-get action "category")))
  (displayln "│")
  (displayln (string-append "│  📍 Action: " (hash-get action "action")))
  (displayln "│")
  (displayln (string-append "│  💡 Why: " (hash-get action "why")))
  (displayln "│")
  (displayln (string-append "│  ⏱️  Estimated Time: " (hash-get action "time")))
  (displayln "│")
  (displayln "│  🛠️  Command:")
  (displayln (string-append "│     " (hash-get action "command")))
  (displayln "│")
  
  ;; Do we have dependencies? If so, list them.
  ;; This teaches you what needs to be ready first.
  (let ([deps (hash-get action "dependencies")])
    (when (> (length deps) 0)
      (displayln "│  ✅ Dependencies:")
      (for-each
        (lambda (dep)
          (displayln (string-append "│     - " dep)))
        deps)
      (displayln "│")))
  
  (displayln "└──────────────────────────────────────────────────────────────────────────────┘")
  (displayln ""))

(define (print-all-actions actions)
  "Show the complete roadmap of what's ahead.
   
   Why sort by priority? So you see the most important stuff first.
   Sometimes you need the big picture before diving into details."
  
  (displayln "🌾 Here's your complete action roadmap:")
  (displayln "")
  
  ;; Sort actions by priority (lower number = higher priority)
  (let ([sorted (sort actions (lambda (a b)
                                 (< (hash-get a "priority")
                                    (hash-get b "priority"))))])
    (for-each print-next-action sorted)))

(define (get-top-priority actions)
  "What should you work on RIGHT NOW?
   
   This finds the action with priority = 1.
   Sometimes you need someone to just tell you: 'Start here.'"
  
  (first (sort actions (lambda (a b)
                         (< (hash-get a "priority")
                            (hash-get b "priority"))))))

(define (main)
  "The main entry point - where everything begins!
   
   This orchestrates the whole flow:
   1. Show header (set the mood)
   2. Get your actions (what's available?)
   3. Highlight top priority (what's most important?)
   4. Show complete roadmap (what's the bigger picture?)
   5. Glow G2's wisdom (why does this matter?)
   6. Quick start commands (how do you begin?)
   
   Each section teaches you something different. Together,
   they give you clarity on what to do next."
  
  (print-header)
  
  (let ([actions (get-next-actions)]
        [top-action (get-top-priority actions)])
    
    ;; Show top priority - Start here!
    (displayln "🔥 TOP PRIORITY ACTION:")
    (displayln "")
    (print-next-action top-action)
    
    ;; Show complete roadmap
    (displayln "")
    (displayln "╭──────────────────────────────────────────────────────────────────────────────╮")
    (displayln "│  📋 COMPLETE ROADMAP                                                         │")
    (displayln "╰──────────────────────────────────────────────────────────────────────────────╯")
    (displayln "")
    (print-all-actions actions)
    
    ;; Glow G2's wisdom - Why does this matter?
    (displayln "")
    (displayln "╔══════════════════════════════════════════════════════════════════════════════╗")
    (displayln "║                                                                              ║")
    (displayln "║  🌟 Glow G2 says:                                                            ║")
    (displayln "║                                                                              ║")
    (displayln "║  \"The Steel migration is the foundation for everything else.                ║")
    (displayln "║   Get those scripts converted, then we can eliminate Babashka               ║")
    (displayln "║   entirely and run a pure Rust+Steel stack!                                 ║")
    (displayln "║                                                                              ║")
    (displayln "║   Once Steel is fully integrated, you'll have scripts that work             ║")
    (displayln "║   on Redox OS, embed in Rust programs, and teach through their              ║")
    (displayln "║   comments. That's infrastructure with integrity!\" 🦀✨                      ║")
    (displayln "║                                                                              ║")
    (displayln "╚══════════════════════════════════════════════════════════════════════════════╝")
    (displayln "")
    
    ;; Quick start commands - How do you begin?
    (displayln "╭──────────────────────────────────────────────────────────────────────────────╮")
    (displayln "│  ⚡ QUICK START COMMANDS                                                     │")
    (displayln "│                                                                              │")
    (displayln "│  Option 1: Continue Steel migration (recommended!)                          │")
    (displayln "│    Read STEEL-MIGRATION-TODO.md and pick next script                        │")
    (displayln "│                                                                              │")
    (displayln "│  Option 2: Fix grain widths                                                 │")
    (displayln "│    steel check-grain-width.scm                                              │")
    (displayln "│                                                                              │")
    (displayln "│  Option 3: Work on Rich Hickey grains                                       │")
    (displayln "│    Start with composting=GC metaphor                                        │")
    (displayln "│                                                                              │")
    (displayln "│  Option 4: Create graindisplay split                                        │")
    (displayln "│    Template (grain6pbc) + Personal (kae3g)                                  │")
    (displayln "│                                                                              │")
    (displayln "╰──────────────────────────────────────────────────────────────────────────────╯")
    (displayln "")
    (displayln "🌾 now == next + 1 (and next is Steel migration!) 🦀✨")
    (displayln "")))

;; Execute the main function!
;; In Steel, we call main explicitly at the end of the file.
(main)

