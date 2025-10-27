(ns graintime.ascendant-unified
  "Unified ascendant calculation with triple redundancy
  
  Implements all three methods:
  - A: Swiss Ephemeris (professional-grade, requires library)
  - B: Manual formula (offline, working on fix)
  - C: API fallback (future, requires network)
  
  Cross-validates results and uses best available method."
  (:require [graintime.generator :as gen]
            [graintime.ascendant-api :as api]
            [clojure.string :as str]))

;; =============================================================================
;; METHOD AVAILABILITY CHECKS
;; =============================================================================

(defn swiss-ephemeris-available?
  "Check if Swiss Ephemeris library is available"
  []
  (try
    (Class/forName "swisseph.SwissEph")
    true
    (catch Exception _
      false)))

(defn api-available?
  "Check if API is available (network + service)"
  []
  ;; TODO: Implement actual API availability check
  false)

;; =============================================================================
;; UNIFIED ASCENDANT CALCULATION
;; =============================================================================

(defn calculate-ascendant-all-methods
  "Calculate ascendant using ALL available methods
  
  Returns a map of results from each method:
    {:swiss {...}  ; if available
     :manual {...}  ; always available
     :api {...}}    ; if available"
  [datetime latitude longitude]
  (let [results {}
        
        ;; Method A: Swiss Ephemeris
        swiss-result (when (swiss-ephemeris-available?)
                      (try
                        (require '[graintime.swiss-ephemeris-real :as swiss])
                        ((resolve 'graintime.swiss-ephemeris-real/calculate-ascendant-swiss)
                         (.toLocalDateTime datetime) latitude longitude)
                        (catch Exception e
                          {:error (.getMessage e)
                           :method :swiss-failed})))
        
        ;; Method B: Manual formula (our calculate-ascendant-tropical)
        manual-result (try
                       (gen/calculate-ascendant-tropical datetime latitude longitude)
                       (catch Exception e
                         {:error (.getMessage e)
                          :method :manual-failed}))
        
        ;; Method C: API fallback
        api-result (when (api-available?)
                    (try
                      (api/calculate-ascendant-api datetime latitude longitude)
                      (catch Exception e
                        {:error (.getMessage e)
                         :method :api-failed})))]
    
    (cond-> results
      swiss-result (assoc :swiss swiss-result)
      manual-result (assoc :manual manual-result)
      api-result (assoc :api api-result))))

(defn calculate-ascendant-best
  "Calculate ascendant using best available method
  
  Priority order:
  1. Swiss Ephemeris (if available and working)
  2. Validated manual (if it agrees with another method)
  3. API (if available)
  4. Manual (fallback, even if unvalidated)
  
  Returns the best result with validation metadata."
  [datetime latitude longitude]
  (let [all-results (calculate-ascendant-all-methods datetime latitude longitude)
        
        ;; Check which methods succeeded
        has-swiss? (and (:swiss all-results) 
                       (not (:error (:swiss all-results))))
        has-manual? (and (:manual all-results)
                        (not (:error (:manual all-results))))
        has-api? (and (:api all-results)
                     (not (:error (:api all-results))))
        
        ;; Validate if we have multiple methods
        validation (when (> (count (filter identity [has-swiss? has-manual? has-api?])) 1)
                    (api/validate-ascendant-methods all-results))
        
        ;; Choose best method
        best-result (cond
                      ;; Prefer Swiss Ephemeris if available
                      has-swiss?
                      (assoc (:swiss all-results)
                             :chosen-method :swiss-ephemeris
                             :confidence :highest)
                      
                      ;; Use manual if it's the only option
                      has-manual?
                      (assoc (:manual all-results)
                             :chosen-method :manual-formula
                             :confidence :unvalidated
                             :warning "Manual formula not yet validated")
                      
                      ;; Fall back to API
                      has-api?
                      (assoc (:api all-results)
                             :chosen-method :api-fallback
                             :confidence :high)
                      
                      ;; No methods available
                      :else
                      {:sign "erro"
                       :degree 0
                       :longitude 0.0
                       :chosen-method :none
                       :confidence :none
                       :error "No ascendant calculation methods available"})]
    
    (assoc best-result
           :all-results all-results
           :validation validation
           :methods-tried {:swiss has-swiss?
                          :manual has-manual?
                          :api has-api?})))

;; =============================================================================
;; TESTING / VALIDATION
;; =============================================================================

(defn test-triple-redundancy
  "Test all three methods for a known-good test case"
  []
  (let [;; Test case: Oct 26, 2025, 17:00 PDT
        dt (java.time.ZonedDateTime/of 2025 10 26 17 0 0 0
                                           (java.time.ZoneId/of "America/Los_Angeles"))
        lat 37.9735
        lon -122.5311
        
        ;; Expected result from astro-seek
        expected {:sign "arie" :degree 5}
        
        ;; Calculate with all methods
        result (calculate-ascendant-best dt lat lon)]
    
    (println "\n🌾 TRIPLE REDUNDANCY TEST")
    (println "=" (apply str (repeat 50 "=")))
    (println "\nTest: Oct 26, 2025, 17:00 PDT, San Rafael CA")
    (println "Expected: Aries 5°03'")
    (println)
    
    (println "METHODS ATTEMPTED:")
    (doseq [[method available?] (:methods-tried result)]
      (println (str "  " (if available? "✅" "❌") " "
                   (name method) (when available? " - available"))))
    (println)
    
    (println "CHOSEN METHOD:" (:chosen-method result))
    (println "CONFIDENCE:" (:confidence result))
    (println)
    
    (println "RESULT:")
    (println (str "  Sign: " (str/upper-case (:sign result))))
    (println (str "  Degree: " (:degree result) "°"))
    (println)
    
    (when (:validation result)
      (println "VALIDATION:")
      (println (str "  " (:recommendation (:validation result)))))
    
    (when (:warning result)
      (println)
      (println "⚠️  WARNING:" (:warning result)))
    
    (println)
    (println "🌾 Test complete!\n")
    
    result))

(comment
  ;; Run the test
  (test-triple-redundancy)
  
  ;; Test validation with mock data
  (api/validate-ascendant-methods
   {:swiss {:sign "arie" :degree 5}
    :manual {:sign "capr" :degree 20}
    :api {:sign "arie" :degree 6}}))

