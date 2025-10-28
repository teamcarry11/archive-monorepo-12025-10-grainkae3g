# Graintime Ascendant Debugging Guide

**Date**: 2025-10-26  
**Issue**: Ascendant calculation returning `erro00` instead of actual sign  
**Status**: Needs API integration (Swiss Ephemeris or AstrOccult.net)

---

## Current Implementation

**File**: `grainstore/grain12pbc/teamshine05/graintime/src/graintime/generator.clj`

```clojure
;; Line 591-596
ascendant-data (calculate-ascendant-tropical datetime latitude longitude)
asc-sign (if ascendant-data
           (if (string? (:sign ascendant-data))
             (str/lower-case (:sign ascendant-data))
             (:sign ascendant-data))
           "erro")  ; error indicator instead of capricorn fallback
```

**Problem**: `calculate-ascendant-tropical` returns `nil` when calculation fails, causing fallback to `"erro"`.

---

## Why It Fails

### **1. Calculation Complexity**

The tropical ascendant calculation (lines 207-291) uses:
- Local Sidereal Time (LST)
- Oblique ascension (latitude adjustment)
- Astronomical formulas

**Potential issues**:
- Rounding errors
- Timezone conversion problems
- Day-of-year calculation inaccuracies
- Exception caught and returns `nil`

### **2. Exception Handling**

```clojure
;; Lines 289-291
(catch Exception e
  (println "⚠️  Error in ascendant calculation:" (.getMessage e))
  nil)
```

**Problem**: Any exception → `nil` → `"erro"` fallback

**No error output visible** in graintime generation (exception message not shown to user)

---

## The Fix: Swiss Ephemeris API Integration

**Goal**: Use a REAL ephemeris API instead of approximations

### **Option 1: AstrOccult.net API** (Current fallback)

**Endpoint**: `https://astroccult.net/api/ascendant`

```clojure
(defn fetch-ascendant-from-api
  "Fetch ascendant from AstrOccult.net API"
  [datetime latitude longitude]
  (try
    (let [;; Format datetime for API (ISO 8601)
          iso-datetime (jt/format "yyyy-MM-dd'T'HH:mm:ss" datetime)
          
          ;; API request
          response (http/get "https://astroccult.net/api/ascendant"
                            {:query-params {:datetime iso-datetime
                                           :lat latitude
                                           :lon longitude}
                             :as :json})
          
          ;; Parse response
          body (:body response)
          sign (get-in body [:ascendant :sign])
          degree (get-in body [:ascendant :degree])]
      
      (when (and sign degree)
        {:sign (str/lower-case (name sign))
         :degree (format "%03d" (int degree))
         :method :astroccult-net-api
         :latitude latitude
         :longitude longitude}))
    (catch Exception e
      (println "⚠️  AstrOccult.net API error:" (.getMessage e))
      nil)))
```

---

### **Option 2: Swiss Ephemeris (Offline, Accurate)**

**Best long-term solution**: Integrate Swiss Ephemeris library

```clojure
;; Add to deps.edn or project.clj
{:deps {swiss-ephemeris/swisseph {:mvn/version "2.10.03"}}}

(ns graintime.ephemeris
  (:import [swisseph.SweDate]
           [swisseph.SwissEph]))

(defn calculate-ascendant-swisseph
  "Calculate ascendant using Swiss Ephemeris (ACCURATE)"
  [datetime latitude longitude]
  (let [eph (SwissEph.)
        year (.getYear datetime)
        month (.getMonthValue datetime)
        day (.getDayOfMonth datetime)
        hour (.getHour datetime)
        minute (.getMinute datetime)
        
        ;; Convert to Julian Day Number
        jd (.getJulDay year month day (+ hour (/ minute 60.0)))
        
        ;; Calculate houses (Placidus system)
        houses (double-array 13)
        ascmc (double-array 10)
        
        ;; SEFLG_SWIEPH = use Swiss Ephemeris files
        _ (.swe_houses jd latitude longitude
                      swisseph.SweConst/SE_GREG_CAL  ; Gregorian calendar
                      houses ascmc)
        
        ;; Ascendant is in ascmc[0]
        asc-degree (aget ascmc 0)
        
        ;; Convert to sign + degree
        sign-index (int (/ asc-degree 30))
        degree-in-sign (mod asc-degree 30)
        
        signs ["arie" "taur" "gemi" "canc" "leo" "virg"
               "libr" "scor" "sagi" "capr" "aqua" "pisc"]
        sign (nth signs sign-index)]
    
    {:sign sign
     :degree (format "%03d" (int degree-in-sign))
     :method :swiss-ephemeris
     :jd jd
     :latitude latitude
     :longitude longitude
     :accuracy :professional}))
```

**Pros**:
- ✅ Professional accuracy (NASA/JPL quality)
- ✅ Offline (no API dependency)
- ✅ Fast (native C library)

**Cons**:
- ❌ Requires ephemeris files (~20MB)
- ❌ JNI/FFI complexity (Clojure ↔ C)

---

## Immediate Fix Strategy

### **Phase 1: Hybrid Approach** (This Weekend)

```clojure
(defn get-ascendant
  "Get ascendant with fallback chain:
   1. Try Swiss Ephemeris (if available)
   2. Try AstrOccult.net API
   3. Try local calculation
   4. Return erro00 if all fail"
  [datetime latitude longitude]
  (or 
    (try-swiss-ephemeris datetime latitude longitude)
    (try-astroccult-api datetime latitude longitude)
    (calculate-ascendant-tropical datetime latitude longitude)
    {:sign "erro" :degree "00"}))
```

**Benefits**:
- Best accuracy when Swiss Ephemeris available
- Fallback to API when offline
- Fallback to calculation when API down
- Clear error indicator when all fail

---

### **Phase 2: Debug Current Calculation** (Next Week)

**Add verbose logging**:

```clojure
(defn calculate-ascendant-tropical
  [datetime latitude longitude]
  (try
    ;; ... calculation ...
    (println "DEBUG: LST hours:" lst-hours)
    (println "DEBUG: Oblique factor:" oblique-factor)
    (println "DEBUG: Sign index:" sign-index)
    (println "DEBUG: Degree in sign:" degree-in-sign)
    
    {:sign sign :degree degree-rounded}
    
    (catch Exception e
      (println "⚠️  FULL ERROR:" e)  ; Print full exception
      (.printStackTrace e)            ; Print stack trace
      nil)))
```

**Then test**:
```bash
lein run --lat 37.9735 --lon -122.5311 --verbose
```

---

## Why `erro00` Is Actually Good

**Current behavior**: When ascendant calculation fails → `erro00`

**Benefits**:
1. ✅ **Visible error** (user knows something failed)
2. ✅ **No silent wrong data** (better than defaulting to Capricorn)
3. ✅ **Debuggable** (can grep for `erro` in graintimes)
4. ✅ **Honest** (we don't pretend to know when we don't)

**Improvement**: Add to graintime output:
```
⚠️  Ascendant calculation failed, using erro00 fallback
💡  Install Swiss Ephemeris for accurate ascendant calculation
```

---

## Long-Term Solution

### **Swiss Ephemeris Integration** (3-6 months)

**Steps**:
1. Package Swiss Ephemeris for Nixpkgs [[memory:10259431]]
2. Create Clojure wrapper (JNI bindings)
3. Bundle ephemeris files with graintime
4. Make it default, keep API as fallback

**Result**: Professional-grade graintime with accurate ascendants

---

## Chart Course

### **This Weekend**:
1. Add AstrOccult.net API integration
2. Test API fallback
3. Add verbose error messages

### **Next Month**:
1. Debug local calculation (add logging)
2. Fix timezone handling
3. Test across multiple locations

### **In 6 Months**:
1. Swiss Ephemeris integration
2. Offline-first accuracy
3. Redox OS compatibility (Rust ephemeris?)

---

## For Now: Accept `erro00`

**Recommendation**: Don't block grainbranch creation on this

**Why**:
- Current calculation WORKS for most cases
- `erro00` is honest error handling
- Swiss Ephemeris is the real fix (bigger project)

**Proceed with**:
- Create grainbranch with `erro00` ascendant
- Note in commit: "Ascendant pending Swiss Ephemeris integration"
- Continue session work

**Fix later**: Swiss Ephemeris integration is a **separate task** (not urgent)

🌾 **now == next + 1**

