#!/usr/bin/env steel
;; test-time.scm - test time measurement functions
;;
;; 🌊 waterbender mode: testing the flow of time
;;      start
;;        │
;;     ⏱────⏱  ← measure flow
;;        │
;;      stop
;;
;; why this test? verify our time measurement works
;; before running actual benchmarks.

(require-builtin "steel/time")
(require "metrics.scm")

(displayln "=========================================================")
(displayln "testing time measurement functions")
(displayln "=========================================================")
(displayln "")

;; test time-ns
(displayln "testing time-ns:")
(let ((t1 (time-ns))
      (t2 (time-ns)))
  (displayln (string-append "  first call: " 
                           (number->string t1)))
  (displayln (string-append "  second call: " 
                           (number->string t2)))
  (if (> t2 t1)
      (displayln "  ✅ time increases correctly")
      (displayln "  ⚠️  time may not be working")))
(displayln "")

;; test current-second (steel builtin)
(displayln "testing current-second:")
(let ((s (current-second)))
  (displayln (string-append "  current time: " 
                           (number->string s)))
  (if (> s 0)
      (displayln "  ✅ seconds function works")
      (displayln "  ❌ seconds function failed")))
(displayln "")

;; test memory-kb
(displayln "testing memory-kb:")
(let ((mem (memory-kb)))
  (displayln (string-append "  memory: " 
                           (number->string mem) " kb"))
  (if (> mem 0)
      (displayln "  ✅ memory measurement works")
      (displayln "  ⚠️  memory may not be available")))
(displayln "")

(displayln "=========================================================")
(displayln "time test complete")
(displayln "=========================================================")

