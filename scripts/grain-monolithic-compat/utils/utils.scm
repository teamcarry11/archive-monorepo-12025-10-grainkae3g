;; grain-monolithic-compat/utils/utils.scm - Utility Functions
;;
;; 🌊 Airbender Mode: Flowing utilities through functions
;; Kid-Friendly: Utility functions are helpers that make things easier!
;;
;; Purpose: Provide utility functions for common operations
;; License: MIT/Apache 2.0

(require "specs.scm")

;; String utilities
;; Why separate functions? Makes code cleaner and reusable.

(define (string-prefix? str prefix)
  ;; Check if string starts with prefix
  ;; Kid-Friendly: Like checking if a word starts with a letter!
  (and (>= (string-length str) (string-length prefix))
       (string=? (substring str 0 (string-length prefix)) prefix)))

(define (string-suffix? str suffix)
  ;; Check if string ends with suffix
  ;; Kid-Friendly: Like checking if a word ends with a letter!
  (let ((str-len (string-length str))
        (suffix-len (string-length suffix)))
    (and (>= str-len suffix-len)
         (string=? (substring str (- str-len suffix-len)) suffix))))

;; Syscall batch utilities
;; Why these? Manage syscall batches cleanly.

(define (make-syscall-batch)
  ;; Create a new empty syscall batch
  ;; Kid-Friendly: Like getting a new empty box!
  '())

(define (syscall-batch-empty? batch)
  ;; Check if batch is empty
  ;; Kid-Friendly: Like checking if a box is empty!
  (null? batch))

(define (syscall-batch-size batch)
  ;; Get batch size
  ;; Kid-Friendly: Like counting items in a box!
  (length batch))

(define (syscall-batch-add batch op . args)
  ;; Add syscall to batch
  ;; Kid-Friendly: Like putting an item in a box!
  (if (syscall-op? op)
      (cons (cons op args) batch)
      (error (string-append "Invalid syscall operation: " (symbol->string op)))))

;; Path utilities
;; Why these? Handle path operations cleanly.

(define (path-join . parts)
  ;; Join path parts with /
  ;; Kid-Friendly: Like connecting path pieces!
  (let ((filtered (filter (lambda (p) (and (string? p) (> (string-length p) 0))) parts)))
    (string-join filtered "/")))

(define (path-normalize path)
  ;; Normalize path (remove //, resolve ., ..)
  ;; Kid-Friendly: Like cleaning up a messy address!
  ;; TODO: Implement full path normalization
  path)

(define (path-basename path)
  ;; Get basename from path
  ;; Kid-Friendly: Like getting just the filename!
  (let ((parts (string-split path "/")))
    (if (null? parts)
        ""
        (car (reverse parts)))))

;; Helper: drop-right (if not available)
(define (drop-right lst n)
  ;; Drop last n elements from list
  ;; Kid-Friendly: Like removing items from the end of a list!
  (let ((len (length lst)))
    (if (<= n 0)
        lst
        (if (>= n len)
            '()
            (let loop ((remaining lst)
                       (idx 0)
                       (result '()))
              (if (>= idx (- len n))
                  (reverse result)
                  (loop (cdr remaining)
                        (+ idx 1)
                        (cons (car remaining) result))))))))

(define (path-dirname path)
  ;; Get directory name from path
  ;; Kid-Friendly: Like getting just the folder name!
  (let ((parts (string-split path "/")))
    (if (<= (length parts) 1)
        "."
        (string-join (drop-right parts 1) "/"))))

;; Helper: string-split (if not available)
(define (string-split str delim)
  ;; Split string by delimiter
  ;; Kid-Friendly: Like cutting a string into pieces!
  (let loop ((remaining str)
             (current "")
             (result '()))
    (if (string=? remaining "")
        (reverse (if (string=? current "")
                     result
                     (cons current result)))
        (let ((char (substring remaining 0 1)))
          (if (string=? char delim)
              (loop (substring remaining 1)
                    ""
                    (if (string=? current "")
                        result
                        (cons current result)))
              (loop (substring remaining 1)
                    (string-append current char)
                    result))))))

;; Helper: string-join (if not available)
(define (string-join strings delim)
  ;; Join strings with delimiter
  ;; Kid-Friendly: Like connecting words with a connector!
  (if (null? strings)
      ""
      (let loop ((remaining (cdr strings))
                 (result (car strings)))
        (if (null? remaining)
            result
            (loop (cdr remaining)
                  (string-append result delim (car remaining)))))))

;; Helper: ->string (convert value to string)
(define (->string x)
  ;; Convert value to string representation
  ;; Kid-Friendly: Like turning something into words!
  (cond
   ((string? x) x)
   ((number? x) (number->string x))
   ((symbol? x) (symbol->string x))
   ((boolean? x) (if x "#t" "#f"))
   (else (string-append "<<" (type-of x) ">>"))))

;; Helper: type-of (simple type checker)
(define (type-of x)
  ;; Get type name as string
  ;; Kid-Friendly: Like asking "what kind of thing is this?"
  (cond
   ((string? x) "string")
   ((number? x) "number")
   ((symbol? x) "symbol")
   ((boolean? x) "boolean")
   ((pair? x) "pair")
   ((null? x) "null")
   (else "unknown")))

;; Module exports
(provide
 string-prefix?
 string-suffix?
 make-syscall-batch
 syscall-batch-empty?
 syscall-batch-size
 syscall-batch-add
 path-join
 path-normalize
 path-basename
 path-dirname
 string-split
 string-join
 drop-right
 ->string
 type-of)

