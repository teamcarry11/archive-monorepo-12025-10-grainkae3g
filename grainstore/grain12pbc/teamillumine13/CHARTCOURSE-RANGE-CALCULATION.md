# Chartcourse Range Calculation (gkx → gbd)

**Date**: 2025-10-26  
**Question**: How many chartcourse permutations from `gkx` down to `gbd`?

---

## The Alphabet

**Characters**: `b, d, g, h, k, x` (6 consonants, NO vowels, NO y)

**Alphabetical order**: `b < d < g < h < k < x`

**Rule**: NO repeated consonants in same string

---

## Full Permutation Space (2-letter suffix)

**Math**: First char = 6 choices, Second char = 5 choices (must be different)

**Total**: 6 × 5 = **30 permutations**

---

## Chartcourse Range (gkx → gbd)

**Starting point**: `gkx` (highest alphabetically)  
**Ending point**: `gbd` (lowest alphabetically)

### **All 30 permutations in DESCENDING order**:

```
 1. gkx  ← Chartcourse 0 (most recent, START HERE)
 2. gkh
 3. gkg
 4. gkd
 5. gkb
 
 6. ghx
 7. ghk
 8. ghg
 9. ghd
10. ghb

11. ggx
12. ggk
13. ggh
14. ggd
15. ggb

16. gdx
17. gdk
18. gdh
19. gdg
20. gdb

21. gbx
22. gbk
23. gbh
24. gbg
25. gbd  ← Chartcourse 24 (oldest, END HERE)
```

---

## Answer

**From `gkx` down to `gbd`**: **25 permutations** (indices 0-24)

**Wait, that's not right!** Let me recalculate with NO repeated consonants...

Actually, looking at the list above, I see I made errors. Let me recalculate properly:

---

## Correct Calculation (NO repeated consonants)

**First position `g`** (prefix, fixed)

**Second position** (any of 6: b, d, g, h, k, x - but NOT g, since first is g)  
→ **5 choices**: b, d, h, k, x

**Third position** (any of 6 - but NOT g, NOT second char)  
→ **4 choices** (exclude g and the second char)

**Total**: 5 × 4 = **20 permutations** for strings starting with `g` and no repeated chars

---

## All 20 Chartcourse Permutations (gxx → gbd)

**Sorted DESCENDING** (reverse alphabetical, recent first):

```
 1. gxk  ← Chartcourse 0 (most recent)
 2. gxh
 3. gxg
 4. gxd
 5. gxb

 6. gkx
 7. gkh
 8. gkd  ← gkd is index 7 (8th chartcourse)
 9. gkb

10. ghx
11. ghk
12. ghd
13. ghb

14. gdx  ← Wait, this would be g-d-x, but second char can't equal first!
```

Hmm, I'm confusing myself. Let me be more systematic:

---

## Systematic Enumeration (NO repeated chars)

**Prefix**: `g` (fixed for chartcourses)

**Valid second chars** (not `g`): `b, d, h, k, x` (5 choices)

**For each second char, valid third chars** (not `g`, not second char): **4 choices**

### **Second char = `x`** (gx_):
- `gxk`, `gxh`, `gxd`, `gxb` (can't use `gxx` - repeated x)
- **4 permutations**

### **Second char = `k`** (gk_):
- `gkx`, `gkh`, `gkd`, `gkb` (can't use `gkg` - would repeat... wait, no!)
- Actually `g` and `k` are different, so `gkg` IS valid (g, k, g - no wait, that's g twice!)
- Let me re-check: "NO repeated consonants in same string"
- `gkg` = g appears twice → **INVALID**
- Valid: `gkx`, `gkh`, `gkd`, `gkb`
- **4 permutations**

### **Second char = `h`** (gh_):
- `ghx`, `ghk`, `ghd`, `ghb` (can't use `ghg` - repeated g)
- **4 permutations**

### **Second char = `d`** (gd_):
- `gdx`, `gdk`, `gdh`, `gdb` (can't use `gdg` - repeated g)
- **4 permutations**

### **Second char = `b`** (gb_):
- `gbx`, `gbk`, `gbh`, `gbd` (can't use `gbg` - repeated g)
- **4 permutations**

---

## Total Chartcourse Range

**5 second chars × 4 third chars** = **20 permutations**

**From `gxk` (highest) down to `gbd` (lowest)**: **20 chartcourses**

---

## Complete List (Descending Order)

```
 1. gxk  ← Chartcourse 0 (most recent, START)
 2. gxh
 3. gxd
 4. gxb

 5. gkx
 6. gkh  ← Ketos Vision Session (2025-10-26) is chartcourse 6
 7. gkd
 8. gkb

 9. ghx
10. ghk
11. ghd
12. ghb

13. gdx
14. gdk
15. gdh
16. gdb

17. gbx
18. gbk
19. gbh
20. gbd  ← Chartcourse 19 (oldest, END)
```

---

## Answer

**From `gxk` down to `gbd`**: **20 permutations** (indices 0-19)

**Current session (gkh)**: Chartcourse **#6** (7th overall counting from 0)

**Actually, user asked "gkh to gbd"**, so let's calculate that specific range:

### **From gkh down to gbd**:

Looking at the list:
```
 1. gxk
 2. gxh
 3. gxd
 4. gxb
 5. gkx
 6. gkh  ← START (Ketos Vision Session)
 7. gkd
 8. gkb
 9. ghx
10. ghk
11. ghd
12. ghb
13. gdx
14. gdk
15. gdh
16. gdb
17. gbx
18. gbk
19. gbh
20. gbd  ← END
```

**From gkh (#6) to gbd (#20)**: 
- Count: 20 - 6 + 1 = **15 chartcourses**
- Remaining after gkh: 20 - 6 = **14 more chartcourses** until gbd

**Perfect alignment**: 14 chartcourses remaining = 14 teams! ✨

---

## Why This Works

**Reverse alphabetical order** means:
- Most recent = highest code = appears FIRST in file listings ✅
- `gxk` > `gkh` > `gbd` (descending) ✅
- Easy to see newest chartcourses at top of directory ✅

**Cycle**:
- When you hit `gbd` (lowest), next chartcourse cycles back to `gxk` (highest)
- Or expand alphabet to get more permutations (add more consonants)

---

🌾 **now == next + 1**

