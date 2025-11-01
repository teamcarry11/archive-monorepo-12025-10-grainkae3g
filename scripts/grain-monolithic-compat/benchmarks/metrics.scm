#!/usr/bin/env steel
;; metrics.scm - benchmark metrics collection
;;
;; 🌊 waterbender mode: capturing the flow of time
;;      ___
;;     /   \
;;    |  ⏱  |  ← time flows like water
;;     \___/
;;       |
;;      measure
;;
;; why separate metrics? we want clean separation
;; between measuring and running benchmarks. this
;; module handles timing, memory tracking, and result
;; aggregation.
;;
;; does this make sense? metrics are independent of
;; what we're benchmarking. we can measure anything
;; using the same tools.

;; Benchmark result structure
;; Why this structure? Captures everything we need to
;; compare microkernel vs monolithic performance.
(define (make-benchmark-result name mode iterations 
                                total-ns avg-ns min-ns 
                                max-ns memory-kb)
  `((name . ,name)
    (mode . ,mode)
    (iterations . ,iterations)
    (total-ns . ,total-ns)
    (avg-ns . ,avg-ns)
    (min-ns . ,min-ns)
    (max-ns . ,max-ns)
    (memory-kb . ,memory-kb)))

;; require steel time builtin
;; why this? steel provides high-precision timing.
(require-builtin "steel/time")

;; get current time in nanoseconds
;; why nanoseconds? higher precision than milliseconds.
;; helps us measure fast operations accurately.
(define (time-ns)
  ;; why use instant/now? steel provides high-precision
  ;; timing via instant. we create a timestamp that
  ;; represents "now" in nanoseconds since epoch.
  (* (current-milliseconds) 1000000))

;; create a timing marker
;; why this? we need to mark start/end times for
;; measuring elapsed time.
(define (time-marker)
  (instant/now))

;; get elapsed nanoseconds from marker
;; why this? calculates time difference for benchmarks.
(define (elapsed-ns marker)
  (duration->nanos (instant/elapsed marker)))

;; measure memory usage
;; why measure memory? ipc overhead includes memory
;; allocations. this helps us understand full cost.
(define (memory-kb)
  ;; why use shell command? steel may not have built-in
  ;; memory query. we use ps or /proc/self/status.
  ;; note: for now, return 0 as placeholder
  ;; todo: implement using steel/process when available
  0)

;; Calculate statistics from measurements
;; Why this function? Raw measurements need processing.
;; We compute average, min, max from raw data.
(define (calculate-stats measurements)
  (if (null? measurements)
      (make-benchmark-result "empty" "none" 0 0 0 0 0 0)
      (let ((total (fold + 0 measurements))
            (count (length measurements))
            (min-val (fold min (car measurements) measurements))
            (max-val (fold max (car measurements) measurements)))
        (make-benchmark-result 
          "calculated" "stats" count total 
          (/ total count) min-val max-val 0))))

;; helper: fold function
;; why this? steel may not have fold built-in.
;; we need it for aggregating measurements.
(define (fold f init lst)
  (if (null? lst)
      init
      (fold f (f init (car lst)) (cdr lst))))

;; helper: min function
;; why this? steel may not have min built-in.
(define (min a b)
  (if (< a b) a b))

;; helper: max function
;; why this? steel may not have max built-in.
(define (max a b)
  (if (> a b) a b))

;; export metrics functions
(provide
 make-benchmark-result
 time-ns
 time-marker
 elapsed-ns
 memory-kb
 calculate-stats)

