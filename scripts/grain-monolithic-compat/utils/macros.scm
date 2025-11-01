;; grain-monolithic-compat/utils/macros.scm - Utility Macros
;;
;; 🌊 Airbender Mode: Flowing abstractions through macros
;; Kid-Friendly: Macros make code simpler and easier to read!
;;
;; Purpose: Provide macros for common patterns
;; License: MIT/Apache 2.0

(require "specs.scm")

;; Helper: convert value to string for error messages
;; Why this? We need to convert any value to string for error messages.
(define (value->string x)
  (cond
   ((string? x) x)
   ((number? x) (number->string x))
   ((symbol? x) (symbol->string x))
   ((boolean? x) (if x "#t" "#f"))
   (else "[unknown]")))

;; Macro: define-syscall
;; Why this macro? Makes defining syscalls cleaner and consistent.
;; Kid-Friendly: Like a template for making syscalls!
(define-macro (define-syscall name op . param-specs)
  `(define (,name ,@(map car param-specs))
     ;; Validate parameters using specs
     ,@(map (lambda (param-spec)
              (let ((param (car param-spec))
                    (spec (cadr param-spec)))
                `(if (not (,spec ,param))
                     (error (string-append "Invalid " ,(symbol->string param) ": " (value->string ,param))))))
            param-specs)
     ;; Batch the syscall
     (batch-syscall ',op ,@(map car param-specs))))

;; Macro: with-syscall-batch
;; Why this macro? Groups syscalls together for batching.
;; Kid-Friendly: Like putting multiple commands in one box!
(define-macro (with-syscall-batch . body)
  `(begin
     ;; Start batch
     (let ((batch-start (current-syscall-batch-size)))
       ;; Execute body (syscalls go into batch)
       ,@body
       ;; Flush batch if it grew
       (if (> (current-syscall-batch-size) batch-start)
           (flush-syscall-batch)))))

;; Macro: define-path-mapper
;; Why this macro? Makes path mapping functions easier to define.
;; Kid-Friendly: Like a template for translating paths!
;; 
;; Mappings format: ((pattern replacement) ...)
;; Replacement can be:
;; - A string: direct replacement, rest of path appended
;; - A symbol: treated as code expression (evaluated)
(define-macro (define-path-mapper name mappings)
  `(define (,name path)
     (cond
      ,@(map (lambda (mapping)
               (let ((pattern (car mapping))
                     (replacement (cadr mapping)))
                 (if (string? replacement)
                     ;; String replacement: append rest of path
                     `((string-prefix? path ,pattern)
                       (string-append ,replacement (substring path ,(string-length pattern))))
                     ;; Code replacement: evaluate as expression
                     `((string-prefix? path ,pattern)
                       ,replacement))))
             mappings)
      (else path))))

;; Macro: define-linux-syscall-wrapper
;; Why this macro? Makes Linux syscall wrappers easier to define.
;; Kid-Friendly: Like a template for wrapping syscalls!
(define-macro (define-linux-syscall-wrapper linux-num redox-op)
  `(define (linux-syscall-,(symbol->string redox-op) . args)
     (apply redox-syscall ',redox-op args)))

;; Module exports
(provide
 value->string
 define-syscall
 with-syscall-batch
 define-path-mapper
 define-linux-syscall-wrapper)
