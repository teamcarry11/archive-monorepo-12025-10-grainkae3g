(ns grainorder.core
  "Grainorder - Universal ordering system using xbdghjklmnsvz alphabet
   
   6-character codes, no duplicates, lexicographic order.
   Total possible: 13!/(13-6)! = 1,235,520 unique codes
   
   Copyright © 3x39 | https://github.com/3x39
   Author: kae3g (kj3x39, @risc.love)"
  (:require [clojure.string :as str]))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ GRAINORDER ALPHABET                                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(def ^:const grainorder-alphabet
  "The 13-character alphabet: xbdghjklmnsvz
   No vowels, no y, all consonants."
  "xbdghjklmnsvz")

(def ^:const code-length 6)

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ VALIDATION                                                                    ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn valid-grainorder?
  "Check if code is valid: 6 chars, from alphabet, no duplicates"
  [code]
  (and (string? code)
       (= code-length (count code))
       (every? #(str/includes? grainorder-alphabet (str %)) code)
       (apply distinct? code)))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ NEXT CODE (Simple working version)                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn next-grainorder
  "Get next grainorder code. Returns nil if overflow."
  [current]
  (when (valid-grainorder? current)
    (let [chars (vec grainorder-alphabet)
          code-vec (vec current)]
      ;; Start from rightmost position
      (loop [pos 5]
        (when (>= pos 0)
          (let [curr-char (nth code-vec pos)
                curr-idx (.indexOf chars curr-char)
                ;; Find next char that doesn't create duplicate
                next-idx (first 
                          (filter 
                           (fn [i]
                             (let [test-code (assoc code-vec pos (nth chars i))]
                               (apply distinct? test-code)))
                           (range (inc curr-idx) (count chars))))]
            (if next-idx
              ;; Found valid next char
              (str/join (assoc code-vec pos (nth chars next-idx)))
              ;; Carry left: reset this position to first char, try next position
              (recur (dec pos)))))))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ SEQUENCE GENERATION                                                          ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn grainorder-seq
  "Lazy sequence of grainorder codes"
  ([] (grainorder-seq "xbdghj"))
  ([start]
   (iterate next-grainorder start)))

(defn first-n-grainorders
  "Get first n codes"
  ([n] (first-n-grainorders n "xbdghj"))
  ([n start]
   (take n (take-while some? (grainorder-seq start)))))

;; ╔══════════════════════════════════════════════════════════════════════════════╗
;; ║ UTILITIES                                                                     ║
;; ╚══════════════════════════════════════════════════════════════════════════════╝

(defn total-permutations []
  "13 × 12 × 11 × 10 × 9 × 8 = 1,235,520"
  (reduce * (range 8 14)))

(defn -main [& args]
  (println "🌾 Grainorder - Copyright © 3x39")
  (println "First 20 codes:")
  (doseq [code (first-n-grainorders 20)]
    (println "  " code)))
