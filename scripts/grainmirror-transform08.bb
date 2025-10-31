#!/usr/bin/env bb
;; grainmirror-transform08.bb - Sync teamkae3gtransform08 files to grainstore
;; 
;; Automatically syncs markdown files from GitHub repo to grainstore

(ns grainmirror-transform08
  (:require [babashka.fs :as fs]
            [babashka.process :refer [shell]]))

(def source-dir "/home/xy/github/kae3g/teamkae3gtransform08")
(def target-dir "/home/xy/kae3g/grainkae3g/grainstore/kae3g/teamkae3gtransform08")

(defn sync-files []
  (println "🌾 Syncing teamkae3gtransform08 files to grainstore...")
  (let [result (shell {:out :string} 
                      "rsync" "-av" 
                      (str source-dir "/*.md")
                      (str target-dir "/"))]
    (println (:out result))
    (println "✅ Sync complete!")))

(defn -main [& args]
  (sync-files))

(-main)
