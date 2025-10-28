# 🌊⚡ babashka to steel migration plan

**created**: 12025-10-27  
**team**: teamtreasure02 (steel team)  
**status**: planning phase  
**goal**: pure rust+steel stack - eliminate all babashka dependencies

## 📊 current state

Found **225 babashka files** (`.bb` scripts and configs) across the repository.

### breakdown by location:

- **grainbarrel** (teambright01): ~40 scripts (core utilities)
- **personal workspace** (grainkae3g-12025-10): ~60 scripts
- **template structure** (teamstructure10): ~60 scripts (duplicates of personal)
- **grain6pbc-org** (legacy): ~20 scripts
- **team-specific**: ~30 scripts across various teams
- **root/misc**: ~15 scripts

## 🎯 migration strategy

### phase 1: core utilities (✅ started)
**priority**: high  
**team**: teamtreasure02

already migrated:
- ✅ `n-kg-go.bb` → `n-kg-go.scm`
- ✅ `qb-kk-grainbook.bb` → `qb-kk.scm`
- ✅ `draw.bb` → `draw.scm`
- ✅ `graincard-generator.bb` → `graincard-generator.scm`
- ✅ `grain-phi-vortex` (new steel script)
- ✅ `lowercase-files.scm` (new steel script)
- ✅ `graintime.scm` (graintime/grainbranch formatting)

need to migrate (high priority):
- ⏳ `grainconfig-grainsync.bb`
- ⏳ `grainconfig-graintime.bb`
- ⏳ `grainstore-validate.bb`
- ⏳ `grainstore-stats.bb`
- ⏳ `grainstore-generate-docs.bb`
- ⏳ `grainsync-course-new.bb`
- ⏳ `qb-shot.bb`
- ⏳ `setup-github-token.bb`

### phase 2: grainbarrel unification
**priority**: high  
**action**: decide which grainbarrel to keep

current situation:
- `grainstore/grain12pbc/teambright01/grainbarrel/` (40 scripts)
- `grainstore/grain12pbc/teamplay04/grainbarrel/` (10 scripts)

**recommendation**: 
1. Move all grainbarrel to `teamtreasure02` (steel team)
2. Merge both versions, keeping best of each
3. Port all scripts to steel
4. Delete babashka originals

### phase 3: team-specific tools
**priority**: medium  
**approach**: port or delete

key scripts to evaluate:
- **teamshine05**: `graindisplay` scripts (10 files)
- **teamquest09**: `graincourse` build/deploy (6 files)
- **teamplay04**: `graindaemon` utilities (4 files)
- **teamelegance06**: `grainenvvars-validator.bb`
- **teamrebel10**: `graincard-validator.bb`

**action**: audit each script - does it still serve a purpose?

### phase 4: legacy cleanup
**priority**: low  
**action**: delete or archive

files to remove:
- `grain6pbc-org/` scripts (20 files) - old structure
- `archive/` babashka scripts (6 files)
- duplicate scripts in `teamstructure10/` (60 files)

### phase 5: personal workspace
**priority**: personal  
**owner**: kae3g

scripts in `grainkae3g-12025-10/`:
- framework16 hardware scripts (5 files)
- display/desktop management (4 files)
- sixos/vm management (3 files)
- formatting/navigation (6 files)
- other utilities (40+ files)

**recommendation**: port actively used scripts, archive the rest

## 🔧 steel porting guidelines

### when to port:
- ✅ script is actively used
- ✅ script is core to grain network
- ✅ script would benefit from steel's features
- ✅ script is referenced in documentation

### when to delete:
- ❌ script hasn't been used in months
- ❌ functionality is obsolete
- ❌ better solution exists in steel/rust
- ❌ was experimental/aspirational

### porting checklist:
1. ✅ read the babashka script, understand its purpose
2. ✅ check if it's still needed
3. ✅ rewrite in steel with glow g2 teaching comments
4. ✅ test the steel version
5. ✅ update any references to the script
6. ✅ delete the `.bb` file
7. ✅ commit with "🌊⚡ ported [script] from babashka to steel"

## 📝 migration tracking

### completed (7/225 = 3.1%)
1. n-kg-go.scm
2. qb-kk.scm
3. draw.scm
4. graincard-generator.scm
5. grain-phi-vortex.scm
6. lowercase-files.scm
7. graintime.scm

### in progress (0)
(none currently)

### blocked (0)
(none currently)

### deferred for evaluation (218)
all remaining babashka scripts need evaluation

## 🎬 next steps

1. **immediate**: move grainbarrel to teamtreasure02
2. **this week**: audit all grainbarrel scripts, decide port vs delete
3. **this month**: port remaining core utilities to steel
4. **q1 12025**: evaluate team-specific tools
5. **q2 12025**: clean up legacy and personal workspace

## 🤔 questions to answer

1. do we still need graindaemon? can it be steel?
2. are the framework16 scripts still useful? (personal workspace)
3. what's the status of graincourse build/deploy? still in use?
4. can we consolidate duplicate scripts across teams?
5. should we keep any babashka for backwards compatibility?

## 🌊⚡ philosophy

we're moving to **pure rust+steel stack** because:
- **simplicity**: one scripting language, not two
- **power**: steel has access to rust ecosystem
- **elegance**: steel's syntax is beautiful
- **teaching**: steel scripts teach through comments
- **performance**: compiled rust > interpreted clojure

babashka served us well! but steel is the future. 🌾

---

**now == next + 1** 🌾





