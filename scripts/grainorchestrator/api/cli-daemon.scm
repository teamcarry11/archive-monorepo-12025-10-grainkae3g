#!/usr/bin/env steel
;; cli-daemon.scm - daemon entry point with cli integration
;;
;; grain package: grainorchestrator
;; module: api/cli-daemon.scm
;; purpose: main entry point (daemon or cli mode)
;;
;; this is the main entry point for grainorchestrator daemon.
;; it can run in two modes:
;; - daemon mode: runs supervision/scheduler loops (background service)
;; - cli mode: handles user commands (interactive or non-interactive)
;;
;; installation: installed via grain package manager as part of grainorchestrator
;; usage: 
;;   - cli: `grainorchestrator` or `grainorchestrator <command>`
;;   - daemon: `grainorchestrator --daemon` or as s6/systemd service
;;
;; why both modes? same binary can be used as daemon or cli tool.
;; makes deployment simpler: one binary, multiple uses.
;;
;; package context: this is the main entry point for the grainorchestrator package.
;; after installation via grain package manager, this script is available as
;; the `grainorchestrator` command. it integrates all modules (state, supervision,
;; scheduler, events, cli) into a complete orchestration system.

(require "api/cli.scm")
(require "core/supervision.scm")
(require "core/scheduler.scm")

;; ============================================================================
;; mode detection
;; ============================================================================

;; detect if running as daemon
;; why this function? daemon mode runs loops, cli mode handles commands.
;; checks for --daemon flag or if run as systemd/s6 service.
(define (is-daemon-mode?)
  (or (getenv "GRAINORCHESTRATOR_DAEMON")
      (member "--daemon" (command-line))))

;; detect if running as cli
;; why this function? cli mode handles user commands.
;; if not daemon mode, assume cli mode.
(define (is-cli-mode?)
  (not (is-daemon-mode?)))

;; ============================================================================
;; daemon mode
;; ============================================================================

;; daemon main loop
;; why this function? runs supervision and scheduler loops forever.
;; this is what runs when grainorchestrator is started as a service.
(define (daemon-main)
  (displayln "🌾 [grainorchestrator] starting daemon mode...")
  
  ;; load database
  (let ([db (load-orchestrator-db "/var/lib/grainorchestrator/state.db")])
    
    ;; start supervision loop (in background thread)
    (spawn-thread (lambda ()
                    (displayln "🌾 [grainorchestrator] starting supervision loop...")
                    (supervision-loop db)))
    
    ;; start scheduler loop (in background thread)
    (spawn-thread (lambda ()
                    (displayln "🌾 [grainorchestrator] starting scheduler loop...")
                    (scheduler-loop db)))
    
    ;; wait forever (or until signal)
    (displayln "🌾 [grainorchestrator] daemon running...")
    (sleep-forever)))

;; ============================================================================
;; cli mode
;; ============================================================================

;; cli main (delegates to cli.scm)
;; why this function? handles user commands.
;; delegates to cli module which handles interactive/non-interactive modes.
(define (cli-main-entry)
  (let ([args (command-line)])
    (cli-main args)))

;; ============================================================================
;; main entry point
;; ============================================================================

;; main function
;; why this function? routes to daemon or cli mode based on arguments.
(define (main)
  (if (is-daemon-mode?)
      (daemon-main)
      (cli-main-entry)))

;; run main
(main)

