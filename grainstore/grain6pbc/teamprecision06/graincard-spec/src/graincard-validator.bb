#!/usr/bin/env bb

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ GRAINCARD VALIDATOR (Babashka)                                               ║
;; ║ Team: 06 (teamprecision06 - Virgo ♍ / VI. The Lovers)                       ║
;; ║ Copyright © 3x39 | Author: kae3g (kj3x39, @risc.love)                        ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(require '[clojure.string :as str])

(defn read-grain [file]
  "Read a grain file and return lines"
  (str/split-lines (slurp file)))

(defn validate-grain [lines filename]
  "Validate a grain according to 80×110 spec
   
   Expected structure:
   Line 1: # Graincard {code} - {title}
   Line 2: (blank)
   Line 3: **Live**: {url}
   Line 4: (blank)
   Line 5: ``` (opening code fence)
   Lines 6-115: 110 lines of ASCII box content
   Line 116: ``` (closing code fence)
   Total: 116 lines"
  
  (let [errors []
        total-lines (count lines)]
    
    ;; Check total line count
    (when (not= total-lines 116)
      (conj errors (format "❌ Total lines: %d (expected 116)" total-lines)))
    
    ;; Check opening fence (line 5, index 4)
    (when (and (>= (count lines) 5)
               (not= (str/trim (nth lines 4)) "```"))
      (conj errors "❌ Line 5: Expected opening ``` code fence"))
    
    ;; Check closing fence (line 116, index 115)
    (when (and (>= (count lines) 116)
               (not= (str/trim (nth lines 115)) "```"))
      (conj errors "❌ Line 116: Expected closing ``` code fence"))
    
    ;; Check ASCII box content (lines 6-115 = 110 lines)
    (when (>= (count lines) 116)
      (let [box-lines (subvec (vec lines) 5 115)  ;; indices 5-114 = 110 lines
            box-line-count (count box-lines)]
        (when (not= box-line-count 110)
          (conj errors (format "❌ ASCII box content: %d lines (expected 110)" box-line-count)))))
    
    ;; Check top border (line 6, index 5)
    (when (and (>= (count lines) 6)
               (not (str/starts-with? (nth lines 5) "┌")))
      (conj errors "❌ Line 6: Expected top border starting with ┌"))
    
    ;; Check bottom border (line 115, index 114)
    (when (and (>= (count lines) 115)
               (not (str/starts-with? (nth lines 114) "└")))
      (conj errors "❌ Line 115: Expected bottom border starting with └"))
    
    ;; Check width of box lines (should be 80 chars)
    (when (>= (count lines) 116)
      (doseq [i (range 5 115)]
        (let [line (nth lines i)
              visual-width (count (str/replace line #"\u001b\[[0-9;]*m" ""))]  ;; Strip ANSI
          (when (not= visual-width 80)
            (conj errors (format "❌ Line %d: Width %d chars (expected 80)" (inc i) visual-width))))))
    
    ;; Check footer metadata (line 108, index 107 - should have card number)
    (when (>= (count lines) 108)
      (let [footer-line (nth lines 107)]
        (when-not (re-find #"Grain: [xbdghjklmnsvz]{6} \(\d+ of 1,235,520\)\s+>" footer-line)
          (conj errors "❌ Line 108: Footer should have 'Grain: {code} (N of 1,235,520) >'"))))
    
    ;; Check blank line before footer (line 107, index 106)
    (when (and (>= (count lines) 107)
               (not (str/blank? (str/trim (nth lines 106)))))
      (conj errors "❌ Line 107: Should be blank before footer"))
    
    ;; Check blank line after footer (line 109, index 108)
    (when (and (>= (count lines) 109)
               (not (str/blank? (str/trim (nth lines 108)))))
      (conj errors "❌ Line 109: Should be blank after footer"))
    
    errors))

(defn validate-file [file]
  "Validate a single grain file"
  (let [lines (read-grain file)
        filename (.getName (io/file file))
        errors (validate-grain lines filename)]
    
    (if (empty? errors)
      (println (format "✅ %s - VALID" filename))
      (do
        (println (format "❌ %s - INVALID" filename))
        (doseq [error errors]
          (println (str "   " error)))))))

(defn validate-all-grains [grain-dir]
  "Validate all grains in a directory"
  (let [files (->> (file-seq (io/file grain-dir))
                   (filter #(and (.isFile %)
                                 (str/ends-with? (.getName %) ".md")))
                   (sort-by #(.getName %)))]
    
    (println "🎃 Validating grains...")
    (println (format "Directory: %s" grain-dir))
    (println)
    
    (doseq [file files]
      (validate-file (.getPath file)))
    
    (println)
    (println "🌾 Validation complete!")
    (println "now == next + 1")))

;; CLI
(require '[clojure.java.io :as io])

(when (empty? *command-line-args*)
  (println "Usage: graincard-validator.bb <grain-directory>")
  (println "")
  (println "Example:")
  (println "  graincard-validator.bb grainstore/.../grains/")
  (System/exit 1))

(validate-all-grains (first *command-line-args*))

