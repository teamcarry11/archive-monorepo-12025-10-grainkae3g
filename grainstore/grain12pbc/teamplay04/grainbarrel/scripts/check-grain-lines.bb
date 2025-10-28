#!/usr/bin/env bb

(require '[clojure.string :as str]
         '[clojure.java.io :as io])

(defn count-box-lines [filepath]
  "Count lines within the ASCII box (between fences, excluding fences)"
  (let [lines (str/split-lines (slurp filepath))
        opening-fence-idx (first (keep-indexed #(when (str/starts-with? %2 "```") %1) lines))
        closing-fence-idx (last (keep-indexed #(when (str/starts-with? %2 "```") %1) lines))]
    (if (and opening-fence-idx closing-fence-idx)
      (let [box-start (inc opening-fence-idx)  ; Line after opening ```
            box-end (dec closing-fence-idx)     ; Line before closing ```
            box-lines (- box-end box-start -1)  ; Inclusive count
            total-lines (count lines)]
        {:file (str filepath)
         :total total-lines
         :box-lines box-lines
         :box-start box-start
         :box-end box-end
         :target 110
         :diff (- box-lines 110)
         :needs-work? (not= box-lines 110)})
      {:file (str filepath)
       :error "No ASCII box fences found"})))

(defn check-all-grains [base-dir]
  "Check all grain markdown files"
  (let [modes ["grains-glow-g2-mode" "grains-helen-mode" "grains-davinci-mode" 
               "grains-ariana-mode" "grains-oxford-mode" "grains-rich-mode"]
        results (for [mode modes
                      :let [mode-dir (io/file base-dir mode)]
                      :when (.exists mode-dir)
                      file (filter #(and (.isFile %)
                                        (str/ends-with? (.getName %) ".md")
                                        (str/starts-with? (.getName %) "x"))
                                  (file-seq mode-dir))]
                  (assoc (count-box-lines file) :mode mode))]
    results))

(defn print-results [results]
  "Pretty print the results"
  (println "\n✧･ﾟ:* GRAIN LINE COUNT ANALYSIS ✧･ﾟ:*\n")
  
  (doseq [mode (distinct (map :mode results))]
    (println (str "=== " mode " ==="))
    (let [mode-results (filter #(= mode (:mode %)) results)]
      (doseq [r (sort-by :file mode-results)]
        (let [filename (last (str/split (:file r) #"/"))]
          (if (:error r)
            (printf "  %-45s ERROR: %s\n" filename (:error r))
            (printf "  %-45s %3d lines (need %+3d) %s\n"
                   filename
                   (:box-lines r)
                   (:diff r)
                   (if (:needs-work? r) "❌" "✅"))))))
    (println ""))
  
  (let [total (count results)
        perfect (count (filter (complement :needs-work?) results))
        need-work (count (filter :needs-work? results))]
    (println (format "Total grains: %d" total))
    (println (format "Perfect (110 lines): %d ✅" perfect))
    (println (format "Need adjustment: %d ❌\n" need-work))))

;; Main execution
(let [base-dir "grainstore/grain12pbc/teamdescend14/gkd-prompt-execution--12025-10-27--0145-PDT--moon-p_ashadha----asc-leo023-sun-03h----teamdescend14"
      results (check-all-grains base-dir)]
  (print-results results))

(println "now == next + 1 ✧･ﾟ:* 🌾\n")

