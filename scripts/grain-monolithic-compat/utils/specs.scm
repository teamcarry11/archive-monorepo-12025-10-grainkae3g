;; grain-monolithic-compat/utils/specs.scm - Type Specifications
;;
;; 🌊 Airbender Mode: Flowing types through specs
;; Kid-Friendly: Specs tell us what things are!
;;
;; Purpose: Define specifications for monolithic-compat types
;; License: MIT/Apache 2.0

;; Macro: define-spec
;; Why this macro? Makes defining type predicates cleaner.
;; Kid-Friendly: Like a template for checking what things are!
;; note: define-spec macro removed - steel doesn't support
;; define-macro the way we need. use regular define instead.

;; syscall operation spec
;; what is a syscall operation? it's a symbol like 'open, 'read, 'write
;; kid-friendly: like a command name ("open file", "read file", etc.)
(define (syscall-op? x)
  (and (symbol? x)
       (memq x '(open read write close fork exec exit stat chmod chown))))

;; syscall arguments spec
;; what are syscall arguments? a list of values passed to the syscall
;; kid-friendly: like parameters to a function
(define (syscall-args? x)
  (list? x))

;; batched syscall spec
;; what is a batched syscall? an operation + arguments pair
;; kid-friendly: like a command with its parameters
(define (batched-syscall? x)
  (and (pair? x)
       (syscall-op? (car x))
       (syscall-args? (cdr x))))

;; syscall batch spec
;; what is a syscall batch? a list of batched syscalls
;; kid-friendly: like a list of commands waiting to run
(define (syscall-batch? x)
  (and (list? x)
       (let loop ((remaining x))
         (if (null? remaining)
             #t
             (if (batched-syscall? (car remaining))
                 (loop (cdr remaining))
                 #f)))))

;; file descriptor spec
;; what is a file descriptor? a number representing an open file
;; kid-friendly: like a ticket number for an open file
(define (file-descriptor? x)
  (and (integer? x)
       (>= x 0)))

;; file path spec
;; what is a file path? a string representing a file location
;; kid-friendly: like an address for a file
(define (file-path? x)
  (and (string? x)
       (> (string-length x) 0)))

;; linux path spec
;; what is a linux path? a file path that might need translation
;; kid-friendly: like an address in a different language
(define (linux-path? x)
  (file-path? x))

;; redox path spec
;; what is a redox path? a file path in redox scheme format
;; kid-friendly: like an address in redox's language
(define (redox-path? x)
  (file-path? x))

;; Module exports
(provide
 syscall-op?
 syscall-args?
 batched-syscall?
 syscall-batch?
 file-descriptor?
 file-path?
 linux-path?
 redox-path?)

