#!/usr/bin/env steel
;; process-bench.scm - process spawning benchmarks
;;
;; 🌊 waterbender mode: processes like water droplets
;;      parent
;;        │
;;     ┌──┴──┐
;;     │fork │  ← splits like water
;;     └──┬──┘
;;        │
;;    ┌───┴───┐
;;   child   child
;;
;; why process benchmarks? process creation overhead
;; differs between microkernel and monolithic kernels.
;; ipc setup vs direct kernel calls.
;;
;; does this make sense? fork/exec operations reveal
;; how efficiently kernels handle process creation.
;; important for workloads that spawn many processes.

(require "metrics.scm")
(require "runner.scm")
(require "specs.scm")

;; benchmark: process spawn
;; why process spawn? measures process creation cost.
;; common in shell scripts and service managers.
;; note: using placeholder for now. steel's command api
;; needs wait->stdout or wait to get results.
(define (bench-spawn-micro)
  (lambda ()
    ;; microkernel: ipc to process manager
    ;; placeholder: return true for now
    ;; todo: implement using steel/process wait->stdout
    #t))

(define (bench-spawn-mono)
  (lambda ()
    ;; monolithic: direct kernel call
    ;; placeholder: return true for now
    ;; todo: implement using steel/process wait->stdout
    #t))

;; benchmark: fork overhead
;; why fork? measures process duplication cost.
;; fork is cheaper than exec, but still has overhead.
(define (bench-fork-micro)
  (lambda ()
    ;; microkernel: ipc to create new process
    ;; note: actual fork requires kernel support
    ;; placeholder: return true for now
    ;; todo: implement using steel/process spawn-process
    #t))

(define (bench-fork-mono)
  (lambda ()
    ;; monolithic: direct kernel call
    ;; placeholder: return true for now
    ;; todo: implement using steel/process spawn-process
    #t))

;; Run process benchmark suite
;; Why this function? Groups process benchmarks.
(define (run-process-benchmarks iterations)
  (if (not (iteration-count? iterations))
      (error "invalid iteration count"))
  (let ((results '()))
    ;; Spawn benchmark
    (set! results 
          (cons (compare-modes "spawn"
                               (bench-spawn-micro)
                               (bench-spawn-mono)
                               iterations)
                results))
    ;; Fork benchmark
    (set! results 
          (cons (compare-modes "fork"
                               (bench-fork-micro)
                               (bench-fork-mono)
                               iterations)
                results))
    (reverse results)))

;; Export benchmarks
(provide
 bench-spawn-micro
 bench-spawn-mono
 bench-fork-micro
 bench-fork-mono
 run-process-benchmarks)

