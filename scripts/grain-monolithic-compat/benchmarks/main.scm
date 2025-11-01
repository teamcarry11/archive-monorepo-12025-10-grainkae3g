#!/usr/bin/env steel
;; main.scm - Benchmark suite entry point
;;
;; 🌊 waterbender mode: flowing benchmarks through time
;;    ___         ___
;;   /   \~~~v~~~/   \
;;  |     |     |     |
;;  |  ~  |  ~  |  ~  |
;;   \___/     \___/
;;     |         |
;;   flow      measure
;;
;; why a main file? provides single entry point for
;; running all benchmarks. makes it easy to execute
;; the full test suite.
;;
;; does this make sense? users shouldn't need to know
;; about individual benchmark modules. they just run
;; the main script and get comprehensive results.

(require "metrics.scm")
(require "runner.scm")
(require "specs.scm")
(require "utils.scm")
(require "syscall-bench.scm")
(require "file-io-bench.scm")
(require "process-bench.scm")

;; Default iteration count
;; Why 1000 iterations? Balances accuracy and time.
;; More iterations = more accurate, but slower.
(define default-iterations 1000)

;; detect if running on redox
;; why this? benchmarks only meaningful on redox vs linux.
;; on ubuntu/linux, both modes run on same monolithic kernel.
(define (detect-system)
  ;; check for redox-specific paths or environment
  ;; note: this is a placeholder - actual detection may vary
  (let ((os-type (getenv "OS")))
    (if (and os-type (string-contains? os-type "redox"))
        "redox"
        "linux")))

;; helper: check if string contains substring
(define (string-contains? str substr)
  (let ((str-len (string-length str))
        (substr-len (string-length substr)))
    (let loop ((i 0))
      (if (> (+ i substr-len) str-len)
          #f
          (if (string=? (substring str i (+ i substr-len)) substr)
              #t
              (loop (+ i 1)))))))

;; helper: get environment variable (placeholder)
;; why placeholder? steel may not have getenv yet.
(define (getenv name)
  ;; todo: implement using steel's env api when available
  #f)

;; run all benchmarks
;; why this function? provides complete comparison.
;; users want to see all results together.
;; important: benchmarks only meaningful when comparing
;; redox (microkernel) vs linux (monolithic) results.
;; running on ubuntu/linux measures abstraction overhead,
;; not real ipc differences.
(define (run-all-benchmarks iterations)
  ;; why validate? catch errors early.
  (if (not (iteration-count? iterations))
      (error "invalid iteration count"))
  (displayln "=========================================================")
  (displayln "microkernel vs monolithic benchmark suite")
  (displayln "=========================================================")
  (displayln "")
  (displayln "⚠️  important: these benchmarks only show real")
  (displayln "   microkernel vs monolithic differences when")
  (displayln "   comparing results from redox os (microkernel)")
  (displayln "   vs linux (monolithic).")
  (displayln "")
  (displayln "   running on ubuntu/linux measures abstraction")
  (displayln "   overhead, not actual ipc differences.")
  (displayln "")
  (displayln (string-append 
              "running benchmarks with " 
              (number->string iterations) 
              " iterations each..."))
  (displayln "")
  ;; Run each benchmark suite
  (let ((syscall-results (run-syscall-benchmarks iterations))
        (file-results (run-file-io-benchmarks iterations))
        (process-results (run-process-benchmarks iterations)))
    ;; Display results
    ;; Why flatten results? compare-modes returns pairs.
    ;; We want to show both micro and mono results.
    (define (display-result-pair pair)
      ;; why check if pair? compare-modes returns list of two.
      (if (and (list? pair) (= (length pair) 2))
          (let ((micro-result (car pair))
                (mono-result (cadr pair)))
            (displayln (format-result micro-result))
            (displayln (format-result mono-result))
            ;; show overhead percentage
            (let ((micro-avg (cdr (assoc 'avg-ns micro-result)))
                  (mono-avg (cdr (assoc 'avg-ns mono-result))))
              (if (> mono-avg 0)
                  (let ((overhead-pct (* 100 (/ (- micro-avg mono-avg) mono-avg))))
                    (displayln (string-append 
                               "  overhead: " 
                               (number->string (round overhead-pct))
                               "%")))
                  (displayln "  overhead: n/a")))
            (displayln ""))
          (displayln (format-result pair))))
    (displayln "=====================================================")
    (displayln "syscall benchmarks:")
    (displayln "=====================================================")
    (for-each display-result-pair syscall-results)
    (displayln "")
    (displayln "=====================================================")
    (displayln "file I/O benchmarks:")
    (displayln "=====================================================")
    (for-each display-result-pair file-results)
    (displayln "")
    (displayln "=====================================================")
    (displayln "process benchmarks:")
    (displayln "=====================================================")
    (for-each display-result-pair process-results)
    (displayln "")
    (displayln "=====================================================")
    (displayln "benchmark suite complete")
    (displayln "=====================================================")))

;; Main entry point
;; Why this structure? Handles command-line arguments.
;; Users can specify iteration count if desired.
(define (main)
  (let ((args (command-line)))
    (if (null? args)
        ;; Default: run with default iterations
        (run-all-benchmarks default-iterations)
        ;; Custom: parse iteration count from args
        (let ((iterations (string->number (car args))))
          (if iterations
              (run-all-benchmarks iterations)
              (begin
                (displayln "usage: main.scm [iterations]")
                (displayln 
                 "  iterations: number of times to run each benchmark")
                (displayln "  default: 1000")))))))

;; run benchmarks with small iteration count for testing
;; note: using 10 iterations for quick testing
(run-all-benchmarks 10)

