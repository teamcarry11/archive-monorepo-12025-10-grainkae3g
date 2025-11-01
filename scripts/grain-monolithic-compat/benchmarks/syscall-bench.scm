#!/usr/bin/env steel
;; syscall-bench.scm - system call overhead benchmarks
;;
;; 🌊 waterbender mode: measuring the flow of syscalls
;;    microkernel:     monolithic:
;;      app              app
;;       │                │
;;    ┌──▼──┐          ┌─▼─┐
;;    │ ipc │          │ k │  ← kernel
;;    └──┬──┘          └─┬─┘
;;       │                │
;;      kernel           (direct)
;;
;; why syscall benchmarks? ipc overhead is the main
;; cost difference between microkernel and monolithic
;; kernels. we need to measure this directly.
;;
;; does this make sense? every syscall in a microkernel
;; requires ipc. monolithic kernels do direct calls.
;; this benchmark measures that difference.

(require "metrics.scm")
(require "runner.scm")
(require "specs.scm")
(require "../syscall-layer.scm")

;; benchmark: null syscall (no-op)
;; why null syscall? measures pure ipc overhead.
;; no actual work, just the cost of crossing boundaries.
;; note: on ubuntu/linux, both modes run on monolithic kernel.
;; real differences only visible when comparing redox vs linux.
(define (bench-null-syscall-micro)
  ;; microkernel: requires ipc to kernel
  ;; (on redox, this would be real ipc)
  (lambda ()
    ;; why batch syscall? reduces ipc overhead.
    ;; but still requires at least one ipc roundtrip.
    (batch-syscall 'read 0 "" 0)
    (flush-syscall-batch)))

(define (bench-null-syscall-mono)
  ;; monolithic: direct kernel call
  ;; (on linux, this would be real direct call)
  ;; (on ubuntu running this script, both are simulated)
  (lambda ()
    ;; why direct call? no ipc boundary to cross.
    ;; just a function call in the same address space.
    (batch-syscall 'read 0 "" 0)
    (flush-syscall-batch)))

;; Benchmark: file open syscall
;; Why file open? Common operation with clear overhead.
;; File operations are frequent in real workloads.
(define (bench-open-syscall-micro)
  (lambda ()
    ;; Microkernel: IPC to filesystem server
    (batch-syscall 'open "/dev/null" '())
    (flush-syscall-batch)))

(define (bench-open-syscall-mono)
  (lambda ()
    ;; Monolithic: direct VFS call
    (batch-syscall 'open "/dev/null" '())
    (flush-syscall-batch)))

;; Benchmark: read syscall
;; Why read syscall? Measures data transfer overhead.
;; IPC requires copying data between processes.
(define (bench-read-syscall-micro buffer-size)
  ;; Why parameter? Different buffer sizes show scaling.
  ;; Small buffers vs large buffers behave differently.
  (lambda ()
    ;; Microkernel: IPC with data copy
    (batch-syscall 'read 0 "" buffer-size)
    (flush-syscall-batch)))

(define (bench-read-syscall-mono buffer-size)
  (lambda ()
    ;; Monolithic: direct memory access
    (batch-syscall 'read 0 "" buffer-size)
    (flush-syscall-batch)))

;; Run syscall benchmark suite
;; Why this function? Groups related benchmarks together.
;; Makes it easy to run all syscall tests.
(define (run-syscall-benchmarks iterations)
  ;; Why validate iterations? Ensure we have valid input.
  (if (not (iteration-count? iterations))
      (error "invalid iteration count"))
  (let ((results '()))
    ;; Null syscall benchmark
    (set! results 
          (cons (compare-modes "null-syscall"
                               (bench-null-syscall-micro)
                               (bench-null-syscall-mono)
                               iterations)
                results))
    ;; Open syscall benchmark
    (set! results 
          (cons (compare-modes "open-syscall"
                               (bench-open-syscall-micro)
                               (bench-open-syscall-mono)
                               iterations)
                results))
    ;; Read syscall benchmarks (different sizes)
    (set! results 
          (cons (compare-modes "read-syscall-1k"
                               (bench-read-syscall-micro 1024)
                               (bench-read-syscall-mono 1024)
                               iterations)
                results))
    (set! results 
          (cons (compare-modes "read-syscall-64k"
                               (bench-read-syscall-micro 65536)
                               (bench-read-syscall-mono 65536)
                               iterations)
                results))
    (reverse results)))

;; Export benchmarks
(provide
 bench-null-syscall-micro
 bench-null-syscall-mono
 bench-open-syscall-micro
 bench-open-syscall-mono
 bench-read-syscall-micro
 bench-read-syscall-mono
 run-syscall-benchmarks)

