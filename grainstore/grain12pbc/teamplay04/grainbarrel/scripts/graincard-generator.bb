#!/usr/bin/env bb
;; ┌──────────────────────────────────────────────────────────────────────────────┐
;; │ GRAINCARD GENERATOR (team04 grainbarrel)                                     │
;; │ Generate 80×110 monospace graincards from templates                          │
;; │ Author: kae3g (kj3x39, @risc.love)                                           │
;; └──────────────────────────────────────────────────────────────────────────────┘

(require '[clojure.string :as str]
         '[clojure.java.io :as io])

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ GRAINORDER - 6-char xbdghjklmnsvz alphabet (1,235,520 permutations)         ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(def grainorder-alphabet "xbdghjklmnsvz") ;; 13 consonants, no vowels/y
(def grainorder-length 6)

(defn next-grainorder
  "Generate next grainorder code (6 chars, no duplicates)"
  [current]
  (let [chars (vec grainorder-alphabet)
        n (count chars)]
    (loop [code (vec current)
           pos (dec grainorder-length)]
      (if (< pos 0)
        nil ;; overflow
        (let [current-char (get code pos)
              current-idx (.indexOf chars current-char)
              next-idx (inc current-idx)]
          (if (< next-idx n)
            ;; Try next char at this position
            (let [next-char (nth chars next-idx)
                  new-code (assoc code pos next-char)]
              ;; Check for duplicates
              (if (apply distinct? new-code)
                (str/join new-code)
                (recur code pos))) ;; duplicate, keep trying
            ;; Overflow at this position, carry to left
            (recur (assoc code pos (first chars)) (dec pos))))))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ TEXT WRAPPING - 80 chars wide max                                            ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn wrap-text
  "Wrap text to max-width characters, preserving words"
  [text max-width]
  (let [words (str/split text #"\s+")]
    (loop [remaining words
           lines []
           current-line ""]
      (if (empty? remaining)
        (conj lines current-line)
        (let [word (first remaining)
              test-line (if (empty? current-line)
                          word
                          (str current-line " " word))]
          (if (<= (count test-line) max-width)
            (recur (rest remaining) lines test-line)
            (recur (rest remaining) (conj lines current-line) word)))))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ GRAINCARD TEMPLATE - 80×110 ASCII box                                        ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn pad-line
  "Pad line to exactly 78 chars (80 including borders)"
  [line]
  (let [padded (str line (str/join (repeat (- 78 (count line)) " ")))]
    (str "│ " padded " │")))

(defn generate-graincard
  "Generate an 80×110 graincard"
  [{:keys [grainorder-code title file-path live-url prev-card next-card
           content card-num total-cards author grainbook-name]}]
  (let [;; Header section
        header-lines [(str "# Graincard " grainorder-code " - " title)
                      ""
                      (str "**File**: " file-path)
                      (str "**Live**: " live-url)
                      (when prev-card (str "**Prev Card**: [" prev-card "](" prev-card "-*.md)"))
                      (when next-card (str "**Next Card**: [" next-card "](" next-card "-*.md)"))]
        
        ;; Content wrapped to 78 chars
        wrapped-content (mapcat #(wrap-text % 78) (str/split content #"\n"))
        
        ;; Ensure exactly 110 lines total in the box
        box-header [(str "┌" (str/join (repeat 78 "─")) "┐")
                    (pad-line (str "GRAINCARD " grainorder-code 
                                   (when card-num (str "                          Card " card-num " of " total-cards))))]
        
        content-lines (map pad-line wrapped-content)
        
        ;; Calculate padding to reach line 108
        current-lines (+ (count box-header) (count content-lines))
        padding-needed (max 0 (- 108 current-lines))
        padding-lines (repeat padding-needed (pad-line ""))
        
        box-footer [(str "├" (str/join (repeat 78 "─")) "┤")
                    (pad-line (str "Grainbook: " (or grainbook-name "Ember Harvest 🎃")))
                    (pad-line (str "Card: " grainorder-code 
                                   (when total-cards (str " (" card-num " of " (format "%,d" total-cards) ")"))))
                    (pad-line "now == next + 1 🌾")
                    (str "└" (str/join (repeat 78 "─")) "┘")]
        
        full-card (concat header-lines
                          ["" "```"] ;; code block start
                          box-header
                          content-lines
                          padding-lines
                          box-footer
                          ["```"])] ;; code block end
    
    (str/join "\n" full-card)))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ CLI INTERFACE                                                                 ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn -main [& args]
  (let [opts (apply hash-map args)
        grainorder-code (get opts "--code" "xbdghj")
        title (get opts "--title" "Untitled Graincard")
        content (get opts "--content" "Content goes here...")
        output-file (get opts "--output" (str grainorder-code "-graincard.md"))]
    
    (println "🌾 Generating graincard" grainorder-code "...")
    
    (let [card (generate-graincard
                {:grainorder-code grainorder-code
                 :title title
                 :file-path output-file
                 :live-url "https://kae3g.github.io/grainkae3g/"
                 :content content
                 :total-cards 1235520
                 :card-num 1
                 :author "kae3g (kj3x39, @risc.love)"
                 :grainbook-name "Ember Harvest 🎃"})]
      
      (spit output-file card)
      (println "✅ Graincard saved to" output-file)
      (println "🎃 now == next + 1 🌾"))))

(-main)

