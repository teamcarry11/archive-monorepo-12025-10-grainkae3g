#!/usr/bin/env steel

;; graincard width validator (Steel - pure Rust Scheme)
;; team: 02 (teamvault02 - taurus ♉ / ii. the high priestess)
;; authored by: 14 (teamdescend14 - ketu ☋ / xiv. temperance)
;; checks that all grain box lines are exactly 80 display characters
;; unicode-aware display width calculation

(require-builtin steel/filesystem)
(require-builtin steel/strings)

(define (char-display-width c)
  "Calculate display width of a character (unicode-aware).
   Handles box-drawing, CJK wide chars, combining marks, etc."
  (let ([code (char->integer c)])
    (cond
      [(< code 32) 0]                              ; control chars
      [(< code 127) 1]                             ; ascii
      [(and (>= code #x2500) (<= code #x257F)) 1]  ; box-drawing
      [(and (>= code #x3000) (<= code #x9FFF)) 2]  ; cjk wide
      [(and (>= code #x0300) (<= code #x036F)) 0]  ; combining marks
      [else 1])))                                  ; default

(define (string-display-width s)
  "Calculate total display width of string."
  (transduce (map char-display-width) 
             (into-sum) 
             (string->list s)))

(define (check-grain-width filepath)
  "Check a single grain file for 80-char width compliance."
  (let* ([lines (lines (read-file-to-string filepath))]
         [total-lines (length lines)]
         [filename (path/file-name filepath)])
    
    (if (not (= 116 total-lines))
        (hash "file" filename 
              "valid" #f 
              "error" (string-append "wrong total lines: " 
                                    (number->string total-lines)))
        
        (let* ([box-lines (slice lines 5 115)]  ; lines 6-115 (indices 5-114)
               [width-errors 
                (transduce 
                  (compose
                    (enumerating)
                    (mapping 
                      (lambda (pair)
                        (let* ([idx (car pair)]
                               [line (cdr pair)]
                               [width (string-display-width line)])
                          (if (not (= 80 width))
                              (hash "line" (+ idx 6) 
                                    "width" width 
                                    "content" line)
                              void))))
                    (filtering (lambda (x) (not (void? x)))))
                  (into-list)
                  box-lines)])
          
          (if (empty? width-errors)
              (hash "file" filename "valid" #t)
              (hash "file" filename "valid" #f "errors" width-errors))))))

(define (check-all-grains dir-path)
  "Check all grains in a directory."
  (let* ([files (filter (lambda (f) 
                         (and (path/is-file? f)
                              (ends-with? (path/file-name f) ".md")))
                       (read-dir dir-path))]
         [full-paths (map (lambda (f) (path/join dir-path f)) files)]
         [results (map check-grain-width full-paths)]
         [invalid (filter (lambda (r) (not (hash-get r "valid"))) results)])
    
    (hash "total" (length results)
          "valid" (- (length results) (length invalid))
          "invalid" invalid)))

(define (main args)
  "Main entry point for width validation."
  (if (empty? args)
      (begin
        (displayln "🦀 graincard width validator (Steel)")
        (displayln "checks that all grain box lines are exactly 80 display chars")
        (displayln "")
        (displayln "usage:")
        (displayln "  steel check-grain-width.scm <grain-directory>")
        (displayln "")
        (displayln "now == next + 1 🌾")
        1)
      
      (let* ([grain-dir (car args)]
             [results (check-all-grains grain-dir)]
             [total (hash-get results "total")]
             [valid (hash-get results "valid")]
             [invalid (hash-get results "invalid")])
        
        (displayln (string-append "\n📏 checking width in: " grain-dir))
        
        (for-each 
          (lambda (result)
            (let ([file (hash-get result "file")]
                  [errors (hash-try-get result "errors")])
              (displayln (string-append "\n❌ " file))
              (when errors
                (for-each
                  (lambda (err)
                    (let ([line (hash-get err "line")]
                          [width (hash-get err "width")])
                      (displayln (string-append "   line " 
                                               (number->string line) 
                                               ": " 
                                               (number->string width) 
                                               " chars (expected 80)"))))
                  errors))))
          invalid)
        
        (displayln (string-append "\n📊 " 
                                 (number->string valid) 
                                 "/" 
                                 (number->string total) 
                                 " grains have correct width"))
        
        (if (= valid total)
            (begin
              (displayln "✅ all grains valid!")
              0)
            (begin
              (displayln "⚠️  some grains need width fixes")
              1)))))

;; Run main with command-line args
(main (command-line-args))

