;; grain-linux-compat.scm - Linux Compatibility Layer for Redox
;;
;; Inspired by: aero os (linux source-level compatibility)
;; Reference: https://github.com/Andy-Python-Programmer/aero
;; Note: We study aero's compatibility approach, but write our own implementation
;;
;; 🌊 Airbender Mode: Flowing Linux compatibility through Steel
;; Kid-Friendly: Makes Redox understand Linux paths and syscalls!
;;
;; Purpose: Provide Linux source-level compatibility for easier porting
;; Strategy: Map Linux paths/syscalls to Redox equivalents
;; License: MIT/Apache 2.0 (our code, compatible with Redox MIT)

(require "utils/specs.scm")
(require "utils/macros.scm")
(require "utils/utils.scm")

;; Linux Path Mapping
;; Why map paths? Linux uses /dev, /proc, /sys.
;; Redox uses /scheme/ (url-based).
;; This layer translates between them!
;; Using define-path-mapper macro for cleaner code

(define-path-mapper linux-path->redox-path
  (("/dev/null" "/scheme/null")
   ("/dev/zero" "/scheme/zero")
   ("/proc/" (string-append "/scheme/proc" (substring path 5)))
   ("/sys/" (string-append "/scheme/sys" (substring path 4)))
   ("/dev/" (string-append "/scheme/device" (substring path 4)))))

;; Validate input using spec
(define (linux-path->redox-path-validated linux-path)
  ;; Validate input path
  (if (not (linux-path? linux-path))
      (error (string-append "Invalid Linux path: " linux-path)))
  ;; Map using utility function
  (linux-path->redox-path linux-path))

;; Linux Syscall Mapping
;; Map Linux syscall numbers to Redox syscalls
;; This helps port Linux applications!

(define linux-syscall-map
  ;; Map Linux syscall numbers to Redox syscalls
  ;; TODO: Complete mapping based on Linux syscall table
  '((0 . read)        ; SYS_read
    (1 . write)       ; SYS_write
    (2 . open)        ; SYS_open
    (3 . close)       ; SYS_close
    ;; Add more as needed
    ))

(define (linux-syscall num . args)
  ;; Execute Linux syscall by mapping to Redox
  (let ((redox-op (assoc num linux-syscall-map)))
    (if redox-op
        ;; Map to Redox syscall
        (apply redox-syscall (cdr redox-op) args)
        ;; Unknown syscall - error
        (error (string-append "Unknown Linux syscall: " (number->string num))))))

;; Linux Environment Variables
;; Map Linux-specific env vars to Redox equivalents
(define (map-linux-env)
  ;; Set up Linux-compatible environment
  ;; TODO: Map common Linux env vars
  (setenv "PATH" "/usr/bin:/bin")
  (setenv "HOME" "/home/user")
  ;; Add more as needed
  )

;; Linux File Descriptors
;; Map Linux FD numbers to Redox handles
(define linux-fd-map (make-hash))

(define (linux-fd->redox-handle linux-fd)
  ;; Convert Linux file descriptor to Redox handle
  (hash-ref linux-fd-map linux-fd #f))

(define (register-linux-fd linux-fd redox-handle)
  ;; Register Linux FD -> Redox handle mapping
  (hash-set! linux-fd-map linux-fd redox-handle))

;; Linux Compatibility Mode
;; Enable Linux compatibility for an application
(define (enable-linux-compat)
  ;; Set up Linux-compatible environment
  (map-linux-env)
  ;; Install syscall handler
  ;; TODO: Install syscall interceptor
  (displayln "Linux compatibility enabled"))

;; Module exports
(provide
 linux-path->redox-path
 linux-syscall
 enable-linux-compat
 linux-fd->redox-handle
 register-linux-fd)

