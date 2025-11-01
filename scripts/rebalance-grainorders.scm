#!/usr/bin/env steel
;; rebalance-grainorders.scm - rebalance grainorder codes in steel
;; 
;; assigns unique grainorder codes maintaining chronological order
;; newest files get smallest codes (alphabetically first)
;; handles duplicates, listen-part ordering, and dash padding cleanup
;;
;; why steel instead of python?
;; steel is the unified scripting language for grain network.
;; this aligns with our philosophy: one language for everything.
;; steel runs natively on redox os, compiles to wasm for icp,
;; and provides the same memory safety as rust.
;;
;; does this make sense? we're building infrastructure that works
;; across all grain network platforms: redox, linux, icp canisters.
;; steel gives us that portability.

;; alphabet (13 consonants in alphabetical order)
(define alphabet "bcfghlmnqsvxz")
(define alphabet-length 13)
(define grainorder-length 6)

;; character position in alphabet
;; why this function? we need to know where characters are
;; in the alphabet to generate new codes.
(define (char-position c)
  (let loop ([chars (string->list alphabet)]
             [pos 0])
    (if (null? chars)
        -1  ; not found
        (if (char=? (car chars) c)
            pos
            (loop (cdr chars) (+ pos 1))))))

;; string-contains? helper
;; why this? steel may not have string-contains? built-in.
(define (string-contains? str substr)
  (let ([substr-len (string-length substr)]
        [str-len (string-length str)])
    (let loop ([i 0])
      (if (> (+ i substr-len) str-len)
          #f
          (if (string=? (substring str i (+ i substr-len)) substr)
              #t
              (loop (+ i 1)))))))

;; find next smaller character than c, not in forbidden string
;; why smaller? because we're generating codes backwards
;; (largest first, then smaller ones).
(define (find-smaller c forbidden)
  (let ([pos (char-position c)])
    (if (< pos 0)
        #f
        (let loop ([i (- pos 1)])
          (if (< i 0)
              #f
              (let ([candidate (string-ref alphabet i)])
                (if (string-contains? forbidden (string candidate))
                    (loop (- i 1))
                    candidate)))))))

;; find largest character not in forbidden string
;; why largest? because we're resetting positions to right
;; (shallower positions get largest available chars).
(define (find-largest forbidden)
  (let loop ([i (- alphabet-length 1)])
    (if (< i 0)
        #f
        (let ([candidate (string-ref alphabet i)])
          (if (string-contains? forbidden (string candidate))
              (loop (- i 1))
              candidate)))))

;; get previous (smaller) grainorder code
;; uses place-value thinking: start at position 1 (rightmost),
;; try to decrement. if can't, carry left (go deeper).
;; why this algorithm? it generates codes in descending order,
;; which we then reverse to get ascending order for assignment.
(define (prev-grainorder current)
  (if (not (= (string-length current) grainorder-length))
      #f
      (let ([try-position
             (lambda (pos)
               (if (> pos grainorder-length)
                   #f
                   (let* ([left (substring current 0 (- grainorder-length pos))]
                          [char-here (string-ref current (- grainorder-length pos))]
                          [smaller (find-smaller char-here left)])
                     (if smaller
                         ;; found smaller char! use it and reset positions to right
                         (let ([built (string-append left (string smaller))])
                           (let loop ([p (- pos 1)]
                                      [b built])
                             (if (<= p 0)
                                 b
                                 (let ([largest (find-largest b)])
                                   (if largest
                                       (loop (- p 1) (string-append b (string largest)))
                                       b)))))
                         ;; no smaller char, carry left (go deeper)
                         (try-position (+ pos 1))))))])
        (try-position 1))))

;; parse grainorder filename
;; extracts grainorder code, timestamp, and rest of filename
;; why regex? filenames follow a pattern:
;; {grainorder}-{YYYY-MM-DD}--{HHMM}-{tz}-{rest}.md
(define (parse-grainorder-filename filename)
  ;; check if filename matches pattern
  (if (and (string-prefix? filename "xzv")
           (string-suffix? filename ".md"))
      (let* ([parts (string-split filename "-")]
             [grainorder (if (>= (length parts) 1) (car parts) "")])
        (if (and (= (string-length grainorder) grainorder-length)
                 (string-prefix? grainorder "xzv"))
            (let* ([year (if (>= (length parts) 2) (list-ref parts 1) "")]
                   [month (if (>= (length parts) 3) (list-ref parts 2) "")]
                   [day (if (>= (length parts) 4) (list-ref parts 3) "")]
                   [dash-dash (if (>= (length parts) 5) (list-ref parts 4) "")]
                   [time-str (if (>= (length parts) 6) (list-ref parts 5) "")]
                   [tz (if (>= (length parts) 7) (list-ref parts 6) "")])
              (if (and (= (string-length year) 5)
                       (= (string-length month) 2)
                       (= (string-length day) 2)
                       (string=? dash-dash "--"))
                  (let ([timestamp (string-append year "-" month "-" day "--" time-str "-" tz)]
                        [rest (string-join (list-tail parts 7) "-")])
                    (hash 'grainorder grainorder
                          'timestamp timestamp
                          'rest rest
                          'full-path filename))
                  #f))
            #f))
      #f))

;; convert timestamp to comparable integer
;; format: YYYY-MM-DD--HHMM-tz
;; example: 12025-10-31--2145-pdt → 1202510312145
;; why integer? so we can sort chronologically.
(define (timestamp-to-int timestamp)
  (let* ([parts (string-split timestamp "--")]
         [date-part (if (>= (length parts) 1) (car parts) "")]
         [time-part (if (>= (length parts) 2) (cadr parts) "")])
    (if (string=? time-part "")
        0
        (let* ([time-str (car (string-split time-part "-"))]
               [time (if (>= (string-length time-str) 4)
                        (substring time-str 0 4)
                        "0000")]
               [date-parts (string-split date-part "-")]
               [year (if (>= (length date-parts) 1) (car date-parts) "")]
               [month (if (>= (length date-parts) 2) (cadr date-parts) "")]
               [day (if (>= (length date-parts) 3) (caddr date-parts) "")])
          (if (and (string=? year "") (string=? month "") (string=? day ""))
              0
              (let ([combined (string-append year month day time)])
                (string->number combined 10)))))))

;; extract part number from listen-part filename
;; why this helper? steel may not have regex match groups.
;; we parse manually instead.
(define (extract-part-number rest)
  (let ([pos (string-contains? rest "listen-part-")])
    (if pos
        (let* ([start (+ pos 12)]  ; "listen-part-" is 12 chars
               [end-pos (let loop ([i start])
                          (if (>= i (string-length rest))
                              (string-length rest)
                              (if (char-numeric? (string-ref rest i))
                                  (loop (+ i 1))
                                  i)))])
          (if (> end-pos start)
              (let ([num-str (substring rest start end-pos)])
                (string->number num-str 10))
              #f))
        #f)))

;; sort key for files
;; handles listen-part files specially: part 3 (newest) → part 2 → part 1 (oldest)
;; why special handling? because listen-part files share same timestamp,
;; but part 3 should be treated as newest.
(define (file-sort-key parsed-file)
  (let* ([ts-int (timestamp-to-int (hash-ref parsed-file 'timestamp))]
         [rest (hash-ref parsed-file 'rest)]
         [part-num (extract-part-number rest)])
    (if part-num
        ;; with reverse sort, higher values come first
        ;; so part 3 (newest) should have highest value
        (list ts-int part-num rest)
        (list ts-int rest))))

;; basename helper
;; why this? steel may not have basename built-in.
;; we extract filename from path manually.
(define (basename path)
  (let ([parts (string-split path "/")])
    (if (null? parts)
        ""
        (car (reverse parts)))))

;; dirname helper
;; why this? steel may not have dirname built-in.
;; we extract directory from path manually.
(define (dirname path)
  (let ([parts (string-split path "/")])
    (if (<= (length parts) 1)
        "."
        (string-join (reverse (cdr (reverse parts))) "/"))))

;; find markdown files in directory
;; why shell command? steel may not have built-in directory listing yet.
;; we use find command that works on both posix and redox.
(define (find-markdown-files dir)
  (let ([result (command (string-append "find " dir " -name '*.md' -type f"))])
    (if (= (command-exit-code result) 0)
        (let ([output (command-stdout result)])
          (filter (lambda (file)
                    (and (not (string=? file ""))
                         (let ([base (basename file)])
                           (and (>= (string-length base) 3)
                                (string-prefix? base "xzv")))))
                  (string-split output "\n")))
        '())))

;; generate new grainorder codes
;; strategy: generate many codes, sort alphabetically,
;; assign smallest to newest files
;; why this strategy? because we want newest files to have
;; smallest codes (alphabetically first).
(define (generate-grainorder-codes count)
  (let loop ([current-code "xzvsnm"]  ; start from large code
             [generated '()]
             [i 0])
    (if (or (>= i (* count 2))  ; generate more than we need
            (not current-code))
        (take (sort generated string<?) count)  ; sort and take smallest
        (let ([prev (prev-grainorder current-code)])
          (if prev
              (loop prev (cons prev generated) (+ i 1))
              (take (sort generated string<?) count))))))

;; clean up rest part of filename
;; removes leading dashes, ensures single dash separator
;; why cleanup? because filenames sometimes have excessive dashes
;; which makes them harder to read.
(define (clean-rest rest)
  (let* ([cleaned (string-trim-left rest #\-)]
         [result (if (and (not (string=? cleaned ""))
                          (not (string-prefix? cleaned "-")))
                    (string-append "-" cleaned)
                    cleaned)])
    result))

;; main rebalance function
;; why this structure? we separate concerns:
;; 1. find files (reading)
;; 2. parse filenames (understanding)
;; 3. sort files (ordering)
;; 4. generate codes (assignment)
;; 5. rename files (writing)
(define (rebalance-grainorders directory-path)
  (displayln "")
  (displayln (string-append "=" (make-string 60 #\=)))
  (displayln "  GRAINORDER REBALANCE 🔄")
  (displayln (string-append "=" (make-string 60 #\=)))
  (displayln "")
  (displayln (string-append "Directory: " directory-path))
  (displayln "")
  
  ;; find all markdown files
  (let ([files (find-markdown-files directory-path)])
    (if (null? files)
        (begin
          (displayln "✓ No grainorder files found")
          #t)
        ;; parse filenames
        (let ([parsed (filter (lambda (p) p)
                              (map (lambda (file)
                                     (let ([p (parse-grainorder-filename (basename file))])
                                       (if p
                                           (hash-set p 'full-path file)
                                           #f)))
                                   files))])
          (if (null? parsed)
              (begin
                (displayln "✓ No grainorder files found")
                #t)
              (begin
                (displayln (string-append "Found " (number->string (length parsed)) " files to rebalance (ensuring unique codes)"))
                (displayln "")
                
                ;; sort files (newest first)
                (let ([sorted-files (sort parsed
                                          (lambda (a b)
                                            (let ([key-a (file-sort-key a)]
                                                  [key-b (file-sort-key b)])
                                              ;; compare keys (newest first = reverse sort)
                                              (not (lexical<? key-a key-b)))))])
                  
                  ;; generate new codes
                  (let ([new-codes (generate-grainorder-codes (length sorted-files))])
                    
                    ;; show plan
                    (displayln "Rebalancing plan (newest → oldest):")
                    (displayln "Strategy: Assign unique codes using alphabet (bcfghlmnqsvxz)")
                    (displayln "         Newest files get smallest codes")
                    (displayln "")
                    
                    ;; show assignment preview
                    (displayln "Assignment verification (newest → oldest):")
                    (let loop ([files sorted-files]
                               [codes new-codes]
                               [i 1])
                      (if (and (not (null? files))
                                (not (null? codes))
                                (<= i 10))
                          (let* ([file (car files)]
                                 [sandbox-code (car codes)]
                                 [old-code (hash-ref file 'grainorder)]
                                 [timestamp (hash-ref file 'timestamp)]
                                 [rest (hash-ref file 'rest)])
                            (displayln (string-append "  " 
                                                      (number->string i)
                                                      ". "
                                                      timestamp
                                                      "  "
                                                      old-code
                                                      " → "
                                                      sandbox-code
                                                      "  ("
                                                      (if (> (string-length rest) 50)
                                                          (string-append (substring rest 0 50) "...")
                                                          rest)
                                                      ")"))
                            (loop (cdr files) (cdr codes) (+ i 1)))))
                    
                    (if (> (length sorted-files) 10)
                        (displayln (string-append "  ... (" 
                                                  (number->string (- (length sorted-files) 10))
                                                  " more files)")))
                    
                    ;; prompt for confirmation
                    (displayln "")
                    (display "⚠️  This will rename files! Continue? (y/n): ")
                    (flush-output-port (current-output-port))
                    (let ([response (read-line)])
                      (if (and response (string=? (string-trim response) "y"))
                          (begin
                            (displayln "")
                            (displayln "🔄 Renaming files...")
                            (displayln "")
                            
                            ;; rename each file
                            (let loop ([files sorted-files]
                                       [codes new-codes]
                                       [renamed 0])
                              (if (and (not (null? files))
                                       (not (null? codes)))
                                  (let* ([file (car files)]
                                         [new-code (car codes)]
                                         [old-path (hash-ref file 'full-path)]
                                         [timestamp (hash-ref file 'timestamp)]
                                         [rest (hash-ref file 'rest)]
                                         [cleaned-rest (clean-rest rest)]
                                         [new-filename (string-append new-code
                                                                      "-"
                                                                      timestamp
                                                                      cleaned-rest)]
                                         [new-path (string-append (dirname old-path)
                                                                  "/"
                                                                  new-filename)]
                                         [mv-result (command (string-append "mv \"" old-path "\" \"" new-path "\""))])
                                    (begin
                                      (displayln (string-append "  → " new-filename))
                                      (loop (cdr files) (cdr codes) (+ renamed 1))))
                                  (begin
                                    (displayln "")
                                    (displayln (string-append "✅ Rebalancing complete! (" (number->string renamed) " files renamed)"))
                                    (displayln "🌾 now == next + 1")
                                    (displayln "")
                                    #t)))))))))))))

;; test functions
;; why tests? we want to verify our logic works correctly
;; before using it on real files. tests help catch bugs early.

;; test char-position
(define (test-char-position)
  (and (= (char-position (string-ref "b" 0)) 0)
       (= (char-position (string-ref "c" 0)) 1)
       (= (char-position (string-ref "f" 0)) 2)
       (= (char-position (string-ref "z" 0)) 12)
       (= (char-position (string-ref "d" 0)) -1)  ; d not in alphabet
       (= (char-position (string-ref "a" 0)) -1))) ; a not in alphabet

;; test find-smaller
(define (test-find-smaller)
  (and (char=? (find-smaller (string-ref "c" 0) "") (string-ref "b" 0))
       (char=? (find-smaller (string-ref "f" 0) "") (string-ref "c" 0))
       (equal? (find-smaller (string-ref "b" 0) "") #f)  ; no smaller than b
       (equal? (find-smaller (string-ref "c" 0) "b") #f))) ; b forbidden

;; test find-largest
(define (test-find-largest)
  (and (char=? (find-largest "") (string-ref "z" 0))
       (char=? (find-largest "z") (string-ref "x" 0))
       (equal? (find-largest alphabet) #f))) ; all forbidden

;; test prev-grainorder
(define (test-prev-grainorder)
  (let ([result1 (prev-grainorder "xzvsnm")]
        [result2 (prev-grainorder "xzvnsb")]
        [result3 (prev-grainorder "invalid")])
    (and (string? result1)
         (string<? result1 "xzvsnm")  ; should be smaller
         (= (string-length result1) 6)
         (equal? result3 #f)))) ; invalid length

;; test timestamp-to-int
(define (test-timestamp-to-int)
  (and (= (timestamp-to-int "12025-10-31--2145-pdt") 1202510312145)
       (= (timestamp-to-int "12025-10-30--1330-pdt") 1202510301330)
       (> (timestamp-to-int "12025-10-31--2340-pdt")
          (timestamp-to-int "12025-10-31--2145-pdt")))) ; newer > older

;; test extract-part-number
(define (test-extract-part-number)
  (and (= (extract-part-number "listen-part-03-autumn.md") 3)
       (= (extract-part-number "listen-part-01-something.md") 1)
       (equal? (extract-part-number "no-part-here.md") #f)))

;; test string-contains?
(define (test-string-contains?)
  (and (string-contains? "listen-part-03" "listen-part")
       (string-contains? "hello world" "world")
       (not (string-contains? "hello" "world"))))

;; test clean-rest
(define (test-clean-rest)
  (and (string=? (clean-rest "hello") "-hello")
       (string=? (clean-rest "--hello") "-hello")
       (string=? (clean-rest "---hello") "-hello")
       (string=? (clean-rest "") "")))

;; run all tests
;; why this function? runs all tests and reports results.
;; helps verify our implementation before using it.
(define (run-tests)
  (displayln "")
  (displayln "running tests...")
  (displayln "")
  
  (let ([results (list (list "char-position" (test-char-position))
                       (list "find-smaller" (test-find-smaller))
                       (list "find-largest" (test-find-largest))
                       (list "prev-grainorder" (test-prev-grainorder))
                       (list "timestamp-to-int" (test-timestamp-to-int))
                       (list "extract-part-number" (test-extract-part-number))
                       (list "string-contains?" (test-string-contains?))
                       (list "clean-rest" (test-clean-rest)))])
    (let loop ([results results]
               [passed 0]
               [failed 0])
      (if (null? results)
          (begin
            (displayln "")
            (displayln (string-append "tests passed: " (number->string passed)))
            (displayln (string-append "tests failed: " (number->string failed)))
            (if (= failed 0)
                (begin
                  (displayln "✅ all tests passed!")
                  #t)
                (begin
                  (displayln "❌ some tests failed")
                  #f)))
          (let* ([result (car results)]
                 [name (car result)]
                 [passed? (cadr result)])
            (begin
              (if passed?
                  (displayln (string-append "✅ " name))
                  (displayln (string-append "❌ " name)))
              (loop (cdr results)
                    (if passed? (+ passed 1) passed)
                    (if passed? failed (+ failed 1)))))))))

;; main entry point
;; why this structure? checks command-line arguments,
;; then calls rebalance function or runs tests.
(define (main)
  (let ([args (command-line)])
    (cond
     [(and (>= (length args) 2)
           (string=? (list-ref args 1) "test"))
      ;; run tests
      (run-tests)]
     [(< (length args) 2)
      (begin
        (displayln "Usage: steel rebalance-grainorders.scm <directory|test>")
        (displayln "  test     - run test suite")
        (displayln "  <dir>    - rebalance grainorders in directory")
        #f)]
     [else
      (rebalance-grainorders (list-ref args 1))])))

;; run main
;; why call main here? when script executes, start the main function.
;; this is standard scheme pattern: define functions, then call main.
(main)

