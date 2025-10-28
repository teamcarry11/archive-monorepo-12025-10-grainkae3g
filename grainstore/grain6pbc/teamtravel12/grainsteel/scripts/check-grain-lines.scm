#!/usr/bin/env steel

;; grain line count validator (Steel - pure Rust Scheme)
;; team: 12 (teamtravel12 - pisces ♓ / xii. the hanged man)
;; authored by: 14 (teamabsorb14 - ketu ☋ / xiv. temperance)
;; checks that all grain boxes have exactly 110 lines (between fences)

(require-builtin steel/filesystem)
(require-builtin steel/strings)

(define (count-box-lines filepath)
  "Count lines within the ASCII box (between fences, excluding fences)."
  (let* ([content (read-file-to-string filepath)]
         [lines (lines content)]
         [total-lines (length lines)]
         [fence-indices 
          (transduce 
            (compose
              (enumerating)
              (filtering (lambda (pair) 
                          (starts-with? (cdr pair) "```")))
              (mapping car))
            (into-list)
            lines)])
    
    (if (< (length fence-indices) 2)
        (hash "file" filepath "error" "No ASCII box fences found")
        
        (let* ([opening-fence-idx (first fence-indices)]
               [closing-fence-idx (last fence-indices)]
               [box-start (+ opening-fence-idx 1)]  ; Line after opening ```
               [box-end (- closing-fence-idx 1)]     ; Line before closing ```
               [box-lines (+ (- box-end box-start) 1)]  ; Inclusive count
               [diff (- box-lines 110)])
          
          (hash "file" filepath
                "total" total-lines
                "box-lines" box-lines
                "box-start" box-start
                "box-end" box-end
                "target" 110
                "diff" diff
                "needs-work" (not (= box-lines 110)))))))

(define (check-all-grains base-dir)
  "Check all grain markdown files across all modes."
  (let ([modes (list "grains-glow-g2-mode" "grains-helen-mode" "grains-davinci-mode" 
                     "grains-ariana-mode" "grains-oxford-mode" "grains-rich-mode")])
    
    (transduce
      (compose
        (mapping (lambda (mode)
                  (let ([mode-dir (path/join base-dir mode)])
                    (if (path/exists? mode-dir)
                        (let ([files (filter 
                                      (lambda (f)
                                        (and (path/is-file? (path/join mode-dir f))
                                             (ends-with? f ".md")
                                             (starts-with? f "x")))
                                      (read-dir mode-dir))])
                          (map (lambda (f)
                                (let ([result (count-box-lines (path/join mode-dir f))])
                                  (hash-insert result "mode" mode)))
                               files))
                        '()))))
        (flattening))
      (into-list)
      modes)))

(define (print-results results)
  "Pretty print the results."
  (displayln "\n✧･ﾟ:* GRAIN LINE COUNT ANALYSIS ✧･ﾟ:*\n")
  
  ; Group by mode
  (let ([modes (transduce (mapping (lambda (r) (hash-get r "mode")))
                         (into-hashset)
                         results)])
    
    (for-each
      (lambda (mode)
        (displayln (string-append "=== " mode " ==="))
        (let ([mode-results (filter (lambda (r) (equal? mode (hash-get r "mode"))) 
                                   results)])
          (for-each
            (lambda (r)
              (let ([filename (last (split (hash-get r "file") "/"))]
                    [error (hash-try-get r "error")])
                (if error
                    (display (string-append "  " 
                                          (pad-right filename 45) 
                                          " ERROR: " 
                                          error 
                                          "\n"))
                    (display (string-append "  "
                                          (pad-right filename 45)
                                          " "
                                          (pad-left (number->string (hash-get r "box-lines")) 3)
                                          " lines (need "
                                          (if (> (hash-get r "diff") 0) "+" "")
                                          (number->string (hash-get r "diff"))
                                          ") "
                                          (if (hash-get r "needs-work") "❌" "✅")
                                          "\n")))))
            mode-results))
        (displayln ""))
      (hash-keys->list modes)))
  
  (let* ([total (length results)]
         [perfect (length (filter (lambda (r) (not (hash-get r "needs-work"))) results))]
         [need-work (length (filter (lambda (r) (hash-get r "needs-work")) results))])
    (displayln (string-append "Total grains: " (number->string total)))
    (displayln (string-append "Perfect (110 lines): " (number->string perfect) " ✅"))
    (displayln (string-append "Need adjustment: " (number->string need-work) " ❌\n"))))

;; Helper functions for padding strings
(define (pad-right s width)
  "Pad string to the right with spaces."
  (let ([len (string-length s)])
    (if (>= len width)
        s
        (string-append s (make-string (- width len) #\space)))))

(define (pad-left s width)
  "Pad string to the left with spaces."
  (let ([len (string-length s)])
    (if (>= len width)
        s
        (string-append (make-string (- width len) #\space) s))))

;; Main execution
(let* ([base-dir "grainstore/grain6pbc/teamabsorb14/gkd-prompt-execution--12025-10-27--0145-PDT--moon-p_ashadha----asc-leo023-sun-03h----teamabsorb14"]
       [results (check-all-grains base-dir)])
  (print-results results))

(displayln "now == next + 1 ✧･ﾟ:* 🌾\n")

