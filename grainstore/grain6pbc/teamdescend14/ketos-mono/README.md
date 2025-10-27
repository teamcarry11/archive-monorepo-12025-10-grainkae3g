# ketos-mono: One Folder, All Ketos Scripts ✧･ﾟ:*

**Team**: 14 (teamdescend14 - Ketu ☋ / XIV. Temperance)  
**Purpose**: Single discoverable location for all Ketos scripts in the grain ecosystem  
**Pattern**: Symbolic links pointing to actual implementations across teams  
**Philosophy**: The mono folder is empty yet points to everything

---

## What Is This?

This folder contains symlinks to every Ketos script in the grain network. It's like a table of contents, an index, a directory of pointers.

The scripts themselves live in their proper team folders. These symlinks just make them all discoverable from one place.

**The meta-pattern**: This folder demonstrates the very principle that `grainbranch-readme-sync` teaches - symbolic indirection enabling both precise organization and convenient access.

---

## Available Scripts

### graintime.ket
**Team**: 10 (teamstructure10 - Capricorn ♑ / X. Wheel of Fortune)  
**Location**: `teamstructure10/graintime-ketos/src/graintime.ket`  
**Purpose**: Generate 76-character graintime strings with astronomical precision  
**Usage**: Calculate temporal coordinates with moon nakshatra, ascendant, solar house

### graintime-validator.ket
**Team**: 10 (teamstructure10)  
**Location**: `teamstructure10/graintime-ketos/src/graintime-validator.ket`  
**Purpose**: Validate graintime strings for astrological and format consistency  
**Usage**: CI/CD integration, format checking, temporal validation

### graincard-validator.ket
**Team**: 10 (teamstructure10)  
**Location**: `teamstructure10/graincard-spec/src/graincard-validator.ket`  
**Purpose**: Validate grain format (80-char width, 110-line box, footer format)  
**Usage**: Ensure all grains meet format specification

### grainsearch.ket
**Team**: 07 (teambalance07 - Libra ♎ / VII. The Chariot)  
**Location**: `teambalance07/grainsearch/src/grainsearch.ket`  
**Purpose**: Functional text search and field extraction for grain processing  
**Usage**: Pattern matching, field extraction, aggregation, grain-specific patterns

### check-grain-lines.ket
**Team**: 04 (teamnurture04 - Taurus ♉ / IV. The Emperor)  
**Location**: `teamnurture04/grainbarrel/scripts/check-grain-lines.ket`  
**Purpose**: Check that all grains have exactly 110 lines in ASCII box  
**Usage**: Quality assurance, format validation, batch checking

---

## Why Symlinks? Why "Mono"?

**Symlinks** because:
- Each script lives in its proper team folder (organizational clarity)
- This folder makes them all discoverable (navigational convenience)
- No duplication, just pointers (don't repeat yourself)
- Updates to source automatically reflect here (single source of truth)

**"Mono"** (monorepo-inspired) because:
- One place to find all Ketos code
- Like a monorepo but using symlinks instead of copying
- The gathering place for distributed scripts
- Unity through collection, not through centralization

---

## Team Assignments

Notice how different teams author different tools:

**Team 04 (Taurus ♉)**: Build systems, grainbarrel, grain checking  
→ *Stability, structure, reliable foundations*

**Team 07 (Libra ♎)**: Text search, pattern matching, balanced processing  
→ *Balance, harmony, weighing input/output*

**Team 10 (Capricorn ♑)**: Time systems, validation, structural integrity  
→ *Discipline, precision, temporal mastery*

**Team 14 (Ketu ☋)**: Meta-organization, synthesis, teaching integration  
→ *Release, integration, bringing streams together*

Each team contributes its unique energy. This folder gathers their gifts.

---

## Usage Examples

### Run graintime generator:
```bash
ketos ketos-mono/graintime.ket
```

### Validate all grains:
```bash
ketos ketos-mono/check-grain-lines.ket
```

### Search for graintimes:
```bash
ketos ketos-mono/grainsearch.ket "moon-p_ashadha" grains-*/*.md
```

### Validate graintime format:
```bash
ketos ketos-mono/graintime-validator.ket "12025-10-27--0145-PDT--moon-p_ashadha----asc-leo023-sun-03h----teamdescend14"
```

---

## The Pattern

This folder itself demonstrates what the first grain (`xbdghj`) teaches:

*Symbolic links create convenient access while maintaining precise organization. The README at the root points to deep grainbranch paths. These symlinks in ketos-mono point to team-specific implementations. The pattern repeats at different scales, always serving the same purpose: emptiness (symlinks) enabling fullness (discovering actual scripts).*

---

**Now == Next + 1** ✧･ﾟ:* 🌾

**Copyright © 2025 kae3g (kj3x39, @risc.love)**  
**Team**: 14 (teamdescend14 - Ketu ☋ / XIV. Temperance)

Grainbook Issue 1: Ember Harvest 🎃  
The Ecological Computer

