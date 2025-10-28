#!/usr/bin/env steel
;;; GRAINMODULES REGISTRY - Complete Module Catalog
;;; 
;;; Hey! This is the master registry of ALL Grain Network modules.
;;; Think of it like a table of contents for the entire system.
;;;
;;; Every module is listed here with:
;;; - What it does (purpose)
;;; - What it depends on (dependencies)
;;; - What uses it (used-by)
;;; - Which team owns it (team)
;;; - Where it lives (location)
;;;
;;; This makes the architecture visible and navigable!
;;;
;;; Voice: Glow G2 (patient teacher, first principles)
;;; Team: 02 (teamtreasure02 - Cow Goddess 🐄)

(require-builtin steel/base)

;; What's a module in the Grain Network?
;;
;; It's a self-contained unit of functionality with:
;; - Clear purpose (what problem does it solve?)
;; - Explicit dependencies (what does it need?)
;; - Known dependents (what uses it?)
;; - Team ownership (who maintains it?)
;;
;; This structure makes complexity manageable through organization!

(define grainmodules
  "The complete registry of all Grain Network modules.
   
   Organized by layer (foundation → data → tools → platforms → etc.)
   Each module is a hash with all its metadata.
   
   Why organize by layer? Because it shows the dependency flow!
   Foundation modules have NO dependencies. Data modules depend on
   foundation. Tools depend on data. And so on up the stack.
   
   This is like building a house: foundation → frame → walls → roof.
   You can't build the roof before the foundation!"
  
  (hash
    ;; ═══════════════════════════════════════════════════════════
    ;; FOUNDATION LAYER - The Bedrock (no dependencies)
    ;; ═══════════════════════════════════════════════════════════
    "foundation" (list
      (hash
        "name" "graintime"
        "team" "teamshine05"
        "purpose" "Temporal coordinate system with astronomical precision"
        "location" "grain12pbc/teamshine05/graintime/"
        "data-structures" (list "graintime-hash")
        "dependencies" (list)
        "used-by" (list "grainbranch" "grain" "grainmark" "ALL-MODULES")
        "status" "active"
        "language" "Clojure + Steel (migrating)")
      
      (hash
        "name" "grainorder"
        "team" "teamillumine13"
        "purpose" "Base-13 encoding system (1,235,520 unique codes)"
        "location" "grain12pbc/teamillumine13/grainorder/"
        "data-structures" (list "grainorder-code")
        "dependencies" (list)
        "used-by" (list "grain" "grainbranch" "graincard")
        "status" "active"
        "language" "Steel")
      
      (hash
        "name" "grainmark"
        "team" "teamdance03"
        "purpose" "Identity system (like email for Grain Network)"
        "location" "grain12pbc/teamdance03/grainidentity/"
        "data-structures" (list "grainmark-hash")
        "dependencies" (list "graintime")
        "used-by" (list "grain" "grainweb" "graincomms")
        "status" "design"
        "language" "Steel"))
    
    ;; ═══════════════════════════════════════════════════════════
    ;; DATA LAYER - Knowledge Structures
    ;; ═══════════════════════════════════════════════════════════
    "data" (list
      (hash
        "name" "grain"
        "team" "teamquest09"
        "purpose" "80×110 knowledge card format"
        "location" "grain12pbc/teamquest09/graincard/"
        "data-structures" (list "grain-hash")
        "dependencies" (list "grainorder" "graintime" "grainmark")
        "used-by" (list "grainbook" "grainweb" "grainmode")
        "status" "active"
        "language" "Steel + Markdown")
      
      (hash
        "name" "grainbranch"
        "team" "teamrebel10"
        "purpose" "Git branch with temporal graintime naming"
        "location" "grain12pbc/teamrebel10/grainbranch/"
        "data-structures" (list "grainbranch-hash")
        "dependencies" (list "graintime")
        "used-by" (list "ALL-REPOS")
        "status" "active"
        "language" "Steel")
      
      (hash
        "name" "grainframe"
        "team" "teamflow12"
        "purpose" "Typed data containers (functional schemas)"
        "location" "grain12pbc/teamflow12/grain-metatypes/"
        "data-structures" (list "grainframe-hash")
        "dependencies" (list "grainorder" "graintime" "grainmark")
        "used-by" (list "ALL-MODULES")
        "status" "design"
        "language" "Steel"))
    
    ;; ═══════════════════════════════════════════════════════════
    ;; TOOL LAYER - Build System & Utilities
    ;; ═══════════════════════════════════════════════════════════
    "tools" (list
      (hash
        "name" "grainsteel"
        "team" "teamflow12"
        "purpose" "Steel scripting infrastructure (validators, generators, workflows)"
        "location-template" "grain12pbc/teamflow12/grainsteel/"
        "location-personal" "grainkae3g/grainkae3gsteel/"
        "data-structures" (list)
        "dependencies" (list)
        "used-by" (list "grainbarrel" "grainstore" "ALL-BUILD-SCRIPTS")
        "status" "active"
        "language" "Steel")
      
      (hash
        "name" "grainbarrel"
        "team" "teambright01"
        "purpose" "Build automation and CLI commands (gb/qb)"
        "location-template" "grain12pbc/teambright01/grainbarrel/"
        "location-personal" "grainkae3g/grainkae3gbarrel/"
        "data-structures" (list)
        "dependencies" (list "grainsteel")
        "used-by" (list "ALL-PROJECTS")
        "status" "active"
        "language" "Steel")
      
      (hash
        "name" "grainstore"
        "team" "teamtreasure02"
        "purpose" "Curated dependency registry and module management"
        "location-template" "grain12pbc/teamtreasure02/grainstore/"
        "location-personal" "grainkae3g/grainkae3gstore/"
        "data-structures" (list "module-registry-hash")
        "dependencies" (list "grainsteel")
        "used-by" (list "ALL-PROJECTS")
        "status" "migrating"
        "language" "Steel"))
    
    ;; ═══════════════════════════════════════════════════════════
    ;; PLATFORM LAYER - Applications & Services
    ;; ═══════════════════════════════════════════════════════════
    "platforms" (list
      (hash
        "name" "graindisplay"
        "team" "teamshine05"
        "purpose" "Display configuration and color management"
        "location-template" "grain12pbc/teamshine05/graindisplay/"
        "location-personal" "grainkae3g/grainkae3gdisplay/"
        "data-structures" (list "display-config-hash")
        "dependencies" (list)
        "used-by" (list "DESKTOP-ENVIRONMENT")
        "status" "active"
        "language" "Steel + System")
      
      (hash
        "name" "grainui"
        "team" "teamshine05"
        "purpose" "Immediate-mode GUI library (Steel + egui)"
        "location" "grain12pbc/teamshine05/grainui/"
        "data-structures" (list "widget-hash" "layout-hash")
        "dependencies" (list "grainsteel" "egui-rust")
        "used-by" (list "grainweb" "mantraos" "graindisplay")
        "status" "research"
        "language" "Steel + Rust FFI")
      
      (hash
        "name" "grainweb"
        "team" "teamdance03"
        "purpose" "Browser + Git explorer + Atlas alternative"
        "location" "grain12pbc/teamdance03/grainweb/"
        "data-structures" (list "page-hash" "connection-hash")
        "dependencies" (list "grain" "grainmark" "grainframe" "grainui")
        "used-by" (list "END-USERS")
        "status" "design"
        "language" "Steel + SvelteKit")
      
      (hash
        "name" "grain6"
        "team" "teambright01"
        "purpose" "Core daemon and supervision system (s6 integration)"
        "location" "grain12pbc/teambright01/grain6/"
        "data-structures" (list "service-hash" "supervision-hash")
        "dependencies" (list "graintime")
        "used-by" (list "SYSTEM")
        "status" "active"
        "language" "Rust + Steel + s6"))
    
    ;; ═══════════════════════════════════════════════════════════
    ;; META LAYER - Perspectives & Organization
    ;; ═══════════════════════════════════════════════════════════
    "meta" (list
      (hash
        "name" "grainmode"
        "team" "teamillumine13"
        "purpose" "Multiple perspectives on same content (voices)"
        "location" "grain12pbc/teamillumine13/grainmode/"
        "data-structures" (list "mode-hash" "transform-fn")
        "dependencies" (list "grain")
        "used-by" (list "grainbook" "grainweb")
        "status" "active"
        "language" "Steel")
      
      (hash
        "name" "grainpersona"
        "team" "teamrebel10"
        "purpose" "AI persona specifications (Glow G2, etc.)"
        "location" "grain12pbc/teamrebel10/grainpersona/"
        "data-structures" (list "persona-hash")
        "dependencies" (list)
        "used-by" (list "grainmode" "grainai-vocab")
        "status" "active"
        "language" "Markdown + Steel"))
    
    ;; ═══════════════════════════════════════════════════════════
    ;; MODULES META-MODULE
    ;; ═══════════════════════════════════════════════════════════
    "meta-meta" (list
      (hash
        "name" "grainmodules"
        "team" "teamtreasure02"
        "purpose" "Registry of all modules (this file!)"
        "location" "grain12pbc/teamtreasure02/grainmodules/"
        "data-structures" (list "module-hash" "registry-hash")
        "dependencies" (list)
        "used-by" (list "grainstore" "documentation")
        "status" "active"
        "language" "Steel"))))

;; ═══════════════════════════════════════════════════════════════
;; HELPER FUNCTIONS - Query the Registry
;; ═══════════════════════════════════════════════════════════════

(define (list-all-modules)
  "List all module names across all layers.
   
   This gives you a bird's-eye view of the entire system.
   Like looking at a map from above and seeing all the cities!"
  
  (let ([all-layers (list "foundation" "data" "tools" "platforms" "meta" "meta-meta")])
    (apply append
      (map (lambda (layer)
             (map (lambda (mod) (hash-get mod "name"))
                  (hash-get grainmodules layer)))
           all-layers))))

(define (get-module name)
  "Find a module by name across all layers.
   
   Why search across layers? Because you might not remember
   which layer a module is in. This finds it for you!"
  
  (let ([all-layers (list "foundation" "data" "tools" "platforms" "meta" "meta-meta")])
    (let loop ([layers all-layers])
      (if (empty? layers)
          #f  ; not found
          (let ([modules (hash-get grainmodules (first layers))])
            (let ([found (filter (lambda (m) (equal? (hash-get m "name") name)) modules)])
              (if (empty? found)
                  (loop (rest layers))
                  (first found))))))))

(define (get-dependencies module-name)
  "Get all dependencies for a module.
   
   This shows you what needs to exist BEFORE you can use this module.
   Like a recipe showing ingredients!"
  
  (let ([module (get-module module-name)])
    (if module
        (hash-get module "dependencies")
        (list))))

(define (get-dependents module-name)
  "Get all modules that depend on this one.
   
   This shows you what would break if you changed this module.
   Important for understanding impact!"
  
  (let ([module (get-module module-name)])
    (if module
        (hash-get module "used-by")
        (list))))

(define (print-module-info module-name)
  "Display complete information about a module.
   
   This is like looking up a word in a dictionary -
   you get the full definition, context, and usage!"
  
  (let ([module (get-module module-name)])
    (if module
        (begin
          (displayln "")
          (displayln "╔══════════════════════════════════════════════════════════╗")
          (displayln (string-append "║  🌾 " (hash-get module "name")))
          (displayln "╚══════════════════════════════════════════════════════════╝")
          (displayln "")
          (displayln (string-append "Purpose: " (hash-get module "purpose")))
          (displayln (string-append "Team: " (hash-get module "team")))
          (displayln (string-append "Status: " (hash-get module "status")))
          (displayln (string-append "Language: " (hash-get module "language")))
          (displayln "")
          (displayln "Dependencies:")
          (let ([deps (hash-get module "dependencies")])
            (if (empty? deps)
                (displayln "  (none - foundational!)")
                (for-each (lambda (dep) 
                           (displayln (string-append "  - " dep)))
                         deps)))
          (displayln "")
          (displayln "Used by:")
          (for-each (lambda (user) 
                     (displayln (string-append "  - " user)))
                   (hash-get module "used-by"))
          (displayln ""))
        (displayln (string-append "Module '" module-name "' not found in registry.")))))

;; ═══════════════════════════════════════════════════════════════
;; USAGE EXAMPLES
;; ═══════════════════════════════════════════════════════════════

;; How do you use this registry?
;;
;; Query specific modules:
;;   (print-module-info "graintime")
;;   (print-module-info "grainsteel")
;;
;; List all modules:
;;   (list-all-modules)
;;
;; Check dependencies:
;;   (get-dependencies "grain")      ; What does grain need?
;;   (get-dependents "graintime")    ; What uses graintime?
;;
;; This makes the architecture explorable and understandable!

;; Export for use in other Steel scripts
(provide grainmodules
         list-all-modules
         get-module
         get-dependencies
         get-dependents
         print-module-info)

(displayln "🌾 Grainmodules registry loaded!")
(displayln (string-append "📊 Total modules: " (number->string (length (list-all-modules)))))
(displayln "")
(displayln "Try: (print-module-info \"graintime\")")
(displayln "     (list-all-modules)")
(displayln "")
(displayln "now == next + 1 🌾")

