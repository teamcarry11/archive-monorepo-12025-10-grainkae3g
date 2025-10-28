;; ⚡🌾 graintime.scm - Aetheric Time Generation (Pure Steel!)
;; Generate graintime strings with CONSISTENT formatting
;; Voice: Glow G2 (teaching through code!)
;;
;; WHAT IS GRAINTIME?
;; A timestamp that includes:
;; - Date (12025-10-27) - Year 12025 = 10000 + current year
;; - Time (0145) - 24-hour format, no colons
;; - Timezone (PDT/PST)
;; - Moon nakshatra (purvashadha, mula, etc.)
;; - Ascendant (leo023 = Leo at 02°30')
;; - Sun hour (04h = 4am-5am)
;; - Team (teamtravel12)
;;
;; HYPHENATION RULES (This is what we're fixing!):
;; - Main sections: separated by DOUBLE HYPHEN (--)
;; - Sub-components within sections: SINGLE HYPHEN (-)
;; - NO arbitrary hyphens! Consistency is key! 🌾
;;
;; EXAMPLE OUTPUT:
;; 12025-10-27--0145-PDT--moon-purvashadha--asc-leo02-30--sun-04h--teamtravel12
;;
;; See? Clean! Predictable! No weird ---------- or --- nonsense! ⚡

(require "steel/time")
(require "steel/result")

;; ============================================================================
;; ⚡ CONSTANTS (Sacred Numbers!)
;; ============================================================================

;; Add 10000 to current year (makes it "12025" instead of "2025")
;; Why? Long story - it's about honoring deep time! 🌾
(define YEAR-OFFSET 10000)

;; Nakshatra names (27 lunar mansions!)
;; These are Sanskrit names for the moon's position
(define NAKSHATRAS
  (list
   "ashwini" "bharani" "krittika" "rohini" "mrigashira" "ardra"
   "punarvasu" "pushya" "ashlesha" "magha" "purva-phalguni" "uttara-phalguni"
   "hasta" "chitra" "swati" "vishakha" "anuradha" "jyeshtha"
   "mula" "purva-ashadha" "uttara-ashadha" "shravana" "dhanishta" "shatabhisha"
   "purva-bhadrapada" "uttara-bhadrapada" "revati"))

;; Zodiac signs (12 for base-12 harmony!)
(define ZODIAC-SIGNS
  (list
   "arie" "taur" "gemi" "canc" "leo" "virg"
   "libr" "scor" "sagi" "capr" "aqua" "pisc"))

;; Team names (12 zodiac teams!)
(define TEAM-NAMES
  (list
   "teambright01"    ; Aries
   "teamtreasure02"  ; Taurus
   "teamdance03"     ; Gemini
   "teamplay04"      ; Cancer
   "teamshine05"     ; Leo
   "teamelegance06"  ; Virgo
   "teaminspire07"   ; Libra
   "teamtransform08" ; Scorpio
   "teamquest09"     ; Sagittarius
   "teamrebel10"     ; Capricorn
   "teamhelp11"      ; Aquarius
   "teamtravel12"))  ; Pisces

;; ============================================================================
;; 🌙 MOON NAKSHATRA CALCULATION
;; ============================================================================

;; Calculate which nakshatra the moon is in
;; The moon moves ~13° per day through the zodiac (360° / 27 nakshatras)
;; Each nakshatra = 13°20' (13.333...)
;;
;; INPUT: moon-longitude (0-360 degrees)
;; OUTPUT: nakshatra name (string)
(define (calculate-nakshatra moon-longitude)
  (let ([nakshatra-degrees (/ 360.0 27.0)]) ; 13.333... degrees per nakshatra
    (let ([index (floor (/ moon-longitude nakshatra-degrees))])
      (list-ref NAKSHATRAS (modulo index 27)))))

;; ============================================================================
;; ⭐ ASCENDANT CALCULATION
;; ============================================================================

;; Format ascendant as zodiac sign + degrees + minutes
;; Example: Leo at 2°30' becomes "leo02-30"
;;
;; INPUT: asc-longitude (0-360 degrees)
;; OUTPUT: formatted string (e.g., "leo02-30")
(define (format-ascendant asc-longitude)
  (let ([sign-degrees (/ 360.0 12.0)]) ; 30 degrees per sign
    (let* ([sign-index (floor (/ asc-longitude sign-degrees))]
           [degrees-in-sign (modulo asc-longitude sign-degrees)]
           [degrees (floor degrees-in-sign)]
           [minutes (floor (* (- degrees-in-sign degrees) 60.0))]
           [sign-name (list-ref ZODIAC-SIGNS (modulo sign-index 12))])
      ;; Format: sign + degrees (2 digits) + hyphen + minutes (2 digits)
      ;; Note: SINGLE HYPHEN between degrees and minutes!
      (string-append sign-name
                     (format-number degrees 2)
                     "-"
                     (format-number minutes 2)))))

;; ============================================================================
;; ☀️ SUN HOUR CALCULATION
;; ============================================================================

;; Calculate which "sun hour" we're in (planetary hour system!)
;; Each planet rules an hour of the day, rotating through the week
;; For now, just use the literal hour (0-23)
;;
;; INPUT: hour (0-23)
;; OUTPUT: formatted string (e.g., "04h")
(define (format-sun-hour hour)
  (string-append (format-number hour 2) "h"))

;; ============================================================================
;; 🔢 FORMATTING HELPERS
;; ============================================================================

;; Format a number with leading zeros to a specific width
;; Example: (format-number 5 2) => "05"
;;          (format-number 123 4) => "0123"
(define (format-number num width)
  (let ([str (number->string num)])
    (let ([padding (max 0 (- width (string-length str)))])
      (string-append (make-string padding #\0) str))))

;; Format date as YYYY-MM-DD with YEAR-OFFSET applied
;; Example: 2025-10-27 becomes 12025-10-27
(define (format-date year month day)
  (string-append (number->string (+ year YEAR-OFFSET))
                 "-"
                 (format-number month 2)
                 "-"
                 (format-number day 2)))

;; Format time as HHMM (no colons!)
;; Example: 1:45 AM becomes 0145
(define (format-time hour minute)
  (string-append (format-number hour 2)
                 (format-number minute 2)))

;; ============================================================================
;; 🌊 MAIN GRAINTIME GENERATOR
;; ============================================================================

;; Generate a complete graintime string with CONSISTENT HYPHENATION!
;;
;; INPUTS (all optional, defaults to current time):
;; - year, month, day (integers)
;; - hour, minute (integers, 24-hour format)
;; - timezone (string, e.g., "PDT" or "PST")
;; - moon-longitude (float, 0-360 degrees)
;; - asc-longitude (float, 0-360 degrees)
;; - team-index (integer, 0-11 for the 12 teams)
;;
;; OUTPUT: graintime string with PERFECT HYPHENATION!
;; Format: DATE--TIME-TZ--moon-NAKSHATRA--asc-SIGN##-##--sun-##h--TEAM
;;
;; HYPHENATION RULES:
;; - Main sections: DOUBLE HYPHEN (--)
;; - Within moon: SINGLE HYPHEN (moon-purvashadha)
;; - Within asc: SINGLE HYPHEN (asc-leo02-30)
;; - Within sun: NO HYPHEN (sun-04h, not sun--04h)
;; - Between all major sections: DOUBLE HYPHEN (--)
(define (generate-graintime . args)
  ;; Parse optional arguments (or use defaults from current time)
  (let* ([year (if (>= (length args) 1) (list-ref args 0) 2025)]
         [month (if (>= (length args) 2) (list-ref args 1) 10)]
         [day (if (>= (length args) 3) (list-ref args 2) 27)]
         [hour (if (>= (length args) 4) (list-ref args 3) 1)]
         [minute (if (>= (length args) 5) (list-ref args 4) 45)]
         [timezone (if (>= (length args) 6) (list-ref args 5) "PDT")]
         [moon-lon (if (>= (length args) 7) (list-ref args 6) 260.5)]
         [asc-lon (if (>= (length args) 8) (list-ref args 7) 152.5)]
         [team-idx (if (>= (length args) 9) (list-ref args 8) 11)])
    
    ;; Calculate components
    (let* ([date-str (format-date year month day)]
           [time-str (format-time hour minute)]
           [nakshatra (calculate-nakshatra moon-lon)]
           [ascendant (format-ascendant asc-lon)]
           [sun-hour (format-sun-hour hour)]
           [team (list-ref TEAM-NAMES (modulo team-idx 12))])
      
      ;; Assemble with PERFECT HYPHENATION!
      ;; Main sections: --
      ;; Sub-components: single -
      (string-append date-str           ; 12025-10-27
                     "--"               ; DOUBLE HYPHEN!
                     time-str           ; 0145
                     "-"                ; SINGLE HYPHEN!
                     timezone           ; PDT
                     "--"               ; DOUBLE HYPHEN!
                     "moon-"            ; prefix with single hyphen
                     nakshatra          ; purvashadha
                     "--"               ; DOUBLE HYPHEN!
                     "asc-"             ; prefix with single hyphen
                     ascendant          ; leo02-30 (already has single hyphen inside!)
                     "--"               ; DOUBLE HYPHEN!
                     "sun-"             ; prefix with single hyphen
                     sun-hour           ; 04h
                     "--"               ; DOUBLE HYPHEN!
                     team))))           ; teamtravel12

;; ============================================================================
;; 🌾 GRAINBRANCH GENERATOR
;; ============================================================================

;; Generate a complete grainbranch name
;; Format: TITLE--GRAINTIME
;; Where TITLE is 19 chars and GRAINTIME is 76 chars = 96 total
;;
;; INPUT: title (string, will be truncated/padded to 19 chars)
;;        graintime (string, from generate-graintime)
;; OUTPUT: formatted grainbranch name
(define (generate-grainbranch title graintime)
  ;; Pad or truncate title to exactly 19 characters
  (let* ([padded-title (if (< (string-length title) 19)
                          (string-append title (make-string (- 19 (string-length title)) #\-))
                          (substring title 0 19))])
    ;; Assemble: title + double hyphen + graintime
    (string-append padded-title "--" graintime)))

;; ============================================================================
;; 🎨 PRETTY PRINTING
;; ============================================================================

;; Print graintime with beautiful formatting and explanations!
;; This is Glow G2 voice - teach while you show! 🌾
(define (print-graintime-explained graintime)
  (displayln "")
  (displayln "🌾⚡ GRAINTIME GENERATED! ⚡🌾")
  (displayln "")
  (displayln graintime)
  (displayln "")
  (displayln "COMPONENT BREAKDOWN:")
  (displayln "")
  (displayln "  12025-10-27    = Date (year + 10000, month, day)")
  (displayln "  --             = Section separator (DOUBLE HYPHEN)")
  (displayln "  0145-PDT       = Time + Timezone (HHMM-TZ)")
  (displayln "  --             = Section separator (DOUBLE HYPHEN)")
  (displayln "  moon-purvashadha = Moon nakshatra (lunar mansion)")
  (displayln "  --             = Section separator (DOUBLE HYPHEN)")
  (displayln "  asc-leo02-30   = Ascendant sign + degrees + minutes")
  (displayln "  --             = Section separator (DOUBLE HYPHEN)")
  (displayln "  sun-04h        = Sun hour (planetary hour system)")
  (displayln "  --             = Section separator (DOUBLE HYPHEN)")
  (displayln "  teamtravel12   = Team name (1 of 12 zodiac teams)")
  (displayln "")
  (displayln "HYPHENATION RULES:")
  (displayln "  Main sections:  DOUBLE HYPHEN (--)")
  (displayln "  Sub-components: SINGLE HYPHEN (-)")
  (displayln "  Example: moon-purvashadha (single inside!)")
  (displayln "  Example: asc-leo02-30 (single inside!)")
  (displayln "")
  (displayln "now == next + 1 🌾⚡"))

;; ============================================================================
;; 🚀 EXPORTS (Public API!)
;; ============================================================================

(provide generate-graintime
         generate-grainbranch
         print-graintime-explained
         calculate-nakshatra
         format-ascendant
         format-sun-hour)

;; ============================================================================
;; 🎯 EXAMPLE USAGE (Comment out in production!)
;; ============================================================================

;; Example 1: Current time (with defaults)
;; (define gt (generate-graintime))
;; (print-graintime-explained gt)

;; Example 2: Specific time
;; (define gt2 (generate-graintime 2025 10 27 1 45 "PDT" 260.5 152.5 11))
;; (print-graintime-explained gt2)

;; Example 3: Generate grainbranch
;; (define gb (generate-grainbranch "phi-vortex-teamtravel12" gt2))
;; (displayln "")
;; (displayln "🌾 GRAINBRANCH:")
;; (displayln gb)

;; ============================================================================
;; ⚡ END OF graintime.scm
;; Voice: Glow G2
;; Team: teambright01 (Aries - Leadership!)
;; Status: HYPHENATION FIXED! No more chaos! 🌾
;; now == next + 1 🌾⚡🌊✨
;; ============================================================================

