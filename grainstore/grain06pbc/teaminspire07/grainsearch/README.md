# grainsearch - Ketos-Based Text Search Utility ⚖️

**Team**: 07 (teaminspire07 - Libra ♎ / VII. The Chariot)  
**Authored by**: 14 (teamabsorb14 - Ketu ☋ / XIV. Temperance)

---

## Purpose

grainsearch is a text searching and processing utility written entirely in Ketos (Rust Lisp), providing awk-like functionality with Lisp elegance and functional composition.

**The Chariot's Victory**: Movement with balance, action with equilibrium  
**Libra's Scales**: Weighing patterns, finding matches, balancing input/output

---

## Features

### Pattern Matching
- Regex patterns (text matching)
- Predicate functions (custom logic)
- Grain-specific patterns (graintime, grain codes, ASCII boxes)

### Field Extraction
- Split lines by separator (like awk's field splitting)
- Extract specific fields ($1, $2, etc.)
- Transform fields through functions

### Aggregation
- Count matches
- Extract unique values
- Statistical summaries
- Custom aggregations through reduce

### Composability
- Chain operations functionally
- Map, filter, reduce over lines
- Pure functions (no hidden state)
- Testable components

---

## Why Ketos Instead of AWK?

**Libra Weighs Both Sides**:

**AWK Benefits** ⚖️ **Ketos Benefits**:
- Ubiquitous (everywhere) ←→ Pure functional (composable)
- Terse syntax (brief) ←→ Expressive power (lisp macros)
- Fast (C implementation) ←→ Type-safe (rust integration)
- Pattern language ←→ Full programming language
- Line-oriented ←→ Arbitrary data structures

**The Chariot's Movement**: Use both tools where each serves best. AWK for quick shell one-liners. Ketos for complex grain processing, CI/CD integration, and Redox OS compatibility.

**Balance, not dogma**.

---

## Usage Examples

### Find All Graintimes

```ketos
(require 'grainsearch)

(find-graintimes ["grains/*.md" "docs/*.md"])
;; → lists all files and lines containing valid graintime strings
```

### Count Grains Mentioning "ketos"

```ketos
(count-lines-matching "ketos" ["grains/*.md"])
;; → prints total count of matching lines
```

### Extract Second Field from CSV

```ketos
(grainsearch "active"
             ["data.csv"]
             {:field-sep ","
              :action (action-print-field 1)})
;; → prints second column from lines containing "active"
```

### Validate Grain Box Line Counts

```ketos
(grainsearch pattern-ascii-box
             ["grains/*.md"]
             {:aggregate (lambda (matches)
                          (let ((count (length matches)))
                            (format "{} box lines {}" 
                                   count
                                   (if (equal? count 110) "✅" "❌"))))})
```

### Custom Pattern and Transformation

```ketos
(grainsearch (predicate-contains "helen")
             ["grains-helen-mode/*.md"]
             {:action (action-transform string-upcase)})
;; → prints matching lines in UPPERCASE
```

---

## Integration with Grain Network

### With Grainbarrel

```ketos
;;; grainbarrel build task
(deftask search-todos
  "find all TODO comments in grain files"
  []
  (grainsearch "TODO" 
               (glob "grains*/*.md")
               {:action action-print}))
```

### With CI/CD

```ketos
;;; validate-grains.ket
(require 'grainsearch)

(define (validate-all-grains)
  (let ((results (search-files (glob "grains*/*.md")
                               pattern-ascii-box
                               action-count
                               "")))
    (for-each (lambda (file-result)
               (let ((count (aggregate-count (get file-result :matches))))
                 (when (not (equal? count 110))
                   (println (format "❌ {}: {} lines (need 110)" 
                                   (get file-result :file)
                                   count)))))
             results)))
```

---

## Team 07 Attribution

**Libra (♎)**: The Scales
- Balance in all things
- Harmony through equilibrium
- Justice through measured response
- Beauty in proportion

**The Chariot (VII)**: Victory Through Control
- Forward movement with balance
- Opposing forces harnessed
- Willpower aligned with wisdom
- Triumph through discipline

**Combined Energy**: Balanced movement, harmonious search, equitable pattern matching. The tool that weighs input fairly and moves through text with victorious precision.

---

## Status

**Current**: Specification and core architecture complete  
**Next**: Implement file I/O and regex matching in Ketos  
**Future**: Integration with grainbarrel, CI/CD, and grain validation

---

**Now == Next + 1** ⚖️✧･ﾟ:* 🌾

**Copyright © 2025 kae3g (kj3x39, @risc.love)**  
**Team**: 07 (teaminspire07 - Libra ♎ / VII. The Chariot)  
**Authored by**: 14 (teamabsorb14 - Ketu ☋)

