# DataScript for Veganic Farm Tools

**team04 (Nurture) + Helen Atthowe's 78 Elements**  
*Using DataScript (Clojure immutable database) for soil tracking, crop planning, and farm management*

---

## Why DataScript?

### **Perfect for Farm Data**

**DataScript = Datomic-like database in Clojure**:
- Immutable (records never change, only accumulate)
- Time-based (every observation has timestamp)
- Query-able (ask questions about patterns over years)
- Local-first (works offline, farmer's field has no WiFi)
- Clojure-native (integrates perfectly with Grain Network)

**Farm data is temporal**: Soil changes over seasons. Crops rotate. Weather varies. DataScript captures TIME naturally.

---

## The Schema (Farm Database Structure)

### **Core Entities**

```clojure
(def farm-schema
  {;; SOIL OBSERVATIONS
   :soil/id {:db/unique :db.unique/identity}
   :soil/location {:db/valueType :db.type/string}  ; "North Field Plot A"
   :soil/date {:db/valueType :db.type/instant}
   :soil/ph {:db/valueType :db.type/float}
   :soil/nitrogen {:db/valueType :db.type/string}  ; "low/medium/high"
   :soil/phosphorus {:db/valueType :db.type/string}
   :soil/potassium {:db/valueType :db.type/string}
   :soil/organic-matter {:db/valueType :db.type/float}  ; Percentage
   :soil/moisture {:db/valueType :db.type/string}
   :soil/temperature {:db/valueType :db.type/float}
   :soil/notes {:db/valueType :db.type/string}
   :soil/photo {:db/valueType :db.type/string}  ; File path
   
   ;; CROPS
   :crop/id {:db/unique :db.unique/identity}
   :crop/name {:db/valueType :db.type/string}  ; "Tomatoes"
   :crop/variety {:db/valueType :db.type/string}  ; "San Marzano"
   :crop/planted-date {:db/valueType :db.type/instant}
   :crop/harvest-date {:db/valueType :db.type/instant}
   :crop/location {:db/valueType :db.type/string}
   :crop/yield {:db/valueType :db.type/float}  ; Pounds harvested
   :crop/notes {:db/valueType :db.type/string}
   
   ;; WEATHER
   :weather/date {:db/valueType :db.type/instant}
   :weather/temp-high {:db/valueType :db.type/float}
   :weather/temp-low {:db/valueType :db.type/float}
   :weather/precipitation {:db/valueType :db.type/float}  ; Inches
   :weather/frost? {:db/valueType :db.type/boolean}
   :weather/notes {:db/valueType :db.type/string}
   
   ;; HELEN'S 78 ELEMENTS (extensible)
   :element/id {:db/unique :db.unique/identity}
   :element/name {:db/valueType :db.type/string}
   :element/category {:db/valueType :db.type/string}  ; "Soil/Plant/Water/etc"
   :element/status {:db/valueType :db.type/string}  ; "Present/Absent/Improving"
   :element/date-observed {:db/valueType :db.type/instant}})
```

---

## Example: Soil Tracking Over Years

### **Adding Observations**

```clojure
(require '[datascript.core :as d])

;; Create database
(def conn (d/create-conn farm-schema))

;; Add soil observation (Spring 2025)
(d/transact! conn
  [{:soil/id "north-field-plot-a-2025-03-15"
    :soil/location "North Field Plot A"
    :soil/date #inst "2025-03-15"
    :soil/ph 6.5
    :soil/nitrogen "medium"
    :soil/phosphorus "low"
    :soil/potassium "high"
    :soil/organic-matter 4.2
    :soil/moisture "adequate"
    :soil/temperature 45.0
    :soil/notes "Early spring, snow just melted, soil workable"
    :soil/photo "/photos/soil-2025-03-15.jpg"}])

;; Add observation 6 months later (Fall 2025)
(d/transact! conn
  [{:soil/id "north-field-plot-a-2025-09-20"
    :soil/location "North Field Plot A"
    :soil/date #inst "2025-09-20"
    :soil/ph 6.8
    :soil/nitrogen "high"  ; Improved!
    :soil/phosphorus "medium"  ; Improved!
    :soil/potassium "high"
    :soil/organic-matter 5.1  ; Increased!
    :soil/moisture "good"
    :soil/temperature 52.0
    :soil/notes "Post-harvest, cover crop planted, soil health improving"
    :soil/photo "/photos/soil-2025-09-20.jpg"}])
```

### **Querying: "How Has Soil Changed Over Time?"**

```clojure
(defn soil-history
  "Get all observations for a location, ordered by date"
  [db location]
  (d/q '[:find ?date ?ph ?om ?nitrogen
         :in $ ?loc
         :where
         [?e :soil/location ?loc]
         [?e :soil/date ?date]
         [?e :soil/ph ?ph]
         [?e :soil/organic-matter ?om]
         [?e :soil/nitrogen ?nitrogen]]
       db
       location))

;; Result:
;; [[#inst "2025-03-15" 6.5 4.2 "medium"]
;;  [#inst "2025-09-20" 6.8 5.1 "high"]]

;; Shows: pH up (6.5 → 6.8), organic matter up (4.2 → 5.1), nitrogen improved!
```

**This is POWERFUL for Helen**:
- See trends over years (soil regenerating?)
- Prove methods work (organic matter increasing = success)
- Teach others (data shows veganic farming improves soil)
- Make decisions (what to plant where based on historical data)

---

## Example: Crop Rotation Planning

### **Helen's 78 Elements Include Crop Rotation**

**DataScript makes rotation planning easy**:

```clojure
;; Record crops planted
(d/transact! conn
  [{:crop/id "tomatoes-north-2024"
    :crop/name "Tomatoes"
    :crop/variety "San Marzano"
    :crop/planted-date #inst "2024-05-01"
    :crop/harvest-date #inst "2024-09-15"
    :crop/location "North Field Plot A"
    :crop/yield 450.0
    :crop/notes "Heavy feeders, depleted nitrogen"}
   
   {:crop/id "cover-crop-north-2024-fall"
    :crop/name "Cover Crop"
    :crop/variety "Clover + Vetch"
    :crop/planted-date #inst "2024-09-20"
    :crop/location "North Field Plot A"
    :crop/notes "Nitrogen-fixing, will improve soil for next year"}])

;; Query: What was planted here in last 3 years?
(defn rotation-history
  [db location years]
  (let [cutoff-date (... subtract years from now)]
    (d/q '[:find ?crop-name ?variety ?planted ?harvested
           :in $ ?loc ?cutoff
           :where
           [?e :crop/location ?loc]
           [?e :crop/planted-date ?planted]
           [?e :crop/name ?crop-name]
           [?e :crop/variety ?variety]
           [(> ?planted ?cutoff)]
           [?e :crop/harvest-date ?harvested]]
         db location cutoff-date)))

;; Shows: Tomatoes 2024 (nitrogen depleter) → Cover crop (nitrogen fixer)
;; Suggests: Next year, plant light feeders (lettuce, peas) - rotation complete
```

**This helps Helen**:
- Avoid planting same family twice (prevents disease, nutrient depletion)
- Plan complementary crops (nitrogen fixers after heavy feeders)
- Track yields over time (which varieties do best in Montana cold?)
- Teach pattern (show data to other farmers - proof of concept)

---

## Example: Weather + Planting Calendar

### **Montana Cold Climate = Timing Matters**

```clojure
;; Record weather
(d/transact! conn
  [{:weather/date #inst "2025-05-15"
    :weather/temp-high 58.0
    :weather/temp-low 32.0
    :weather/precipitation 0.5
    :weather/frost? true
    :weather/notes "Late frost! Killed early tomato transplants"}])

;; Query: "When is it safe to plant tomatoes?" (no frost after this date)
(defn last-frost-dates
  "Find last frost dates for past 10 years"
  [db]
  (d/q '[:find ?year ?latest-frost-date
         :where
         [?e :weather/frost? true]
         [?e :weather/date ?date]
         [(year ?date) ?year]
         ;; Group by year, find latest frost date
         ]
       db))

;; Result shows: 2024 (May 22), 2023 (May 18), 2022 (May 25), etc.
;; Average: ~May 20
;; Recommendation: Don't plant tomatoes before May 25 (safety margin)
```

**This is GOLD for cold climate farmers**:
- Historical data (10+ years of frost dates)
- Safe planting windows (calculated from real observations)
- Risk reduction (don't plant too early, lose crop to frost)
- Local knowledge (Montana is different from California - data proves it)

---

## Example: Veganic Certification Tool

### **Helen's Methods = Certification Standard**

```clojure
(def veganic-certification-schema
  {;; FARM PRACTICES
   :practice/id {:db/unique :db.unique/identity}
   :practice/name {:db/valueType :db.type/string}  ; "No animal inputs"
   :practice/compliant? {:db/valueType :db.type/boolean}
   :practice/evidence {:db/valueType :db.type/string}  ; "Photos of compost ingredients"
   :practice/date-verified {:db/valueType :db.type/instant}
   
   ;; CERTIFICATION
   :cert/farm-name {:db/valueType :db.type/string}
   :cert/certified-date {:db/valueType :db.type/instant}
   :cert/expires-date {:db/valueType :db.type/instant}
   :cert/practices {:db/valueType :db.type/ref
                    :db/cardinality :db.cardinality/many}})

;; Check compliance
(defn check-veganic-compliance
  "Verify all required practices are met"
  [db farm-id]
  (d/q '[:find (count ?practice)
         :in $ ?farm
         :where
         [?farm :cert/practices ?practice]
         [?practice :practice/compliant? true]]
       db farm-id))

;; If all practices compliant: Issue certification
;; Store in DataScript: Permanent record, time-stamped, queryable
```

**Benefit**:
- Audit trail (all checks recorded, immutable)
- Annual renewal (query: is certification expired?)
- Public directory (query: all certified farms in Montana)
- Trust (blockchain-like immutability, but simpler)

---

## Example: Community Network

### **Connecting Veganic Farmers**

```clojure
(def community-schema
  {;; FARMERS
   :farmer/id {:db/unique :db.unique/identity}
   :farmer/name {:db/valueType :db.type/string}
   :farmer/location {:db/valueType :db.type/string}
   :farmer/climate-zone {:db/valueType :db.type/string}  ; "Cold/Temperate/Hot"
   :farmer/practices {:db/valueType :db.type/ref
                      :db/cardinality :db.cardinality/many}
   :farmer/crops-grown {:db/valueType :db.type/ref
                        :db/cardinality :db.cardinality/many}
   
   ;; KNOWLEDGE SHARING
   :knowledge/id {:db/unique :db.unique/identity}
   :knowledge/title {:db/valueType :db.type/string}
   :knowledge/author {:db/valueType :db.type/ref}  ; Links to farmer
   :knowledge/category {:db/valueType :db.type/string}
   :knowledge/content {:db/valueType :db.type/string}
   :knowledge/date {:db/valueType :db.type/instant}})

;; Query: "Find farmers in cold climates growing tomatoes"
(defn find-similar-farmers
  [db my-climate my-crop]
  (d/q '[:find ?farmer-name ?location
         :in $ ?climate ?crop
         :where
         [?f :farmer/climate-zone ?climate]
         [?f :farmer/crops-grown ?c]
         [?c :crop/name ?crop]
         [?f :farmer/name ?farmer-name]
         [?f :farmer/location ?location]]
       db my-climate my-crop))

;; Result: Other Montana farmers growing tomatoes
;; Helen can: Contact them, share knowledge, learn from them
```

**Network effect**: More farmers = more data = better insights = stronger community.

---

## Why DataScript Perfect for This

### **1. Immutable (Soil Observations Permanent)**

**Traditional database**: Update record (old data lost)

**DataScript**: Add new fact (all history preserved)

```clojure
;; March: Record nitrogen as "low"
{:soil/id "plot-a"
 :soil/nitrogen "low"
 :soil/date #inst "2025-03"}

;; September: Record nitrogen as "high"  
;; Old databases: Overwrite "low" with "high" (history lost!)
;; DataScript: ADD new fact (both "low" and "high" exist with timestamps)

{:soil/id "plot-a"
 :soil/nitrogen "high"
 :soil/date #inst "2025-09"}

;; Query history: See nitrogen went low → high (soil improvement proven!)
```

**This is CRITICAL for farming**: You NEED history. Soil changes over time. DataScript preserves all changes.

### **2. Time-Travel Queries**

**Question**: "What was soil pH in this field 2 years ago?"

**DataScript answer**: Query as-of any date.

```clojure
(def db-now @conn)  ; Current state

(def db-2-years-ago 
  (d/as-of db-now #inst "2023-10-25"))  ; State 2 years ago

;; Query old state
(d/q '[:find ?ph
       :where [?e :soil/location "North Field Plot A"]
              [?e :soil/ph ?ph]]
     db-2-years-ago)

;; Shows: pH was 6.2 (2 years ago)
;; Compare to now: pH is 6.8 (improved 0.6 points!)
```

**Farmers LOVE this**: "Proof my methods work. Soil is better than 2 years ago."

### **3. Offline-First**

**Farm reality**: No WiFi in field. No cell signal in many areas.

**DataScript**:
- Runs in browser (no server needed)
- Stores in IndexedDB (browser storage, persistent)
- Syncs when online (back to server if desired)
- Works completely offline (critical for rural farming)

**Helen in Montana field**:
- Opens Daylight tablet (Android app)
- Records soil observation (DataScript stores locally)
- No internet? No problem.
- Back at farmhouse WiFi: Syncs to server (optional backup)

### **4. Powerful Queries (Ask Any Question)**

**Examples Helen might ask**:

```clojure
;; "Which crops give best yield in cold years?"
(d/q '[:find ?crop-name (avg ?yield)
       :where
       [?c :crop/name ?crop-name]
       [?c :crop/yield ?yield]
       [?c :crop/planted-date ?date]
       [?w :weather/date ?date]
       [?w :weather/temp-high ?temp]
       [(< ?temp 65)]]  ; Cold year threshold
     @conn)

;; "Has organic matter increased since I started veganic methods?"
(d/q '[:find ?year (avg ?om)
       :where
       [?s :soil/date ?date]
       [?s :soil/organic-matter ?om]
       [(year ?date) ?year]]
     @conn)

;; "What was I doing in this field 5 years ago today?"
(d/as-of @conn #inst "2020-10-26")
```

**Any question. Any time. All history available.**

---

## The Android App (Daylight Tablet)

### **UI Design** (Simple, Field-Usable)

**Home screen**:
- Big buttons (work with gloves on)
- Photos (take picture of soil, auto-attach to observation)
- GPS (auto-record location if available)
- Offline-first (saves immediately to DataScript local)

**Soil observation screen**:
```
┌──────────────────────────────────────┐
│  SOIL OBSERVATION                     │
├──────────────────────────────────────┤
│  📍 Location: [GPS] or [Type name]   │
│  📅 Date: Oct 26, 2025 (auto)        │
│                                       │
│  pH: [____] (6.0-7.0 ideal)          │
│  Nitrogen: [Low] [Med] [High]        │
│  Phosphorus: [Low] [Med] [High]      │
│  Potassium: [Low] [Med] [High]       │
│  Organic Matter %: [____]            │
│  Moisture: [Dry] [OK] [Wet]          │
│  Temp °F: [____]                     │
│                                       │
│  📷 [Take Photo]                     │
│  📝 Notes: [____________________]    │
│                                       │
│  [SAVE]                              │
└──────────────────────────────────────┘
```

**Clean. Simple. Works in field with dirty hands.**

### **Queries Screen** (Back at farmhouse)

```
┌──────────────────────────────────────┐
│  INSIGHTS                             │
├──────────────────────────────────────┤
│  📊 Soil Health Trend (2 years)      │
│     Organic Matter: 3.8% → 5.1% ↗    │
│     pH: 6.2 → 6.8 ↗                  │
│     Nitrogen: Low → High ↗           │
│                                       │
│  🌱 Best Crops This Year:            │
│     1. Tomatoes (yield: 450 lbs)     │
│     2. Lettuce (yield: 200 lbs)      │
│                                       │
│  ❄️ Last Frost: May 20 (avg)         │
│     Safe to plant: May 25+           │
│                                       │
│  📅 Next Rotation:                   │
│     North Field: Light feeders       │
│     (Lettuce, peas recommended)      │
└──────────────────────────────────────┘
```

**Data becomes wisdom**: Patterns emerge. Decisions improve.

---

## Why This Serves Helen

### **Her Needs** (what she actually wants):

1. **Remember observations** (brain can't hold 40 years of data)
   - DataScript: Perfect. All recorded. Never forgotten.

2. **See patterns** (does cover cropping work?)
   - DataScript: Query shows organic matter increasing. Proof.

3. **Make decisions** (what to plant where and when?)
   - DataScript: Historical yield + weather + soil = informed choice.

4. **Teach others** (share veganic knowledge)
   - DataScript: Export data, show graphs, prove methods work.

5. **Certify farms** (help others become veganic)
   - DataScript: Compliance tracking, audit trail, certification database.

**All five needs: DataScript solves elegantly.**

---

## Technical Implementation

### **Stack**

```
Daylight Tablet (Android, E-ink screen)
    ↓
ClojureScript (compiles to JavaScript, runs in Android WebView)
    ↓
DataScript (immutable database, stores in IndexedDB)
    ↓
Local storage (offline-first, syncs when online optional)
    ↓
Server backup (NixOS on AWS $30/month, optional, for sync + backup)
```

**Offline works**: Farmer can use app anywhere, anytime.

**Online enhances**: Backup to server, sync across devices, community features.

### **Build Process**

```bash
# 1. Create ClojureScript Android app
lein new app veganic-farm-tools

# 2. Add DataScript dependency
;; project.clj
:dependencies [[datascript "1.6.5"]]

# 3. Define schema (farm-schema above)

# 4. Build UI (Reagent for React-like components)

# 5. Compile to Android APK
lein cljsbuild once android

# 6. Test on Daylight tablet

# 7. Deploy to Helen (if she wants it!)
```

---

## The Leonardo Approach

**Study** (understand veganic farming) → **Sketch** (design schema, UI mockups) → **Build** (code the tool) → **Refine** (Helen's feedback) → **Document** (teach others) → **Share** (open source, community improves it)

**DataScript fits this**:
- **Study**: Farm data is temporal, immutable, query-able (DataScript designed for this)
- **Sketch**: Schema IS the sketch (visual representation of farm knowledge)
- **Build**: Clojure + ClojureScript (same language, seamless)
- **Refine**: Add entities as needed (schema extensible)
- **Document**: Schema self-documents (read schema = understand farm model)
- **Share**: Open source (other farmers fork, customize, improve)

---

## Next Steps

### **This Week**

1. ✅ Spec written (this document)
2. 🔜 Create project: `veganic-farm-tools` (ClojureScript + DataScript)
3. 🔜 Define schema (soil, crops, weather, 78 elements)
4. 🔜 Mock UI (sketch screens, show Helen before building)

### **This Month**

5. Build first screen (soil observation entry)
6. Test DataScript queries (prove time-travel works)
7. Deploy to Daylight tablet (Android APK)
8. Dogfood (use it yourself for something - maybe track coding time?)

### **This Year**

9. Helen tests (if she engages)
10. Other farmers use (community grows)
11. Open source release (chartcourse-io/veganic-farm-tools)
12. Certification program (if farmers want it)

---

**DataScript = perfect choice for farm tools. Immutable. Temporal. Offline-first. Query-able. Clojure-native.**

🌾 **now == next + 1**

