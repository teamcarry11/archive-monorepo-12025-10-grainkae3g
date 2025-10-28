#!/usr/bin/env steel

;; grainbranch-readme-sync.scm - Steel version
;; team: 12 (teamtravel12 - pisces ♓ / xii. the hanged man)
;; authored by: 14 (teamabsorb14 - ketu ☋ / xiv. temperance)
;; 
;; Syncs the current grainbranch README to root README (symlink)
;; "As above, so below" - outer reflects inner
;;
;; Usage: steel grainbranch-readme-sync.scm [grainbranch-name]
;;        If no grainbranch provided, uses current git branch

(require-builtin steel/process)
(require-builtin steel/filesystem)
(require-builtin steel/time)

;; =============================================================================
;; GLOW G2'S TEACHING COMMENTS
;; =============================================================================

;; Listen, what are we doing here?
;;
;; We have grainbranch READMEs that live deep in the repository:
;;   grainstore/grain6pbc/teamabsorb14/{grainbranch}/README.md
;;
;; But GitHub shows the root README.md by default.
;;
;; Question: How do we make the root README reflect the current grainbranch?
;;
;; Answer: Symlink! The root README.md becomes a symbolic link that points
;; to the current grainbranch's README. When you switch branches, you run
;; this script to update the symlink.
;;
;; Why symlink instead of copy?
;; - Changes to grainbranch README automatically show at root
;; - One source of truth (DRY principle)
;; - Git tracks the symlink, not duplicate content
;;
;; Does this make sense?

;; =============================================================================
;; HELPER FUNCTIONS
;; =============================================================================

(define (get-current-branch)
  "Get the current git branch name."
  (let ([result (command "git branch --show-current")])
    (if (void? result)
        (begin
          (displayln "⚠️  Could not determine current branch")
          #f)
        (trim result))))

(define (backup-root-readme)
  "Back up the current root README if it exists and isn't a symlink."
  (let* ([readme-path "README.md"]
         [timestamp (local-time->string (current-time))]
         [backup-path (string-append "README-backup-" 
                                    (replace timestamp ":" "")
                                    ".md")])
    (when (and (path/exists? readme-path)
              (path/is-file? readme-path))  ; Regular file, not symlink
      (displayln (string-append "📋 Backing up root README to: " backup-path))
      (command (string-append "cp " readme-path " " backup-path))
      backup-path)))

(define (create-symlink grainbranch-name)
  "Create symlink from root README to grainbranch README.
   
   Glow G2: This is where the magic happens. We're creating a symbolic link,
   which is like a shortcut or portal. The root README.md becomes a pointer
   to the grainbranch README.
   
   In Hermetic terms: As above (root), so below (grainbranch).
   The outer world (root) reflects the inner truth (grainbranch)."
  (let* ([target-path (string-append "grainstore/grain6pbc/teamabsorb14/" 
                                    grainbranch-name 
                                    "/README.md")]
         [link-path "README.md"])
    
    ; Check if target exists
    (if (not (path/exists? target-path))
        (begin
          (displayln (string-append "❌ Target README not found: " target-path))
          (displayln "   Create the grainbranch README first!")
          #f)
        
        (begin
          (displayln "🔗 Creating symlink...")
          (displayln (string-append "   From: " link-path " (root)"))
          (displayln (string-append "   To:   " target-path " (grainbranch)"))
          
          ; Remove existing README if it exists
          (when (path/exists? link-path)
            (command (string-append "rm " link-path)))
          
          ; Create the symlink
          (let ([result (command (string-append "ln -sf " target-path " " link-path))])
            (if (not (void? result))
                (begin
                  (displayln "✅ Symlink created successfully!")
                  (displayln "")
                  (displayln "As above, so below. 🌾")
                  (displayln "The outer (root) now reflects the inner (grainbranch).")
                  #t)
                (begin
                  (displayln "❌ Failed to create symlink")
                  #f)))))))

;; =============================================================================
;; MAIN FUNCTION
;; =============================================================================

(define (main args)
  "Main entry point for grainbranch README sync."
  (let ([grainbranch (if (empty? args) 
                        (get-current-branch) 
                        (first args))])
    
    (displayln "")
    (displayln "🌾 GRAINBRANCH README SYNC")
    (displayln (string-append "=" (make-string 60 #\=)))
    (displayln "")
    (displayln (string-append "Grainbranch: " (if grainbranch grainbranch "NONE")))
    (displayln "")
    
    (if (not grainbranch)
        (begin
          (displayln "❌ No grainbranch specified and could not detect current branch")
          (displayln "")
          (displayln "Usage: steel grainbranch-readme-sync.scm [grainbranch-name]")
          1)
        
        (begin
          ; Back up existing root README if needed
          (backup-root-readme)
          (displayln "")
          
          ; Create the symlink
          (if (create-symlink grainbranch)
              (begin
                (displayln "")
                (displayln "💡 Next steps:")
                (displayln "   1. git add README.md (add the symlink)")
                (displayln "   2. git commit -m \"docs: README symlinked to grainbranch\"")
                (displayln "   3. git push")
                (displayln "")
                (displayln "The root README now reflects your grainbranch README.")
                (displayln "Change the grainbranch README, and the root changes too.")
                (displayln "")
                0)
              1)))))

;; Run main with command-line args
(main (command-line-args))

