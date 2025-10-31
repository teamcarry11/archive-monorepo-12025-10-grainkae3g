#!/usr/bin/env steel
;; platform-examples.scm - examples of platform abstraction usage
;;
;; this file shows how to use the platform abstraction layer
;; to write code that works on both host (posix) and redox platforms.

(require "utils/platform.scm")

;; ============================================================================
;; example 1: file operations
;; ============================================================================

;; save database (works on both platforms)
(define (example-save-db db)
  ;; on host: "/var/lib/grainorchestrator/state.db"
  ;; on redox: "file:///var/lib/grainorchestrator/state.db"
  ;; platform abstraction handles the conversion
  (platform-save-db db "/var/lib/grainorchestrator/state.db"))

;; load database (works on both platforms)
(define (example-load-db)
  ;; same path works on both platforms
  (platform-load-db "/var/lib/grainorchestrator/state.db"))

;; ============================================================================
;; example 2: network operations
;; ============================================================================

;; connect to kafka (works on both platforms)
(define (example-connect-kafka)
  ;; on host: "localhost:9092"
  ;; on redox: "tcp://localhost:9092"
  ;; platform abstraction handles the conversion
  (platform-connect-event-log "localhost:9092"))

;; ============================================================================
;; example 3: conditional platform code
;; ============================================================================

;; platform-specific logic (when needed)
(define (example-platform-specific)
  (if (is-redox?)
      ;; redox-specific code
      (displayln "running on redox: using scheme system")
      ;; host-specific code
      (displayln "running on host: using posix")))

;; ============================================================================
;; example 4: using macros
;; ============================================================================

;; file path macro (expands at compile time)
(define (example-file-path)
  ;; this macro expands differently based on platform:
  ;; host: "/var/lib/db"
  ;; redox: "file:///var/lib/db"
  (let ([path (file-path "/var/lib/db")])
    (displayln (string-append "using path: " path))))

;; network url macro (expands at compile time)
(define (example-network-url)
  ;; this macro expands differently based on platform:
  ;; host: "localhost:9092"
  ;; redox: "tcp://localhost:9092"
  (let ([url (network-url "localhost" 9092)])
    (displayln (string-append "using url: " url))))

;; ============================================================================
;; example 5: database persistence
;; ============================================================================

;; save orchestrator state (platform-abstracted)
(define (example-save-orchestrator-state db)
  ;; uses platform abstraction
  (platform-save-db db "/var/lib/grainorchestrator/state.db"))

;; load orchestrator state (platform-abstracted)
(define (example-load-orchestrator-state)
  ;; uses platform abstraction
  (platform-load-db "/var/lib/grainorchestrator/state.db"))

;; ============================================================================
;; example 6: event log
;; ============================================================================

;; connect to event log (platform-abstracted)
(define (example-event-log)
  ;; can use either format, platform abstraction handles conversion
  (let ([log1 (platform-connect-event-log "localhost:9092")]  ; kafka
        [log2 (platform-connect-event-log "/var/log/events.log")])  ; file
    ;; both work on both platforms
    (list log1 log2)))

;; ============================================================================
;; example 7: detecting platform
;; ============================================================================

;; log platform info
(define (example-log-platform)
  (displayln (string-append "platform: " (get-platform-name)))
  (displayln (string-append "is redox: " (if (is-redox?) "yes" "no")))
  (displayln (string-append "is host: " (if (is-host?) "yes" "no"))))

