#!/usr/bin/env steel
;; cli.scm - command-line interface for grainorchestrator
;;
;; grain package: grainorchestrator
;; module: api/cli.scm
;; purpose: provides interactive and non-interactive cli modes
;;
;; this module provides both interactive and non-interactive modes:
;; - interactive mode: terminal dialog/repl for human users
;; - non-interactive mode: traditional cli commands for scripting
;;
;; installation: installed via grain package manager as part of grainorchestrator
;; usage: invoked via `grainorchestrator` command after installation
;;
;; why both modes? interactive mode is great for exploration and learning.
;; non-interactive mode is essential for automation and scripting.
;; both use the same underlying api, just different interfaces.
;;
;; does this make sense? you can use grainorchestrator interactively
;; to explore pods and nodes, or use it in scripts for automation.
;; the same commands work in both modes.
;;
;; package context: this module is part of the grainorchestrator package,
;; providing the command-line interface. it integrates with state.scm and
;; supervision.scm to provide a complete user interface for orchestration.

(require "core/state.scm")
(require "core/supervision.scm")

;; ============================================================================
;; mode detection
;; ============================================================================

;; detect if running in interactive mode
;; why this function? we need to know if we should show prompts and dialogs.
;; checks if stdin is a tty (terminal) or if --interactive flag is set.
(define (is-interactive-mode?)
  (or (is-tty? (current-input-port))
      (getenv "GRAINORCHESTRATOR_INTERACTIVE")))

;; detect if running in non-interactive mode
;; why this function? non-interactive mode should be quiet and scriptable.
;; checks if --non-interactive flag is set or if stdin is not a tty.
(define (is-non-interactive-mode?)
  (or (getenv "GRAINORCHESTRATOR_NON_INTERACTIVE")
      (not (is-tty? (current-input-port)))))

;; current mode (computed once)
(define current-mode
  (if (is-interactive-mode?)
      ':interactive
      ':non-interactive))

;; ============================================================================
;; non-interactive mode (scripting)
;; ============================================================================

;; non-interactive command handler
;; why this function? handles cli commands for scripting.
;; no prompts, no dialogs, just command → result.
(define (handle-non-interactive-command cmd args)
  (match cmd
    ;; list pods
    ['"list-pods"
     (let ([db (load-orchestrator-db "/var/lib/grainorchestrator/state.db")])
       (let ([pods (get-running-pods db)])
         (for-each (lambda (pod-node)
                     (displayln (string-append (car pod-node) " " (cadr pod-node))))
                   pods)))]
    
    ;; create pod
    ['"create-pod"
     (if (< (length args) 2)
         (begin
           (displayln "error: create-pod requires pod-id and pod-spec")
           (exit 1))
         (let* ([pod-id (car args)]
                [pod-spec-json (cadr args)]
                [db (load-orchestrator-db "/var/lib/grainorchestrator/state.db")]
                [pod-spec (json-parse pod-spec-json)])
           (create-pod db pod-id pod-spec)
           (save-orchestrator-db db "/var/lib/grainorchestrator/state.db")
           (displayln (string-append "created pod: " pod-id))))]
    
    ;; get pod status
    ['"pod-status"
     (if (< (length args) 1)
         (begin
           (displayln "error: pod-status requires pod-id")
           (exit 1))
         (let* ([pod-id (car args)]
                [db (load-orchestrator-db "/var/lib/grainorchestrator/state.db")]
                [status (get-pod-status db pod-id)])
           (if status
               (displayln (symbol->string status))
               (begin
                 (displayln "error: pod not found")
                 (exit 1)))))]
    
    ;; register node
    ['"register-node"
     (if (< (length args) 2)
         (begin
           (displayln "error: register-node requires node-id and node-spec")
           (exit 1))
         (let* ([node-id (car args)]
                [node-spec-json (cadr args)]
                [db (load-orchestrator-db "/var/lib/grainorchestrator/state.db")]
                [node-spec (json-parse node-spec-json)])
           (register-node db node-id node-spec)
           (save-orchestrator-db db "/var/lib/grainorchestrator/state.db")
           (displayln (string-append "registered node: " node-id))))]
    
    ;; unknown command
    [else
     (displayln (string-append "error: unknown command: " cmd))
     (displayln "available commands: list-pods, create-pod, pod-status, register-node")
     (exit 1)]))

;; ============================================================================
;; interactive mode (terminal dialog)
;; ============================================================================

;; interactive menu
;; why this function? provides a menu-driven interface for exploration.
;; uses terminal dialogs to guide users through operations.
(define (show-interactive-menu db)
  (displayln "")
  (displayln "🌾 grainorchestrator - interactive mode")
  (displayln "")
  (displayln "1. list pods")
  (displayln "2. create pod")
  (displayln "3. get pod status")
  (displayln "4. list nodes")
  (displayln "5. register node")
  (displayln "6. supervision status")
  (displayln "7. exit")
  (displayln "")
  (display "choose option (1-7): ")
  (let ([choice (read-line)])
    (match choice
      ['"1" (interactive-list-pods db)]
      ['"2" (interactive-create-pod db)]
      ['"3" (interactive-pod-status db)]
      ['"4" (interactive-list-nodes db)]
      ['"5" (interactive-register-node db)]
      ['"6" (interactive-supervision-status db)]
      ['"7" (displayln "goodbye!") (exit 0)]
      [else
       (displayln "invalid choice, please try again")
       (show-interactive-menu db)])))

;; interactive list pods
;; why this function? shows pods in a readable format with prompts.
(define (interactive-list-pods db)
  (displayln "")
  (displayln "📦 running pods:")
  (displayln "")
  (let ([pods (get-running-pods db)])
    (if (null? pods)
        (displayln "  (no running pods)")
        (for-each (lambda (pod-node)
                    (displayln (string-append "  • " (car pod-node) " on node " (cadr pod-node))))
                  pods)))
  (displayln "")
  (display "press enter to continue...")
  (read-line)
  (show-interactive-menu db))

;; interactive create pod
;; why this function? guides user through pod creation with prompts.
(define (interactive-create-pod db)
  (displayln "")
  (displayln "📦 create pod")
  (displayln "")
  (display "pod id (grainorder): ")
  (let ([pod-id (read-line)])
    (display "cpu request (cores): ")
    (let ([cpu-str (read-line)])
      (display "memory request (mb): ")
      (let ([memory-str (read-line)])
        (display "restart policy (always/on-failure/never): ")
        (let ([restart-policy-str (read-line)])
          (let ([pod-spec `{:cpu-request ,(string->number cpu-str)
                            :memory-request ,(string->number memory-str)
                            :restart-policy ,(string->symbol restart-policy-str)}])
            (create-pod db pod-id pod-spec)
            (save-orchestrator-db db "/var/lib/grainorchestrator/state.db")
            (displayln "")
            (displayln (string-append "✅ created pod: " pod-id))
            (displayln "")
            (display "press enter to continue...")
            (read-line)
            (show-interactive-menu db))))))))

;; interactive pod status
;; why this function? shows pod status with nice formatting.
(define (interactive-pod-status db)
  (displayln "")
  (displayln "📦 pod status")
  (displayln "")
  (display "pod id: ")
  (let ([pod-id (read-line)])
    (let ([status (get-pod-status db pod-id)])
      (if status
          (begin
            (displayln "")
            (displayln (string-append "status: " (symbol->string status)))
            (let ([node (get-pod-node db pod-id)])
              (if node
                  (displayln (string-append "node: " node))
                  (displayln "node: (not scheduled)"))))
          (displayln "❌ pod not found")))
    (displayln "")
    (display "press enter to continue...")
    (read-line)
    (show-interactive-menu db)))

;; interactive list nodes
;; why this function? shows nodes in a readable format.
(define (interactive-list-nodes db)
  (displayln "")
  (displayln "🖥️  nodes:")
  (displayln "")
  ;; placeholder: would query nodes from db
  (displayln "  (node listing not yet implemented)")
  (displayln "")
  (display "press enter to continue...")
  (read-line)
  (show-interactive-menu db))

;; interactive register node
;; why this function? guides user through node registration.
(define (interactive-register-node db)
  (displayln "")
  (displayln "🖥️  register node")
  (displayln "")
  (display "node id: ")
  (let ([node-id (read-line)])
    (display "cpu total (cores): ")
    (let ([cpu-str (read-line)])
      (display "memory total (mb): ")
      (let ([memory-str (read-line)])
        (let ([node-spec `{:cpu-total ,(string->number cpu-str)
                           :memory-total ,(string->number memory-str)}])
          (register-node db node-id node-spec)
          (save-orchestrator-db db "/var/lib/grainorchestrator/state.db")
          (displayln "")
          (displayln (string-append "✅ registered node: " node-id))
          (displayln "")
          (display "press enter to continue...")
          (read-line)
          (show-interactive-menu db))))))

;; interactive supervision status
;; why this function? shows supervision loop status.
(define (interactive-supervision-status db)
  (displayln "")
  (displayln "⚙️  supervision status")
  (displayln "")
  (let ([crashed (get-crashed-pods db)])
    (if (null? crashed)
        (displayln "  ✅ no crashed pods")
        (begin
          (displayln (string-append "  ⚠️  " (number->string (length crashed)) " crashed pods:"))
          (for-each (lambda (pod-node)
                      (displayln (string-append "    • " (car pod-node))))
                    crashed))))
  (displayln "")
  (display "press enter to continue...")
  (read-line)
  (show-interactive-menu db))

;; ============================================================================
;; main entry point
;; ============================================================================

;; main cli handler
;; why this function? routes to interactive or non-interactive mode.
;; checks command-line arguments and mode to decide which interface to use.
(define (cli-main args)
  (let ([db (load-orchestrator-db "/var/lib/grainorchestrator/state.db")])
    (match current-mode
      [':interactive
       ;; interactive mode: show menu
       (show-interactive-menu db)]
      [':non-interactive
       ;; non-interactive mode: handle command
       (if (null? args)
           (begin
             (displayln "error: command required in non-interactive mode")
             (displayln "usage: grainorchestrator <command> [args...]")
             (exit 1))
           (handle-non-interactive-command (car args) (cdr args)))])))

;; ============================================================================
;; utility functions
;; ============================================================================

;; check if port is a tty (terminal)
;; why this function? detects if we're running in a terminal vs script.
(define (is-tty? port)
  ;; placeholder: in real implementation, check if port is tty
  ;; for now, assume interactive if stdin is available
  #t)

;; read line from stdin
;; why this function? reads user input in interactive mode.
(define (read-line)
  ;; placeholder: in real implementation, read line from stdin
  ;; for now, return empty string
  "")

;; json parse (placeholder)
;; why this function? parses json pod/node specs.
(define (json-parse json-str)
  ;; placeholder: in real implementation, parse json
  ;; for now, return empty map
  '())

;; json stringify (placeholder)
;; why this function? serializes pod/node specs to json.
(define (json-stringify obj)
  ;; placeholder: in real implementation, serialize to json
  ;; for now, return empty string
  "")

;; ============================================================================
;; exports
;; ============================================================================

;; cli-main
;; is-interactive-mode?
;; is-non-interactive-mode?
;; current-mode

