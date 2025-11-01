#!/usr/bin/env steel
;; file-io-bench.scm - file i/o performance benchmarks
;;
;; 🌊 waterbender mode: flowing data like water
;;    read:           write:
;;    ┌────┐         ┌────┐
;;    │file│ ──────> │ app│  ← data flows
;;    └────┘         └────┘
;;      │               │
;;    kernel         kernel
;;
;; why file i/o benchmarks? file operations are common
;; in real workloads. different i/o patterns reveal
;; different overheads.
;;
;; does this make sense? sequential vs random access,
;; small vs large files, read vs write - each shows
;; different aspects of kernel performance.

(require "metrics.scm")
(require "runner.scm")
(require "specs.scm")

;; Benchmark: sequential read
;; Why sequential read? Common pattern. Measures
;; how well kernel handles sequential access.
(define (bench-sequential-read-micro file-size)
  (lambda ()
    ;; Microkernel: IPC for each read operation
    ;; Why multiple reads? Simulates real workloads.
    (let loop ((remaining file-size)
               (offset 0))
      (if (> remaining 0)
          (let ((chunk-size (min remaining 4096)))
            ;; each read requires ipc
            ;; placeholder for file operations
            ;; todo: implement using steel file api
            ;; for now, just simulate a read operation
            (loop (- remaining chunk-size) 
                  (+ offset chunk-size)))
          #t))))

(define (bench-sequential-read-mono file-size)
  (lambda ()
    ;; Monolithic: direct kernel calls
    ;; Why same pattern? Fair comparison.
    (let loop ((remaining file-size)
               (offset 0))
      (if (> remaining 0)
          (let ((chunk-size (min remaining 4096)))
            ;; placeholder for file operations
            ;; todo: implement using steel file api
            ;; for now, just simulate a read operation
            (loop (- remaining chunk-size) 
                  (+ offset chunk-size)))
          #t))))

;; Benchmark: small file write
;; Why small files? Many workloads use small files.
;; Measures overhead of file creation and writes.
(define (bench-small-write-micro)
  (lambda ()
    ;; Microkernel: IPC for each write
    ;; placeholder for file write operations
    ;; todo: implement using steel file api
    #t))

(define (bench-small-write-mono)
  (lambda ()
    ;; Monolithic: direct kernel calls
    ;; placeholder for file write operations
    ;; todo: implement using steel file api
    #t))

;; Run file I/O benchmark suite
;; Why this function? Groups file benchmarks together.
(define (run-file-io-benchmarks iterations)
  (if (not (iteration-count? iterations))
      (error "invalid iteration count"))
  (let ((results '()))
    ;; Sequential read benchmarks
    (set! results 
          (cons (compare-modes "seq-read-1mb"
                               (bench-sequential-read-micro 
                                1048576)
                               (bench-sequential-read-mono 
                                1048576)
                               iterations)
                results))
    (set! results 
          (cons (compare-modes "seq-read-10mb"
                               (bench-sequential-read-micro 
                                10485760)
                               (bench-sequential-read-mono 
                                10485760)
                               iterations)
                results))
    ;; Small write benchmark
    (set! results 
          (cons (compare-modes "small-write"
                               (bench-small-write-micro)
                               (bench-small-write-mono)
                               iterations)
                results))
    (reverse results)))

;; Export benchmarks
(provide
 bench-sequential-read-micro
 bench-sequential-read-mono
 bench-small-write-micro
 bench-small-write-mono
 run-file-io-benchmarks)

