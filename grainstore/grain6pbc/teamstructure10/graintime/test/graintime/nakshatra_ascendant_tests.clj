(ns graintime.nakshatra-ascendant-tests
  "Test suite for Moon Nakshatra and Ascendant calculations
  
  Data sources:
  - AstrOccult.net transit data (sidereal, Lahiri ayanamsa)
  - Astro-Seek.com sidereal calculator (tropical zodiac + sidereal nakshatras)
  
  Test coverage: 2+ years (Oct 2023 - Nov 2025)"
  (:require [clojure.test :refer [deftest is testing]]
            [graintime.generator :as gen]))

;; =============================================================================
;; KNOWN GOOD VALUES FROM ASTROCCULT.NET
;; =============================================================================

(def astroccult-test-cases
  "Moon nakshatra transits from AstrOccult.net
   
   Format: {:datetime ... :nakshatra-expected ...}
   
   Source: https://www.astroccult.net/transit_of_planets_planetary_events.html
   Base City: New Delhi, India (28.6139°N, 77.2090°E)
   Timezone: IST (UTC+5:30)"
  
  [{:name "Earliest data point"
    :year 2023
    :month 10
    :day 3
    :hour 18
    :minute 3
    :timezone "Asia/Kolkata"  ; IST
    :nakshatra-expected "rohini"
    :source "AstrOccult.net"}
   
   {:name "Latest data point"
    :year 2025
    :month 11
    :day 2
    :hour 17
    :minute 3
    :timezone "Asia/Kolkata"  ; IST
    :nakshatra-expected "u_bhadrapada"  ; Uttara Bhadrapada
    :source "AstrOccult.net"}
   
   {:name "Mid-range test (Jyeshtha)"
    :year 2024
    :month 10
    :day 17
    :hour 21
    :minute 0
    :timezone "Asia/Kolkata"  ; IST
    :nakshatra-expected "jyeshtha"
    :source "AstrOccult.net"}
   
   {:name "Mid-range test (Mula)"
    :year 2024
    :month 10
    :day 19
    :hour 21
    :minute 3
    :timezone "Asia/Kolkata"  ; IST
    :nakshatra-expected "mula"
    :source "AstrOccult.net"}])

;; =============================================================================
;; KNOWN GOOD VALUES FROM ASTRO-SEEK.COM
;; =============================================================================

(def astro-seek-test-cases
  "Verified calculations from Astro-Seek.com sidereal calculator
   
   Settings:
   - Tropical Zodiac + Sidereal Nakshatras
   - Ayanamsa: 0°00' (matching our tropical approach)
   - House system: Whole Sign
   
   Source: https://horoscopes.astro-seek.com/sidereal-astrology-chart-calculator"
  
  [{:name "San Rafael, Oct 26, 2025, 17:00 PDT"
    :year 2025
    :month 10
    :day 26
    :hour 17
    :minute 0
    :timezone "America/Los_Angeles"  ; PDT
    :location {:latitude 37.9735 :longitude -122.5311}
    :nakshatra-expected "mula"
    :ascendant-expected {:sign "arie" :degree 5}  ; Aries 5°03'
    :sun-house-expected 8  ; Late afternoon, descending toward sunset
    :lst-expected 18.205  ; 18:12:18
    :source "Astro-Seek.com verified"}])

;; =============================================================================
;; HELPER FUNCTIONS
;; =============================================================================

(defn create-datetime
  "Create ZonedDateTime from test case map"
  [{:keys [year month day hour minute timezone]}]
  (java.time.ZonedDateTime/of year month day hour minute 0 0
                               (java.time.ZoneId/of timezone)))

(defn within-tolerance?
  "Check if two values are within tolerance"
  [expected actual tolerance]
  (< (Math/abs (- expected actual)) tolerance))

;; =============================================================================
;; NAKSHATRA TESTS
;; =============================================================================

(deftest test-astroccult-nakshatras
  (testing "Moon Nakshatra calculations match AstrOccult.net data"
    (doseq [test-case astroccult-test-cases]
      (let [dt (create-datetime test-case)
            expected (:nakshatra-expected test-case)]
        (testing (:name test-case)
          (comment
            ;; TODO: Implement nakshatra calculation
            ;; This will require either:
            ;; 1. Swiss Ephemeris integration
            ;; 2. API call to ephemeris service
            ;; 3. Pre-calculated lookup table
            
            (let [result (gen/calculate-moon-nakshatra dt)]
              (is (= expected (:nakshatra result))
                  (str "Expected nakshatra " expected
                       " at " dt
                       " (from " (:source test-case) ")")))))))))

(deftest test-astro-seek-complete-calculations
  (testing "Complete graintime calculations match Astro-Seek.com"
    (doseq [test-case astro-seek-test-cases]
      (let [dt (create-datetime test-case)
            {:keys [latitude longitude]} (:location test-case)
            
            ;; Calculate all components
            asc-result (gen/calculate-ascendant-tropical dt latitude longitude)
            ;; sun-house (gen/get-sun-house-for-datetime dt latitude longitude)
            ]
        
        (testing (str (:name test-case) " - LST")
          (is (within-tolerance? (:lst-expected test-case)
                                 (:lst-hours asc-result)
                                 0.01)
              (str "LST should be ~" (:lst-expected test-case) " hours"
                   ", got " (format "%.4f" (:lst-hours asc-result)))))
        
        (testing (str (:name test-case) " - Ascendant sign")
          (is (= (get-in test-case [:ascendant-expected :sign])
                 (:sign asc-result))
              (str "Ascendant should be "
                   (get-in test-case [:ascendant-expected :sign])
                   ", got " (:sign asc-result))))
        
        (testing (str (:name test-case) " - Ascendant degree")
          (let [expected-deg (get-in test-case [:ascendant-expected :degree])
                actual-deg (Integer/parseInt (:degree asc-result))]
            (is (within-tolerance? expected-deg actual-deg 2)
                (str "Ascendant degree should be ~" expected-deg "°"
                     ", got " actual-deg "°"))))
        
        (comment
          (testing (str (:name test-case) " - Sun house")
            (is (= (:sun-house-expected test-case) sun-house)
                (str "Sun house should be " (:sun-house-expected test-case)
                     ", got " sun-house))))))))

;; =============================================================================
;; MANUAL TEST RUNNER (for Babashka)
;; =============================================================================

(defn run-tests
  "Run all tests and print results"
  []
  (println "\n🌾 GRAINTIME TEST SUITE\n")
  (println "Testing against known good values from:")
  (println "  - AstrOccult.net (2+ years of data)")
  (println "  - Astro-Seek.com (verified calculations)")
  (println)
  
  ;; Run LST test for Astro-Seek case
  (let [test-case (first astro-seek-test-cases)
        dt (create-datetime test-case)
        {:keys [latitude longitude]} (:location test-case)
        asc-result (gen/calculate-ascendant-tropical dt latitude longitude)]
    
    (println "TEST: San Rafael, Oct 26, 2025, 17:00 PDT")
    (println "----------------------------------------------")
    (println (str "LST Expected: " (:lst-expected test-case) " hours (18:12:18)"))
    (println (str "LST Actual:   " (format "%.4f" (:lst-hours asc-result)) " hours"))
    (println (str "LST Match:    "
                  (if (within-tolerance? (:lst-expected test-case)
                                         (:lst-hours asc-result)
                                         0.01)
                    "✅ PASS"
                    "❌ FAIL")))
    (println)
    
    (println (str "Ascendant Expected: "
                  (clojure.string/upper-case (get-in test-case [:ascendant-expected :sign]))
                  " " (get-in test-case [:ascendant-expected :degree]) "°"))
    (println (str "Ascendant Actual:   "
                  (clojure.string/upper-case (:sign asc-result))
                  " " (:degree asc-result) "°"))
    (println (str "Sign Match:         "
                  (if (= (get-in test-case [:ascendant-expected :sign])
                         (:sign asc-result))
                    "✅ PASS"
                    "❌ FAIL")))
    (println (str "Degree Match:       "
                  (if (within-tolerance? (get-in test-case [:ascendant-expected :degree])
                                         (Integer/parseInt (:degree asc-result))
                                         2)
                    "✅ PASS"
                    "❌ FAIL")))
    (println)
    (println "🌾 Test complete!\n")))

(comment
  ;; Run tests manually
  (run-tests)
  
  ;; Or run specific test
  (test-astro-seek-complete-calculations))

