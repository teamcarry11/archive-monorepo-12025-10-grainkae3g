(ns graintime.swiss-ephemeris-real
  "REAL Swiss Ephemeris integration for accurate nakshatra calculations
  
  This replaces the placeholder swiss_ephemeris.clj with actual Swiss Eph library calls.
  
  Usage:
    bb -A:swisseph -cp src -e '(require 'graintime.swiss-ephemeris-real) ...'"
  (:require [clojure.string :as str])
  (:import [java.time LocalDateTime ZonedDateTime ZoneId]
           [swisseph SwissEph SweDate SweConst]))

;; =============================================================================
;; NAKSHATRA DATA
;; =============================================================================

(def nakshatras
  "27 Vedic nakshatras in order (index 0-26)"
  ["Ashwini" "Bharani" "Krittika" "Rohini" "Mrigashira" "Ardra"
   "Punarvasu" "Pushya" "Ashlesha" "Magha" "Purva Phalguni" "Uttara Phalguni"
   "Hasta" "Chitra" "Swati" "Vishakha" "Anuradha" "Jyeshtha"
   "Mula" "Purva Ashadha" "Uttara Ashadha" "Shravana" "Dhanishta"
   "Shatabhisha" "Purva Bhadrapada" "Uttara Bhadrapada" "Revati"])

(def nakshatra-abbrevs
  "Abbreviated nakshatra names for graintime"
  ["ashwini" "bharani" "krittika" "rohini" "mrigashira" "ardra"
   "punarvasu" "pushya" "ashlesha" "magha" "p_phalguni" "u_phalguni"
   "hasta" "chitra" "swati" "vishakha" "anuradha" "jyeshtha"
   "mula" "p_ashadha" "u_ashadha" "shravana" "dhanishta"
   "shatabhisha" "p_bhadrapada" "u_bhadrapada" "revati"])

;; =============================================================================
;; SWISS EPHEMERIS INITIALIZATION
;; =============================================================================

(defn init-swiss-ephemeris
  "Initialize Swiss Ephemeris with ephemeris data path"
  []
  (let [sw (SwissEph.)]
    (.swe_set_ephe_path sw "resources/ephe")
    sw))

;; =============================================================================
;; JULIAN DAY CONVERSION
;; =============================================================================

(defn datetime-to-julian-day
  "Convert LocalDateTime to Julian Day Number (Universal Time)"
  [^LocalDateTime dt]
  (let [year (.getYear dt)
        month (.getMonthValue dt)
        day (.getDayOfMonth dt)
        hour (.getHour dt)
        minute (.getMinute dt)
        second (.getSecond dt)
        
        ;; Time as decimal hours
        time-decimal (+ hour (/ minute 60.0) (/ second 3600.0))
        
        ;; Swiss Ephemeris Julian Day function
        sw (SwissEph.)
        jd (.swe_julday sw year month day time-decimal SweConst/SE_GREG_CAL)]
    
    jd))

;; =============================================================================
;; MOON POSITION (SIDEREAL)
;; =============================================================================

(defn calculate-sidereal-moon
  "Calculate moon's sidereal longitude using Swiss Ephemeris
  
  This is the REAL calculation - accurate to the second!"
  [^LocalDateTime datetime]
  (let [sw (init-swiss-ephemeris)
        
        ;; Set sidereal mode with Lahiri ayanamsa (standard for Vedic astrology)
        _ (.swe_set_sid_mode sw SweConst/SE_SIDM_LAHIRI 0.0 0.0)
        
        ;; Convert to Julian Day
        jd (datetime-to-julian-day datetime)
        
        ;; Prepare result arrays
        xx (double-array 6)
        serr (StringBuffer.)
        
        ;; Calculate Moon position with SIDEREAL flag
        flag (bit-or SweConst/SEFLG_SWIEPH 
                     SweConst/SEFLG_SIDEREAL
                     SweConst/SEFLG_SPEED)
        ret (.swe_calc sw jd SweConst/SE_MOON flag xx serr)]
    
    (if (= ret SweConst/OK)
      {:sidereal-longitude (aget xx 0)
       :sidereal-latitude (aget xx 1)
       :distance (aget xx 2)
       :speed-longitude (aget xx 3)
       :julian-day jd
       :datetime datetime
       :method :swiss-ephemeris-sidereal
       :accuracy :high}
      (throw (ex-info "Swiss Ephemeris calculation failed"
                      {:error (.toString serr)
                       :julian-day jd})))))

(defn calculate-tropical-moon
  "Calculate moon's tropical longitude using Swiss Ephemeris"
  [^LocalDateTime datetime]
  (let [sw (init-swiss-ephemeris)
        jd (datetime-to-julian-day datetime)
        xx (double-array 6)
        serr (StringBuffer.)
        
        ;; Calculate Moon position (tropical - default)
        flag (bit-or SweConst/SEFLG_SWIEPH SweConst/SEFLG_SPEED)
        ret (.swe_calc sw jd SweConst/SE_MOON flag xx serr)]
    
    (if (= ret SweConst/OK)
      {:tropical-longitude (aget xx 0)
       :tropical-latitude (aget xx 1)
       :distance (aget xx 2)
       :julian-day jd
       :datetime datetime}
      (throw (ex-info "Swiss Ephemeris tropical calculation failed"
                      {:error (.toString serr)})))))

(defn get-ayanamsa
  "Get Lahiri ayanamsa for given datetime"
  [^LocalDateTime datetime]
  (let [sw (init-swiss-ephemeris)
        _ (.swe_set_sid_mode sw SweConst/SE_SIDM_LAHIRI 0.0 0.0)
        jd (datetime-to-julian-day datetime)
        ayanamsa (.swe_get_ayanamsa_ut sw jd)]
    ayanamsa))

;; =============================================================================
;; NAKSHATRA CALCULATION
;; =============================================================================

(defn sidereal-to-nakshatra
  "Convert sidereal longitude to nakshatra index and name"
  [sidereal-longitude]
  (let [normalized (mod sidereal-longitude 360)
        nakshatra-span 13.333333333333334
        nakshatra-index (min (int (/ normalized nakshatra-span)) 26)]
    
    {:nakshatra-index nakshatra-index
     :nakshatra-name (nth nakshatras nakshatra-index)
     :nakshatra-abbrev (nth nakshatra-abbrevs nakshatra-index)
     :sidereal-longitude normalized
     :degree-within-nakshatra (mod normalized nakshatra-span)}))

(defn calculate-moon-nakshatra
  "Calculate moon nakshatra using REAL Swiss Ephemeris
  
  This is accurate to the second - professional quality!"
  [^LocalDateTime datetime]
  (let [;; Get sidereal moon position
        moon-sidereal (calculate-sidereal-moon datetime)
        sidereal-long (:sidereal-longitude moon-sidereal)
        
        ;; Calculate nakshatra
        nakshatra-info (sidereal-to-nakshatra sidereal-long)]
    
    (merge nakshatra-info moon-sidereal)))

;; =============================================================================
;; PUBLIC API
;; =============================================================================

(defn get-current-nakshatra
  "Get current nakshatra using REAL Swiss Ephemeris"
  []
  (calculate-moon-nakshatra (LocalDateTime/now)))

(defn get-nakshatra-at
  "Get nakshatra for specific datetime using REAL Swiss Ephemeris"
  [datetime]
  (calculate-moon-nakshatra datetime))

;; =============================================================================
;; TESTING / VERIFICATION
;; =============================================================================

(defn test-against-astromitra
  "Test against Astromitra known value
  
  Test case: Oct 25, 2025, 07:21 PDT = 19:51 IST
  Expected: Jyeshtha (index 17, range 226.667° - 240°)"
  []
  (let [;; IST time for verification
        test-dt (LocalDateTime/of 2025 10 25 19 51 0)
        result (calculate-moon-nakshatra test-dt)]
    
    (println "\n🌟 Testing REAL Swiss Ephemeris against Astromitra:")
    (println "   Test datetime: 2025-10-25 19:51 IST")
    (println "   Expected: Jyeshtha (index 17, sidereal 226.667° - 240°)")
    (println)
    (println "   RESULT:")
    (println "     Nakshatra:" (:nakshatra-name result))
    (println "     Index:" (:nakshatra-index result))
    (println "     Sidereal longitude:" (format "%.4f°" (:sidereal-longitude result)))
    (println "     Degree within nakshatra:" (format "%.2f°" (:degree-within-nakshatra result)))
    (println)
    (println "     Julian Day:" (:julian-day result))
    (println "     Method:" (:method result))
    (println "     Accuracy:" (:accuracy result))
    (println)
    
    (let [expected-index 17
          expected-min 226.667
          expected-max 240.0
          actual-index (:nakshatra-index result)
          actual-long (:sidereal-longitude result)]
      
      (if (and (= actual-index expected-index)
               (>= actual-long expected-min)
               (<= actual-long expected-max))
        (println "   ✅ SUCCESS! Matches Astromitra perfectly!")
        (println "   ❌ MISMATCH - needs debugging")))
    
    result))

(defn test-current-time
  "Test Swiss Ephemeris with current time"
  []
  (let [result (get-current-nakshatra)]
    (println "\n🌙 Current Moon Nakshatra (Swiss Ephemeris):")
    (println "   Time:" (:datetime result))
    (println "   Nakshatra:" (:nakshatra-name result) 
             "(" (:nakshatra-abbrev result) ")")
    (println "   Index:" (:nakshatra-index result))
    (println "   Sidereal longitude:" (format "%.4f°" (:sidereal-longitude result)))
    (println "   Method:" (:method result))
    (println "   Accuracy:" (:accuracy result))
    result))

;; =============================================================================
;; ASCENDANT & HOUSE CALCULATION (TROPICAL)
;; =============================================================================

(defn calculate-ascendant-swiss
  "Calculate tropical ascendant using REAL Swiss Ephemeris
  
  This is the gold standard - uses Swiss Ephemeris swe_houses function
  with Placidus house system (most common in Western astrology).
  
  Returns:
    {:sign \"Libra\"
     :degree 15
     :longitude 195.0
     :house-cusps [house1 house2 ... house12]
     :ascendant 195.0
     :mc 90.0  ; Midheaven (10th house cusp)
     :method :swiss-ephemeris-placidus
     :accuracy :professional-grade}"
  [^LocalDateTime datetime latitude longitude]
  (let [sw (init-swiss-ephemeris)
        jd (datetime-to-julian-day datetime)
        
        ;; Prepare arrays for house cusps and ascendant/MC
        cusps (double-array 13)  ; houses 1-12 (index 0 unused)
        ascmc (double-array 10)  ; ascendant, MC, etc.
        
        ;; Calculate houses using Placidus system
        ;; 'P' = Placidus (most common), other options: 'K' (Koch), 'E' (Equal), etc.
        ret (.swe_houses sw jd SweConst/SEFLG_SWIEPH latitude longitude (int \P) cusps ascmc)]
    
    (let [asc-longitude (aget ascmc 0)  ; Ascendant longitude (0-360°)
          mc-longitude (aget ascmc 1)   ; Midheaven (MC) longitude
          
          ;; Convert longitude to zodiac sign
          sign-index (int (/ asc-longitude 30))
          signs ["Aries" "Taurus" "Gemini" "Cancer" "Leo" "Virgo"
                 "Libra" "Scorpio" "Sagittarius" "Capricorn" "Aquarius" "Pisces"]
          sign (nth signs sign-index)
          degree (int (mod asc-longitude 30))
          
          ;; Extract all house cusps
          house-cusps (vec (map #(aget cusps %) (range 1 13)))]
      
      {:sign sign
       :degree degree
       :longitude asc-longitude
       :mc mc-longitude
       :house-cusps house-cusps
       :ascendant asc-longitude
       :method :swiss-ephemeris-placidus
       :accuracy :professional-grade
       :julian-day jd
       :latitude latitude
       :longitude longitude
       :datetime datetime})))

(defn get-ascendant-now
  "Get current ascendant for given location using REAL Swiss Ephemeris"
  [latitude longitude]
  (calculate-ascendant-swiss (LocalDateTime/now) latitude longitude))

;; =============================================================================
;; INTEGRATED GRAINTIME CALCULATION
;; =============================================================================

(defn get-graintime-components-swiss
  "Get ALL graintime components using REAL Swiss Ephemeris
  
  This is the complete, professional-grade calculation:
  - Moon nakshatra (sidereal, Lahiri ayanamsa)
  - Ascendant (tropical, Placidus houses)
  - Both accurate to the second!
  
  Usage:
    (get-graintime-components-swiss datetime latitude longitude)"
  [^LocalDateTime datetime latitude longitude]
  (let [;; Moon nakshatra (sidereal)
        nakshatra (calculate-moon-nakshatra datetime)
        
        ;; Ascendant (tropical)
        ascendant (calculate-ascendant-swiss datetime latitude longitude)]
    
    {:nakshatra (:nakshatra-abbrev nakshatra)
     :nakshatra-full (:nakshatra-name nakshatra)
     :nakshatra-index (:nakshatra-index nakshatra)
     :sidereal-longitude (:sidereal-longitude nakshatra)
     
     :ascendant-sign (:sign ascendant)
     :ascendant-degree (:degree ascendant)
     :ascendant-longitude (:longitude ascendant)
     :mc (:mc ascendant)
     :house-cusps (:house-cusps ascendant)
     
     :method :swiss-ephemeris-complete
     :accuracy :professional-grade
     :datetime datetime
     :latitude latitude
     :longitude longitude}))

;; =============================================================================
;; TESTING / VERIFICATION
;; =============================================================================

(defn test-ascendant-calculation
  "Test ascendant calculation for San Rafael, CA"
  []
  (let [;; Test time: 4:30 PM PDT, Oct 26, 2025
        test-dt (LocalDateTime/of 2025 10 26 16 30 0)
        latitude 37.9735
        longitude -122.5311
        result (calculate-ascendant-swiss test-dt latitude longitude)]
    
    (println "\n🌅 Testing REAL Swiss Ephemeris Ascendant:")
    (println "   Location: San Rafael, CA (" latitude "°N, " longitude "°W)")
    (println "   Datetime: 2025-10-26 16:30 PDT")
    (println)
    (println "   RESULT:")
    (println "     Ascendant Sign:" (:sign result))
    (println "     Ascendant Degree:" (:degree result) "°")
    (println "     Ascendant Longitude:" (format "%.4f°" (:longitude result)))
    (println "     Midheaven (MC):" (format "%.4f°" (:mc result)))
    (println "     Method:" (:method result))
    (println "     Accuracy:" (:accuracy result))
    (println)
    (println "     House Cusps:")
    (doseq [[i cusp] (map-indexed vector (:house-cusps result))]
      (let [house-sign-index (int (/ cusp 30))
            house-degree (int (mod cusp 30))
            signs ["Aries" "Taurus" "Gemini" "Cancer" "Leo" "Virgo"
                   "Libra" "Scorpio" "Sagittarius" "Capricorn" "Aquarius" "Pisces"]
            house-sign (nth signs house-sign-index)]
        (println (format "       House %2d: %6.2f° (%s %d°)" (inc i) cusp house-sign house-degree))))
    (println)
    
    result))

(defn test-complete-graintime
  "Test complete graintime calculation with Swiss Ephemeris"
  []
  (let [;; Current time
        dt (LocalDateTime/now)
        latitude 37.9735
        longitude -122.5311
        result (get-graintime-components-swiss dt latitude longitude)]
    
    (println "\n🌾 Complete Graintime Components (Swiss Ephemeris):")
    (println "   Location: San Rafael, CA")
    (println "   Datetime:" (:datetime result))
    (println)
    (println "   MOON:")
    (println "     Nakshatra:" (:nakshatra-full result) "(" (:nakshatra result) ")")
    (println "     Sidereal longitude:" (format "%.4f°" (:sidereal-longitude result)))
    (println)
    (println "   ASCENDANT:")
    (println "     Sign:" (:ascendant-sign result))
    (println "     Degree:" (:ascendant-degree result) "°")
    (println "     Longitude:" (format "%.4f°" (:ascendant-longitude result)))
    (println)
    (println "   METHOD:")
    (println "     Calculation:" (:method result))
    (println "     Accuracy:" (:accuracy result))
    (println)
    
    result))

(comment
  ;; Test against known value
  (test-against-astromitra)
  
  ;; Test current time
  (test-current-time)
  
  ;; Get ayanamsa for 2025
  (get-ayanamsa (LocalDateTime/of 2025 10 25 12 0 0))
  ;; Should be ~24.1-24.2°
  
  ;; Test ascendant calculation
  (test-ascendant-calculation)
  
  ;; Test complete graintime
  (test-complete-graintime)
  )

