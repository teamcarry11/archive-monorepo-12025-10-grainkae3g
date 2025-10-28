#!/usr/bin/env steel
;;; QB KK - Print PSEUDO.md as a grainbook of graincards
;;; "kk" means "continue" - keep the momentum going!
;;;
;;; qb = QUERY       (ask, show, inspect, read - you're asking)
;;; gb = GRAINBARREL (do, execute, build - you're commanding)
;;; k  = OKAY        (simple affirmation - ready to continue!)
;;;
;;; QB commands feel like questions: "show me", "what is", "list"
;;; GB commands feel like actions: "build", "deploy", "generate"
;;;
;;; Type "qb kk" - QUERY, OKAY OKAY (show me, I'm ready!)
;;; Short, simple, flows like water.
;;; Hit return. Watch knowledge unfold. Keep momentum. 🌾
;;;
;;; Hey! This script reads PSEUDO.md and formats it as beautiful
;;; 80×110 graincards. Think of it like taking your philosophy
;;; document and turning it into a teaching deck.
;;;
;;; Written in Steel (Rust-embedded Scheme)
;;; Voice: Glow G2 (patient teacher, first principles)

(require-builtin steel/base as base)

;; What's a graincard? It's an 80-character-wide by 110-line-tall
;; text box that holds knowledge. Like a physical index card,
;; but perfectly sized for monospace terminals and E Ink displays.
(define graincard-width 80)
(define graincard-height 110)

(define (print-graincard-header)
  "Show the beautiful header that sets the mood.
   
   Why do we use ASCII box drawing? It makes terminal output
   feel intentional and crafted. We're not just dumping text -
   we're presenting knowledge."
  
  (displayln "╔══════════════════════════════════════════════════════════════════════════════╗")
  (displayln "║                                                                              ║")
  (displayln "║                    🌾 G R A I N B O O K - K K 🌾                            ║")
  (displayln "║                                                                              ║")
  (displayln "║                  PSEUDO.md as Graincard Collection                          ║")
  (displayln "║                                                                              ║")
  (displayln "╚══════════════════════════════════════════════════════════════════════════════╝")
  (displayln ""))

(define (wrap-text text width)
  "Wrap text to fit within a specified width.
   
   Why wrap text? Long lines are hard to read. By breaking text
   into ~76-character lines (leaving room for card borders),
   we make the content readable on any screen.
   
   This is like how newspapers use columns - narrower text is
   easier for eyes to scan. Functional design!"
  
  (let ([words (string-split text " ")])
    (let loop ([lines '()]
               [current-line ""]
               [remaining words])
      (if (empty? remaining)
          (reverse (cons current-line lines))
          (let* ([word (first remaining)]
                 [test-line (if (equal? current-line "")
                               word
                               (string-append current-line " " word))])
            (if (> (string-length test-line) width)
                (loop (cons current-line lines) word (rest remaining))
                (loop lines test-line (rest remaining))))))))

(define (repeat-string str n)
  "Repeat a string n times. Useful for drawing borders!
   
   Why not just type out '────────────...'? Because we want
   EXACTLY 78 characters every time. Automation ensures consistency."
  
  (apply string-append (map (lambda (_) str) (range 0 n))))

(define (pad-right str width)
  "Pad a string to a specific width with spaces.
   
   This keeps our card edges aligned perfectly. Every line should
   end at exactly the same column - that's what makes the box
   look crisp and professional."
  
  (let ([len (string-length str)])
    (if (>= len width)
        (substring str 0 width)
        (string-append str (repeat-string " " (- width len))))))

(define (print-graincard title content card-num)
  "Print a single graincard in 80×110 format.
   
   What makes a graincard special?
   - Fixed width (80 chars) - fits any terminal
   - Fixed height (110 lines) - standardized knowledge chunks
   - Beautiful borders - makes it feel crafted
   - Title header - tells you what you're learning
   - Footer - reminds you to keep going
   
   Each card is a complete unit of teaching. You could print this
   on paper, display it on E Ink, or read it in a terminal.
   The format is the same everywhere!"
  
  (displayln "")
  (displayln (string-append "┌" (repeat-string "─" 78) "┐"))
  (displayln (string-append "│ " 
                           (pad-right (string-append "Card " (number->string card-num) ": " title) 76)
                           " │"))
  (displayln (string-append "├" (repeat-string "─" 78) "┤"))
  
  ;; Wrap content and print each line
  ;; We take 105 lines for content (leaving room for header/footer)
  (let* ([lines (string-split content "\n")]
         [wrapped (apply append (map (lambda (line) (wrap-text line 76)) lines))]
         [padded (take 105 (append wrapped (repeat "")))])
    (for-each
      (lambda (line)
        (displayln (string-append "│ " (pad-right line 76) " │")))
      padded))
  
  (displayln (string-append "├" (repeat-string "─" 78) "┤"))
  (displayln (string-append "│ " (pad-right "now == next + 1 🌾" 76) " │"))
  (displayln (string-append "└" (repeat-string "─" 78) "┘"))
  (displayln ""))

(define (parse-pseudo-sections content)
  "Parse PSEUDO.md into sections that become graincards.
   
   How do we know where one card ends and another begins?
   We look for headers (lines starting with # or ##).
   
   Each header becomes a new card title. Everything between
   headers becomes that card's content. Simple structure!
   
   This is like how a book has chapters - headers divide
   the content into digestible pieces."
  
  (let ([lines (string-split content "\n")])
    (let loop ([sections '()]
               [current-title ""]
               [current-content '()]
               [remaining lines])
      (if (empty? remaining)
          ;; Done! Return all sections
          (reverse (if (not (equal? current-title ""))
                      (cons (hash "title" current-title 
                                  "content" (string-join (reverse current-content) "\n"))
                            sections)
                      sections))
          
          (let ([line (first remaining)])
            (cond
              ;; Is this a header line?
              [(or (string-starts-with? line "# ")
                   (string-starts-with? line "## "))
               ;; Save previous section if it exists
               (let ([new-sections (if (not (equal? current-title ""))
                                      (cons (hash "title" current-title
                                                  "content" (string-join (reverse current-content) "\n"))
                                            sections)
                                      sections)])
                 ;; Start new section
                 (loop new-sections
                       (string-trim (string-replace line #/^##?\s+/ ""))
                       '()
                       (rest remaining)))]
              
              ;; Is this a content line?
              [(not (string-trim (= line "")))
               (loop sections
                     current-title
                     (cons line current-content)
                     (rest remaining))]
              
              ;; Blank line - skip it
              [else
               (loop sections current-title current-content (rest remaining))]))))))

(define (file-exists? path)
  "Check if a file exists at the given path.
   
   Why do we need this? Steel doesn't have built-in file existence
   checking yet, so we try to read the file. If it works, it exists!"
  
  (with-handler
    (lambda (_) #f)
    (lambda ()
      (read-file-to-string path)
      #t)))

(define (find-pseudo-file)
  "Find PSEUDO.md somewhere in the repository.
   
   Why check multiple locations? You might run this script from
   different directories. We want it to work no matter where
   you are in the project.
   
   This is like how your brain searches for memories - you check
   the most likely places first!"
  
  (let ([possible-paths (list
                          "../../docs/core/philosophy/PSEUDO.md"
                          "docs/core/philosophy/PSEUDO.md"
                          "docs/PSEUDO.md"
                          "PSEUDO.md")])
    (let loop ([paths possible-paths])
      (if (empty? paths)
          #f
          (if (file-exists? (first paths))
              (first paths)
              (loop (rest paths)))))))

(define (main)
  "The main entry point - where the magic happens!
   
   This orchestrates everything:
   1. Show header (set expectations)
   2. Find PSEUDO.md (locate the knowledge)
   3. Parse it into sections (chunk it up)
   4. Generate graincards (make it beautiful)
   5. Show summary (celebrate completion)
   
   Each step builds on the previous one. That's functional
   composition - small functions doing one thing well,
   then combining them to create something powerful!"
  
  (print-graincard-header)
  
  (let ([pseudo-path (find-pseudo-file)])
    (if pseudo-path
        (begin
          (displayln (string-append "📖 Reading PSEUDO.md from: " pseudo-path))
          (displayln "")
          
          (let* ([content (read-file-to-string pseudo-path)]
                 [sections (parse-pseudo-sections content)])
            
            (displayln (string-append "🌾 Generating " 
                                     (number->string (length sections)) 
                                     " graincards..."))
            (displayln "")
            
            ;; Generate each graincard
            (let loop ([idx 0]
                      [remaining sections])
              (when (not (empty? remaining))
                (let ([section (first remaining)])
                  (print-graincard 
                    (hash-get section "title")
                    (hash-get section "content")
                    (+ idx 1))
                  (loop (+ idx 1) (rest remaining)))))
            
            ;; Show completion summary
            (displayln "")
            (displayln "╔══════════════════════════════════════════════════════════════════════════════╗")
            (displayln "║                                                                              ║")
            (displayln (string-append "║  " 
                                     (pad-right (string-append "Total Graincards: " 
                                                              (number->string (length sections)))
                                               74)
                                     "  ║"))
            (displayln "║                                                                              ║")
            (displayln "║                         🌾 now == next + 1 🌾                               ║")
            (displayln "║                                                                              ║")
            (displayln "╚══════════════════════════════════════════════════════════════════════════════╝")
            (displayln "")
            (displayln "🌾 Grainbook complete! From PSEUDO to graincard reality!")
            (displayln "🌾 kk - keep the momentum going!")))
        
        ;; File not found - show helpful error
        (begin
          (displayln "❌ Error: Could not find PSEUDO.md")
          (displayln "")
          (displayln "Searched locations:")
          (displayln "  • docs/core/philosophy/PSEUDO.md")
          (displayln "  • docs/PSEUDO.md")
          (displayln "  • PSEUDO.md")
          (displayln "")
          (displayln "Please ensure PSEUDO.md exists in one of these locations.")))))

;; Run it!
(main)

