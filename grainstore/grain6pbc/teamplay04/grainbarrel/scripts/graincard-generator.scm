#!/usr/bin/env steel
;; ┌──────────────────────────────────────────────────────────────────────────────┐
;; │ GRAINCARD GENERATOR (team04 grainbarrel → teamplay04)                        │
;; │ Generate 80×110 monospace graincards from templates                          │
;; │ Author: kae3g (kj3x39, @risc.love)                                           │
;; │ Written in Steel (Rust-embedded Scheme) with Glow G2 teaching voice          │
;; └──────────────────────────────────────────────────────────────────────────────┘

;; Hey! Welcome to the graincard generator.
;;
;; What does this script do? It creates perfectly formatted 80×110
;; knowledge cards from your content. Think of it like a printing
;; press for digital index cards.
;;
;; Why 80×110?
;; - 80 chars wide: Fits any terminal, readable on E Ink
;; - 110 lines tall: Perfect portrait format, not too long, not too short
;; - Standardized: Every grain looks the same, easy to navigate
;;
;; The format itself is the innovation. Does that make sense?

(require-builtin steel/base)

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ GRAINORDER - 6-char xbdghjklmnsvz alphabet (1,235,520 permutations)         ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

;; What's grainorder? It's our numbering system!
;; 
;; Instead of 0001, 0002, 0003... we use xbdghj, xbdghk, xbdghl...
;; Why? Because:
;; - 13 consonants (x b d g h j k l m n s v z)
;; - 6 characters long
;; - No duplicates (xbdghj ✓, xbdghh ✗)
;; - Total capacity: 1,235,520 unique cards!
;;
;; This gives us a HUGE namespace while keeping codes short and
;; pronounceable. Try saying "xbdghj" - it sounds like a word!

(define grainorder-alphabet "xbdghjklmnsvz")
(define grainorder-length 6)

(define (char-at str idx)
  "Get character at index in string. Helper function!"
  (string-ref str idx))

(define (index-of-char chars target)
  "Find the index of a character in a string.
   
   This is like searching for a specific grain in a bundle.
   You check each one until you find the match."
  
  (let loop ([idx 0])
    (if (>= idx (string-length chars))
        -1  ;; not found
        (if (equal? (char-at chars idx) target)
            idx
            (loop (+ idx 1))))))

(define (has-duplicates? lst)
  "Check if a list has duplicate elements.
   
   Grainorder codes must have NO duplicates.
   xbdghj ✓ (all different)
   xbdghh ✗ (h appears twice)
   
   This maintains uniqueness and readability!"
  
  (let ([unique (transduce (map identity) (into-hashset) lst)])
    (not (equal? (length lst) (length unique)))))

(define (list->string lst)
  "Convert a list of characters to a string."
  (apply string-append (map (lambda (c) (list->string (list c))) lst)))

(define (next-grainorder current)
  "Generate the next grainorder code.
   
   How does this work? Like counting!
   
   Normal counting:  0009 → 0010 (carry from right to left)
   Grainorder:       xbdghz → xbdgkx (same carry principle!)
   
   But we skip duplicates:
   If xbdghh would be next (duplicate h), we skip to xbdghj.
   
   This is base-13 counting with a no-duplicates rule.
   Elegant, right?"
  
  (let* ([chars (string->list grainorder-alphabet)]
         [code (string->list current)]
         [n (length chars)])
    
    (let loop ([code-vec code]
               [pos (- grainorder-length 1)])
      (if (< pos 0)
          #f  ;; overflow - we've used all possible codes!
          
          (let* ([current-char (list-ref code-vec pos)]
                 [current-idx (index-of-char grainorder-alphabet current-char)]
                 [next-idx (+ current-idx 1)])
            
            (if (< next-idx n)
                ;; Try next char at this position
                (let* ([next-char (list-ref chars next-idx)]
                       [new-code (list-set code-vec pos next-char)])
                  
                  ;; Check for duplicates
                  (if (has-duplicates? new-code)
                      (loop code-vec pos)  ;; duplicate, keep trying
                      (list->string new-code)))  ;; success!
                
                ;; Overflow at this position, carry left
                (loop (list-set code-vec pos (first chars))
                      (- pos 1))))))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ TEXT WRAPPING - 80 chars wide max                                            ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(define (wrap-text text max-width)
  "Wrap text to fit within max-width, preserving words.
   
   Why wrap instead of just truncating? Because we respect
   the integrity of words! Breaking mid-word is confusing.
   
   This is like how newspapers wrap text in columns - words
   stay whole, making reading smooth and natural.
   
   The algorithm:
   1. Split text into words
   2. Try adding each word to current line
   3. If line gets too long, start a new line
   4. Repeat until all words are placed
   
   Simple, elegant, effective!"
  
  (let ([words (string-split text " ")])
    (let loop ([remaining words]
               [lines '()]
               [current-line ""])
      
      (if (empty? remaining)
          (reverse (cons current-line lines))
          
          (let* ([word (first remaining)]
                 [test-line (if (equal? current-line "")
                               word
                               (string-append current-line " " word))])
            
            (if (<= (string-length test-line) max-width)
                ;; Word fits! Add it to current line
                (loop (rest remaining) lines test-line)
                ;; Word doesn't fit. Start new line
                (loop (rest remaining) 
                      (cons current-line lines) 
                      word)))))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ GRAINCARD TEMPLATE - 80×110 ASCII box                                        ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(define (repeat-string str n)
  "Repeat a string n times. For drawing borders!"
  (apply string-append (map (lambda (_) str) (range 0 n))))

(define (pad-line line)
  "Pad a line to exactly 78 chars (80 including │ borders).
   
   Why exactly 78? Because:
   │ (1 char) + content (78 chars) + │ (1 char) = 80 total
   
   Every line must end at the same column, creating that
   crisp box edge. Precision creates beauty!"
  
  (let* ([len (string-length line)]
         [padding-needed (- 78 len)]
         [padded (string-append line (repeat-string " " padding-needed))])
    (string-append "│ " padded " │")))

(define (generate-graincard opts)
  "Generate a complete 80×110 graincard from options.
   
   What goes into a graincard?
   - Header: Title, file path, live URL, navigation links
   - Box: 110-line ASCII bordered content area
   - Content: Your actual teaching/knowledge
   - Footer: Grainbook name, card number, signature
   
   This function orchestrates all the pieces. It's like
   assembling a book page - header, body, footer, all
   perfectly aligned and sized.
   
   The result? A beautiful, consistent, reusable format
   for knowledge transfer!"
  
  (let* ([grainorder-code (hash-get opts "code" "xbdghj")]
         [title (hash-get opts "title" "Untitled Graincard")]
         [file-path (hash-get opts "file-path" "grain.md")]
         [live-url (hash-get opts "live-url" "https://kae3g.github.io/grainkae3g/")]
         [prev-card (hash-get opts "prev-card" #f)]
         [next-card (hash-get opts "next-card" #f)]
         [content (hash-get opts "content" "Content goes here...")]
         [card-num (hash-get opts "card-num" 1)]
         [total-cards (hash-get opts "total-cards" 1235520)]
         [author (hash-get opts "author" "kae3g (kj3x39, @risc.love)")]
         [grainbook-name (hash-get opts "grainbook-name" "Grainbook Issue 1")])
    
    ;; Build header lines
    (let* ([header-lines (list
                          (string-append "# Graincard " grainorder-code " - " title)
                          ""
                          (string-append "**File**: " file-path)
                          (string-append "**Live**: " live-url))]
           
           ;; Wrap content to 78 chars
           [content-lines (string-split content "\n")]
           [wrapped-content (apply append (map (lambda (line) (wrap-text line 78)) 
                                              content-lines))]
           
           ;; Box header (2 lines)
           [box-header (list
                        (string-append "┌" (repeat-string "─" 78) "┐")
                        (pad-line (string-append "GRAINCARD " grainorder-code)))]
           
           ;; Padded content lines
           [content-padded (map pad-line wrapped-content)]
           
           ;; Calculate padding to reach line 108
           [current-lines (+ (length box-header) (length content-padded))]
           [padding-needed (max 0 (- 108 current-lines))]
           [padding-lines (map (lambda (_) (pad-line "")) (range 0 padding-needed))]
           
           ;; Box footer (5 lines)
           [box-footer (list
                        (string-append "├" (repeat-string "─" 78) "┤")
                        (pad-line (string-append "Card: " grainorder-code 
                                                 " (" (number->string card-num) 
                                                 " of " (number->string total-cards) ")"))
                        (pad-line "now == next + 1 🌾")
                        (string-append "└" (repeat-string "─" 78) "┘"))]
           
           ;; Assemble full card
           [full-card (append header-lines
                             (list "" "```")
                             box-header
                             content-padded
                             padding-lines
                             box-footer
                             (list "```"))])
      
      (string-join full-card "\n"))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ CLI INTERFACE - Parse command-line arguments                                 ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(define (parse-args args)
  "Parse command-line arguments into a hash table.
   
   How does this work? We expect pairs of arguments:
   --code xbdghj --title 'My Card' --content 'Hello!'
   
   We convert those pairs into a hash table:
   { 'code': 'xbdghj', 'title': 'My Card', 'content': 'Hello!' }
   
   This makes the data easy to work with in generate-graincard."
  
  (let loop ([remaining args]
             [opts (hash)])
    (if (< (length remaining) 2)
        opts
        (let* ([key (first remaining)]
               [val (second remaining)]
               [key-clean (string-replace key "--" "")])
          (loop (rest (rest remaining))
                (hash-insert opts key-clean val))))))

(define (main args)
  "Main entry point - generate a graincard!
   
   This orchestrates the whole process:
   1. Parse your command-line arguments
   2. Generate the graincard with beautiful formatting
   3. Write it to a file
   4. Celebrate completion!
   
   Each step is simple. Together they create a powerful
   tool for knowledge generation. That's composition!"
  
  (let* ([opts (if (empty? args) (hash) (parse-args args))]
         [grainorder-code (hash-try-get opts "code" "xbdghj")]
         [title (hash-try-get opts "title" "Untitled Graincard")]
         [content (hash-try-get opts "content" "Content goes here...")]
         [output-file (hash-try-get opts "output" 
                                     (string-append grainorder-code "-graincard.md"))])
    
    (displayln (string-append "🌾 Generating graincard " grainorder-code " ..."))
    
    (let ([card-opts (hash
                      "code" grainorder-code
                      "title" title
                      "file-path" output-file
                      "live-url" "https://kae3g.github.io/grainkae3g/"
                      "content" content
                      "total-cards" 1235520
                      "card-num" 1
                      "author" "kae3g (kj3x39, @risc.love)"
                      "grainbook-name" "Grainbook Issue 1")])
      
      (let ([card (generate-graincard card-opts)])
        ;; Write to file
        (write-file output-file card)
        (displayln (string-append "✅ Graincard saved to " output-file))
        (displayln "🎃 now == next + 1 🌾")))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ USAGE EXAMPLES                                                                ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

;; How do you use this script?
;;
;; Basic:
;;   steel graincard-generator.scm
;;
;; With custom content:
;;   steel graincard-generator.scm --code xbdghk --title "My Card" --content "Hello!"
;;
;; All options:
;;   --code      Grainorder code (xbdghj, xbdghk, etc.)
;;   --title     Card title
;;   --content   Card content (can be multi-line)
;;   --output    Output filename
;;
;; The script handles formatting, wrapping, padding - you just
;; provide the knowledge! That's separation of concerns.

;; Run it!
;; Steel scripts can check their arguments. For now, we run
;; with empty args to show the default card.
(main '())

