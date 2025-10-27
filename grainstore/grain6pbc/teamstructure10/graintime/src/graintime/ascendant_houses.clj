(ns graintime.ascendant-houses
  "House system implementations for ascendant calculation
  
  Implements multiple house systems:
  - Equal House (simplest, good approximation)
  - Placidus (most common in Western astrology)
  - Whole Sign (used in Vedic, simple)
  
  Strategy: Start with Equal House for quick offline calculation,
  then add Placidus for accuracy."
  (:require [clojure.string :as str]))

;; =============================================================================
;; EQUAL HOUSE SYSTEM (Simplest)
;; =============================================================================

(defn calculate-ascendant-equal-house
  "Calculate ascendant using Equal House system
  
  In Equal House, each house is exactly 30°, starting from the ascendant.
  The ascendant equals LST - 90° (or LST + 270° mod 360)
  
  This is MUCH simpler than Placidus and often close enough.
  
  Formula: ASC = (LST × 15°) - 90° mod 360°
  
  Why? Because when LST = 6h (90°), the Sun is at MC (zenith),
  and the ascendant (eastern horizon) is 90° behind (0° Aries)."
  [lst-hours]
  (let [;; Convert LST to degrees
        lst-deg (* lst-hours 15.0)
        
        ;; Equal House: ASC = LST - 90° (because ASC is 90° before MC)
        ;; Or equivalently: ASC = LST + 270° (going the other way)
        asc-deg (mod (- lst-deg 90.0) 360.0)]
    
    {:longitude asc-deg
     :method :equal-house
     :formula "ASC = (LST × 15°) - 90° mod 360°"}))

;; =============================================================================
;; WHOLE SIGN HOUSE SYSTEM (Vedic)
;; =============================================================================

(defn calculate-ascendant-whole-sign
  "Calculate ascendant using Whole Sign houses
  
  In Whole Sign, the ascendant sign determines the 1st house,
  and each subsequent house is one whole sign.
  
  This is the same as Equal House for the ascendant itself."
  [lst-hours]
  (calculate-ascendant-equal-house lst-hours))

;; =============================================================================
;; PLACIDUS HOUSE SYSTEM (Complex but accurate)
;; =============================================================================

(defn calculate-mc-from-ramc
  "Calculate Midheaven (MC) ecliptic longitude from RAMC
  
  MC is where the meridian (LST) intersects the ecliptic.
  
  Formula: tan(MC) = tan(RAMC) / cos(obliquity)
  where RAMC = LST × 15° (Right Ascension of MC)"
  [ramc-deg obliquity-rad]
  (let [ramc-rad (Math/toRadians ramc-deg)
        
        ;; Calculate MC using the standard formula
        ;; We use atan2 for proper quadrant handling
        mc-x (Math/cos ramc-rad)
        mc-y (/ (Math/sin ramc-rad) (Math/cos obliquity-rad))
        mc-rad (Math/atan2 mc-y mc-x)
        mc-deg (mod (Math/toDegrees mc-rad) 360.0)]
    
    mc-deg))

(defn calculate-ascendant-placidus
  "Calculate ascendant using Placidus house system
  
  Formula from Future Point India / standard astrology references:
  tan(ASC) = (cos(LST + 90°) - tan(ε) × tan(φ)) / sin(LST + 90°)
  
  Where:
  - LST = Local Sidereal Time (in degrees)
  - ε = Obliquity of ecliptic (~23.44°)
  - φ = Latitude
  
  This accounts for Earth's axial tilt and observer's position."
  [lst-hours latitude obliquity-deg]
  (let [obliquity-rad (Math/toRadians obliquity-deg)
        lat-rad (Math/toRadians latitude)
        
        ;; Convert LST to degrees
        lst-deg (* lst-hours 15.0)
        
        ;; LST + 90°
        lst-plus-90-deg (+ lst-deg 90.0)
        lst-plus-90-rad (Math/toRadians lst-plus-90-deg)
        
        ;; Calculate ascendant using the formula from web search
        ;; tan(ASC) = (cos(LST + 90°) - tan(ε) × tan(φ)) / sin(LST + 90°)
        
        numerator (- (Math/cos lst-plus-90-rad)
                    (* (Math/tan obliquity-rad) (Math/tan lat-rad)))
        denominator (Math/sin lst-plus-90-rad)
        
        ;; Use atan to get the angle, then atan2 for proper quadrant
        ;; Actually, let's use atan2 directly for robustness
        asc-rad (Math/atan2 numerator denominator)
        asc-deg-raw (Math/toDegrees asc-rad)
        
        ;; Normalize to 0-360° range
        asc-deg (mod (+ asc-deg-raw 360) 360.0)
        
        ;; Also calculate MC for reference
        ramc-deg lst-deg
        mc-deg (calculate-mc-from-ramc ramc-deg obliquity-rad)]
    
    {:longitude asc-deg
     :mc mc-deg
     :ramc ramc-deg
     :method :placidus-future-point
     :formula "tan(ASC) = (cos(LST+90°) - tan(ε)×tan(φ)) / sin(LST+90°)"}))

;; =============================================================================
;; TESTING / COMPARISON
;; =============================================================================

(defn compare-house-systems
  "Compare all house systems for given LST and location
  
  This helps us understand which system matches astro-seek."
  [lst-hours latitude]
  (let [obliquity 23.4397
        
        equal (calculate-ascendant-equal-house lst-hours)
        placidus (calculate-ascendant-placidus lst-hours latitude obliquity)]
    
    {:lst-hours lst-hours
     :latitude latitude
     :systems
     {:equal-house
      {:asc-deg (:longitude equal)
       :asc-sign-index (int (/ (:longitude equal) 30))
       :asc-degree-in-sign (mod (:longitude equal) 30)}
      
      :placidus
      {:asc-deg (:longitude placidus)
       :mc-deg (:mc placidus)
       :asc-sign-index (int (/ (:longitude placidus) 30))
       :asc-degree-in-sign (mod (:longitude placidus) 30)}}}))

(defn format-zodiac-result
  "Format ascendant result as zodiac sign + degree"
  [asc-deg]
  (let [signs ["Aries" "Taurus" "Gemini" "Cancer" "Leo" "Virgo"
               "Libra" "Scorpio" "Sagittarius" "Capricorn" "Aquarius" "Pisces"]
        sign-index (int (/ asc-deg 30))
        degree (int (mod asc-deg 30))
        sign (nth signs sign-index)]
    (str sign " " degree "°")))

(defn test-house-systems
  "Test different house systems against known good value"
  []
  (let [;; Test case: Oct 26, 2025, 17:00 PDT
        ;; LST: 18.2051 hours
        ;; Expected: Aries 5°
        lst 18.2051
        lat 37.9735
        
        comparison (compare-house-systems lst lat)
        equal-asc (get-in comparison [:systems :equal-house :asc-deg])
        placidus-asc (get-in comparison [:systems :placidus :asc-deg])
        placidus-mc (get-in comparison [:systems :placidus :mc-deg])]
    
    (println "\n🌾 HOUSE SYSTEM COMPARISON")
    (println "=" (apply str (repeat 60 "=")))
    (println "\nTest: Oct 26, 2025, 17:00 PDT")
    (println (str "LST: " lst " hours = " (format "%.2f°" (* lst 15))))
    (println (str "Latitude: " lat "°N"))
    (println)
    
    (println "EXPECTED (astro-seek):")
    (println "  Ascendant: Aries 5° (~5°)")
    (println)
    
    (println "EQUAL HOUSE SYSTEM:")
    (println (str "  ASC = " (format "%.2f°" equal-asc)))
    (println (str "  Sign: " (format-zodiac-result equal-asc)))
    (println (str "  Formula: ASC = (LST × 15°) - 90° mod 360°"))
    (println (str "  Calculation: (" lst " × 15°) - 90° = " (format "%.2f°" equal-asc)))
    (println)
    
    (println "PLACIDUS HOUSE SYSTEM:")
    (println (str "  MC = " (format "%.2f°" placidus-mc)))
    (println (str "  ASC = " (format "%.2f°" placidus-asc)))
    (println (str "  Sign: " (format-zodiac-result placidus-asc)))
    (println)
    
    (println "ANALYSIS:")
    (let [expected 5.0  ; Aries 5° = 5°
          equal-error (Math/abs (- equal-asc expected))
          placidus-error (Math/abs (- placidus-asc expected))]
      (println (str "  Equal House error: " (format "%.2f°" equal-error)))
      (println (str "  Placidus error: " (format "%.2f°" placidus-error)))
      (println)
      (cond
        (< equal-error 2.0)
        (println "  ✅ Equal House MATCHES! (within 2°)")
        
        (< placidus-error 2.0)
        (println "  ✅ Placidus MATCHES! (within 2°)")
        
        :else
        (println "  ❌ Neither system matches - more work needed")))
    
    (println "\n🌾 Test complete!\n")
    
    comparison))

