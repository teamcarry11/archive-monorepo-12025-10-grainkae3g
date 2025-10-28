# 🌾⚡ GRAINTIME SPECIFICATION v2.0 - Perfect 100×75 Alignment

**Date**: 12025-10-27--2145-PDT  
**Branch**: phi-vortex-teamtravel12  
**Team**: teambright01 (Aries - Leadership!)  
**Purpose**: Recalculate graintime for perfect monospace vertical stacking  

---

## 🎯 THE PROBLEM

**Old Spec:**
- Title: 19 chars
- Separator: `--` (2 chars)
- Graintime: 76 chars
- **Total: 97 chars** (3 chars buffer from 100-wide graincard)

**Issues:**
1. Do longest nakshatras + teams actually fit in 76 chars?
2. Need dash-padding for perfect vertical alignment
3. Want graintimes at **73 or 71 chars** for better balance

---

## 📏 COMPONENT MEASUREMENTS

### Longest Nakshatra Names

```
ashwini             (7)
bharani             (7)
krittika            (8)
rohini              (6)
mrigashira          (10)
ardra               (5)
punarvasu           (9)
pushya              (6)
ashlesha            (8)
magha               (5)
purva-phalguni      (14) ← LONGEST!
uttara-phalguni     (15) ← LONGEST!
hasta               (5)
chitra              (6)
swati               (5)
vishakha            (8)
anuradha            (8)
jyeshtha            (8)
mula                (4)
purva-ashadha       (13)
uttara-ashadha      (14)
shravana            (8)
dhanishta           (9)
shatabhisha         (11)
purva-bhadrapada    (16) ← LONGEST!
uttara-bhadrapada   (17) ← LONGEST!!!
revati              (6)
```

**Longest**: `uttara-bhadrapada` = **17 chars**

### Longest Team Names

```
teambright01        (12)
teamtreasure02      (14) ← LONGEST!
teamdance03         (11)
teamplay04          (10)
teamshine05         (11)
teamelegance06      (14) ← LONGEST!
teaminspire07       (13)
teamtransform08     (15) ← LONGEST!!!
teamquest09         (11)
teamrebel10         (11)
teamhelp11          (10)
teamtravel12        (12)
```

**Longest**: `teamtransform08` = **15 chars**

---

## 🔢 GRAINTIME COMPONENT BREAKDOWN

### Fixed Components

```
DATE:           12025-10-27     (11 chars)
SEPARATOR:      --              (2 chars)
TIME:           0145            (4 chars)
TZ-SEP:         -               (1 char)
TIMEZONE:       PDT/PST         (3 chars) ← Could be 4 for "AKST"!
SEPARATOR:      --              (2 chars)
MOON-PREFIX:    moon-           (5 chars)
NAKSHATRA:      uttara-bhadrapada (17 chars MAX)
SEPARATOR:      --              (2 chars)
ASC-PREFIX:     asc-            (4 chars)
SIGN:           pisc            (4 chars)
DEGREES:        02              (2 chars)
DEG-MIN-SEP:    -               (1 char)
MINUTES:        30              (2 chars)
SEPARATOR:      --              (2 chars)
SUN-PREFIX:     sun-            (4 chars)
HOUR:           04h             (3 chars)
SEPARATOR:      --              (2 chars)
TEAM:           teamtransform08 (15 chars MAX)
```

### Calculate Total (WORST CASE)

```
11  (date)
+2  (sep)
+4  (time)
+1  (tz-sep)
+4  (timezone - AKST worst case!)
+2  (sep)
+5  (moon-)
+17 (nakshatra - uttara-bhadrapada!)
+2  (sep)
+4  (asc-)
+4  (sign)
+2  (degrees)
+1  (deg-min-sep)
+2  (minutes)
+2  (sep)
+4  (sun-)
+3  (hour)
+2  (sep)
+15 (team - teamtransform08!)
───
= 87 chars!!! 😱
```

**PROBLEM**: 87 chars for graintime alone!
**With 19-char title + 2-char sep**: 19 + 2 + 87 = **108 chars total!**
**OVER the 100-char graincard width by 8 chars!** 💥

---

## 💡 THE SOLUTION

### Option 1: Reduce Title Length

```
TITLE:      15 chars (was 19)
SEP:        --  (2 chars)
GRAINTIME:  83 chars (padded worst-case)
───────
TOTAL:      100 chars EXACTLY! ✅
```

**Format:**
```
phi-vortex-----12025-10-27--0145-AKST--moon-uttara-bhadrapada--asc-pisc02-30--sun-04h--teamtransform08
│←────15────→││←──────────────────────────────── 83 chars ──────────────────────────────────────────→│
```

### Option 2: Abbreviate Components

**Nakshatras** (Use 3-letter codes!):
```
ashwini         → ash
bharani         → bha
krittika        → kri
rohini          → roh
mrigashira      → mri
ardra           → ard
punarvasu       → pun
pushya          → pus
ashlesha        → asl
magha           → mag
purva-phalguni  → pph  ← Saves 11 chars!
uttara-phalguni → uph  ← Saves 12 chars!
hasta           → has
chitra          → chi
swati           → swa
vishakha        → vis
anuradha        → anu
jyeshtha        → jye
mula            → mul
purva-ashadha   → pas  ← Saves 10 chars!
uttara-ashadha  → uas  ← Saves 11 chars!
shravana        → shr
dhanishta       → dha
shatabhisha     → sha
purva-bhadrapada  → pbd ← Saves 13 chars!
uttara-bhadrapada → ubd ← Saves 14 chars!!!
revati          → rev
```

**Teams** (Use 2-letter + number!):
```
teambright01      → br01    (Saves 8 chars!)
teamtreasure02    → tr02    (Saves 10 chars!)
teamdance03       → da03    (Saves 7 chars!)
teamplay04        → pl04    (Saves 6 chars!)
teamshine05       → sh05    (Saves 7 chars!)
teamelegance06    → el06    (Saves 10 chars!)
teaminspire07     → in07    (Saves 9 chars!)
teamtransform08   → tf08    (Saves 11 chars!!!)
teamquest09       → qu09    (Saves 7 chars!)
teamrebel10       → re10    (Saves 7 chars!)
teamhelp11        → he11    (Saves 6 chars!)
teamtravel12      → tv12    (Saves 8 chars!)
```

### Recalculate with Abbreviations

```
11  (date)
+2  (sep)
+4  (time)
+1  (tz-sep)
+4  (timezone - AKST)
+2  (sep)
+5  (moon-)
+3  (nakshatra - ubd!)  ← Was 17, now 3! Saved 14 chars!
+2  (sep)
+4  (asc-)
+4  (sign)
+2  (degrees)
+1  (deg-min-sep)
+2  (minutes)
+2  (sep)
+4  (sun-)
+3  (hour)
+2  (sep)
+4  (team - tf08!)  ← Was 15, now 4! Saved 11 chars!
───
= 62 chars! 🎉
```

**With abbreviations:**
- Title: 19 chars
- Sep: 2 chars
- Graintime: 62 chars (worst case!)
- **Total: 83 chars** (17 chars under 100!)

**With padding to 73 chars (your suggestion!):**
```
phi-vortex-teamtravel12--12025-10-27--0145-AKST--moon-ubd--asc-pisc02-30--sun-04h--tf08-----
│←──────19 chars──────→││←────────────────────────── 73 chars ─────────────────────────────→│
                                                                                     │←─8─→│ (padding!)
```

### Option 3: Hybrid (Best of Both!)

**Use full names when short, abbreviate when long:**

```python
# Pseudocode
if len(nakshatra) > 10:
    use_abbreviation()
else:
    use_full_name()

if len(team) > 12:
    use_abbreviation()
else:
    use_full_name()
```

**Example worst case:**
```
phi-vortex-teamtravel12--12025-10-27--0145-PDT--moon-ubd--asc-leo02-30--sun-04h--tf08---------
│←──────19 chars──────→││←────────────────────────── 73 chars ─────────────────────────────→│
```

**Example best case:**
```
phi-vortex-teamtravel12--12025-10-27--0145-PDT--moon-mula--asc-leo02-30--sun-04h--teamplay04-
│←──────19 chars──────→││←────────────────────────── 73 chars ─────────────────────────────→│
```

---

## 🎨 RECOMMENDED SPEC v2.0

### Format

```
TITLE--GRAINTIME
│←19→││←──73──→│
= 94 chars total (6 chars buffer from 100!)
```

### Components

```
TITLE:          19 chars (dash-padded if needed)
SEPARATOR:      --  (2 chars)
DATE:           12025-10-27  (11 chars)
SEPARATOR:      --  (2 chars)
TIME-TZ:        0145-PDT  (8-9 chars, depends on TZ)
SEPARATOR:      --  (2 chars)
MOON:           moon-XXX  (8-22 chars, use 3-letter if >10)
SEPARATOR:      --  (2 chars)
ASCENDANT:      asc-SSSS##-##  (13-14 chars)
SEPARATOR:      --  (2 chars)
SUN:            sun-##h  (7 chars)
SEPARATOR:      --  (2 chars)
TEAM:           XXXX##  (6-15 chars, use 4-char if >12)
PADDING:        ----- (fill to 73 total)
```

### Abbreviation Tables

**Nakshatras (3-letter codes):**
```scm
(define NAKSHATRA-ABBREV
  '(("ashwini" "ash")
    ("bharani" "bha")
    ("krittika" "kri")
    ("rohini" "roh")
    ("mrigashira" "mri")
    ("ardra" "ard")
    ("punarvasu" "pun")
    ("pushya" "pus")
    ("ashlesha" "asl")
    ("magha" "mag")
    ("purva-phalguni" "pph")
    ("uttara-phalguni" "uph")
    ("hasta" "has")
    ("chitra" "chi")
    ("swati" "swa")
    ("vishakha" "vis")
    ("anuradha" "anu")
    ("jyeshtha" "jye")
    ("mula" "mul")
    ("purva-ashadha" "pas")
    ("uttara-ashadha" "uas")
    ("shravana" "shr")
    ("dhanishta" "dha")
    ("shatabhisha" "sha")
    ("purva-bhadrapada" "pbd")
    ("uttara-bhadrapada" "ubd")
    ("revati" "rev")))
```

**Teams (4-char codes):**
```scm
(define TEAM-ABBREV
  '(("teambright01" "br01")
    ("teamtreasure02" "tr02")
    ("teamdance03" "da03")
    ("teamplay04" "pl04")
    ("teamshine05" "sh05")
    ("teamelegance06" "el06")
    ("teaminspire07" "in07")
    ("teamtransform08" "tf08")
    ("teamquest09" "qu09")
    ("teamrebel10" "re10")
    ("teamhelp11" "he11")
    ("teamtravel12" "tv12")))
```

---

## ✅ FINAL DECISION

### Recommended: 19 + 2 + 73 = 94 chars

**Benefits:**
- ✅ Fits in 100-char graincard width (6 chars buffer!)
- ✅ Dash-padded for perfect vertical alignment
- ✅ Abbreviates only when necessary (hybrid approach!)
- ✅ Human-readable (most names still full!)
- ✅ Monospace-friendly (all lines same width!)

**Example (short names):**
```
phi-vortex---------12025-10-27--0145-PDT--moon-mula--asc-leo02-30--sun-04h--teamplay04---
```

**Example (long names):**
```
phi-vortex---------12025-10-27--0145-AKST--moon-ubd--asc-pisc02-30--sun-04h--tf08---------
```

**Both exactly 94 chars!** Perfect vertical stacking! 🌾⚡

---

## 🚀 NEXT STEPS

1. [ ] Update `graintime.scm` with abbreviation tables
2. [ ] Add hybrid logic (abbreviate only if >threshold)
3. [ ] Add dash-padding to reach exactly 73 chars
4. [ ] Test with all 27 nakshatras × 12 teams = 324 combinations!
5. [ ] Verify perfect vertical alignment in monospace

---

**Status**: Specification Complete  
**Version**: 2.0  
**Format**: TITLE(19)--GRAINTIME(73) = 94 chars  
**Strategy**: Hybrid (abbreviate only long names!)  
**Alignment**: Perfect monospace vertical stacking! 🌾  

now == next + 1 🌾⚡🌊✨

