#!/usr/bin/env steel
;; runner.scm - benchmark execution framework
;;
;; 🌊 waterbender mode: directing the flow of tests
;;      start
;;        |
;;     ┌──┴──┐
;;     │ run │  ← flow through benchmarks
;;     └──┬──┘
;;        |
;;      stop
;;
;; why separate runner? execution logic is different
;; from metrics collection. this handles running
;; benchmarks and collecting raw data.
;;
;; does this make sense? we can swap different
;; runners without changing how we measure.

(require "metrics.scm")

;; run benchmark function multiple times
;; why multiple iterations? single runs can vary.
;; averaging gives us more reliable results.
(define (run-benchmark name mode bench-fn iterations)
  ;; why these parameters? name identifies what we're
  ;; testing. mode tells us microkernel vs monolithic.
  ;; bench-fn is what we're timing. iterations is how
  ;; many times to run it.
  (let ((measurements '())
        (memory-start (memory-kb)))
    ;; run function iterations times
    ;; why use time-marker? more accurate than time-ns
    ;; difference. instant/elapsed gives precise duration.
    (let loop ((i 0))
      (if (< i iterations)
          (let ((marker (time-marker)))
            (let ((result (bench-fn))
                  (elapsed (elapsed-ns marker)))
              (set! measurements 
                    (cons elapsed measurements))
              (loop (+ i 1))))
          (let ((memory-end (memory-kb))
                (stats (calculate-stats measurements)))
            ;; add name and mode to stats
            stats)))))

;; run benchmark in microkernel mode
;; why separate function? makes it clear which mode
;; we're testing. easier to compare results.
(define (run-microkernel-benchmark name bench-fn iterations)
  (run-benchmark name "microkernel" bench-fn iterations))

;; run benchmark in monolithic mode
;; why separate function? same reason - clarity.
;; we can see which mode each result belongs to.
(define (run-monolithic-benchmark name bench-fn iterations)
  (run-benchmark name "monolithic" bench-fn iterations))

;; Compare two benchmark results
;; Why this function? We need to see the difference
;; between microkernel and monolithic performance.
;; Returns comparison result with overhead percentage.
(define (compare-results micro-result mono-result)
  ;; Calculate overhead percentage
  ;; Why overhead? Tells us how much IPC costs us.
  ;; Positive = microkernel slower, negative = faster.
  (let ((micro-avg (cdr (assoc 'avg-ns micro-result)))
        (mono-avg (cdr (assoc 'avg-ns mono-result))))
    (if (> mono-avg 0)
        (make-benchmark-result 
          (cdr (assoc 'name micro-result))
          "comparison"
          1
          (* 100 (/ (- micro-avg mono-avg) mono-avg))
          (* 100 (/ (- micro-avg mono-avg) mono-avg))
          0
          0
          0)
        (make-benchmark-result 
          (cdr (assoc 'name micro-result))
          "comparison"
          1
          0
          0
          0
          0
          0))))

;; compare microkernel vs monolithic modes
;; why this function? convenience wrapper for comparing
;; the same benchmark in both modes.
(define (compare-modes name micro-fn mono-fn iterations)
  (let ((micro-result 
          (run-benchmark name "microkernel" micro-fn 
                        iterations))
        (mono-result 
          (run-benchmark name "monolithic" mono-fn 
                        iterations)))
    ;; return both results for detailed comparison
    (list micro-result mono-result)))

;; Export runner functions
(provide
 run-benchmark
 run-microkernel-benchmark
 run-monolithic-benchmark
 compare-results
 compare-modes)

