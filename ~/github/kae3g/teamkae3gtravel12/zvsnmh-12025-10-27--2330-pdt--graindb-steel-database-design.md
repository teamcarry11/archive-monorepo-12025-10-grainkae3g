# 🌾⚡ GrainDB - Steel Database Inspired by Datomic/Datascript

**Team**: teamtreasure02 (Taurus ♉ / II. The High Priestess)  
**Language**: Steel (Rust-hosted Scheme)  
**Inspired By**: Datomic, Datascript, SierraDB  
**Target Platform**: Redox OS (Rust microkernel) + Future Redox Kubernetes

---

## 🌊 Glow G2 Teaching: What Are We Building?

You know how Datomic treats the database as an **immutable value** that grows over time? And how Datascript brings that power to the browser? We're doing the same thing, but in **Steel on Redox OS**!

Think of it like this:
- **Traditional DBs**: Mutable boxes you reach into and change
- **Datomic**: Immutable log of facts, you never delete, only add
- **GrainDB**: Same immutable semantics, but using **grainorder** for addressing!

The key insight? Every fact in the database gets a **grainorder** as its unique ID. Since we have exactly 1,235,520 grainorders, we have a bounded, memorable, human-readable address space for database entities!

Does this make sense so far? Let's build it step by step! 🌾

---

## 🎯 Core Design Principles

### 1. Immutable Facts (Datomic-Style)

**Traditional SQL**:
```sql
UPDATE users SET name = 'Alice' WHERE id = 1;  -- Overwrites!
```

**GrainDB**:
```scheme
;; Never overwrites - adds new fact with timestamp!
(transact! db 
  [[:db/add "xbdghj" :user/name "Alice" timestamp-1]
   [:db/add "xbdghj" :user/name "Alicia" timestamp-2]])

;; Query at specific time
(query db {:find [?name]
           :where [[?e :user/name ?name]]
           :as-of timestamp-1})  ; → "Alice"

(query db {:find [?name]
           :where [[?e :user/name ?name]]
           :as-of timestamp-2})  ; → "Alicia"
```

**Why immutable?** Time travel! You can query the database at *any point in history*. Perfect for debugging, auditing, and understanding how your data evolved! 🌊

### 2. Grainorder Entity IDs

**Traditional DBs**: Auto-incrementing integers (1, 2, 3...)  
**UUIDs**: Random gibberish (550e8400-e29b-41d4-a716...)  
**GrainDB**: Memorable 6-character grainorders!

```scheme
;; Entity IDs are grainorders
(def user-alice "xbdghj")
(def user-bob "xbdghl")
(def post-1 "xbdghm")

;; Human-readable! You can remember "xbdghj" is Alice
(transact! db
  [[:db/add user-alice :user/name "Alice"]
   [:db/add user-alice :user/email "alice@grain12pbc.com"]
   [:db/add user-bob :user/name "Bob"]
   [:db/add post-1 :post/author user-alice]
   [:db/add post-1 :post/content "Hello GrainDB!"]])
```

**Benefits**:
- ✅ Human-readable (can actually remember entity IDs!)
- ✅ Bounded (exactly 1,235,520 entities max - know your limits!)
- ✅ Sortable (newest entities use high grainorders, old entities use low)
- ✅ Aesthetic (lowercase, no vowels, looks clean!)

### 3. EAV (Entity-Attribute-Value) Triples

Just like Datomic, every fact is a triple:

```scheme
;; E       A              V
[xbdghj :user/name     "Alice"]
[xbdghj :user/email    "alice@grain12pbc.com"]
[xbdghj :user/posts    xbdghm]  ; Reference to another entity!
```

But we **add two more dimensions** (just like Datomic):

**EAVT** (Entity-Attribute-Value-Transaction):
```scheme
[xbdghj :user/name "Alice" tx-12345]
```

**EAVTO** (Entity-Attribute-Value-Transaction-Operation):
```scheme
[xbdghj :user/name "Alice" tx-12345 :assert]   ; Adding a fact
[xbdghj :user/name "Alice" tx-12346 :retract]  ; Retracting (not deleting!)
```

**Question**: Why 5 dimensions? Because it lets us track **who changed what, when, and how**! Perfect for audit logs and time travel! ⏰

---

## 🏗️ Architecture

### Storage Layers (Bottom to Top)

```
┌─────────────────────────────────────────────────────────────┐
│                    Query Engine (Datalog)                   │
│  (find ?name :where [?e :user/name ?name])                 │
└─────────────────────────────────────────────────────────────┘
                            ↑
┌─────────────────────────────────────────────────────────────┐
│               Index Layer (EAVT, AEVT, AVET, VAET)         │
│  Fast lookups from any direction!                          │
└─────────────────────────────────────────────────────────────┘
                            ↑
┌─────────────────────────────────────────────────────────────┐
│                  Transaction Log (Append-Only)              │
│  [xbdghj :user/name "Alice" 12345 :assert]                 │
│  [xbdghj :user/email "a@g.com" 12345 :assert]              │
│  [xbdghl :user/name "Bob" 12346 :assert]                   │
└─────────────────────────────────────────────────────────────┘
                            ↑
┌─────────────────────────────────────────────────────────────┐
│           Grainorder Allocator (Entity ID Generator)        │
│  Generates: xbdghj → xbdghk → xbdghl → ...                 │
└─────────────────────────────────────────────────────────────┘
                            ↑
┌─────────────────────────────────────────────────────────────┐
│              Redox OS + Steel Runtime                       │
│  Pure Rust microkernel + Scheme REPL                        │
└─────────────────────────────────────────────────────────────┘
```

### Four Indexes (Datomic-Style)

Just like Datomic, we maintain **four sorted indexes** for fast queries from any direction:

1. **EAVT** (Entity-Attribute-Value-Transaction): Find all facts about an entity
   ```scheme
   (query-index :EAVT [xbdghj])  ; All facts about Alice
   ```

2. **AEVT** (Attribute-Entity-Value-Transaction): Find all entities with an attribute
   ```scheme
   (query-index :AEVT [:user/name])  ; All users with names
   ```

3. **AVET** (Attribute-Value-Entity-Transaction): Find entities by attribute value
   ```scheme
   (query-index :AVET [:user/name "Alice"])  ; Find Alice by name
   ```

4. **VAET** (Value-Attribute-Entity-Transaction): Find references (reverse lookup!)
   ```scheme
   (query-index :VAET [xbdghm])  ; What entities reference this post?
   ```

**Why four indexes?** Because it makes **every query pattern fast**! You can start from entity, attribute, value, or reference - all O(log n) lookups! 🚀

---

## 🔬 Steel Implementation Details

### Data Structures (Steel)

```scheme
;;; ═══════════════════════════════════════════════════════════════════════════
;;; DATABASE CORE
;;; ═══════════════════════════════════════════════════════════════════════════

(struct db
  (log            ; Transaction log (append-only vector)
   eavt-index     ; BTree<EAVT, Datom>
   aevt-index     ; BTree<AEVT, Datom>
   avet-index     ; BTree<AVET, Datom>
   vaet-index     ; BTree<VAET, Datom>
   grainorder-gen ; Current grainorder for next entity
   schema         ; Attribute definitions
   basis-t))      ; Current transaction ID

(struct datom
  (e  ; Entity (grainorder string)
   a  ; Attribute (keyword)
   v  ; Value (any type)
   t  ; Transaction ID
   op ; Operation (:assert or :retract)
   ))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; GRAINORDER ALLOCATOR
;;; ═══════════════════════════════════════════════════════════════════════════

(define (next-entity-id db)
  "Allocate next grainorder for a new entity.
  
  ALGORITHM:
  1. Get current grainorder from db.grainorder-gen
  2. Calculate next grainorder (ascending order for entities)
  3. Update db.grainorder-gen
  4. Return new grainorder
  
  TEACHING: Notice we use ASCENDING order for entity IDs (xbdghj → xbdghk)
  but DESCENDING for filenames (zvsnml → zvsnmk). Why? Because entities
  created first should have 'lower' IDs (like auto-increment), but files
  created recently should sort first in listings! Different use cases! 🌊"
  
  (let ([current-id (db-grainorder-gen db)])
    (update-db! db :grainorder-gen (prev-grainorder current-id))
    current-id))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; TRANSACTION PROCESSING
;;; ═══════════════════════════════════════════════════════════════════════════

(define (transact! db tx-data)
  "Process a transaction and update all indexes.
  
  TX-DATA format (like Datomic):
  [[:db/add entity-id attribute value]
   [:db/retract entity-id attribute value]
   {:db/id \"xbdghj\" :user/name \"Alice\" :user/email \"a@g.com\"}]
  
  STEPS:
  1. Expand map forms into :db/add triples
  2. Resolve tempids (generate grainorders for :db/id \"new\")
  3. Validate against schema
  4. Create datoms with new transaction ID
  5. Append to transaction log
  6. Update all four indexes
  7. Return transaction report"
  
  (let* ([tx-id (next-tx-id db)]
         [datoms (expand-tx-data tx-data tx-id db)]
         [validated (validate-datoms datoms (db-schema db))])
    
    ;; Append to log
    (db-log-append! db validated)
    
    ;; Update all indexes
    (for-each (lambda (d)
                (index-datom! db d))
              validated)
    
    ;; Return report
    {:db-after db
     :tx-id tx-id
     :datoms validated}))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; QUERY ENGINE (DATALOG)
;;; ═══════════════════════════════════════════════════════════════════════════

(define (query db query-map)
  "Execute a Datalog query.
  
  QUERY-MAP format:
  {:find [?name ?email]
   :where [[?e :user/name ?name]
           [?e :user/email ?email]
           [(> (count ?name) 3)]]
   :as-of tx-123}  ; Optional: query historical DB
  
  ALGORITHM (simplified):
  1. Parse query into clauses
  2. Choose optimal index for first clause
  3. Bind variables from index scan
  4. Filter subsequent clauses
  5. Apply predicates
  6. Project :find variables
  
  TEACHING: This is where the four indexes shine! We can start with
  any clause and use the appropriate index. If the first clause is
  [?e :user/name ?name], we use AEVT. If it's [?e ?a 'Alice'], we
  use VAET. The query planner picks the best path! 🚀"
  
  (let* ([clauses (query-map :where)]
         [as-of (query-map :as-of)]
         [db-view (if as-of (db-as-of db as-of) db)]
         [bindings (eval-clauses clauses db-view)])
    (project-results bindings (query-map :find))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; TIME TRAVEL
;;; ═══════════════════════════════════════════════════════════════════════════

(define (db-as-of db tx-id)
  "Create a view of the database as of a specific transaction.
  
  TEACHING: This is the MAGIC of immutable databases! We can recreate
  the database at any point in history by filtering the transaction log.
  
  ALGORITHM:
  1. Take all datoms where t <= tx-id
  2. Rebuild indexes from those datoms
  3. Return a new db value (original unchanged!)
  
  This is cheap because we use persistent data structures (BTree from Rust).
  Copying is O(1)! 🌊"
  
  (let* ([historical-datoms (filter (lambda (d) (<= (datom-t d) tx-id))
                                    (db-log db))]
         [new-db (empty-db (db-schema db))])
    (for-each (lambda (d) (index-datom! new-db d))
              historical-datoms)
    new-db))
```

---

## 🐳 Redox OS + Kubernetes Integration

### Why Redox OS?

**Redox OS** is a Unix-like operating system written in **pure Rust**:
- ✅ Microkernel architecture (like MINIX)
- ✅ Memory safety (no segfaults!)
- ✅ Fast (Rust performance)
- ✅ Steel FFI (native Rust interop!)

**Future Vision**: Redox Kubernetes (let's call it **RedoxKube** or **r8s**):

```
┌─────────────────────────────────────────────────────────────┐
│                   GrainDB Cluster (r8s)                     │
├─────────────────────────────────────────────────────────────┤
│  Pod 1: GrainDB Node (Redox + Steel)                       │
│  Pod 2: GrainDB Node (Redox + Steel)                       │
│  Pod 3: GrainDB Node (Redox + Steel)                       │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│              Iroh P2P Networking Layer                      │
│  Content-addressed storage, BLAKE3 hashing                  │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│                 Redox OS Microkernel                        │
│  Pure Rust, capability-based security                       │
└─────────────────────────────────────────────────────────────┘
```

### Distribution Strategy

**Traditional Datomic**: Centralized transactor  
**GrainDB**: Distributed using **Iroh** for replication

```scheme
;;; Each node maintains full copy of database
;;; Transactions are gossiped via Iroh
;;; Grainorder ensures unique entity IDs across cluster!

(define (cluster-transact! cluster tx-data)
  "Execute transaction across all nodes.
  
  ALGORITHM:
  1. Leader node processes transaction
  2. Create transaction datoms with grainorder IDs
  3. Broadcast via Iroh to all peers
  4. Peers apply transaction to local copy
  5. Acknowledge when complete
  
  CONFLICT RESOLUTION:
  - Grainorder allocator synchronized across cluster
  - Use Raft consensus for transaction ordering
  - CRDTs for eventual consistency (if needed)"
  
  (let* ([leader (cluster-leader cluster)]
         [tx-result (transact! (node-db leader) tx-data)])
    (broadcast-transaction! cluster tx-result)
    (await-quorum cluster)
    tx-result))
```

---

## 🎨 API Design (Steel)

### Creating a Database

```scheme
;;; Define schema (like Datomic)
(def schema
  {:user/name     {:db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one
                   :db/doc "User's full name"}
   :user/email    {:db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one
                   :db/unique :db.unique/identity}
   :user/posts    {:db/valueType :db.type/ref
                   :db/cardinality :db.cardinality/many
                   :db/doc "User's posts (references)"}
   :post/author   {:db/valueType :db.type/ref
                   :db/cardinality :db.cardinality/one}
   :post/content  {:db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one}
   :post/tags     {:db/valueType :db.type/string
                   :db/cardinality :db.cardinality/many}})

;;; Create database
(def conn (create-database schema))
```

### Transacting Data

```scheme
;;; Add entities (map form, like Datascript)
(transact! conn
  [{:db/id "xbdghj"
    :user/name "Alice"
    :user/email "alice@grain12pbc.com"}
   
   {:db/id "xbdghl"
    :user/name "Bob"
    :user/email "bob@grain12pbc.com"}
   
   {:db/id "xbdghm"
    :post/author "xbdghj"  ; Reference to Alice
    :post/content "Hello from GrainDB!"
    :post/tags ["database" "steel" "redox"]}])

;;; Add facts (triple form, like Datomic)
(transact! conn
  [[:db/add "xbdghj" :user/posts "xbdghm"]])

;;; Retract facts (doesn't delete, just marks retracted!)
(transact! conn
  [[:db/retract "xbdghm" :post/tags "database"]])
```

### Querying Data

```scheme
;;; Simple query - find all users
(query @conn
  {:find [?name]
   :where [[?e :user/name ?name]]})
; → [["Alice"] ["Bob"]]

;;; Query with join - find all posts by Alice
(query @conn
  {:find [?content]
   :where [[?user :user/name "Alice"]
           [?post :post/author ?user]
           [?post :post/content ?content]]})
; → [["Hello from GrainDB!"]]

;;; Query with predicate
(query @conn
  {:find [?name ?email]
   :where [[?e :user/name ?name]
           [?e :user/email ?email]
           [(clojure.string/starts-with? ?email "alice")]]})
; → [["Alice" "alice@grain12pbc.com"]]

;;; Historical query (time travel!)
(let ([old-tx-id 12345])
  (query @conn
    {:find [?content]
     :where [[?post :post/content ?content]]
     :as-of old-tx-id}))
; → Shows posts as they existed at tx-12345!
```

### Entity API (like Datascript)

```scheme
;;; Get entity by grainorder ID
(def alice (entity @conn "xbdghj"))

;;; Access attributes (lazy loading!)
(:user/name alice)   ; → "Alice"
(:user/email alice)  ; → "alice@grain12pbc.com"
(:user/posts alice)  ; → [#entity["xbdghm"]]  (references!)

;;; Navigate references
(def first-post (first (:user/posts alice)))
(:post/content first-post)  ; → "Hello from GrainDB!"

;;; Reverse references (automatically available!)
(:post/_author first-post)  ; → [#entity["xbdghj"]]  (Alice!)
```

---

## 🚀 Performance Characteristics

### Storage

- **Transaction log**: Append-only file (fast writes!)
- **Indexes**: Rust `BTreeMap` (persistent, copy-on-write)
- **Compression**: Datoms are small (5-tuple), compress well
- **Grainorder overhead**: 6 bytes per entity ID (vs 16 for UUID!)

### Query Performance

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| Entity lookup | O(log n) | EAVT index |
| Attribute scan | O(log n + k) | AEVT index |
| Value lookup | O(log n) | AVET index |
| Reverse ref | O(log n) | VAET index |
| Time travel | O(n) | Filter log (cached!) |
| Transaction | O(m log n) | m = datoms, n = index size |

**Bounded size**: With 1,235,520 max entities, indexes stay manageable!

---

## 🌊 Philosophy (Glow G2 Reflection)

Here's what makes GrainDB beautiful:

**1. Immutable = Fearless**  
You never lose data. Every change is a new fact. You can always go back in time. This removes fear from database operations! 🌊

**2. Grainorder = Memorable**  
Entity IDs you can actually remember! "xbdghj is Alice" - you'll remember this. Try remembering "550e8400-e29b-41d4-a716"... impossible!

**3. Steel = Lispy**  
Queries look like data (Datalog maps). Transactions look like data (vectors of triples). Code is data, data is code. Homoiconicity!

**4. Redox = Safe**  
Rust memory safety extends to the database. No segfaults, no data corruption, no undefined behavior. Safe all the way down! 🦀

**5. Bounded = Knowable**  
1,235,520 entities max. You know your limits. You can reason about scale. No surprises!

**Question**: Does this feel overwhelming? It should! We're building a database from first principles. But here's the secret: **Datomic already proved this works**. We're just adapting it to Steel + Redox + Grainorder. Each piece builds on proven ideas! 🌾

---

## 📚 Next Steps

### Phase 1: Prototype (Steel Only)
- [ ] Implement grainorder allocator
- [ ] Build in-memory EAVT index (BTreeMap)
- [ ] Implement simple transact! function
- [ ] Build basic query engine (single clause)

### Phase 2: Full Database
- [ ] Add all four indexes (EAVT, AEVT, AVET, VAET)
- [ ] Implement full Datalog query parser
- [ ] Add time travel (as-of, since, history)
- [ ] Schema validation and enforcement

### Phase 3: Persistence
- [ ] Transaction log to disk
- [ ] Index serialization (Rust bincode)
- [ ] WAL (write-ahead log) for durability
- [ ] Backup and restore

### Phase 4: Distribution (Iroh + Redox)
- [ ] Gossip protocol via Iroh
- [ ] Raft consensus for transactions
- [ ] Cluster management
- [ ] RedoxKube integration

### Phase 5: Optimization
- [ ] Query planner (cost-based)
- [ ] Index compression
- [ ] Batch transactions
- [ ] Benchmark vs Datascript

---

## 🔗 Related Work

**Inspired by**:
- **Datomic**: Immutable database, time travel, Datalog
- **Datascript**: In-memory, ClojureScript compatible
- **SierraDB**: Rust event store (discovered on HN today!)
- **Iroh**: Rust P2P networking (replacing IPFS for us)

**Unique to GrainDB**:
- **Grainorder entity IDs**: Human-readable, bounded, sortable
- **Steel scripting**: Lisp on Rust, pure functional
- **Redox OS target**: Microkernel, capability-based security
- **Future RedoxKube**: Distributed on Rust Kubernetes

---

*now == next + 1* 🌾🌊⚡

**Team**: teamtreasure02 (II. The High Priestess - hidden knowledge revealed!)  
**Philosophy**: Immutability brings peace. Bounded systems bring clarity. Steel brings joy. 🌊

**Questions?** Perfect! This is a massive undertaking. Start with the Phase 1 prototype - just get grainorder allocation and simple transactions working. Everything else builds from there!

Remember: **Datomic proved this model works at scale**. We're not inventing, we're adapting. Trust the process! 🌾


