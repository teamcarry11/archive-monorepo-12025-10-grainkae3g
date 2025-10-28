#!/usr/bin/env bb

;; fix graincard header line (line 7) to exactly 80 chars
;; format: │ GRAINCARD xbdghj                            grain N of 1,235,520 │

(require '[clojure.java.io :as io]
         '[clojure.string :as str])

(defn fix-header-line
  "rebuild header line with exact 80-char width"
  [card-code grain-num]
  (let [;; Format: │ GRAINCARD xbdghj [spaces] grain N of 1,235,520 │
        ;; Total: 80 chars
        ;; │ = 1, space = 1, GRAINCARD = 9, space = 1, code = 6
        ;; "grain" = 5, space = 1, num = variable, " of 1,235,520" = 15, space = 1, │ = 1
        ;; So: 1 + 1 + 9 + 1 + 6 + padding + 1 + 5 + 1 + (num digits) + 15 + 1 + 1 = 80
        ;; Simplify: use sprintf-style formatting
        grain-text (format "grain %s of 1,235,520" grain-num)
        ;; │ GRAINCARD xbdghj [pad] grain N of 1,235,520 │
        ;; = 2 + 10 + 6 + pad + (grain text) + 2 = 80
        ;; = 18 + pad + (grain text) + 2 = 80
        ;; pad = 80 - 18 - (grain text) - 2 = 60 - (grain text)
        grain-text-len (count grain-text)
        padding (- 60 grain-text-len)
        padding-str (apply str (repeat padding \space))]
    (str "│ GRAINCARD " card-code padding-str grain-text " │")))

(defn fix-grain-header
  "fix header line in a single grain file"
  [filepath]
  (let [lines (str/split-lines (slurp filepath))
        filename (.getName (io/file filepath))]
    
    (if (< (count lines) 7)
      (println (str "⚠️  " filename ": not enough lines"))
      
      (let [line7 (nth lines 6)  ;; 0-indexed, so line 7 is index 6
            card-match (re-find #"xbd[ghjklmnsvz]{3}" line7)
            grain-match (second (re-find #"grain (\d+)" line7))]
        
        (if (and card-match grain-match)
          (let [new-line7 (fix-header-line card-match grain-match)
                new-lines (concat (take 6 lines) [new-line7] (drop 7 lines))
                new-content (str (str/join "\n" new-lines) "\n")]
            (spit filepath new-content)
            (println (str "✅ " filename)))
          (println (str "⚠️  " filename ": no header found on line 7")))))))

(defn main
  [& args]
  (if (empty? args)
    (do
      (println "🎃 graincard header fixer")
      (println "fixes line 7 (header line) to exactly 80 chars")
      (println "")
      (println "usage:")
      (println "  bb fix-grain-header.bb <grain-directory>")
      (println "")
      (println "now == next + 1 🌾")
      1)
    
    (let [grain-dir (first args)
          files (->> (io/file grain-dir)
                     .listFiles
                     (filter #(.isFile %))
                     (filter #(str/ends-with? (.getName %) ".md"))
                     (filter #(re-matches #"xbd[ghjklmnsvz]{3}.*" (.getName %)))
                     (sort-by #(.getName %)))]
      
      (doseq [f files]
        (fix-grain-header (.getPath f)))
      
      (println (str "\n📏 header fixing complete"))
      (println "now == next + 1 🌾")
      0)))

(apply main *command-line-args*)

