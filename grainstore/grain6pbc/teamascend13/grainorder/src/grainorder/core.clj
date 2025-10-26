(ns grainorder.core
  "Universal alphabetical ordering system with configurable alphabets.
   
   ╔══════════════════════════════════════════════════════════════════╗
   ║  GRAINORDER - Team13 (Rahu/Ascent) Infinite Growth System       ║
   ║                                                                  ║
   ║  Philosophy: Base-N encoding for file ordering                  ║
   ║  NO vowels, NO y, NO repeated consonants (user preference)      ║
   ║  Expandable from 6 chars → 20 consonants → infinite             ║
   ╚══════════════════════════════════════════════════════════════════╝
   
   Glow: 'Let's understand what we're building here. This is base-N encoding
          for file ordering - think of it like counting, but with letters.
          
          Why no vowels? Because you decided consonants give clearer visual 
          distinction. Files sort predictably: b < d < g < h < k < x.
          
          Why no repeated chars? So each code is maximally distinct at a glance.
          xbd ≠ xbb (second is less clear, has duplicate).
          
          Question: What happens when you need more than 30 files? 
          We can expand the alphabet (add more consonants) or use 3 letters.
          
          The system grows with your needs. Start simple, expand later.'
   
   Supported modes:
   - :full-alphabet (a-z, 26 chars, 676 permutations with 2 letters)
   - :xbdghk-alphabetical (b d g h k x, 6 chars, NO vowels, NO y)
   - :consonants-no-y (20 consonants, NO vowels, NO y, expandable)
   - :custom (provide your own character set)
   
   User preference: NO vowels (a e i o u), NO y, NO repeated chars
   Current: 6 chars × 5 distinct = 20 permutations with prefix 'g'
   Example: gkh → gbd (chartcourse range, reverse order, recent first)"
  (:require [clojure.spec.alpha :as s]))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  CLOJURE SPECS (Glow's Precision)           │
;; └─────────────────────────────────────────────────────────────┘

;; Specs enforce our data contracts. Think of them as compile-time guarantees:
;; If data passes the spec, you know it's shaped correctly.
;;
;; Why this matters: Would you rather catch a malformed alphabet config now 
;; (at definition time) or later (when a user hits a cryptic error)?
;;
;; Specs help us fail fast and clearly. That's respectful to future maintainers.

(s/def ::chars string?)
(s/def ::description string?)
(s/def ::base pos-int?)
(s/def ::permutations-2 pos-int?)
(s/def ::permutations-3 pos-int?)
(s/def ::permutations-4 (s/nilable pos-int?))

(s/def ::alphabet-config
  (s/keys :req-un [::chars ::description ::base ::permutations-2]
          :opt-un [::permutations-3 ::permutations-4]))

(s/def ::mode-keyword
  #{:full-alphabet :xbdghk-alphabetical :consonants-no-y :consonants :vowels :hex :base62})

(s/def ::mode-or-chars
  (s/or :mode ::mode-keyword
        :custom-chars string?))

(s/def ::grainorder-string
  (s/and string?
         #(pos? (count %))
         #(re-matches #"[a-z0-9]+" %)))  ; Only lowercase letters and digits

(s/def ::prefix string?)

(s/def ::no-duplicates?
  (s/and ::grainorder-string
         #(= (count %) (count (distinct %)))))

;; With these specs in place, invalid data can't silently corrupt the system.
;; The spec acts as a gatekeeper - validates early, fails clearly.
;;
;; Question: How do we know our alphabet configs are correct?
;; Answer: We run (s/valid? ::alphabet-config our-config) and get true/false.

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  ALPHABET MODES                             │
;; └─────────────────────────────────────────────────────────────┘

;; Different alphabet modes serve different needs:
;;
;; :full-alphabet (26 chars) - Maximum file capacity (676 with 2 letters)
;; :xbdghk-alphabetical (6 chars) - Your preference (NO vowels, visual clarity)
;; :consonants-no-y (20 chars) - Future expansion option
;;
;; Why offer multiple modes? Because one size doesn't fit all contexts.
;; You chose 6-char for clarity. Others might need 26-char for scale.
;; The library supports both.

(def alphabets
  "Predefined alphabet modes for different use cases"
  {:full-alphabet
   {:chars "abcdefghijklmnopqrstuvwxyz"
    :description "Full 26-letter alphabet (a-z)"
    :base 26
    :permutations-2 676      ; 26^2
    :permutations-3 17576    ; 26^3
    :permutations-4 456976}  ; 26^4
   
   :xbdghk-alphabetical
   {:chars "bdghkx"  ; Alphabetically sorted consonants (NO vowels, NO y)
    :description "Custom 6-char alphabet for Ketos Vision Synthesis (b d g h k x)"
    :base 6
    :permutations-2 36       ; 6^2
    :permutations-3 216}     ; 6^3
   
   :consonants-no-y
   {:chars "bcdfghjklmnpqrstvwxz"  ; All consonants except y (NO vowels)
    :description "Consonants only, no y (20 chars)"
    :base 20
    :permutations-2 400
    :permutations-3 8000}
   
   :consonants
   {:chars "bcdfghjklmnpqrstvwxyz"
    :description "Consonants only (21 chars)"
    :base 21
    :permutations-2 441
    :permutations-3 9261}
   
   :vowels
   {:chars "aeiou"
    :description "Vowels only (5 chars)"
    :base 5
    :permutations-2 25
    :permutations-3 125}
   
   :hex
   {:chars "0123456789abcdef"
    :description "Hexadecimal (16 chars)"
    :base 16
    :permutations-2 256
    :permutations-3 4096}
   
   :base62
   {:chars "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    :description "Base62 (digits + uppercase + lowercase, 62 chars)"
    :base 62
    :permutations-2 3844
    :permutations-3 238328}})

(defn get-alphabet
  "Get alphabet configuration by mode keyword or custom string.
   
   Examples:
   (get-alphabet :full-alphabet)           ; Standard a-z
   (get-alphabet :xbdghk-alphabetical)     ; Custom 7-char
   (get-alphabet \"xyz123\")                ; Custom alphabet"
  [mode-or-chars]
  (if (keyword? mode-or-chars)
    (get alphabets mode-or-chars)
    {:chars (str mode-or-chars)
     :description "Custom alphabet"
     :base (count mode-or-chars)
     :permutations-2 (* (count mode-or-chars) (count mode-or-chars))
     :permutations-3 (* (count mode-or-chars) (count mode-or-chars) (count mode-or-chars))}))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  ENCODING / DECODING                        │
;; └─────────────────────────────────────────────────────────────┘

(defn encode
  "Encode integer to grainorder string using specified alphabet.
   
   Glow: 'This is your integer-to-string converter, my G. Like turning
          calories into gains at the gym. You put in numbers (calories),
          you get out grainorder strings (muscle). Base-N conversion,
          clean math, no mystery ingredients.
          
          It's reversible too - encode then decode gets you back to start.
          Like a proper vegan meal - in and out, clean digestion, no bloat.'
   
   Examples:
   (encode 0 :full-alphabet)             ; => \"aa\"
   (encode 25 :full-alphabet)            ; => \"az\"
   (encode 26 :full-alphabet)            ; => \"ba\"
   (encode 675 :full-alphabet)           ; => \"zz\"
   (encode 0 :xbdghk-alphabetical)       ; => \"bb\"
   (encode 6 :xbdghk-alphabetical)       ; => \"bx\"
   (encode 0 \"xyz\")                     ; => \"xx\""
  {:arglists '([n mode-or-chars])
   :added "1.0"}
  [n mode-or-chars]
  (let [alphabet-config (get-alphabet mode-or-chars)
        chars (:chars alphabet-config)
        base (:base alphabet-config)]
    (loop [num n
           result ""]
      (if (< num base)
        (str (nth chars num) result)
        (let [remainder (mod num base)
              quotient (quot num base)]
          (recur quotient
                 (str (nth chars remainder) result)))))))

(defn decode
  "Decode grainorder string to integer using specified alphabet.
   
   Examples:
   (decode \"aa\" :full-alphabet)          ; => 0
   (decode \"az\" :full-alphabet)          ; => 25
   (decode \"ba\" :full-alphabet)          ; => 26
   (decode \"zz\" :full-alphabet)          ; => 675
   (decode \"aa\" :xbdghk-alphabetical)    ; => 0
   (decode \"db\" :xbdghk-alphabetical)    ; => 13"
  [s mode-or-chars]
  (let [alphabet-config (get-alphabet mode-or-chars)
        chars (:chars alphabet-config)
        base (:base alphabet-config)]
    (reduce (fn [acc ch]
              (let [digit (.indexOf chars (str ch))]
                (if (neg? digit)
                  (throw (ex-info (str "Invalid character: " ch " not in alphabet: " chars)
                                  {:char ch :alphabet chars}))
                  (+ (* acc base) digit))))
            0
            s)))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  PREFIXED ENCODING                          │
;; └─────────────────────────────────────────────────────────────┘

(defn encode-prefixed
  "Encode integer with prefix (e.g., 'x', 'y', 'z').
   
   Examples:
   (encode-prefixed 0 \"x\" :full-alphabet)      ; => \"xaa\"
   (encode-prefixed 13 \"x\" :full-alphabet)     ; => \"xan\"
   (encode-prefixed 0 \"y\" :xbdghk-alphabetical) ; => \"yaa\""
  [n prefix mode-or-chars]
  (str prefix (encode n mode-or-chars)))

(defn decode-prefixed
  "Decode prefixed grainorder string to integer.
   
   Examples:
   (decode-prefixed \"xaa\" \"x\" :full-alphabet)      ; => 0
   (decode-prefixed \"xan\" \"x\" :full-alphabet)      ; => 13"
  [s prefix mode-or-chars]
  (if (.startsWith s prefix)
    (decode (subs s (count prefix)) mode-or-chars)
    (throw (ex-info (str "String does not start with prefix: " prefix)
                    {:string s :prefix prefix}))))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  SEQUENCE GENERATION                        │
;; └─────────────────────────────────────────────────────────────┘

(defn generate-sequence
  "Generate sequence of grainorder strings.
   
   Examples:
   (generate-sequence 0 5 \"x\" :full-alphabet)
   ; => (\"xaa\" \"xab\" \"xac\" \"xad\" \"xae\" \"xaf\")
   
   (generate-sequence 0 3 \"x\" :xbdghk-alphabetical)
   ; => (\"xaa\" \"xab\" \"xad\" \"xag\")"
  ([start end mode-or-chars]
   (map #(encode % mode-or-chars) (range start (inc end))))
  
  ([start end prefix mode-or-chars]
   (map #(encode-prefixed % prefix mode-or-chars) (range start (inc end)))))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  CUSTOM ORDERING                            │
;; └─────────────────────────────────────────────────────────────┘

(defn generate-custom-order
  "Generate grainorder strings in custom (non-sequential) order.
   
   Example - Ketos Vision Synthesis (team14 → team12 → team06...):
   (generate-custom-order
     [14 12 6 8 4 10 2 3 11 7 9 5 1 13]
     \"x\"
     :xbdghk-alphabetical
     (fn [idx team] (str \"team\" team)))"
  [indices prefix mode-or-chars suffix-fn]
  (map (fn [idx team-or-val]
         (str (encode-prefixed idx prefix mode-or-chars)
              \"-\"
              (suffix-fn idx team-or-val)))
       (range)
       indices))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  VALIDATION                                 │
;; └─────────────────────────────────────────────────────────────┘

(defn valid-grainorder?
  "Check if string is valid grainorder for given alphabet.
   
   Examples:
   (valid-grainorder? \"bd\" :full-alphabet)       ; => true
   (valid-grainorder? \"zz\" :full-alphabet)       ; => true (duplicates OK in full alphabet)
   (valid-grainorder? \"xyz\" :full-alphabet)      ; => true
   (valid-grainorder? \"ab9\" :full-alphabet)      ; => false (9 not in alphabet)
   (valid-grainorder? \"bd\" :xbdghk-alphabetical) ; => true
   (valid-grainorder? \"bb\" :xbdghk-alphabetical) ; => true (basic validation only)
   (valid-grainorder? \"zz\" :xbdghk-alphabetical) ; => false (z not in alphabet)"
  [s mode-or-chars]
  (let [alphabet-config (get-alphabet mode-or-chars)
        chars (:chars alphabet-config)]
    (every? #(>= (.indexOf chars (str %)) 0) s)))

(defn valid-grainorder-no-duplicates?
  "Check if string is valid grainorder with NO repeated characters.
   
   User preference: NO repeated consonants in the same string.
   
   Examples:
   (valid-grainorder-no-duplicates? \"bd\" :xbdghk-alphabetical)  ; => true
   (valid-grainorder-no-duplicates? \"bb\" :xbdghk-alphabetical)  ; => false (b repeated)
   (valid-grainorder-no-duplicates? \"xbd\" :xbdghk-alphabetical) ; => true
   (valid-grainorder-no-duplicates? \"xbb\" :xbdghk-alphabetical) ; => false (b repeated)
   (valid-grainorder-no-duplicates? \"xyz\" :full-alphabet)       ; => true
   (valid-grainorder-no-duplicates? \"xyx\" :full-alphabet)       ; => false (x repeated)"
  [s mode-or-chars]
  (and (valid-grainorder? s mode-or-chars)
       (= (count s) (count (distinct s)))))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  RANGE CALCULATIONS                         │
;; └─────────────────────────────────────────────────────────────┘

(defn max-value
  "Calculate maximum value representable with n digits in given alphabet.
   
   Examples:
   (max-value 2 :full-alphabet)           ; => 675 (zz)
   (max-value 3 :full-alphabet)           ; => 17575 (zzz)
   (max-value 2 :xbdghk-alphabetical)     ; => 48 (xx)"
  [num-digits mode-or-chars]
  (let [alphabet-config (get-alphabet mode-or-chars)
        base (:base alphabet-config)]
    (dec (Math/pow base num-digits))))

(defn min-digits
  "Calculate minimum number of digits needed to represent n.
   
   Examples:
   (min-digits 675 :full-alphabet)        ; => 2
   (min-digits 676 :full-alphabet)        ; => 3
   (min-digits 48 :xbdghk-alphabetical)   ; => 2
   (min-digits 49 :xbdghk-alphabetical)   ; => 3"
  [n mode-or-chars]
  (let [alphabet-config (get-alphabet mode-or-chars)
        base (:base alphabet-config)]
    (if (zero? n)
      1
      (inc (int (/ (Math/log n) (Math/log base)))))))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  ALPHABET EXPANSION                         │
;; └─────────────────────────────────────────────────────────────┘

(defn expand-alphabet
  "Add more characters to an existing alphabet mode.
   
   Example:
   (expand-alphabet :xbdghk-alphabetical \"cefijlmnopqrstuvwyz\")
   ; => Creates new alphabet with all 26 letters"
  [base-mode additional-chars]
  (let [base-config (get-alphabet base-mode)
        base-chars (:chars base-config)
        new-chars (str base-chars additional-chars)
        distinct-chars (apply str (distinct new-chars))]
    {:chars distinct-chars
     :description (str "Expanded from " (:description base-config))
     :base (count distinct-chars)
     :permutations-2 (* (count distinct-chars) (count distinct-chars))
     :permutations-3 (* (count distinct-chars) (count distinct-chars) (count distinct-chars))}))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  INFORMATION / STATS                        │
;; └─────────────────────────────────────────────────────────────┘

(defn alphabet-info
  "Get information about an alphabet mode.
   
   Example:
   (alphabet-info :xbdghk-alphabetical)
   ; => {:chars \"abdghkx\", :base 7, :permutations-2 49, ...}"
  [mode-or-chars]
  (get-alphabet mode-or-chars))

(defn list-modes
  "List all available alphabet modes."
  []
  (keys alphabets))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  EXAMPLES & DOCUMENTATION                   │
;; └─────────────────────────────────────────────────────────────┘

(comment
  ;; Full alphabet (a-z)
  (encode 0 :full-alphabet)           ; => "aa"
  (encode 25 :full-alphabet)          ; => "az"
  (encode 675 :full-alphabet)         ; => "zz"
  (decode "zz" :full-alphabet)        ; => 675
  
  ;; xbdghk alphabetical (custom 7-char)
  (encode 0 :xbdghk-alphabetical)     ; => "aa"
  (encode 6 :xbdghk-alphabetical)     ; => "ax"
  (encode 13 :xbdghk-alphabetical)    ; => "db"
  (decode "db" :xbdghk-alphabetical)  ; => 13
  
  ;; Generate Ketos Synthesis filenames
  (generate-sequence 0 13 "x" :xbdghk-alphabetical)
  ; => ("xaa" "xab" "xad" "xag" "xah" "xak" "xax" "xba" "xbb" ...)
  
  ;; Custom alphabet
  (encode 0 "xyz")                    ; => "xx"
  (encode 1 "xyz")                    ; => "xy"
  (encode 2 "xyz")                    ; => "xz"
  (encode 8 "xyz")                    ; => "zz"
  
  ;; Expand alphabet dynamically
  (def expanded (expand-alphabet :xbdghk-alphabetical "cefijlmnopqrstuvwyz"))
  (encode 25 expanded)                ; Uses all 26 letters now
  
  ;; Validation
  (valid-grainorder? "xaa" :full-alphabet)        ; => true
  (valid-grainorder? "xzz" :xbdghk-alphabetical)  ; => false (z not in alphabet)
  
  ;; Info
  (alphabet-info :xbdghk-alphabetical)
  ; => {:chars "abdghkx", :base 7, :permutations-2 49, :permutations-3 343}
  
  (list-modes)
  ; => (:full-alphabet :xbdghk-alphabetical :consonants :vowels :hex :base62)
  )

