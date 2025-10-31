#!/usr/bin/env steel
;; state.scm - orchestrator state management using graindb
;;
;; grain package: grainorchestrator
;; module: core/state.scm
;; purpose: manages orchestrator state using graindb
;;
;; this module manages the grainorchestrator state using graindb.
;; all state changes are facts (eavt tuples). queries use datalog.
;;
;; installation: installed via grain package manager as part of grainorchestrator
;; usage: (require "grainorchestrator/core/state.scm")
;;
;; why graindb? it gives us:
;; - immutable facts (every change preserved)
;; - time-travel queries (debug historical state)
;; - event sourcing (state computed from facts)
;; - datalog queries (expressive, composable)
;;
;; does this make sense? instead of mutable state variables,
;; we store facts. the current state is computed by querying
;; the newest fact for each [entity, attribute] pair.
;;
;; think of it like git: we don't store every commit's full
;; file tree. we store commits, and compute the current state
;; by replaying them. graindb does the same for our orchestrator state.
;;
;; package context: this module is part of the grainorchestrator package,
;; which provides a kubernetes replacement for the grain network ecosystem.
;; it integrates with graindb (another grain package) for state persistence.

;; ============================================================================
;; schema definition
;; ============================================================================

;; orchestrator state schema
;; why a schema? it defines what attributes exist, their types,
;; and constraints (like uniqueness). this helps catch errors early
;; and makes queries more efficient.
(define orchestrator-schema
  ;; pod attributes
  '{:pod/id {:db/valueType :db.type/string
             :db/cardinality :db.cardinality/one
             :db/unique :db.unique/identity
             :db/doc "pod identifier (grainorder code)"}
    
    :pod/node {:db/valueType :db.type/string
               :db/cardinality :db.cardinality/one
               :db/doc "node where pod is scheduled"}
    
    :pod/status {:db/valueType :db.type/keyword
                 :db/cardinality :db.cardinality/one
                 :db/doc "pod status (:pending :scheduled :starting :running :crashed :finishing :stopped)"}
    
    :pod/spec {:db/valueType :db.type/string
               :db/cardinality :db.cardinality/one
               :db/doc "pod specification (json string)"}
    
    :pod/cpu-request {:db/valueType :db.type/number
                      :db/cardinality :db.cardinality/one
                      :db/doc "cpu resources requested by pod"}
    
    :pod/memory-request {:db/valueType :db.type/number
                         :db/cardinality :db.cardinality/one
                         :db/doc "memory resources requested by pod (mb)"}
    
    :pod/depends-on {:db/valueType :db.type/ref
                     :db/cardinality :db.cardinality/many
                     :db/doc "pod dependencies (other pods that must be running)"}
    
    :pod/restart-policy {:db/valueType :db.type/keyword
                         :db/cardinality :db.cardinality/one
                         :db/doc "restart policy (:always :on-failure :never)"}
    
    ;; node attributes
    :node/id {:db/valueType :db.type/string
              :db/cardinality :db.cardinality/one
              :db/unique :db.unique/identity
              :db/doc "node identifier"}
    
    :node/status {:db/valueType :db.type/keyword
                  :db/cardinality :db.cardinality/one
                  :db/doc "node status (:up :down :draining)"}
    
    :node/cpu-total {:db/valueType :db.type/number
                     :db/cardinality :db.cardinality/one
                     :db/doc "total cpu capacity (cores)"}
    
    :node/memory-total {:db/valueType :db.type/number
                        :db/cardinality :db.cardinality/one
                        :db/doc "total memory capacity (mb)"}
    
    :node/cpu-allocated {:db/valueType :db.type/number
                          :db/cardinality :db.cardinality/one
                          :db/doc "allocated cpu (cores)"}
    
    :node/memory-allocated {:db/valueType :db.type/number
                             :db/cardinality :db.cardinality/one
                             :db/doc "allocated memory (mb)"}})

;; ============================================================================
;; database creation
;; ============================================================================

;; create orchestrator database
;; why this function? abstracts database creation and schema installation.
;; in the future, we might want to load from disk, connect to remote db, etc.
;; this function gives us a single entry point.
;;
;; redox os note: on redox, we use file:// urls for persistence.
;; example: file:///var/lib/grainorchestrator/state.db
;; redox's scheme system routes file:// urls to the filesystem daemon.
(define (make-orchestrator-db)
  ;; note: in real implementation, this would call graindb's make-graindb
  ;; for now, we'll define a placeholder structure
  ;; when graindb is implemented, replace this with actual graindb call
  (let ([db (make-graindb)])
    (install-schema db orchestrator-schema)))

;; load orchestrator database from file (platform-abstracted)
;; why this function? loads database from file, abstracting platform differences.
;; - host mode: traditional path like "/var/lib/grainorchestrator/state.db"
;; - redox mode: file:// url like "file:///var/lib/grainorchestrator/state.db"
;; uses platform abstraction layer to handle differences.
(define (load-orchestrator-db path)
  ;; use platform abstraction to load database
  (require "utils/platform.scm")
  (let ([db (platform-load-db path)])
    ;; ensure schema is installed
    (install-schema db orchestrator-schema)))

;; save orchestrator database to file (platform-abstracted)
;; why this function? saves database to file, abstracting platform differences.
;; - host mode: traditional path
;; - redox mode: file:// url
;; uses platform abstraction layer to handle differences.
(define (save-orchestrator-db db path)
  ;; use platform abstraction to save database
  (require "utils/platform.scm")
  (platform-save-db db path))

;; ============================================================================
;; state queries
;; ============================================================================

;; query: find all running pods
;; why this query? supervision loop needs to check running pods for health.
;; this query finds all pods with status :running (newest fact only).
(define (get-running-pods db)
  ;; note: this is pseudocode showing the intent
  ;; real implementation would use graindb's q function
  (q db
    '[:find ?pod ?node
      :where [?pod :pod/status :running ?tx]
             [(max-tx ?pod :pod/status) ?max-tx]
             [(= ?tx ?max-tx)]
             [?pod :pod/node ?node ?tx2]
             [(max-tx ?pod :pod/node) ?max-tx2]
             [(= ?tx2 ?max-tx2)]]))

;; query: find crashed pods
;; why this query? supervision loop needs to restart crashed pods.
;; finds all pods with status :crashed (newest fact only).
(define (get-crashed-pods db)
  (q db
    '[:find ?pod ?node
      :where [?pod :pod/status :crashed ?tx]
             [(max-tx ?pod :pod/status) ?max-tx]
             [(= ?tx ?max-tx)]
             [?pod :pod/node ?node ?tx2]
             [(max-tx ?pod :pod/node) ?max-tx2]
             [(= ?tx2 ?max-tx2)]]))

;; query: find pending pods (waiting to be scheduled)
;; why this query? scheduler needs to find pods that haven't been scheduled yet.
(define (get-pending-pods db)
  (q db
    '[:find ?pod
      :where [?pod :pod/status :pending ?tx]
             [(max-tx ?pod :pod/status) ?max-tx]
             [(= ?tx ?max-tx)]]))

;; query: find scheduled pods (assigned to node, waiting to start)
;; why this query? supervision loop needs to start scheduled pods
;; after their dependencies are ready.
(define (get-scheduled-pods db)
  (q db
    '[:find ?pod
      :where [?pod :pod/status :scheduled ?tx]
             [(max-tx ?pod :pod/status) ?max-tx]
             [(= ?tx ?max-tx)]]))

;; query: find nodes with available resources
;; why this query? scheduler needs to find nodes that can fit a pod.
;; filters nodes by available cpu and memory.
(define (get-available-nodes db required-cpu required-memory)
  (q db
    `[:find ?node ?available-cpu ?available-memory
      :where [?node :node/status :up ?tx1]
             [(max-tx ?node :node/status) ?max-tx1]
             [(= ?tx1 ?max-tx1)]
             [?node :node/cpu-total ?total-cpu ?tx2]
             [(max-tx ?node :node/cpu-total) ?max-tx2]
             [(= ?tx2 ?max-tx2)]
             [?node :node/cpu-allocated ?allocated-cpu ?tx3]
             [(max-tx ?node :node/cpu-allocated) ?max-tx3]
             [(= ?tx3 ?max-tx3)]
             [(- ?total-cpu ?allocated-cpu) ?available-cpu]
             [(>= ?available-cpu ,required-cpu)]
             [?node :node/memory-total ?total-mem ?tx4]
             [(max-tx ?node :node/memory-total) ?max-tx4]
             [(= ?tx4 ?max-tx4)]
             [?node :node/memory-allocated ?allocated-mem ?tx5]
             [(max-tx ?node :node/memory-allocated) ?max-tx5]
             [(= ?tx5 ?max-tx5)]
             [(- ?total-mem ?allocated-mem) ?available-memory]
             [(>= ?available-memory ,required-memory)]]))

;; query: get pod dependencies
;; why this query? supervision needs to check if pod dependencies are ready
;; before starting the pod.
(define (get-pod-dependencies db pod-id)
  (q db
    `[:find ?dep
      :where [,pod-id :pod/depends-on ?dep]]))

;; query: get pod status
;; why this query? supervision and scheduling need to check pod status.
;; returns the newest status fact for a pod.
(define (get-pod-status db pod-id)
  (let ([results (q db
                    `[:find ?status
                      :where [,pod-id :pod/status ?status ?tx]
                             [(max-tx ,pod-id :pod/status) ?max-tx]
                             [(= ?tx ?max-tx)]])])
    (if (null? results)
        #f
        (car (car results)))))

;; query: get pod node
;; why this query? need to know which node a pod is scheduled on.
(define (get-pod-node db pod-id)
  (let ([results (q db
                    `[:find ?node
                      :where [,pod-id :pod/node ?node ?tx]
                             [(max-tx ,pod-id :pod/node) ?max-tx]
                             [(= ?tx ?max-tx)]])])
    (if (null? results)
        #f
        (car (car results)))))

;; query: get pod spec
;; why this query? scheduler needs pod spec to check resource requirements.
(define (get-pod-spec db pod-id)
  (let ([results (q db
                    `[:find ?spec
                      :where [,pod-id :pod/spec ?spec ?tx]
                             [(max-tx ,pod-id :pod/spec) ?max-tx]
                             [(= ?tx ?max-tx)]])])
    (if (null? results)
        #f
        (car (car results)))))

;; query: get node cpu allocated
;; why this query? scheduler needs to track resource allocation.
(define (get-node-cpu-allocated db node-id)
  (let ([results (q db
                    `[:find ?allocated
                      :where [,node-id :node/cpu-allocated ?allocated ?tx]
                             [(max-tx ,node-id :node/cpu-allocated) ?max-tx]
                             [(= ?tx ?max-tx)]])])
    (if (null? results)
        0
        (car (car results)))))

;; query: get node memory allocated
;; why this query? scheduler needs to track resource allocation.
(define (get-node-memory-allocated db node-id)
  (let ([results (q db
                    `[:find ?allocated
                      :where [,node-id :node/memory-allocated ?allocated ?tx]
                             [(max-tx ,node-id :node/memory-allocated) ?max-tx]
                             [(= ?tx ?max-tx)]])])
    (if (null? results)
        0
        (car (car results)))))

;; query: get pod restart policy
;; why this query? supervision needs to know if pod should be restarted.
(define (get-pod-restart-policy db pod-id)
  (let ([results (q db
                    `[:find ?policy
                      :where [,pod-id :pod/restart-policy ?policy ?tx]
                             [(max-tx ,pod-id :pod/restart-policy) ?max-tx]
                             [(= ?tx ?max-tx)]])])
    (if (null? results)
        ':always  ; default restart policy
        (car (car results)))))

;; ============================================================================
;; state mutations
;; ============================================================================

;; create pod
;; why this function? api needs to create new pods.
;; adds facts for pod id, status, spec, and resource requests.
(define (create-pod db pod-id pod-spec)
  ;; extract resource requests from pod spec
  ;; note: in real implementation, parse json pod-spec
  (let ([cpu-request (pod-spec-cpu pod-spec)]
        [memory-request (pod-spec-memory pod-spec)]
        [restart-policy (pod-spec-restart-policy pod-spec ':always)]
        [dependencies (pod-spec-dependencies pod-spec '())])
    ;; transact facts to database
    (transact! db
      `({:db/id ,pod-id
         :pod/status :pending
         :pod/spec ,(json-stringify pod-spec)
         :pod/cpu-request ,cpu-request
         :pod/memory-request ,memory-request
         :pod/restart-policy ,restart-policy
         ,@(map (lambda (dep)
                  `{:db/id ,pod-id
                    :pod/depends-on ,dep})
                dependencies)}))))

;; update pod status
;; why this function? supervision needs to change pod status.
;; adds new fact with new status (old status fact remains!).
(define (update-pod-status db pod-id new-status)
  (transact! db
    `({:db/id ,pod-id
       :pod/status ,new-status})))

;; assign pod to node
;; why this function? scheduler assigns pods to nodes.
;; updates pod node and status, and updates node resource allocation.
(define (assign-pod-to-node db pod-id node-id)
  ;; get pod resource requests
  (let* ([pod-spec (get-pod-spec db pod-id)]
         [cpu-request (pod-spec-cpu pod-spec)]
         [memory-request (pod-spec-memory pod-spec)]
         [current-cpu-allocated (get-node-cpu-allocated db node-id)]
         [current-memory-allocated (get-node-memory-allocated db node-id)])
    ;; transact facts: pod assignment and resource allocation
    (transact! db
      `({:db/id ,pod-id
         :pod/node ,node-id
         :pod/status :scheduled}
        {:db/id ,node-id
         :node/cpu-allocated ,(+ current-cpu-allocated cpu-request)}
        {:db/id ,node-id
         :node/memory-allocated ,(+ current-memory-allocated memory-request)}))))

;; register node
;; why this function? new nodes need to register with orchestrator.
;; adds facts for node id, status, and resource capacities.
(define (register-node db node-id node-spec)
  (let ([cpu-total (node-spec-cpu node-spec)]
        [memory-total (node-spec-memory node-spec)])
    (transact! db
      `({:db/id ,node-id
         :node/status :up
         :node/cpu-total ,cpu-total
         :node/memory-total ,memory-total
         :node/cpu-allocated 0
         :node/memory-allocated 0}))))

;; ============================================================================
;; helper functions (placeholder implementations)
;; ============================================================================

;; note: these are placeholder functions that would be implemented
;; when graindb is available. for now, they show the interface.

;; extract cpu request from pod spec
;; why this function? abstracts pod spec parsing.
;; in real implementation, parse json and extract cpu field.
(define (pod-spec-cpu pod-spec)
  ;; placeholder: return default cpu request
  1.0)

;; extract memory request from pod spec
(define (pod-spec-memory pod-spec)
  ;; placeholder: return default memory request (mb)
  512)

;; extract restart policy from pod spec
(define (pod-spec-restart-policy pod-spec default)
  ;; placeholder: return default or extract from spec
  default)

;; extract dependencies from pod spec
(define (pod-spec-dependencies pod-spec default)
  ;; placeholder: return default or extract from spec
  default)

;; extract cpu capacity from node spec
(define (node-spec-cpu node-spec)
  ;; placeholder: return default cpu capacity
  4.0)

;; extract memory capacity from node spec
(define (node-spec-memory node-spec)
  ;; placeholder: return default memory capacity (mb)
  8192)

;; json stringify (placeholder)
;; why this function? pod spec needs to be stored as string.
;; in real implementation, use json library.
(define (json-stringify obj)
  ;; placeholder: return empty string
  "")

;; ============================================================================
;; exports
;; ============================================================================

;; export public functions
;; why exports? other modules need to use these functions.
;; steel module system would handle this (module.exports or similar).

;; state queries
;; get-running-pods
;; get-crashed-pods
;; get-pending-pods
;; get-scheduled-pods
;; get-available-nodes
;; get-pod-dependencies
;; get-pod-status
;; get-pod-node
;; get-pod-spec
;; get-node-cpu-allocated
;; get-node-memory-allocated
;; get-pod-restart-policy

;; state mutations
;; make-orchestrator-db
;; create-pod
;; update-pod-status
;; assign-pod-to-node
;; register-node

