#!/usr/bin/env bb
;; grainbranch-readme-sync.bb - Babashka version
;; 
;; Syncs the current grainbranch README to root README (symlink)
;; "As above, so below" - outer reflects inner
;;
;; Usage: bb grainbranch-readme-sync.bb [grainbranch-name]
;;        If no grainbranch provided, uses current git branch

(require '[clojure.java.shell :refer [sh]]
         '[clojure.string :as str])

;; =============================================================================
;; GLOW'S TEACHING COMMENTS
;; =============================================================================

;; Listen, what are we doing here?
;;
;; We have grainbranch READMEs that live deep in the repository:
;;   grainstore/grain6pbc/teamdescend14/{grainbranch}/README.md
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

(defn get-current-branch
  "Get the current git branch name"
  []
  (let [result (sh "git" "branch" "--show-current")]
    (if (zero? (:exit result))
      (str/trim (:out result))
      (do
        (println "⚠️  Could not determine current branch")
        nil))))

(defn backup-root-readme
  "Back up the current root README if it exists and isn't a symlink"
  []
  (let [readme-path "README.md"
        backup-path (str "README-backup-" 
                        (str/replace (str (java.time.LocalDateTime/now)) #":" "") 
                        ".md")]
    (when (and (.exists (clojure.java.io/file readme-path))
              (not (.isSymbolicLink (.toPath (clojure.java.io/file readme-path)))))
      (println (str "📋 Backing up root README to: " backup-path))
      (sh "cp" readme-path backup-path)
      backup-path)))

(defn create-symlink
  "Create symlink from root README to grainbranch README
   
   Glow: This is where the magic happens. We're creating a symbolic link,
   which is like a shortcut or portal. The root README.md becomes a pointer
   to the grainbranch README.
   
   In Hermetic terms: As above (root), so below (grainbranch).
   The outer world (root) reflects the inner truth (grainbranch)."
  [grainbranch-name]
  (let [target-path (str "grainstore/grain6pbc/teamdescend14/" 
                        grainbranch-name 
                        "/README.md")
        link-path "README.md"]
    
    ;; Check if target exists
    (if-not (.exists (clojure.java.io/file target-path))
      (do
        (println (str "❌ Target README not found: " target-path))
        (println "   Create the grainbranch README first!")
        false)
      
      (do
        (println (str "🔗 Creating symlink..."))
        (println (str "   From: " link-path " (root)"))
        (println (str "   To:   " target-path " (grainbranch)"))
        
        ;; Remove existing README if it's a file (not symlink)
        (when (.exists (clojure.java.io/file link-path))
          (sh "rm" link-path))
        
        ;; Create the symlink
        (let [result (sh "ln" "-sf" target-path link-path)]
          (if (zero? (:exit result))
            (do
              (println "✅ Symlink created successfully!")
              (println)
              (println "As above, so below. 🌾")
              (println "The outer (root) now reflects the inner (grainbranch).")
              true)
            (do
              (println "❌ Failed to create symlink")
              (println (:err result))
              false)))))))

;; =============================================================================
;; MAIN FUNCTION
;; =============================================================================

(defn main
  [& args]
  (let [grainbranch (or (first args) (get-current-branch))]
    
    (println)
    (println "🌾 GRAINBRANCH README SYNC")
    (println "=" (apply str (repeat 60 "=")))
    (println)
    (println (str "Grainbranch: " grainbranch))
    (println)
    
    (if-not grainbranch
      (do
        (println "❌ No grainbranch specified and could not detect current branch")
        (println)
        (println "Usage: bb grainbranch-readme-sync.bb [grainbranch-name]")
        (System/exit 1))
      
      (do
        ;; Back up existing root README if needed
        (backup-root-readme)
        (println)
        
        ;; Create the symlink
        (if (create-symlink grainbranch)
          (do
            (println)
            (println "💡 Next steps:")
            (println "   1. git add README.md (add the symlink)")
            (println "   2. git commit -m \"docs: README symlinked to grainbranch\"")
            (println "   3. git push")
            (println)
            (println "The root README now reflects your grainbranch README.")
            (println "Change the grainbranch README, and the root changes too.")
            (println)
            (System/exit 0))
          (System/exit 1))))))

;; Run main
(apply main *command-line-args*)

