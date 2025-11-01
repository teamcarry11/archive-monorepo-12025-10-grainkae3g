#!/usr/bin/env steel
;; utils.scm - benchmark utility functions
;;
;; 🌊 waterbender mode: helpful tools flowing everywhere
;;      tool
;;        │
;;     ┌──┴──┐
;;     │ use │  ← reusable helpers
;;     └──┬──┘
;;        │
;;    results
;;
;; why separate utilities? common operations used across
;; benchmarks. keeps benchmark code focused on testing.
;;
;; does this make sense? utilities are reusable helpers.
;; they don't depend on benchmark-specific logic.

;; Format nanoseconds as microseconds
;; Why this function? Nanoseconds are hard to read.
;; Microseconds are more human-friendly.
(define (ns-to-us ns)
  ;; Why divide by 1000? 1 microsecond = 1000 nanoseconds.
  (/ ns 1000.0))

;; Format nanoseconds as milliseconds
;; Why this function? Some benchmarks are slow enough
;; that milliseconds are easier to read.
(define (ns-to-ms ns)
  ;; Why divide by 1000000? 1 millisecond = 1M nanoseconds.
  (/ ns 1000000.0))

;; Calculate percentage difference
;; Why this function? Shows relative overhead clearly.
;; Easier to understand than raw nanosecond differences.
(define (percent-diff old-val new-val)
  ;; Why check for zero? Division by zero is undefined.
  (if (= old-val 0)
      0
      (* 100 (/ (- new-val old-val) old-val))))

;; Format benchmark result as string
;; Why this function? Makes results readable.
;; Humans need formatted output, not raw data structures.
(define (format-result result)
  (let ((name (cdr (assoc 'name result)))
        (mode (cdr (assoc 'mode result)))
        (avg-ns (cdr (assoc 'avg-ns result)))
        (min-ns (cdr (assoc 'min-ns result)))
        (max-ns (cdr (assoc 'max-ns result))))
    (string-append
     name " (" mode "): "
     "avg=" (number->string (ns-to-us avg-ns)) "us "
     "min=" (number->string (ns-to-us min-ns)) "us "
     "max=" (number->string (ns-to-us max-ns)) "us")))

;; Export utility functions
(provide
 ns-to-us
 ns-to-ms
 percent-diff
 format-result)
