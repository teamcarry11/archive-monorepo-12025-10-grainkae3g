#!/usr/bin/env bb

;; graincard width auto-fixer (babashka)
;; fixes all grain box lines to be exactly 80 display characters
;; adds/removes spacing as needed while preserving content

(require '[clojure.java.io :as io]
         '[clojure.string :as str])

(defn char-display-width
  "calculate display width of a character (unicode-aware)"
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

(defn fix-line-width
  "fix a single line to be exactly 80 display chars
   assumes format: │ content │
   preserves content, adjusts padding"
  [line]
  (let [width (string-display-width line)]
    (cond
      ;; perfect width - no changes
      (= width 80)
      line
      
      ;; too short - add spaces before closing │
      (< width 80)
      (let [missing (- 80 width)
            ;; find last │
            last-pipe-idx (.lastIndexOf line "│")
            before (subs line 0 last-pipe-idx)
            spaces (apply str (repeat missing \space))]
        (str before spaces "│"))
      
      ;; too long - remove spaces before closing │
      (> width 80)
      (let [excess (- width 80)
            ;; remove spaces before last │
            trimmed (str/replace line #" +│$"
                                (fn [match]
                                  (let [space-count (- (count match) 1)
                                        keep-spaces (max 1 (- space-count excess))]
                                    (str (apply str (repeat keep-spaces \space)) "│"))))]
        (if (not= (string-display-width trimmed) 80)
          ;; fallback: rebuild line with exact padding
          (let [content (-> line
                           (str/replace #"^│\s*" "")
                           (str/replace #"\s*│$" "")
                           str/trim)
                content-width (string-display-width content)
                needed-padding (- 76 content-width)
                padding (apply str (repeat (max 0 needed-padding) \space))]
            (str "│ " content padding " │"))
          trimmed)))))

(defn fix-grain-file
  "fix all box lines in a grain file to be exactly 80 chars"
  [filepath]
  (let [lines (str/split-lines (slurp filepath))
        filename (.getName (io/file filepath))]
    
    (if (not= 116 (count lines))
      (do
        (println (str "⚠️  " filename ": wrong total lines, skipping width fix"))
        false)
      
      (let [;; lines 1-5: header + opening fence (unchanged)
            header (subvec (vec lines) 0 5)
            ;; lines 6-115: box lines (fix width)
            box-lines (subvec (vec lines) 5 115)
            fixed-box (mapv fix-line-width box-lines)
            ;; line 116: closing fence (unchanged)
            closing [(nth lines 115)]
            ;; reassemble
            fixed-lines (vec (concat header fixed-box closing))
            fixed-content (str/join "\n" fixed-lines)]
        
        ;; write back
        (spit filepath (str fixed-content "\n"))
        (println (str "✅ " filename ": width fixed"))
        true))))

(defn fix-all-grains
  "fix all grains in a directory"
  [dir-path]
  (let [files (->> (io/file dir-path)
                   .listFiles
                   (filter #(.isFile %))
                   (filter #(str/ends-with? (.getName %) ".md"))
                   (filter #(not (str/includes? (.getName %) "README")))
                   (filter #(not (str/includes? (.getName %) "HELEN-LETTER")))
                   (sort-by #(.getName %)))
        results (mapv fix-grain-file files)
        fixed (count (filter identity results))]
    
    {:total (count results)
     :fixed fixed}))

(defn main
  [& args]
  (if (empty? args)
    (do
      (println "🎃 graincard width auto-fixer (babashka)")
      (println "fixes all grain box lines to exactly 80 display chars")
      (println "")
      (println "usage:")
      (println "  bb fix-grain-width.bb <grain-directory>")
      (println "")
      (println "now == next + 1 🌾")
      1)
    
    (let [grain-dir (first args)
          {:keys [total fixed]} (fix-all-grains grain-dir)]
      
      (println (str "\n📏 width fixing complete: " fixed "/" total " grains fixed"))
      (println "now == next + 1 🌾")
      0)))

(apply main *command-line-args*)

