#!/usr/bin/env bb

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ FIX WRITINGS LINKS (Babashka)                                                ║
;; ║ Team: 04 (teamnurture04 - Taurus ♉ / IV. The Emperor)                       ║
;; ║ Copyright © 3x39 | Author: kae3g (kj3x39, @risc.love)                        ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(require '[clojure.java.io :as io]
         '[clojure.string :as str]
         '[cheshire.core :as json])

(defn fix-links [html-content base-url]
  "Fix hardcoded GitHub links to SPA-relative paths"
  (-> html-content
      ;; Fix chapter links: /12025-10/xbc-*.html → {base}/xbc-*
      (str/replace #"href='/12025-10/([xbdghjklmnsvz]{3,6}-[^']+)\.html'"
                   (str "href='" base-url "/$1'"))
      ;; Fix index link: /12025-10/ → {base}/
      (str/replace "href='/12025-10/'" (str "href='" base-url"/'"))
      ;; Fix any grainscript links if present
      (str/replace #"href='/grainkae3g/grainscript/"
                   (str "href='" base-url "/grainscript/"))))

(defn process-json-file! [file base-url]
  "Process a single JSON file and fix its links"
  (let [content (slurp file)
        data (json/parse-string content true)
        html (:html data)]
    
    (if html
      (let [fixed-html (fix-links html base-url)
            updated-data (assoc data :html fixed-html)]
        ;; Write updated JSON
        (spit file (json/generate-string updated-data {:pretty true}))
        (println (str "✅ Fixed: " (.getName file))))
      (println (str "⚠️  Skipped (no HTML): " (.getName file))))))

(defn main [content-dir base-url]
  "Process all JSON files in content directory"
  (let [dir (io/file content-dir)
        json-files (filter #(str/ends-with? (.getName %) ".json")
                          (file-seq dir))]
    
    (println "🎃 Fixing writings links for SPA navigation...")
    (println (str "Content dir: " content-dir))
    (println (str "Base URL: " base-url))
    (println)
    
    (doseq [file json-files]
      (process-json-file! file base-url))
    
    (println)
    (println "🎃 All links fixed! SPA navigation ready!")
    (println "now == next + 1 🌾")))

;; CLI
(when (< (count *command-line-args*) 2)
  (println "Usage: fix-writings-links.bb <content-dir> <base-url>")
  (println "")
  (println "Examples:")
  (println "  fix-writings-links.bb web-app/static/content /grainkae3g")
  (println "  fix-writings-links.bb web-app/static/content ''")
  (System/exit 1))

(main (first *command-line-args*) (second *command-line-args*))

