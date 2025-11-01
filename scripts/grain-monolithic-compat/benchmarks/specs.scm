#!/usr/bin/env steel
;; specs.scm - benchmark type specifications
;;
;; 🌊 waterbender mode: validating the flow
;;      input
;;        │
;;     ┌──▼──┐
;;     │check│  ← validate like filtering water
;;     └──┬──┘
;;        │
;;     valid
;;
;; why specs? validate benchmark data before we use it.
;; catch errors early, make code more reliable.
;;
;; does this make sense? specs tell us what shape our
;; data should have. like type checking, but at runtime.

;; benchmark mode spec
;; what is a benchmark mode? either "microkernel" or
;; "monolithic". why only these two? those are the
;; two architectures we're comparing.
(define (benchmark-mode? x)
  (or (equal? x "microkernel")
      (equal? x "monolithic")))

;; iteration count spec
;; what is an iteration count? number of times to run
;; a benchmark. why must it be positive? zero runs
;; gives us no data. negative runs don't make sense.
(define (iteration-count? x)
  (and (integer? x) (> x 0)))

;; nanosecond time spec
;; what is nanosecond time? a time measurement in
;; nanoseconds. why non-negative? time can't go
;; backwards in our measurements.
(define (nanosecond-time? x)
  (and (number? x) (>= x 0)))

;; benchmark name spec
;; what is a benchmark name? a string identifying the
;; benchmark. why non-empty? empty names aren't useful.
(define (benchmark-name? x)
  (and (string? x) (> (string-length x) 0)))

;; Export specs
(provide
 benchmark-mode?
 iteration-count?
 nanosecond-time?
 benchmark-name?)

