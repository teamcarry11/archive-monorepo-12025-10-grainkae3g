#!/usr/bin/env bb
;; grainmirror-carry11.bb - Sync teamkae3gtransform08 files to teamkae3gcarry11 grainstore
;; 
;; 🌊⚒️ Babashka fallback version (Steel preferred)
;;
;; Automatically syncs markdown files from teamkae3gtransform08 repo to teamkae3gcarry11 grainstore
;; Temporary Babashka version until Steel is fully implemented

(ns grainmirror-carry11
  (:require [babashka.fs :as fs]
            [babashka.process :refer [shell]]))

(def source-dir "/home/xy/github/kae3g/teamkae3gtransform08")
(def target-dir "/home/xy/kae3g/grainkae3g/grainstore/kae3g/teamkae3gcarry11")

(defn sync-files []
  (println "🌊 [grainmirror-carry11] Starting sync: teamkae3gtransform08 → teamkae3gcarry11 grainstore")
  
  ;; Check source directory exists
  (if (not (fs/exists? source-dir))
    (do
      (println (str "❌ [grainmirror-carry11 ERROR] Source directory does not exist: " source-dir))
      false)
    ;; Check target directory exists, create if not
    (do
      (when (not (fs/exists? target-dir))
        (fs/create-dirs target-dir)
        (println (str "📁 Created target directory: " target-dir)))
      
      ;; Sync markdown files using rsync
      (let [result (shell {:out :string
                           :err :string}
                          "rsync" "-av"
                          (str source-dir "/*.md")
                          (str target-dir "/"))]
        (println (:out result))
        (when (seq (:err result))
          (println (:err result)))
        (println "✅ [grainmirror-carry11] Sync complete!")
        true))))

(defn -main [& args]
  (sync-files))

(-main)

