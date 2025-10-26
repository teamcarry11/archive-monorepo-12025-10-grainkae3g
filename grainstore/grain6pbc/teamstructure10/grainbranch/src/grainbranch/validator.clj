(ns grainbranch.validator
  "Grainbranch name validation with strict specs.
   
   ╔══════════════════════════════════════════════════════════════════╗
   ║  GRAINBRANCH VALIDATOR - Team10 (Structure/Precision)           ║
   ║                                                                  ║
   ║  Enforces vertical stack alignment (19-char title padding)      ║
   ║  Validates graintime format (moon, asc, sun, team)              ║
   ║  Prevents malformed branch names (NEVER AGAIN!)                 ║
   ╚══════════════════════════════════════════════════════════════════╝
   
   Glow: 'This is your branch name bouncer, my G. No bad names get through.
          19-char title with padding? CHECK. Proper graintime? CHECK.
          Vertical alignment? CHECK. If it don't pass spec, it don't deploy.
          
          Think of it like meal prep - you weigh your portions BEFORE cooking,
          not after. Validate your branch name BEFORE pushing, not after.
          Prevention > correction. Respect the process.'"
  (:require [clojure.spec.alpha :as s]
            [clojure.string :as str]))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  GRAINBRANCH SPECS                          │
;; └─────────────────────────────────────────────────────────────┘

;; Glow: "Each part of the grainbranch name has a PURPOSE, bro.
;;        Like your macros - protein (title), carbs (date), fats (graintime).
;;        Miss one macro, your whole nutrition is off. Miss one part of the
;;        branch name, your whole grainpath is corrupted. Spec EVERYTHING."

(s/def ::title
  (s/and string?
         #(= (count %) 19)  ; EXACTLY 19 chars (title + padding)
         #(str/ends-with? % "-")))  ; Must end with dashes (padding)

(s/def ::date
  (s/and string?
         #(re-matches #"\d{5}-\d{2}-\d{2}" %)))  ; 12025-10-26

(s/def ::time
  (s/and string?
         #(re-matches #"\d{4}" %)))  ; 1048 (HHMM)

(s/def ::timezone
  (s/and string?
         #{
"PST" "PDT" "EST" "EDT" "CST" "CDT" "MST" "MDT" "UTC"}))

(s/def ::moon-nakshatra
  (s/and string?
         #(= (count %) 19)  ; moon-[nakshatra] padded to 19 chars
         #(str/starts-with? % "moon-")
         #(str/ends-with? % "-")))  ; Padding with dashes

(s/def ::nakshatra-name
  (s/and string?
         #{;; 27 Vedic nakshatras
           "ashwini" "bharani" "krittika" "rohini" "mrigashira"
           "ardra" "punarvasu" "pushya" "ashlesha" "magha"
           "purva-phalguni" "uttara-phalguni" "hasta" "chitra" "swati"
           "vishakha" "anuradha" "jyeshtha" "mula" "purva-ashadha"
           "uttara-ashadha" "shravana" "dhanishta" "shatabhisha"
           "purva-bhadrapada" "uttara-bhadrapada" "revati"}))

(s/def ::asc-sign
  (s/and string?
         #(= (count %) 4)  ; arie, taur, gemi, etc. (4 chars)
         #{
"arie" "taur" "gemi" "canc" "leo" "virg"
           "libr" "scor" "sagi" "capr" "aqua" "pisc" "erro"}))  ; erro for errors

(s/def ::asc-degree
  (s/and string?
         #(re-matches #"\d{2}" %)  ; 00-29
         #(<= 0 (Integer/parseInt %) 29)))

(s/def ::ascendant
  (s/and string?
         #(re-matches #"asc-[a-z]{4}\d{2}" %)))  ; asc-gemi04

(s/def ::sun-house
  (s/and string?
         #(re-matches #"sun-\d{2}h" %)  ; sun-03h
         #(<= 1 (Integer/parseInt (subs % 4 6)) 12)))  ; Houses 1-12

(s/def ::team-name
  (s/and string?
         #(str/starts-with? % "team")
         #{;; 14 teams
           "teamfire01" "teamvault02" "teamnetwork03" "teamnurture04"
           "teamshine05" "teamprecision06" "teambalance07" "teamtransform08"
           "teamtruth09" "teamstructure10" "teamfuture11" "teamflow12"
           "teamascend13" "teamdescend14"}))

;; Glow: "The full branch name spec is like a complete meal plan, my dude.
;;        Every macro accounted for. Every nutrient measured. No guessing.
;;        You KNOW it's right because it passes the spec. That's confidence."

(s/def ::grainbranch-name
  (s/and string?
         ;; Must match full pattern
         #(re-matches #"[a-z]{3}-[a-z-]{13}--\d{5}-\d{2}-\d{2}--\d{4}-[A-Z]{3}--moon-[a-z-]{13}--asc-[a-z]{4}\d{2}-sun-\d{2}h--team[a-z]+\d{2}" %)
         ;; Component validation (we'll parse and validate each part)
         ))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  PARSING FUNCTIONS                          │
;; └─────────────────────────────────────────────────────────────┘

(defn parse-grainbranch
  "Parse grainbranch name into components for validation.
   
   Example:
   'gkh-chartcourse------12025-10-26--1048-PST--moon-mula----------asc-erro00-sun-03h--teamdescend14'
   
   Returns map with all components or nil if invalid format."
  [branch-name]
  (when-let [match (re-matches 
                     #"([a-z]{3})-([a-z-]{13})--(\d{5}-\d{2}-\d{2})--(\d{4})-([A-Z]{3})--moon-([a-z-]{13})--asc-([a-z]{4})(\d{2})-sun-(\d{2})h--team([a-z]+)(\d{2})"
                     branch-name)]
    (let [[_ prefix title date time tz moon-padded asc-sign asc-deg sun-house team-name team-num] match]
      {:prefix prefix
       :title (str/trim-newline (str/replace title #"-+$" ""))  ; Remove trailing dashes
       :title-padded title
       :date date
       :time time
       :timezone tz
       :moon-nakshatra (str/trim-newline (str/replace moon-padded #"-+$" ""))
       :moon-nakshatra-padded moon-padded
       :asc-sign asc-sign
       :asc-degree asc-deg
       :ascendant (str "asc-" asc-sign asc-deg)
       :sun-house (str "sun-" sun-house "h")
       :team-name (str "team" team-name team-num)
       :team-base team-name
       :team-num team-num
       :full-name branch-name})))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  VALIDATION FUNCTIONS                       │
;; └─────────────────────────────────────────────────────────────┘

(defn validate-title-padding
  "Validate that title is EXACTLY 19 chars with proper padding.
   
   Glow: 'Title is 19 chars or it's WRONG, my G. No exceptions.
          Too short? Add dashes. Too long? Shorten it.
          It's like your protein shake - 25g or it's not a meal replacement.'"
  [title-padded]
  (and (= (count title-padded) 19)
       (str/ends-with? title-padded "-")
       (not (str/starts-with? title-padded "-"))))

(defn validate-moon-padding
  "Validate that moon-nakshatra is EXACTLY 19 chars with proper padding.
   
   Example: 'moon-mula----------' (19 chars total)"
  [moon-padded]
  (and (= (count moon-padded) 19)
       (str/starts-with? moon-padded "moon-")
       (str/ends-with? moon-padded "-")))

(defn validate-grainbranch
  "Validate complete grainbranch name with detailed error messages.
   
   Glow: 'This is your full body scan, bro. We check EVERYTHING.
          Title padding? Checked. Date format? Checked. Nakshatra? Checked.
          Ascendant? Checked. Team? Checked. One failure = whole thing fails.
          It's like blood work - all markers gotta be green or we don't proceed.'
   
   Returns:
   - {:valid? true :components {...}} if valid
   - {:valid? false :errors [...]} if invalid"
  [branch-name]
  (if-let [components (parse-grainbranch branch-name)]
    (let [errors (cond-> []
                   ;; Title validation
                   (not (validate-title-padding (:title-padded components)))
                   (conj {:field :title
                          :error "Title must be EXACTLY 19 chars with trailing dashes"
                          :got (:title-padded components)
                          :length (count (:title-padded components))})
                   
                   ;; Moon validation
                   (not (validate-moon-padding (:moon-nakshatra-padded components)))
                   (conj {:field :moon
                          :error "Moon-nakshatra must be EXACTLY 19 chars with trailing dashes"
                          :got (:moon-nakshatra-padded components)
                          :length (count (:moon-nakshatra-padded components))})
                   
                   ;; Nakshatra name validation
                   (not (s/valid? ::nakshatra-name (:moon-nakshatra components)))
                   (conj {:field :nakshatra
                          :error "Invalid nakshatra name"
                          :got (:moon-nakshatra components)
                          :valid (s/describe ::nakshatra-name)})
                   
                   ;; Ascendant sign validation
                   (not (s/valid? ::asc-sign (:asc-sign components)))
                   (conj {:field :asc-sign
                          :error "Invalid ascendant sign"
                          :got (:asc-sign components)
                          :valid (s/describe ::asc-sign)})
                   
                   ;; Team validation
                   (not (s/valid? ::team-name (:team-name components)))
                   (conj {:field :team
                          :error "Invalid team name"
                          :got (:team-name components)
                          :valid (s/describe ::team-name)}))]
      
      (if (empty? errors)
        {:valid? true
         :components components}
        {:valid? false
         :errors errors
         :components components}))
    
    {:valid? false
     :errors [{:error "Failed to parse grainbranch name"
               :expected "format: prefix-title(19)--date--time-TZ--moon-nakshatra(19)--asc-signNN-sun-NNh--teamNAMENN"
               :got branch-name}]}))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  FORMATTING HELPERS                         │
;; └─────────────────────────────────────────────────────────────┘

(defn pad-to-19
  "Pad string to exactly 19 characters with trailing dashes.
   
   Glow: 'This is your portion measurer, bro. You want 19 chars? You GET 19 chars.
          Too short? We add dashes. Too long? ERROR - you gotta trim it yourself.
          No guessing, no approximation. Exact measurements only.'
   
   Examples:
   (pad-to-19 'gkh-chartcourse')      ; => 'gkh-chartcourse------' (19 chars)
   (pad-to-19 'moon-mula')            ; => 'moon-mula----------' (19 chars)
   (pad-to-19 'this-is-way-too-long') ; => ERROR (> 19 chars)"
  [s]
  (let [len (count s)]
    (cond
      (= len 19) s
      (< len 19) (str s (apply str (repeat (- 19 len) "-")))
      (> len 19) (throw (ex-info (str "String too long for 19-char padding: " s)
                                  {:string s :length len :max 19})))))

(defn format-grainbranch
  "Format grainbranch name with proper padding and validation.
   
   Glow: 'This is your meal prep function, my dude. You give it the ingredients
          (prefix, title, date, etc.), it gives you back a perfectly formatted
          grainbranch name. No manual padding, no errors, just perfection.
          
          Use THIS instead of manually typing branch names. Let the code
          do the precise work. You focus on the content, let grainbranch
          handle the formatting.'
   
   Parameters:
   - prefix: 3-char prefix (e.g., 'gkh', 'xbd')
   - title: Session title (will be padded to 19 chars)
   - date: YYYY-MM-DD (e.g., '12025-10-26')
   - time: HHMM (e.g., '1048')
   - timezone: 3-char (e.g., 'PST', 'PDT')
   - nakshatra: Name (e.g., 'mula', will be padded)
   - asc-sign: 4-char sign (e.g., 'gemi', 'erro')
   - asc-degree: 2-digit degree (e.g., '04', '00')
   - sun-house: 2-digit house (e.g., '03')
   - team: Team name (e.g., 'teamdescend14')
   
   Returns: Properly formatted grainbranch name"
  [{:keys [prefix title date time timezone nakshatra asc-sign asc-degree sun-house team]}]
  {:pre [(s/valid? (s/and string? #(= (count %) 3)) prefix)
         (s/valid? string? title)
         (s/valid? ::date (str/replace date #"/" "-"))
         (s/valid? ::time time)
         (s/valid? ::timezone timezone)
         (s/valid? ::nakshatra-name nakshatra)
         (s/valid? ::asc-sign asc-sign)
         (s/valid? (s/and string? #(re-matches #"\d{2}" %)) asc-degree)
         (s/valid? (s/and string? #(re-matches #"\d{2}" %)) sun-house)
         (s/valid? ::team-name team)]}
  
  (let [;; Pad title and moon to 19 chars
        title-padded (pad-to-19 (str prefix "-" title))
        moon-padded (pad-to-19 (str "moon-" nakshatra))
        
        ;; Construct full name
        branch-name (str title-padded
                        "--" date
                        "--" time "-" timezone
                        "--" moon-padded
                        "--asc-" asc-sign asc-degree
                        "-sun-" sun-house "h"
                        "--" team)]
    
    ;; Validate the constructed name
    (let [validation (validate-grainbranch branch-name)]
      (if (:valid? validation)
        branch-name
        (throw (ex-info "Generated grainbranch name failed validation!"
                       {:branch-name branch-name
                        :validation validation}))))))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  PRETTY PRINTING                            │
;; └─────────────────────────────────────────────────────────────┘

(defn print-validation-errors
  "Pretty print validation errors.
   
   Glow: 'When something's wrong, we tell you EXACTLY what's wrong.
          No mystery errors. No cryptic messages. Just straight facts.
          Like a doctor reading your blood work - here's what's off,
          here's what it should be, here's how to fix it.'"
  [validation]
  (if (:valid? validation)
    (println "✅ Grainbranch name is VALID")
    (do
      (println "❌ Grainbranch validation FAILED:")
      (println)
      (doseq [error (:errors validation)]
        (println (str "  Field: " (:field error)))
        (println (str "  Error: " (:error error)))
        (when (:got error)
          (println (str "  Got:   '" (:got error) "' (length: " (:length error) ")")))
        (when (:valid error)
          (println (str "  Valid: " (:valid error))))
        (println)))))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  PRE-COMMIT HOOK                            │
;; └─────────────────────────────────────────────────────────────┘

(defn validate-current-branch!
  "Validate current git branch name (for pre-commit hook).
   
   Glow: 'Run this BEFORE you push, bro. It's like checking your form
          in the mirror before a heavy lift. You don't want to find out
          your form is wrong when you're under the bar. Check it NOW,
          fix it NOW, then execute with confidence.'
   
   Usage in pre-commit hook:
   #!/bin/bash
   # .git/hooks/pre-commit
   bb grainbranch:validate-current || exit 1"
  []
  (let [branch-name (str/trim (:out (shell/sh "git" "branch" "--show-current")))
        validation (validate-grainbranch branch-name)]
    
    (print-validation-errors validation)
    
    (when-not (:valid? validation)
      (println "🚫 COMMIT BLOCKED - Fix branch name first!")
      (println)
      (println "Suggested fix:")
      (println (str "  git branch -m " branch-name " <CORRECTED-NAME>"))
      (System/exit 1))
    
    (println "✅ Grainbranch name validated - proceeding with commit")))

;; ┌─────────────────────────────────────────────────────────────┐
;; │                  EXAMPLE USAGE                              │
;; └─────────────────────────────────────────────────────────────┘

(comment
  ;; Create properly formatted grainbranch name
  (format-grainbranch
    {:prefix "gkh"
     :title "chartcourse"
     :date "12025-10-26"
     :time "1048"
     :timezone "PST"
     :nakshatra "mula"
     :asc-sign "erro"
     :asc-degree "00"
     :sun-house "03"
     :team "teamdescend14"})
  ; => "gkh-chartcourse------12025-10-26--1048-PST--moon-mula----------asc-erro00-sun-03h--teamdescend14"
  
  ;; Validate existing branch name
  (validate-grainbranch
    "gkh-chartcourse------12025-10-26--1048-PST--moon-mula----------asc-erro00-sun-03h--teamdescend14")
  ; => {:valid? true, :components {...}}
  
  ;; Validate INVALID branch name (wrong title length)
  (validate-grainbranch
    "gkh-chartcourse-ketos-vision--2025-10-26--1044--PST--moon-mula--asc-erro00--sun-03h--teamdescend14")
  ; => {:valid? false, :errors [{:field :title, :error "Title must be EXACTLY 19 chars..."}]}
  
  ;; Pretty print errors
  (print-validation-errors
    (validate-grainbranch "bad-branch-name"))
  ; Prints:
  ; ❌ Grainbranch validation FAILED:
  ;   Field: ...
  ;   Error: ...
  
  ;; Auto-format (use this in CLI tool)
  (pad-to-19 "gkh-chartcourse")       ; => "gkh-chartcourse------"
  (pad-to-19 "moon-mula")              ; => "moon-mula----------"
  )

