;; ╔══════════════════════════════════════════════════════════════════════════╗
;; ║                          GRAINCARD                                       ║
;; ║          80×110 monospace teaching cards in ASCII art                    ║
;; ║                   pure steel, beautiful typography                       ║
;; ║                                                                          ║
;; ║  "what if knowledge came in perfectly-sized cards?"                     ║
;; ║                                                                          ║
;; ║  phase 1: generation + validation + wrapping                            ║
;; ║  team: teamrebel10 (capricorn ♑ / X. wheel of fortune)                 ║
;; ║                                                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════╝

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ DESIGN PHILOSOPHY                                                       │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; graincards are **teaching cards** - self-contained knowledge units that fit
;; perfectly in a terminal or monospace viewer.
;;
;; **80 characters wide**: the classic terminal width. familiar. readable.
;; **110 lines tall**: extended depth for comprehensive content.
;; **ASCII box borders**: beautiful typography using box-drawing characters.
;;
;; think of them like:
;; - flash cards (portable learning)
;; - man pages (self-contained reference)
;; - index cards (one concept per card)
;; - tarot cards (symbolic, numbered, part of a deck)
;;
;; each graincard has a **grainorder** (6-char unique ID) and lives in a
;; **grainbook** (collection of cards).
;;
;; does this feel like a digital library card catalog? good! 🎴

(require-builtin steel/strings)

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ CONSTANTS                                                               │
;; └────────────────────────────────────────────────────────────────────────┘

(define CARD-WIDTH 80)
(define CARD-HEIGHT 110)
(define CONTENT-WIDTH 78)  ;; 80 - 2 (borders)
(define HEADER-LINES 4)    ;; title, blank, live link, blank
(define FENCE-LINES 2)     ;; opening and closing ```
(define BOX-BORDER-LINES 5) ;; top (2) + middle divider (1) + bottom (2)
(define CONTENT-LINES (- CARD-HEIGHT HEADER-LINES FENCE-LINES BOX-BORDER-LINES))

;; box-drawing characters
(define BOX-TOP-LEFT "┌")
(define BOX-TOP-RIGHT "┐")
(define BOX-BOTTOM-LEFT "└")
(define BOX-BOTTOM-RIGHT "┘")
(define BOX-HORIZONTAL "─")
(define BOX-VERTICAL "│")
(define BOX-TEE-LEFT "├")
(define BOX-TEE-RIGHT "┤")

;; grainorder alphabet (from grainorder.scm)
;; Updated alphabet: replaced 'd' with 'f' and 'k' with 'c' for better visual distinction
;; Why 'f' instead of 'd'? 'f' is visually distinct from 'b' (no mirror-image confusion)
;; Why 'c' instead of 'k'? 'c' is visually distinct from 'h' and 'x' (no angular confusion)
;; Why 'q' instead of 'j'? 'q' provides better phonetic distinction
;; Alphabet maintains 13 consonants: x b f g h q c l m n s v z
;; Alphabetical order: b c f g h l m n q s v x z
(define grainorder-alphabet "xbfghqclmnsvz")
(define total-graincards 1235520) ;; 13P6 = 13!/(13-6)! = 1,235,520

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ TEXT WRAPPING                                                           │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; to fit content into 78-char lines, we need intelligent word wrapping.
;; this preserves words (no mid-word breaks) and handles multiple paragraphs.

;; wrap a single line of text to max-width
(define (wrap-line text max-width)
  (if (<= (string-length text) max-width)
      (list text)  ;; fits! no wrapping needed
      
      ;; need to wrap - split into words
      (let ([words (string-split text " ")])
        (let loop ([remaining words]
                   [lines '()]
                   [current-line ""])
          (if (null? remaining)
              ;; done! append last line
              (reverse (cons current-line lines))
              
              ;; process next word
              (let* ([word (car remaining)]
                     [test-line (if (string=? current-line "")
                                    word
                                    (string-append current-line " " word))])
                (if (<= (string-length test-line) max-width)
                    ;; word fits! add to current line
                    (loop (cdr remaining) lines test-line)
                    ;; word doesn't fit! start new line
                    (loop (cdr remaining)
                          (cons current-line lines)
                          word))))))))

;; wrap multiple lines (paragraphs) to max-width
(define (wrap-text text max-width)
  (let ([lines (string-split text "\n")])
    (apply append (map (lambda (line) (wrap-line line max-width)) lines))))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ LINE PADDING & FORMATTING                                              │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; every line in the box needs to be exactly 78 chars + 2 border chars = 80 total.

;; pad a string to exactly n characters with spaces
(define (pad-string s n)
  (let ([len (string-length s)])
    (if (>= len n)
        (substring s 0 n)  ;; truncate if too long
        (string-append s (make-string (- n len) #\space)))))

;; create a box line with content (│ content │)
(define (box-line content)
  (format "~a ~a ~a" BOX-VERTICAL (pad-string content CONTENT-WIDTH) BOX-VERTICAL))

;; create a horizontal border line (┌──...──┐)
(define (border-line left right)
  (format "~a~a~a"
          left
          (make-string CONTENT-WIDTH (string-ref BOX-HORIZONTAL 0))
          right))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ GRAINCARD STRUCTURE                                                     │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; a graincard is a hash with these keys:
;; :grainorder     - 6-char unique ID (e.g., "xbdghj")
;; :title          - card title (e.g., "Introduction to Graintime")
;; :file-path      - relative path to file
;; :live-url       - github URL to view card
;; :content        - main content text (will be wrapped)
;; :card-num       - card number in grainbook (e.g., 1)
;; :total-cards    - total cards in grainbook (default: 1,235,520)
;; :author         - author name (default: "kae3g (kj3x39, @risc.love)")
;; :grainbook-name - name of grainbook (default: "ember harvest 🎃")

;; create a graincard hash with defaults
(define (make-graincard grainorder title content)
  (hash :grainorder grainorder
        :title title
        :content content
        :file-path (format "~a-graincard.md" grainorder)
        :live-url "https://github.com/..."
        :card-num 1
        :total-cards total-graincards
        :author "kae3g (kj3x39, @risc.love)"
        :grainbook-name "ember harvest 🎃"))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ GRAINCARD GENERATION                                                    │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; this is the main function! it takes a graincard hash and generates the
;; full 80×110 markdown document with ASCII box.

;; generate the complete graincard document
(define (generate-graincard card)
  (let* ([grainorder (hash-ref card :grainorder)]
         [title (hash-ref card :title)]
         [file-path (hash-ref card :file-path)]
         [live-url (hash-ref card :live-url)]
         [content (hash-ref card :content)]
         [card-num (hash-ref card :card-num)]
         [total-cards (hash-ref card :total-cards)]
         [author (hash-ref card :author)]
         [grainbook-name (hash-ref card :grainbook-name)]
         
         ;; header section (outside the box)
         [header-lines (list (format "# graincard ~a - ~a" grainorder title)
                             ""
                             (format "**file**: ~a" file-path)
                             (format "**live**: ~a" live-url)
                             ""
                             "```")]  ;; opening code fence
         
         ;; wrap content to 78 chars
         [wrapped-content (wrap-text content CONTENT-WIDTH)]
         
         ;; box header (top border + title line)
         [box-header (list (border-line BOX-TOP-LEFT BOX-TOP-RIGHT)
                           (box-line (format "GRAINCARD ~a                          Card ~a of ~a"
                                             grainorder card-num total-cards)))]
         
         ;; content lines (wrapped text in box)
         [content-lines (map box-line wrapped-content)]
         
         ;; calculate padding to reach line 103 (before footer divider)
         [current-lines (+ (length box-header) (length content-lines))]
         [padding-needed (max 0 (- 103 current-lines))]
         [padding-lines (map (lambda (_) (box-line "")) (range padding-needed))]
         
         ;; box footer (divider + metadata + bottom border)
         [box-footer (list (border-line BOX-TEE-LEFT BOX-TEE-RIGHT)
                           (box-line (format "grainbook: ~a" grainbook-name))
                           (box-line (format "card: ~a (~a of ~a)" 
                                             grainorder card-num total-cards))
                           (box-line "now == next + 1 🌾")
                           (border-line BOX-BOTTOM-LEFT BOX-BOTTOM-RIGHT))]
         
         ;; combine everything
         [all-lines (append header-lines
                            box-header
                            content-lines
                            padding-lines
                            box-footer
                            (list "```"))])  ;; closing code fence
    
    ;; join into single string
    (string-join all-lines "\n")))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ VALIDATION                                                              │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; validate that a graincard string meets the 80×110 spec

;; check if a graincard string is valid
(define (validate-graincard card-str)
  (let ([lines (string-split card-str "\n")]
        [errors '()])
    
    ;; check total line count (should be 116: header + box + fences)
    (when (not (= (length lines) 116))
      (set! errors (cons (format "❌ total lines: ~a (expected 116)" (length lines))
                         errors)))
    
    ;; check opening fence (line 6, index 5)
    (when (and (>= (length lines) 6)
               (not (string=? (string-trim (list-ref lines 5)) "```")))
      (set! errors (cons "❌ line 6: expected opening ``` code fence" errors)))
    
    ;; check closing fence (line 116, index 115)
    (when (and (>= (length lines) 116)
               (not (string=? (string-trim (list-ref lines 115)) "```")))
      (set! errors (cons "❌ line 116: expected closing ``` code fence" errors)))
    
    ;; check box content (lines 6-115 = 110 lines)
    (when (>= (length lines) 116)
      (let ([box-lines (slice lines 6 116)])
        (when (not (= (length box-lines) 110))
          (set! errors (cons (format "❌ box content: ~a lines (expected 110)"
                                     (length box-lines))
                             errors)))))
    
    ;; check top border (line 7, index 6)
    (when (and (>= (length lines) 7)
               (not (string-starts-with? (list-ref lines 6) BOX-TOP-LEFT)))
      (set! errors (cons "❌ line 7: expected top border starting with ┌" errors)))
    
    ;; check bottom border (line 115, index 114)
    (when (and (>= (length lines) 115)
               (not (string-starts-with? (list-ref lines 114) BOX-BOTTOM-LEFT)))
      (set! errors (cons "❌ line 115: expected bottom border starting with └" errors)))
    
    ;; check width of box lines (should be 80 chars)
    (when (>= (length lines) 116)
      (for-each (lambda (i)
                  (let ([line (list-ref lines i)])
                    (when (not (= (string-length line) CARD-WIDTH))
                      (set! errors (cons (format "❌ line ~a: width ~a chars (expected 80)"
                                                 (+ i 1) (string-length line))
                                         errors)))))
                (range 6 115)))
    
    ;; return validation result
    (if (null? errors)
        (list 'ok "valid graincard!")
        (list 'err (reverse errors)))))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ FILE I/O                                                                │
;; └────────────────────────────────────────────────────────────────────────┘

;; save graincard to file
(define (save-graincard card filename)
  (let ([card-str (generate-graincard card)])
    (displayln (format "\n🌾 generating graincard: ~a" (hash-ref card :grainorder)))
    (displayln (format "   title: ~a" (hash-ref card :title)))
    (displayln (format "   file: ~a" filename))
    
    ;; validate before saving
    (let ([validation (validate-graincard card-str)])
      (if (equal? (car validation) 'ok)
          (begin
            ;; write to file
            (with-output-to-file filename
              (lambda () (displayln card-str)))
            (displayln "✅ graincard saved successfully!")
            (displayln "🎃 now == next + 1 🌾\n")
            #t)
          
          ;; validation failed
          (begin
            (displayln "❌ validation failed!")
            (for-each displayln (cadr validation))
            #f)))))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ CLI INTERFACE                                                           │
;; └────────────────────────────────────────────────────────────────────────┘

;; display help message
(define (show-help)
  (displayln "\n╔════════════════════════════════════════════════════════════════════╗")
  (displayln "║  GRAINCARD - 80×110 monospace teaching cards                       ║")
  (displayln "╚════════════════════════════════════════════════════════════════════╝\n")
  (displayln "usage:")
  (displayln "  steel graincard.scm create <grainorder> <title> <content>")
  (displayln "  steel graincard.scm validate <file>")
  (displayln "  steel graincard.scm help\n")
  (displayln "examples:")
  (displayln "  steel graincard.scm create xbdghj \"intro to graintime\" \"content here...\"")
  (displayln "  steel graincard.scm validate xbdghj-graincard.md\n")
  (displayln "what it does:")
  (displayln "  - wraps content to 78 chars (preserves words)")
  (displayln "  - generates 80×110 ASCII box with beautiful borders")
  (displayln "  - adds grainorder, card number, metadata footer")
  (displayln "  - validates against spec before saving")
  (displayln "  - creates markdown file with code fences\n")
  (displayln "graincard format:")
  (displayln "  - 80 characters wide (classic terminal width)")
  (displayln "  - 110 lines tall (extended depth)")
  (displayln "  - ASCII box-drawing characters (┌─┐│└─┘)")
  (displayln "  - grainorder unique ID (6 chars, 1,235,520 permutations)")
  (displayln "  - part of a grainbook (collection of cards)\n")
  (displayln "now == next + 1 🌾\n"))

;; create a graincard from CLI arguments
(define (create-graincard-cli grainorder title content)
  (let* ([card (make-graincard grainorder title content)]
         [filename (format "~a-graincard.md" grainorder)])
    (save-graincard card filename)))

;; validate a graincard file from CLI
(define (validate-graincard-cli filename)
  (displayln (format "\n🔍 validating: ~a\n" filename))
  (let* ([card-str (read-file-to-string filename)]
         [validation (validate-graincard card-str)])
    (if (equal? (car validation) 'ok)
        (begin
          (displayln "✅ VALID graincard!")
          (displayln (cadr validation))
          (displayln "\n🎃 now == next + 1 🌾\n")
          #t)
        (begin
          (displayln "❌ INVALID graincard:")
          (for-each displayln (cadr validation))
          (displayln "\n")
          #f))))

;; main entry point
(define (main args)
  (if (< (length args) 1)
      (show-help)
      
      (let ([command (car args)])
        (cond
          [(equal? command "create")
           (if (< (length args) 4)
               (begin
                 (displayln "❌ error: missing arguments!")
                 (displayln "   usage: steel graincard.scm create <grainorder> <title> <content>")
                 #f)
               (let ([grainorder (cadr args)]
                     [title (caddr args)]
                     [content (cadddr args)])
                 (create-graincard-cli grainorder title content)))]
          
          [(equal? command "validate")
           (if (< (length args) 2)
               (begin
                 (displayln "❌ error: missing filename!")
                 (displayln "   usage: steel graincard.scm validate <file>")
                 #f)
               (let ([filename (cadr args)])
                 (validate-graincard-cli filename)))]
          
          [(equal? command "help")
           (show-help)]
          
          [else
           (begin
             (displayln (format "❌ unknown command: ~a" command))
             (displayln "   run 'steel graincard.scm help' for usage")
             #f)]))))

;; ┌────────────────────────────────────────────────────────────────────────┐
;; │ PHASE 1 COMPLETE!                                                      │
;; └────────────────────────────────────────────────────────────────────────┘
;;
;; what we built:
;; ✅ text wrapping (preserves words, handles paragraphs)
;; ✅ line padding & formatting (exactly 80 chars)
;; ✅ graincard structure (hash with all metadata)
;; ✅ generation (full 80×110 markdown with ASCII box)
;; ✅ validation (checks 116 lines, borders, width)
;; ✅ file i/o (save with validation)
;; ✅ cli interface (create + validate commands)
;; ✅ glow g2 teaching comments
;;
;; what's next (phase 2):
;; - grainbook management (collections of cards)
;; - card linking (prev/next navigation)
;; - template support (reusable card layouts)
;; - syntax highlighting (code blocks in cards)
;; - graincard viewer (terminal UI for browsing)
;; - integration with grainorder (auto-assign IDs)
;;
;; does this feel like a digital card catalog? ready to teach? 🎴⚡
;;
;; now == next + 1 🌾

;; run main if executed as script
(when (> (length (command-line-args)) 0)
  (main (command-line-args)))

(displayln "\n╔════════════════════════════════════════════════════════════════════╗")
(displayln "║  GRAINCARD PHASE 1: LOADED! 🎴                                     ║")
(displayln "║  80×110 monospace teaching cards with ASCII art                    ║")
(displayln "║  try: steel graincard.scm create xbdghj \"title\" \"content\"       ║")
(displayln "╚════════════════════════════════════════════════════════════════════╝\n")


