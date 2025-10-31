#!/usr/bin/env steel
;; supervision.scm - s6-style process supervision for pods
;;
;; grain network package: grainorchestrator
;; module: core/supervision.scm
;;
;; this module implements s6-style supervision semantics:
;; - crash-only design (pods expected to exit, supervisor restarts)
;; - auto-restart on crash (unless restart-policy :never)
;; - dependency resolution (start pods only when dependencies ready)
;; - health checks (mark unhealthy pods as crashed)
;;
;; package dependencies:
;; - core/state.scm: orchestrator state management
;;
;; why s6 semantics? they're simple, reliable, and battle-tested.
;; instead of complex state machines, we have a simple loop:
;; 1. find crashed pods, restart them
;; 2. find scheduled pods, start them if dependencies ready
;; 3. check running pods, mark unhealthy ones as crashed
;; 4. repeat forever
;;
;; does this make sense? crashes are normal, not exceptional.
;; the supervisor's job is to notice crashes and restart pods.
;; that's it. simple, reliable, predictable.
;;
;; installation: installed via grain package manager as part of
;; grainorchestrator package. the supervision loop runs automatically
;; when grainorchestrator is started as an s6 service.

(require "core/state.scm")

;; ============================================================================
;; pod states (like s6 service states)
;; ============================================================================

;; pod state machine
;; why these states? they match s6's service states, adapted for pods:
;; - :pending: waiting to be scheduled (like s6's :down before start)
;; - :scheduled: assigned to node, waiting to start
;; - :starting: pod is starting (like s6's transition to :up)
;; - :running: pod is running (like s6's :up)
;; - :crashed: pod crashed (like s6's :down after crash)
;; - :finishing: pod is stopping gracefully (like s6's :finishing)
;; - :stopped: pod is stopped, won't restart (like s6's :down with 'once' mode)
;;
;; question: why not just :up and :down like s6? pods have more lifecycle
;; stages (scheduling, starting) that s6 services don't need. but the core
;; idea is the same: crashed pods restart automatically.

(define pod-states
  '(:pending :scheduled :starting :running :crashed :finishing :stopped))

;; ============================================================================
;; supervision logic
;; ============================================================================

;; supervision tick (like s6-svscan tick)
;; why this function? it's the core supervision loop. runs every 5 seconds,
;; checks pods, restarts crashed ones, starts ready ones.
;;
;; think of it like s6-svscan scanning the service directory:
;; - finds services in :down state
;; - starts them
;; - repeats forever
;;
;; we do the same for pods: find crashed pods, restart them.
(define (supervision-tick db)
  ;; 1. restart crashed pods
  ;; why restart crashed pods? that's the core of supervision.
  ;; a pod crashed? supervisor restarts it (unless restart-policy :never).
  (let ([crashed (get-crashed-pods db)])
    (for-each (lambda (pod-node)
                (let ([pod-id (car pod-node)])
                  (restart-pod db pod-id)))
              crashed))
  
  ;; 2. start scheduled pods (if dependencies ready)
  ;; why check dependencies? pods might depend on other pods.
  ;; example: web pod depends on database pod. we can't start web
  ;; until database is running. this ensures correct startup order.
  (let ([scheduled (get-scheduled-pods db)])
    (for-each (lambda (pod-id)
                (if (pod-dependencies-ready? db pod-id)
                    (start-pod db pod-id)
                    (log (string-append "pod " pod-id " waiting for dependencies"))))
              scheduled))
  
  ;; 3. check running pods (health checks)
  ;; why health checks? pods might be running but unhealthy.
  ;; example: pod is stuck in infinite loop, not responding to requests.
  ;; health check detects this, marks pod as crashed, supervisor restarts it.
  (let ([running (get-running-pods db)])
    (for-each (lambda (pod-node)
                (let ([pod-id (car pod-node)])
                  (check-pod-health db pod-id)))
              running)))

;; restart crashed pod
;; why this function? supervision loop calls this to restart crashed pods.
;; checks restart policy first: some pods shouldn't restart (:never policy).
(define (restart-pod db pod-id)
  ;; check restart policy
  ;; why check restart policy? not all pods should restart.
  ;; example: batch job pod completes successfully, exits. we don't
  ;; want to restart it. restart-policy :never prevents restarts.
  (let ([restart-policy (get-pod-restart-policy db pod-id)])
    (if (or (equal? restart-policy ':always)
            (equal? restart-policy ':on-failure))
        (begin
          ;; mark as starting
          ;; why update status? supervision loop needs to track pod state.
          ;; marking as :starting tells scheduler "this pod is being restarted".
          (update-pod-status db pod-id ':starting)
          
          ;; actually start the pod (calls node api)
          ;; why call node api? the pod runs on a specific node.
          ;; we need to tell that node "start this pod". in real implementation,
          ;; this would make an http request to the node's api.
          (start-pod-on-node db pod-id (get-pod-node db pod-id)))
        ;; restart-policy :never, don't restart
        ;; why mark as stopped? pod won't restart, mark it as stopped
        ;; so supervision loop doesn't keep trying to restart it.
        (update-pod-status db pod-id ':stopped))))

;; start pod (if dependencies ready)
;; why this function? supervision loop calls this to start scheduled pods.
;; only starts if all dependencies are running.
(define (start-pod db pod-id)
  ;; get node where pod is scheduled
  (let ([node-id (get-pod-node db pod-id)])
    (if (pod-dependencies-ready? db pod-id)
        (begin
          ;; mark as starting
          (update-pod-status db pod-id ':starting)
          
          ;; start pod on node
          (start-pod-on-node db pod-id node-id))
        ;; dependencies not ready, wait
        (log (string-append "pod " pod-id " dependencies not ready")))))

;; check if pod dependencies are ready
;; why this function? pods might depend on other pods.
;; example: web pod depends on database pod. we can't start web
;; until database is running. this function checks all dependencies.
(define (pod-dependencies-ready? db pod-id)
  (let ([deps (get-pod-dependencies db pod-id)])
    ;; if no dependencies, pod is ready
    (if (null? deps)
        #t
        ;; check all dependencies are running
        ;; why :running? dependencies must be running, not just started.
        ;; a pod that's :starting might not be ready yet. we wait until
        ;; it's actually :running and serving requests.
        (every? (lambda (dep-id)
                  (let ([dep-status (get-pod-status db dep-id)])
                    (equal? dep-status ':running)))
                deps))))

;; health check (simplified)
;; why this function? pods might be running but unhealthy.
;; example: pod is stuck, not responding to requests. health check
;; detects this, marks pod as crashed, supervisor restarts it.
(define (check-pod-health db pod-id)
  ;; ping pod health endpoint
  ;; why ping? we need to check if pod is actually healthy.
  ;; in real implementation, this would make an http request to
  ;; the pod's health endpoint (like /health or /ready).
  (let ([healthy? (ping-pod-health pod-id)])
    (if (not healthy?)
        ;; pod unhealthy, mark as crashed
        ;; why mark as crashed? supervision loop will restart it.
        ;; this is the crash-only design: unhealthy = crashed = restart.
        (begin
          (log (string-append "pod " pod-id " health check failed, marking as crashed"))
          (update-pod-status db pod-id ':crashed))
        ;; pod healthy, no action needed
        #t)))

;; start pod on node (placeholder)
;; why this function? abstracts pod startup logic.
;; in real implementation, this would make an http request to the node's
;; api to start the pod. the node would then launch the pod's container.
(define (start-pod-on-node db pod-id node-id)
  ;; placeholder: in real implementation, call node api
  ;; node api: POST /api/v1/pods/{pod-id}/start
  (log (string-append "starting pod " pod-id " on node " node-id))
  ;; after starting, update status to :running
  ;; why update status? supervision loop needs to track pod state.
  ;; after node confirms pod started, we mark it as :running.
  (update-pod-status db pod-id ':running))

;; ping pod health (placeholder)
;; why this function? abstracts health check logic.
;; in real implementation, this would make an http request to the pod's
;; health endpoint. returns #t if healthy, #f if unhealthy.
(define (ping-pod-health pod-id)
  ;; placeholder: in real implementation, call pod health endpoint
  ;; pod health endpoint: GET http://pod-ip:port/health
  ;; for now, assume healthy
  #t)

;; ============================================================================
;; supervision loop
;; ============================================================================

;; main supervision loop (like s6-svscan)
;; why this function? it's the daemon's main loop.
;; runs forever, checking pods every 5 seconds, restarting crashed ones.
;;
;; think of it like s6-svscan's main loop:
;; - scan service directory
;; - start services in :down state
;; - sleep 5 seconds
;; - repeat forever
;;
;; we do the same for pods: supervision-tick, sleep, repeat.
(define (supervision-loop db)
  (let loop ()
    ;; run supervision tick
    ;; why call supervision-tick? it does all the work:
    ;; - restarts crashed pods
    ;; - starts scheduled pods (if dependencies ready)
    ;; - checks running pods (health checks)
    (supervision-tick db)
    
    ;; sleep 5 seconds (like s6)
    ;; why 5 seconds? it's a balance between responsiveness and efficiency.
    ;; too frequent: wastes cpu checking pods constantly.
    ;; too infrequent: crashed pods take too long to restart.
    ;; 5 seconds is a reasonable default (s6 uses similar interval).
    (sleep 5)
    
    ;; repeat forever
    ;; why forever? daemons run until stopped. the supervision system
    ;; (s6, systemd, etc) handles starting/stopping/restarting the daemon.
    (loop)))

;; ============================================================================
;; utility functions
;; ============================================================================

;; log message (placeholder)
;; why this function? abstracts logging logic.
;; in real implementation, this would write to log file or syslog.
(define (log message)
  ;; placeholder: display to stdout
  ;; in real implementation, use proper logging library
  (displayln (string-append "🌾 [supervision] " message)))

;; ============================================================================
;; exports
;; ============================================================================

;; export public functions
;; supervision-tick
;; restart-pod
;; start-pod
;; pod-dependencies-ready?
;; check-pod-health
;; supervision-loop

