# Graintime Ketos CI/CD Integration ✧･ﾟ:*

**Team**: 10 (teamrebel10 - Capricorn ♑ / X. Wheel of Fortune)  
**Authored by**: 14 (teamabsorb14 - Ketu ☋ / XIV. Temperance)

---

## Purpose

This document explains how to integrate the Ketos graintime validator into CI/CD pipelines for automated graintime format validation across the entire repository.

---

## What Gets Validated

The `graintime-validator.ket` script checks all graintime strings found in:
- Grainbranch names
- File content (markdown, code, configs)
- Documentation examples
- Patent specifications
- Session summaries

**Validation Checks**:
1. ✅ **Format**: Exactly 76 characters
2. ✅ **Date**: Valid year (12025-12999), month (01-12), day (01-31)
3. ✅ **Time**: Valid hour (00-23), minute (00-59)
4. ✅ **Timezone**: Known abbreviation (PDT, PST, UTC, etc.)
5. ✅ **Nakshatra**: Valid name from 27 lunar mansions
6. ✅ **Nakshatra padding**: Exactly 13 chars (name + dashes)
7. ✅ **Ascendant**: Valid zodiac sign (4 chars) + degree (00-30)
8. ✅ **Solar house**: Valid house number (01-12)
9. ✅ **Team**: Valid team name from 14 teams
10. ✅ **Team padding**: Exactly 17 chars (dashes + teamXXXX14)

**Optimistic Validation Philosophy**:
- Rigorous format validation (structure must be perfect)
- Loose astronomical validation (accept plausible values)
- No network dependencies (no API calls in CI)
- Fast execution (suitable for every commit)

---

## CI/CD Integration

### GitHub Actions (Current)

Add to `.github/workflows/validate.yml`:

```yaml
name: Validate Graintimes

on: [push, pull_request]

jobs:
  validate-graintimes:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Ketos
        run: |
          cargo install ketos
      
      - name: Run Graintime Validator
        run: |
          ketos grainstore/grain06pbc/teamshine05/graintime-ketos/src/graintime-validator.ket .
```

### Ketos-Based CI (Future)

When we migrate to pure Ketos CI/CD:

```ketos
;;; ci-pipeline.ket
(require 'graintime-validator)

(define (run-validation-stage)
  (let ((report (validate-all-graintimes ".")))
    (print-validation-report report)
    (if (equal? 0 (get report :invalid))
        (ok "validation passed ✧･ﾟ:*")
        (error "validation failed - see errors above"))))
```

---

## Usage

### Command Line

```bash
# Validate all graintimes in current directory
ketos graintime-validator.ket .

# Validate specific directory
ketos graintime-validator.ket /path/to/grainkae3g

# Output example:
#
# ✧･ﾟ:* GRAINTIME VALIDATION REPORT ✧･ﾟ:*
#
# Total graintimes found: 42
# Valid: 38 ✅
# Invalid: 4 ❌
#
# ❌ INVALID GRAINTIMES:
#
# File: grainstore/.../old-branch/README.md
# Graintime: 12025-10-26--1700-PDT--moon-mula--asc-arie05...
# Errors:
#   - invalid length: expected 76, got 67
#   - nakshatra padding wrong: got 4 chars, need 13
#
# now == next + 1 🌾
```

### Exit Codes

- `0` - All graintimes valid ✅
- `1` - Some graintimes invalid ❌

Use in CI to fail builds when graintime format violations detected.

---

## Future Enhancements

### Phase 1: Enhanced File Scanning (Immediate)
- Implement `scan-file-for-graintimes` with Ketos io
- Implement `scan-repo-for-graintimes` with recursive traversal
- Support glob patterns for file filtering
- Ignore `.git/`, `node_modules/`, etc.

### Phase 2: Astronomical Validation (Medium-term)
- Integrate Swiss Ephemeris for precise moon positions
- Cache ephemeris data for 2025-2030 date range
- Validate nakshatra matches actual moon position ±1 day
- Warn (don't fail) on astronomical inconsistencies

### Phase 3: Timezone-Aware Validation (Medium-term)
- Verify timezone matches geographic location
- Check daylight saving time transitions
- Validate UTC offsets

### Phase 4: Solar House Verification (Long-term)
- Fetch sunrise/sunset times from api.sunrise-sunset.org
- Calculate precise solar houses for location
- Verify house assignment matches our asymmetric algorithm
- Cache solar times to reduce API dependency

### Phase 5: Ascendant Calculation (Long-term)
- Calculate local sidereal time for date/time/location
- Compute ascendant from LST + latitude
- Verify recorded ascendant matches calculation ±5°
- Use Swiss Ephemeris for professional-grade accuracy

---

## Design Philosophy

**Why Optimistic Validation?**

We validate FORMAT rigorously but ASTRONOMY loosely because:

1. **Format is our responsibility** - we control graintime structure
2. **Astronomy is nature's domain** - we observe, don't control
3. **CI needs speed** - no slow API calls or complex calculations
4. **Trust the generator** - if graintime was generated correctly, format proves it
5. **Fail on obvious errors** - wrong length, bad characters, impossible values
6. **Warn on suspicious** - moon/asc/house that seem off but might be right

This mirrors how you'd review a document:
- Typos and format violations → fix immediately
- Factual claims that seem odd → verify if critical, otherwise note for review

**Progressive Enhancement**:
- Start: Pure format validation (fast, simple, reliable)
- Add: Cached ephemeris validation (offline, precise, for common dates)
- Add: API fallback validation (online, comprehensive, optional)
- Never: Block CI on astronomical minutiae we can't verify offline

---

## Integration with Grainbarrel

The graintime validator integrates with grainbarrel build system:

```ketos
;;; grainbarrel task definition
(deftask validate-graintimes
  "validate all graintime strings in repository"
  []
  (let ((report (validate-all-graintimes ".")))
    (print-validation-report report)
    (when (> (get report :invalid) 0)
      (throw (error "graintime validation failed")))))

;;; pre-commit hook
(defhook pre-commit
  "run before every commit"
  []
  (validate-graintimes))
```

---

## Benefits

**For Developers**:
- Catch graintime format errors before push
- Get immediate feedback on invalid timestamps
- Learn proper format through error messages

**For Repository Quality**:
- Maintain format consistency across all files
- Prevent accumulation of malformed graintimes
- Document validation rules through code

**For Future**:
- Easy to enhance with better astronomical validation
- Foundation for automated graintime generation
- Template for other validation tasks

---

**Now == Next + 1** ✧･ﾟ:* 🌾

**Copyright © 2025 kae3g (kj3x39, @risc.love)**  
**Team**: 10 (teamrebel10)  
**Authored by**: 14 (teamabsorb14 - Ketu ☋)

