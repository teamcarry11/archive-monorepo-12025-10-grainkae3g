;; grain-syscall-layer.scm - Monolithic-like syscall interface for Redox
;;
;; Inspired by: aero os (monolithic rust kernel design)
;; Reference: https://github.com/Andy-Python-Programmer/aero
;; Note: We study aero's design, but write our own implementation
;;
;; 🌊 Airbender Mode: Flowing syscalls through Steel
;; Kid-Friendly: Makes Redox look like a monolithic kernel!
;;
;; Purpose: Provide monolithic-like syscall interface over Redox microkernel
;; Strategy: Batch microkernel syscalls to reduce overhead
;; License: MIT/Apache 2.0 (our code, compatible with Redox MIT)

(require "utils/specs.scm")
(require "utils/utils.scm")

;; System Call Batching State
;; Why separate state? Makes code cleaner and testable.
;; Kid-Friendly: Like having a box to collect commands!

(define syscall-batch (make-syscall-batch))

;; Get current batch size
;; Why this function? Utility for monitoring batch state.
(define (current-syscall-batch-size)
  (syscall-batch-size syscall-batch))

;; Batch syscall operation
;; Collects multiple syscalls and executes them together
;; Uses specs to validate operations
(define (batch-syscall op . args)
  ;; Validate operation using spec
  (if (not (syscall-op? op))
      (error (string-append "Invalid syscall operation: " (symbol->string op))))
  ;; add to batch using utility function
  ;; note: syscall-batch-add takes batch, op, and rest args
  (set! syscall-batch (apply syscall-batch-add 
                             (cons syscall-batch 
                                   (cons op args))))
  ;; Return immediately (async batching)
  #t)

;; Execute batched syscalls
;; Why execute together? Reduces IPC overhead in microkernel
;; Uses utility functions for cleaner code
(define (flush-syscall-batch)
  ;; Execute all batched syscalls together
  ;; Reduces microkernel IPC overhead
  (let ((batch syscall-batch))
    (set! syscall-batch (make-syscall-batch))
    ;; TODO: Implement actual redox syscall batching
    ;; For now, execute sequentially
    (if (not (null? batch))
        (for-each (lambda (call)
                    (let ((op (car call))
                          (args (cdr call)))
                      ;; execute syscall via redox
                      ;; (redox-syscall op args)
                      (displayln (string-append "syscall: " 
                                                (symbol->string op) 
                                                " args: " 
                                                (->string args)))))
                  (reverse batch))
        #t)))

;; monolithic-like file operations
;; these look like monolithic kernel syscalls to applications
;; using regular functions instead of macros for steel compatibility

(define (open-file path flags)
  ;; validate parameters
  (if (not (file-path? path))
      (error (string-append "invalid path: " path)))
  (if (not (list? flags))
      (error "invalid flags: must be list"))
  ;; batch the syscall
  (batch-syscall 'open path flags))

(define (read-file fd buffer size)
  ;; validate parameters
  (if (not (file-descriptor? fd))
      (error (string-append "invalid fd: " (number->string fd))))
  (if (not (string? buffer))
      (error "invalid buffer: must be string"))
  (if (not (integer? size))
      (error (string-append "invalid size: " (number->string size))))
  ;; batch the syscall
  (batch-syscall 'read fd buffer size))

(define (write-file fd buffer size)
  ;; validate parameters
  (if (not (file-descriptor? fd))
      (error (string-append "invalid fd: " (number->string fd))))
  (if (not (string? buffer))
      (error "invalid buffer: must be string"))
  (if (not (integer? size))
      (error (string-append "invalid size: " (number->string size))))
  ;; batch the syscall
  (batch-syscall 'write fd buffer size))

(define (close-file fd)
  ;; validate parameters
  (if (not (file-descriptor? fd))
      (error (string-append "invalid fd: " (number->string fd))))
  ;; batch the syscall
  (batch-syscall 'close fd))

;; monolithic-like process operations
(define (fork-process)
  ;; batch the syscall
  (batch-syscall 'fork))

(define (exec-process path args)
  ;; validate parameters
  (if (not (file-path? path))
      (error (string-append "invalid path: " path)))
  (if (not (list? args))
      (error "invalid args: must be list"))
  ;; batch the syscall
  (batch-syscall 'exec path args))

;; Flush batch periodically
;; Why periodic? Balance between batching efficiency and latency
(define (syscall-tick)
  ;; Called periodically to flush batched syscalls
  (flush-syscall-batch))

;; Module exports
(provide
 batch-syscall
 flush-syscall-batch
 current-syscall-batch-size
 open-file
 read-file
 write-file
 close-file
 fork-process
 exec-process
 syscall-tick)

