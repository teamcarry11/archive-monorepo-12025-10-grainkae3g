#!/usr/bin/env steel
;; macros.scm - benchmark abstraction macros
;;
;; 🌊 waterbender mode: shaping code like water
;;    before:        after:
;;    ┌────┐        ┌────┐
;;    │long│  ───>  │short│  ← macro expands
;;    └────┘        └────┘
;;
;; why macros? reduce boilerplate when writing
;; benchmarks. make benchmark code cleaner and easier
;; to read.
;;
;; does this make sense? macros let us write benchmarks
;; at a higher level. less repetition, more clarity.

(require "specs.scm")

;; Macro: define-benchmark
;; Why this macro? Makes defining benchmarks consistent.
;; Every benchmark follows the same pattern.
(define-macro (define-benchmark name mode fn iterations)
  `(define (,name)
     ;; Why validate inputs? Catch errors before running.
     (if (not (benchmark-name? ,(symbol->string name)))
         (error "invalid benchmark name"))
     (if (not (benchmark-mode? ,mode))
         (error "invalid benchmark mode"))
     (if (not (iteration-count? ,iterations))
         (error "invalid iteration count"))
     ;; Run the benchmark function
     (run-benchmark ,(symbol->string name) ,mode ,fn 
                    ,iterations)))

;; Macro: benchmark-suite
;; Why this macro? Groups related benchmarks together.
;; Makes it easy to run all benchmarks in a suite.
(define-macro (benchmark-suite suite-name . benchmarks)
  `(define (,suite-name)
     ;; Why collect results? We want to compare all
     ;; benchmarks in the suite together.
     (let ((results '()))
       ,@(map (lambda (bench)
                `(set! results 
                       (cons (,bench) results)))
              benchmarks)
       ;; Return all results
       (reverse results))))

;; Macro: compare-modes
;; Why this macro? Makes it easy to compare microkernel
;; vs monolithic for the same benchmark.
(define-macro (compare-modes name micro-fn mono-fn 
                              iterations)
  `(let ((micro-result 
          (run-benchmark ,(symbol->string name) 
                        "microkernel" ,micro-fn 
                        ,iterations))
        (mono-result 
          (run-benchmark ,(symbol->string name) 
                        "monolithic" ,mono-fn 
                        ,iterations)))
     ;; Compare the two results
     (compare-results micro-result mono-result)))

;; Export macros
(provide
 define-benchmark
 benchmark-suite
 compare-modes)

