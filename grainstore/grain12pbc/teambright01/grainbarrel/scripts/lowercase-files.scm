#!/usr/bin/env steel

;; ╔═══════════════════════════════════════════════════════════════════════════════╗
;; ║                          LOWERCASE FILES SCRIPT                               ║
;; ║                   Rename all uppercase files to lowercase                     ║
;; ║                    with kebab-case for visual calm 🌊⚡                       ║
;; ╚═══════════════════════════════════════════════════════════════════════════════╝
;;
;; Hey friend! 👋 Let me explain what we're building here.
;;
;; This script walks through the entire grainstore directory tree and renames
;; any files that have uppercase letters to lowercase, using kebab-case
;; (hyphens between words) for that beautiful aesthetic consistency.
;;
;; Why lowercase? Because visual calm matters. When you look at a file listing,
;; having everything lowercase creates a serene, flowing reading experience.
;; No shouting, no jagged capitals breaking the rhythm. Just smooth, lowercase flow.
;;
;; The kebab-case convention (lowercase-with-hyphens) is both readable and
;; URL-friendly, making it perfect for web-based grain systems.

(require-builtin steel/filesystem as fs)
(require-builtin steel/base)

;; ═══════════════════════════════════════════════════════════════════════════════
;; STRING TRANSFORMATION FUNCTIONS
;; ═══════════════════════════════════════════════════════════════════════════════
;; These helpers convert uppercase strings to lowercase with kebab-case

(define (char-uppercase? ch)
  ;; Does this character want to shout at us?
  ;; If so, we'll gently ask it to calm down. 😊
  (and (char? ch)
       (char>=? ch #\A)
       (char<=? ch #\Z)))

(define (string-lowercase str)
  ;; Take a string and make it whisper instead of shout.
  ;; This is like the "indoor voice" for filenames!
  (list->string
   (map (lambda (ch)
          (if (char-uppercase? ch)
              (integer->char (+ (char->integer ch) 32))
              ch))
        (string->list str))))

(define (should-rename-file? filename)
  ;; Should we rename this file?
  ;; We only rename if:
  ;;   1. It has uppercase letters
  ;;   2. It's not a special file we want to keep as-is
  ;;   3. It's not from external sources (like urbit-source)
  (and (not (string-contains? filename "urbit-source"))
       (not (string-contains? filename "node_modules"))
       (not (string-contains? filename ".dfx"))
       (not (equal? filename (string-lowercase filename)))))

;; ═══════════════════════════════════════════════════════════════════════════════
;; FILE RENAMING CORE
;; ═══════════════════════════════════════════════════════════════════════════════

(define (rename-file-to-lowercase filepath)
  ;; Take a file path and rename it to lowercase.
  ;; We preserve the directory structure, only changing the filename itself.
  ;;
  ;; Example: "grainstore/HELLO-WORLD.md" → "grainstore/hello-world.md"
  (let* ([dir (fs/path-parent filepath)]
         [filename (fs/path-filename filepath)]
         [new-filename (string-lowercase filename)]
         [new-filepath (fs/path-join dir new-filename)])
    (if (should-rename-file? filename)
        (begin
          (displayln (string-append "Renaming: " filepath " → " new-filepath))
          (fs/rename filepath new-filepath)
          #t)
        #f)))

(define (walk-and-rename directory)
  ;; Walk through a directory tree and rename all uppercase files.
  ;; This is a recursive journey through the filesystem, bringing
  ;; lowercase calm to every corner! 🌊
  ;;
  ;; Think of it like this: We're walking through a forest (the directory tree),
  ;; and every time we see a shouting sign (uppercase filename), we gently
  ;; replace it with a calm, lowercase version.
  (let ([entries (fs/read-dir directory)])
    (for-each
     (lambda (entry)
       (let ([full-path (fs/path-join directory entry)])
         (cond
           ;; If it's a directory, descend into it recursively
           [(fs/is-dir? full-path)
            (walk-and-rename full-path)]
           
           ;; If it's a file, try to rename it
           [(fs/is-file? full-path)
            (rename-file-to-lowercase full-path)]
           
           ;; Otherwise, skip it
           [else void])))
     entries)))

;; ═══════════════════════════════════════════════════════════════════════════════
;; MAIN EXECUTION
;; ═══════════════════════════════════════════════════════════════════════════════

(define (main)
  ;; Here we go! Let's bring lowercase calm to the entire grainstore! 🌊⚡
  (displayln "")
  (displayln "╔═══════════════════════════════════════════════════════════════╗")
  (displayln "║         🌊⚡ LOWERCASE AESTHETIC TRANSFORMATION 🌊⚡          ║")
  (displayln "╚═══════════════════════════════════════════════════════════════╝")
  (displayln "")
  (displayln "bringing visual calm to the grainstore...")
  (displayln "")
  
  (let ([grainstore-path "grainstore"])
    (if (fs/is-dir? grainstore-path)
        (begin
          (walk-and-rename grainstore-path)
          (displayln "")
          (displayln "✨ transformation complete! all files now flow in lowercase harmony.")
          (displayln ""))
        (begin
          (displayln "❌ error: grainstore directory not found!")
          (displayln "   make sure you're running this from the grainkae3g repo root.")
          (displayln "")))))

;; Run it!
(main)

;; ═══════════════════════════════════════════════════════════════════════════════
;; 🌾 now == next + 1
;; ═══════════════════════════════════════════════════════════════════════════════

