#!/usr/bin/env bb

;; graincard width validator (babashka bridge to ketos)
;; checks that all grain box lines are exactly 80 display characters
;; unicode-aware display width calculation

(require '[clojure.java.io :as io]
         '[clojure.string :as str])

(defn char-display-width
  "calculate display width of a character (unicode-aware)
   handles box-drawing, cjk wide chars, combining marks, etc."
  [c]
  (let [code (int c)]
    (cond
      (< code 32) 0                              ;; control chars
      (< code 127) 1                             ;; ascii
      (<= 0x2500 code 0x257F) 1                  ;; box-drawing
      (<= 0x3000 code 0x9FFF) 2                  ;; cjk wide
      (<= 0x0300 code 0x036F) 0                  ;; combining marks
      :else 1)))                                 ;; default

(defn string-display-width
  "calculate total display width of string"
  [s]
  (reduce + (map char-display-width s)))

(defn check-grain-width
  "check a single grain file for 80-char width compliance"
  [filepath]
  (let [lines (str/split-lines (slurp filepath))
        total-lines (count lines)
        filename (.getName (io/file filepath))]
    
    (if (not= 116 total-lines)
      {:file filename :valid false :error (str "wrong total lines: " total-lines)}
      
      (let [box-lines (subvec (vec lines) 5 115)  ;; lines 6-115 (indices 5-114)
            width-errors (->> box-lines
                             (map-indexed
                               (fn [idx line]
                                 (let [width (string-display-width line)]
                                   (when (not= 80 width)
                                     {:line (+ idx 6) :width width :content line}))))
                             (remove nil?)
                             vec)]
        
        (if (empty? width-errors)
          {:file filename :valid true}
          {:file filename :valid false :errors width-errors})))))

(defn check-all-grains
  "check all grains in a directory"
  [dir-path]
  (let [files (->> (io/file dir-path)
                   .listFiles
                   (filter #(.isFile %))
                   (filter #(str/ends-with? (.getName %) ".md"))
                   (sort-by #(.getName %)))
        results (map check-grain-width files)
        invalid (filter #(not (:valid %)) results)]
    
    {:total (count results)
     :valid (- (count results) (count invalid))
     :invalid invalid}))

(defn main
  [& args]
  (if (empty? args)
    (do
      (println "🎃 graincard width validator (babashka)")
      (println "checks that all grain box lines are exactly 80 display chars")
      (println "")
      (println "usage:")
      (println "  bb check-grain-width.bb <grain-directory>")
      (println "")
      (println "now == next + 1 🌾")
      1)
    
    (let [grain-dir (first args)
          {:keys [total valid invalid]} (check-all-grains grain-dir)]
      
      (println (str "\n📏 checking width in: " grain-dir))
      
      (doseq [{:keys [file errors]} invalid]
        (println (str "\n❌ " file))
        (doseq [{:keys [line width]} errors]
          (println (str "   line " line ": " width " chars (expected 80)"))))
      
      (println (str "\n📊 " valid "/" total " grains have correct width"))
      
      (if (= valid total)
        (do (println "✅ all grains valid!")
            0)
        (do (println "⚠️  some grains need width fixes")
            1)))))

(apply main *command-line-args*)

