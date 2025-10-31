#!/usr/bin/env steel
;; graindaemon-grainmirror-transform08.scm - Daemon wrapper for grainmirror
;;
;; This is the daemon entry point that s6 or systemd will call.
;; It sets up the environment, handles signals, and runs the sync loop.
;;
;; Why separate from the main script? Separation of concerns:
;; - Main script: sync logic (testable, reusable)
;; - Daemon wrapper: service management (signals, supervision, etc)
;;
;; Does this make sense? We can test sync logic independently,
;; then wrap it in daemon infrastructure when needed.

;; Signal handling
;; Why handle signals? Daemons need graceful shutdown.
;; SIGTERM = "please stop" (we finish current sync, then exit)
;; SIGINT = "stop now" (exit immediately)
;; SIGHUP = "reload config" (reread configuration, continue running)
(define (setup-signal-handlers)
  ;; Why this function? Centralizes signal handling logic.
  ;; If we need to change how signals work, we change it in one place.
  (signal-handler SIGTERM 
                  (lambda (sig)
                    (displayln "🌾 [grainmirror-daemon] Received SIGTERM, shutting down gracefully...")
                    (exit 0)))
  (signal-handler SIGINT
                  (lambda (sig)
                    (displayln "🌾 [grainmirror-daemon] Received SIGINT, shutting down immediately...")
                    (exit 1)))
  (signal-handler SIGHUP
                  (lambda (sig)
                    (displayln "🌾 [grainmirror-daemon] Received SIGHUP, reloading configuration...")
                    ;; Future: reload config here
                    )))

;; Daemon initialization
;; Why initialization? Daemons need setup before main loop:
;; - Set up logging
;; - Load configuration
;; - Verify directories exist
;; - Set up signal handlers
(define (daemon-init)
  ;; Why this function? Separates setup from main loop.
  ;; Makes code easier to test: we can test init separately from loop.
  (displayln "🌾 [grainmirror-daemon] Initializing...")
  
  ;; Set up signal handlers
  (setup-signal-handlers)
  
  ;; Verify source directory exists
  ;; Why check here? Fail fast if misconfigured.
  ;; Better to fail at startup than after running for hours.
  (if (not (directory-exists? "/home/xy/github/kae3g/teamkae3gtransform08"))
      (begin
        (displayln "❌ [grainmirror-daemon] Source directory does not exist!")
        (exit 1))
      ;; Verify target directory exists
      (if (not (directory-exists? "/home/xy/kae3g/grainkae3g/grainstore/kae3g/teamkae3gtransform08"))
          (begin
            (displayln "❌ [grainmirror-daemon] Target directory does not exist!")
            (exit 1))
          (displayln "✅ [grainmirror-daemon] Initialization complete"))))

;; Main daemon entry point
;; Why this structure? Standard daemon pattern:
;; 1. Initialize
;; 2. Enter main loop
;; 3. Loop forever (until signal)
(define (daemon-main)
  ;; Initialize daemon
  (daemon-init)
  
  ;; Load sync interval from environment or default
  ;; Why environment variable? Configuration without code changes.
  ;; S6/systemd can set GRAINMIRROR_INTERVAL=300 to change sync frequency.
  (let ((interval-str (getenv "GRAINMIRROR_INTERVAL"))
        (interval (if interval-str
                     (string->number interval-str)
                     300)))  ; Default: 5 minutes
    
    ;; Why check interval? Validate configuration.
    ;; Negative intervals don't make sense. Zero would cause busy loop.
    (if (or (not interval) (<= interval 0))
        (begin
          (displayln "❌ [grainmirror-daemon] Invalid interval, using default 300s")
          (set! interval 300)))
    
    ;; Import sync function from main script
    ;; Why import? We want to reuse the sync logic.
    ;; In Steel, we'd use (load "grainmirror-transform08.scm") or similar.
    ;; For now, we'll call the sync function directly.
    (displayln (string-append "🌾 [grainmirror-daemon] Starting sync loop (interval: "
                              (number->string interval) "s)"))
    
    ;; Main loop
    ;; Why this structure? Infinite loop that:
    ;; 1. Syncs files
    ;; 2. Sleeps for interval
    ;; 3. Repeats
    ;; Signal handlers will break the loop when needed.
    (let loop ()
      ;; Sync files
      ;; Why call sync here? This is where the actual work happens.
      ;; The daemon wrapper handles service concerns (signals, logging),
      ;; while sync handles file operations.
      (sync-files)  ; From grainmirror-transform08.scm
      
      ;; Sleep for interval
      ;; Why sleep? Don't waste CPU constantly checking.
      ;; Interval-based sync is reasonable for most use cases.
      (sleep interval)
      
      ;; Loop again
      (loop))))

;; Run daemon
;; Why call daemon-main? Entry point for daemon execution.
;; When s6/systemd starts this script, it calls daemon-main.
(daemon-main)

