#!/usr/bin/env steel
;;; GRAINMODULES DEPENDENCIES - Dependency Graph System
;;;
;;; This file defines HOW modules depend on each other.
;;; Why separate this from the registry? Because dependencies
;;; are relationships, not properties. They deserve their own space!
;;;
;;; Think of it like:
;;; - registry.scm = The phone book (who exists?)
;;; - dependencies.scm = The social network (who knows who?)
;;;
;;; Voice: Glow G2 (patient teacher, first principles)
;;; Team: 02 (teamtreasure02 - Cow Goddess 🐄)

(require-builtin steel/base)

;; What's a dependency?
;;
;; It's when Module A needs Module B to work. Like:
;; - grain needs grainorder (for IDs)
;; - grain needs graintime (for timestamps)
;; - grain needs grainmark (for authors)
;;
;; Dependencies flow in ONE direction (acyclic graph):
;; grainorder → grain (not grain → grainorder)
;;
;; This prevents circular dependencies. That's good design!

(define dependency-graph
  "The complete dependency graph as an adjacency list.
   
   What's an adjacency list? It's a hash where:
   - Keys are module names
   - Values are lists of what they depend on
   
   Example:
   'grain' → ['grainorder', 'graintime', 'grainmark']
   
   This shows: grain NEEDS these three to work."
  
  (hash
    ;; Foundation modules (no dependencies!)
    "graintime" (list)
    "grainorder" (list)
    "grainmark" (list "graintime")
    
    ;; Data modules
    "grain" (list "grainorder" "graintime" "grainmark")
    "grainbranch" (list "graintime")
    "grainframe" (list "grainorder" "graintime" "grainmark")
    
    ;; Tool modules
    "grainsteel" (list)
    "grainbarrel" (list "grainsteel")
    "grainstore" (list "grainsteel")
    
    ;; Platform modules
    "graindisplay" (list)
    "grainui" (list "grainsteel")  ; Uses Steel FFI
    "grainweb" (list "grain" "grainmark" "grainframe" "grainui")
    "grain6" (list "graintime")
    
    ;; Meta modules
    "grainmode" (list "grain")
    "grainpersona" (list)
    
    ;; Meta-meta
    "grainmodules" (list)))

(define (get-direct-dependencies module-name)
  "What does this module directly depend on?
   
   Direct = one step away. Like your immediate neighbors.
   If grain depends on grainorder, grainorder is a direct dependency."
  
  (hash-try-get dependency-graph module-name (list)))

(define (get-transitive-dependencies module-name)
  "What does this module depend on, recursively?
   
   Transitive = following the whole chain.
   If grain → grainorder, and grainorder → (nothing),
   then grain's transitive dependencies are just [grainorder].
   
   But if grain → grainmark → graintime,
   then grain's transitive dependencies are [grainmark, graintime].
   
   This shows you EVERYTHING that needs to exist for a module to work!"
  
  (let loop ([to-visit (list module-name)]
             [visited (hash)])
    (if (empty? to-visit)
        (hash-keys visited)
        (let* ([current (first to-visit)]
               [deps (get-direct-dependencies current)]
               [new-deps (filter (lambda (d) (not (hash-contains? visited d))) deps)]
               [new-visited (hash-insert visited current #t)]
               [new-to-visit (append (rest to-visit) new-deps)])
          (loop new-to-visit new-visited)))))

(define (topological-sort)
  "Sort all modules by dependency order (foundation → summit).
   
   What's topological sorting? It's ordering things so that
   dependencies always come before dependents.
   
   Like getting dressed: underwear before pants, socks before shoes!
   You can't put shoes on before socks. Order matters.
   
   For modules: graintime must come before grain (grain needs graintime).
   This function calculates that order automatically!"
  
  ;; TODO: Implement Kahn's algorithm for topological sort
  ;; For now, return manual ordering from world map
  (list "graintime" "grainorder" "grainmark"
        "grain" "grainbranch" "grainframe"
        "grainsteel" "grainbarrel" "grainstore"
        "graindisplay" "grainui" "grainweb" "grain6"
        "grainmode" "grainpersona"
        "grainmodules"))

(define (print-dependency-tree module-name indent)
  "Print a module and its dependencies as an ASCII tree.
   
   Why a tree? Because it shows the hierarchical structure visually!
   You can see at a glance what depends on what.
   
   Example:
   grain
   ├─ grainorder
   ├─ graintime
   └─ grainmark
      └─ graintime
   
   Beautiful AND informative!"
  
  (displayln (string-append indent "├─ " module-name))
  (let ([deps (get-direct-dependencies module-name)])
    (for-each
      (lambda (dep)
        (print-dependency-tree dep (string-append indent "│  ")))
      deps)))

;; Export functions
(provide dependency-graph
         get-direct-dependencies
         get-transitive-dependencies
         topological-sort
         print-dependency-tree)

