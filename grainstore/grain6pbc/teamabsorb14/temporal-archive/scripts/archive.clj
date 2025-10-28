#!/usr/bin/env bb

(ns archive
  "Temporal archive script - organize all markdown by commit timestamp.
   
   Glow: 'This script does the heavy lifting so you don't have to.
          It walks through every commit, finds when each file was last changed,
          and copies it to a dated folder with a graintime prefix.
          
          Think of it like organizing photos by date taken, not just filename.
          You'll be able to see your entire intellectual journey, day by day.'
   
   Usage:
   bb archive.clj session          ; Archive current session files
   bb archive.clj history          ; Archive full git history
   bb archive.clj external <repo>  ; Archive external repo"
  (:require [babashka.process :refer [shell sh]]
            [babashka.fs :as fs]
            [clojure.string :as str]))

;; ═══════════════════════════════════════════════════════════════
;; GIT HELPERS
;; ═══════════════════════════════════════════════════════════════

(defn get-file-last-commit
  "Get the last commit hash and timestamp for a file.
   
   Returns: {:hash \"abc123\" :date \"2025-10-26\" :time \"1040\" :tz \"PST\"}"
  [filepath]
  (try
    (let [result (sh "git" "log" "-1" "--format=%H %ci" "--" filepath)
          output (str/trim (:out result))]
      (when-not (str/blank? output)
        (let [[hash date time tz] (str/split output #"\s+")
              [year month day] (str/split date #"-")
              [hour minute _] (str/split time #":")]
          {:hash hash
           :date (str year "-" month "-" day)
           :time (str hour minute)
           :tz (if (str/includes? tz "-07") "PDT" "PST")  ; Simplify timezone
           :filepath filepath})))
    (catch Exception e
      (println "⚠️  Error getting commit for" filepath ":" (.getMessage e))
      nil)))

;; ═══════════════════════════════════════════════════════════════
;; GRAINTIME PREFIX
;; ═══════════════════════════════════════════════════════════════

(defn format-graintime-prefix
  "Create graintime prefix for filename.
   
   Format: 12025-10-DD--HHMM-PST--
   Example: 12025-10-26--1040-PST--"
  [{:keys [date time tz]}]
  (str "1" date "--" time "-" tz "--"))

(defn add-graintime-prefix
  "Add graintime prefix to filename, preserving extension.
   
   Example:
   'README.md' + {:date '2025-10-26' :time '1040' :tz 'PST'}
   => '12025-10-26--1040-PST--README.md'"
  [filename commit-info]
  (str (format-graintime-prefix commit-info) filename))

;; ═══════════════════════════════════════════════════════════════
;; ARCHIVE FUNCTIONS
;; ═══════════════════════════════════════════════════════════════

(defn archive-file
  "Copy file to temporal archive with graintime prefix.
   
   Steps:
   1. Get file's last commit timestamp
   2. Create dated folder (12025-10-26/)
   3. Copy file with graintime prefix
   4. Preserve original (immutable!)"
  [filepath archive-base]
  (when-let [commit-info (get-file-last-commit filepath)]
    (let [folder-date (:date commit-info)
          archive-dir (str archive-base "/" folder-date)
          filename (fs/file-name filepath)
          prefixed-name (add-graintime-prefix filename commit-info)
          dest-path (str archive-dir "/" prefixed-name)]
      
      (fs/create-dirs archive-dir)
      (fs/copy filepath dest-path {:replace-existing true})
      (println "✅" dest-path)
      
      {:source filepath
       :destination dest-path
       :commit commit-info})))

;; ═══════════════════════════════════════════════════════════════
;; SESSION ARCHIVAL (Phase 1)
;; ═══════════════════════════════════════════════════════════════

(def session-files
  "Files from gkh session (2025-10-26)"
  [;; Personal notes
   "personal-notes/seb-alex-animal-rights-vegan-advocacy.md"
   "personal-notes/claudia-kuper-vegan-animal-rescue.md"
   "personal-notes/mag-vegan-artist-activist-discord.md"
   "personal-notes/besties-vegan-paradise-veggie-awards.md"
   "personal-notes/happycow-vegan-commerce-strategy.md"
   "personal-notes/clipse-pusha-t-malice-let-god-sort-em-out.md"
   "personal-notes/ty-dolla-sign-collaboration-artistry.md"
   "personal-notes/shell-strategy-qb-gb-nushell.md"
   
   ;; Architecture
   "grainstore/grain6pbc/teamplay04/GRAINBARREL-KETOS-ARCHITECTURE.md"
   "grainstore/grain6pbc/teamplay04/UNIVERSAL-PACKAGE-ABSTRACTION.md"
   "grainstore/grain6pbc/teamillumine13/GRAINORDER-SPEC.md"
   "grainstore/grain6pbc/teamillumine13/CHARTCOURSE-RANGE-CALCULATION.md"
   "grainstore/grain6pbc/teamabsorb14/GRAINTIME-ASCENDANT-DEBUG.md"
   
   ;; Session docs
   "grainstore/grain6pbc/teamabsorb14/gkh-chartcourse-ketos-vision-session.md"
   "grainstore/grain6pbc/teamabsorb14/gkh-ARE-WE-ON-TRACK.md"
   "grainstore/grain6pbc/teamabsorb14/GRAIN-NETWORK-DIRECTORY.md"
   
   ;; Ketos Synthesis
   "grainstore/grain6pbc/teamabsorb14/KETOS-VISION-SYNTHESIS/INDEX.md"
   "grainstore/grain6pbc/teamabsorb14/KETOS-VISION-SYNTHESIS/xbd-team14-ketos-descent-philosophy.md"
   
   ;; Personas
   "grainstore/grain6pbc/teamrebel10/grainpersona/GLOW-PERSONA-V2.md"
   
   ;; Friends
   "grainstore/grain6pbc/teamplay04/grainfriends/README.md"])

(defn archive-session!
  "Archive all files from current session (gkh)."
  []
  (let [archive-base "grainstore/grain6pbc/teamabsorb14/temporal-archive"]
    (println "🌾 Archiving gkh session files...\n")
    (doseq [file session-files]
      (when (fs/exists? file)
        (archive-file file archive-base)))
    (println "\n✅ Session archive complete!")))

;; ═══════════════════════════════════════════════════════════════
;; FULL HISTORY ARCHIVAL (Phase 2)
;; ═══════════════════════════════════════════════════════════════

(defn get-all-markdown-files-from-history
  "Get all markdown files that have ever existed in git history."
  []
  (let [result (sh "git" "log" "--all" "--name-only" "--format=" "--" "*.md")
        files (-> result :out str/trim (str/split #"\n"))]
    (->> files
         (filter #(not (str/blank? %)))
         (filter #(str/ends-with? % ".md"))
         distinct
         sort)))

(defn archive-history!
  "Archive ALL markdown files from entire git history."
  []
  (let [archive-base "grainstore/grain6pbc/teamabsorb14/temporal-archive"
        all-md-files (get-all-markdown-files-from-history)
        total (count all-md-files)]
    
    (println (str "🌾 Found " total " unique markdown files in git history\n"))
    (println "This may take a few minutes...\n")
    
    (doseq [[idx file] (map-indexed vector all-md-files)]
      (when (fs/exists? file)
        (when (zero? (mod idx 10))
          (println (str "Progress: " idx "/" total)))
        (archive-file file archive-base)))
    
    (println (str "\n✅ Full history archive complete! (" total " files)"))))

;; ═══════════════════════════════════════════════════════════════
;; CLI
;; ═══════════════════════════════════════════════════════════════

(defn -main [& args]
  (case (first args)
    "session"  (archive-session!)
    "history"  (archive-history!)
    "external" (println "External repo archival not yet implemented")
    (do
      (println "Temporal Archive Script")
      (println)
      (println "Usage:")
      (println "  bb archive.clj session   ; Archive current session")
      (println "  bb archive.clj history   ; Archive full git history")
      (println "  bb archive.clj external  ; Archive external repos")
      (println))))

(when (= *file* (System/getProperty "babashka.file"))
  (apply -main *command-line-args*))

