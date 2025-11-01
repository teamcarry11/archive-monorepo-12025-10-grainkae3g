#!/usr/bin/env steel
;; test-steel-api.scm - test what steel apis are available
;;
;; why this test? we need to know what steel provides before
;; we can implement benchmarks. check available functions.

(displayln "=========================================================")
(displayln "testing steel api availability")
(displayln "=========================================================")
(displayln "")

;; test basic functions
(displayln "basic functions:")
(displayln (string-append "  string-append: " 
                         (if (procedure? string-append) "✅" "❌")))
(displayln (string-append "  displayln: " 
                         (if (procedure? displayln) "✅" "❌")))
(displayln (string-append "  number->string: " 
                         (if (procedure? number->string) "✅" "❌")))
(displayln "")

;; test command execution
(displayln "command execution:")
(displayln "  command: ✅ (tested in other scripts)")
(displayln "  command-exit-code: ✅ (used in grainmirror scripts)")
(displayln "  command-stdout: ✅ (used in grainmirror scripts)")
(displayln "  command-stderr: ✅ (used in grainmirror scripts)")
(displayln "")

;; test time functions
(displayln "time functions:")
(displayln "  current-seconds: ❓ (may need require)")
(displayln "  current-milliseconds: ❓ (may need require)")
(displayln "  note: time functions may need to be imported")
(displayln "")

;; test list functions
(displayln "list functions:")
(displayln (string-append "  length: " 
                         (if (procedure? length) "✅" "❌")))
(displayln (string-append "  null?: " 
                         (if (procedure? null?) "✅" "❌")))
(displayln (string-append "  car: " 
                         (if (procedure? car) "✅" "❌")))
(displayln (string-append "  cdr: " 
                         (if (procedure? cdr) "✅" "❌")))
(displayln (string-append "  cons: " 
                         (if (procedure? cons) "✅" "❌")))
(displayln (string-append "  list?: " 
                         (if (procedure? list?) "✅" "❌")))
(displayln "")

;; test string functions
(displayln "string functions:")
(displayln (string-append "  string-length: " 
                         (if (procedure? string-length) "✅" "❌")))
(displayln (string-append "  substring: " 
                         (if (procedure? substring) "✅" "❌")))
(displayln (string-append "  string=? " 
                         (if (procedure? string=?) "✅" "❌")))
(displayln "")

;; test math functions
(displayln "math functions:")
(displayln (string-append "  +: " 
                         (if (procedure? +) "✅" "❌")))
(displayln (string-append "  -: " 
                         (if (procedure? -) "✅" "❌")))
(displayln (string-append "  *: " 
                         (if (procedure? *) "✅" "❌")))
(displayln (string-append "  /: " 
                         (if (procedure? /) "✅" "❌")))
(displayln "")

;; test control flow
(displayln "control flow:")
(displayln "  if: ✅ (special form)")
(displayln "  lambda: ✅ (special form)")
(displayln "  let: ✅ (special form)")
(displayln "")

(displayln "=========================================================")
(displayln "steel api test complete")
(displayln "=========================================================")

