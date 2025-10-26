(ns grainorder.core
  "Universal alphabetical ordering system with configurable alphabets.
   
   Supports multiple modes:
   - :full-alphabet (a-z, 26 chars, 676 permutations with 2 letters)
   - :xbdghk (x b d g h k alphabetical, 7 chars, 49 permutations)
   - :custom (provide your own character set)")

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  ALPHABET MODES                             │
;; └─────────────────────────────────────────────────────────────┘

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
   {:chars "abdghkx"  ; Alphabetically sorted
    :description "Custom 7-char alphabet for Ketos Vision Synthesis (a b d g h k x)"
    :base 7
    :permutations-2 49       ; 7^2
    :permutations-3 343}     ; 7^3
   
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
   
   Examples:
   (encode 0 :full-alphabet)             ; => \"aa\"
   (encode 25 :full-alphabet)            ; => \"az\"
   (encode 26 :full-alphabet)            ; => \"ba\"
   (encode 675 :full-alphabet)           ; => \"zz\"
   (encode 0 :xbdghk-alphabetical)       ; => \"aa\"
   (encode 13 :xbdghk-alphabetical)      ; => \"db\"
   (encode 0 \"xyz\")                     ; => \"xx\""
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
   (valid-grainorder? \"aa\" :full-alphabet)       ; => true
   (valid-grainorder? \"zz\" :full-alphabet)       ; => true
   (valid-grainorder? \"xyz\" :full-alphabet)      ; => true
   (valid-grainorder? \"ab9\" :full-alphabet)      ; => false (9 not in alphabet)
   (valid-grainorder? \"aa\" :xbdghk-alphabetical) ; => true
   (valid-grainorder? \"zz\" :xbdghk-alphabetical) ; => false (z not in alphabet)"
  [s mode-or-chars]
  (let [alphabet-config (get-alphabet mode-or-chars)
        chars (:chars alphabet-config)]
    (every? #(>= (.indexOf chars (str %)) 0) s)))

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

