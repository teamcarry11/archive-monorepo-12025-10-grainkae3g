# Temporal Archive Plan - Complete Git History Organization

**Date**: 2025-10-26  
**Priority**: #1 Chart Course  
**Team**: teamabsorb14 (Ketu, descent wisdom, documentation)

---

## The Vision

**Goal**: Archive ALL markdown files from entire Git history with graintime prefixes

**Structure**:
```
teamabsorb14/temporal-archive/
├── 12025-10-26/
│   ├── 12025-10-26--0900-PST--GRAINBARREL-KETOS-ARCHITECTURE.md
│   ├── 12025-10-26--1015-PST--grainorder-core.clj.md
│   ├── 12025-10-26--1130-PST--seb-alex-vegan-advocacy.md
│   └── ... (all files from today)
├── 12025-10-25/
│   └── ... (files from Oct 25)
├── 12025-10-24/
│   └── ... (files from Oct 24)
└── ... (back through entire history)
```

**Immutability**: Original files stay in place, copies go to archive

---

## Phase 1: Current Session (gkh)

**Files to archive** (~20 files from today):

### **Personal Notes** (7 files):
1. seb-alex-animal-rights-vegan-advocacy.md
2. claudia-kuper-vegan-animal-rescue.md
3. mag-vegan-artist-activist-discord.md
4. besties-vegan-paradise-veggie-awards.md
5. happycow-vegan-commerce-strategy.md
6. clipse-pusha-t-malice-let-god-sort-em-out.md
7. ty-dolla-sign-collaboration-artistry.md

### **Architecture Docs** (5 files):
8. GRAINBARREL-KETOS-ARCHITECTURE.md
9. UNIVERSAL-PACKAGE-ABSTRACTION.md
10. GRAINORDER-SPEC.md
11. CHARTCOURSE-RANGE-CALCULATION.md
12. GRAINTIME-ASCENDANT-DEBUG.md

### **Session Docs** (3 files):
13. gkh-chartcourse-ketos-vision-session.md
14. gkh-ARE-WE-ON-TRACK.md
15. GRAIN-NETWORK-DIRECTORY.md

### **Ketos Synthesis** (2 files):
16. KETOS-VISION-SYNTHESIS/INDEX.md
17. KETOS-VISION-SYNTHESIS/xbd-team14-ketos-descent-philosophy.md

### **Code/Specs** (3 files):
18. grainorder/src/grainorder/core.clj
19. grainbranch/src/grainbranch/validator.clj
20. grainpersona/GLOW-PERSONA-V2.md

**Timestamp format**: `12025-10-26--HHMM-PST--{original-filename}`

---

## Phase 2: Full Git History

**Process**:
```bash
# For each commit in git history
git log --all --format='%H %ci' | while read hash date time tz; do
  # Extract date (YYYY-MM-DD format)
  folder_date=$(echo $date | tr - -)
  
  # Find all .md files changed in that commit
  git show --name-only --format="" $hash | grep '\.md$' | while read file; do
    # Copy to temporal archive with graintime prefix
    timestamp="${date}--${time%:*}-${tz}"
    cp "$file" "teamabsorb14/temporal-archive/${folder_date}/${timestamp}--$(basename $file)"
  done
done
```

**Estimated**: 500-1000+ markdown files across all commits

---

## Phase 3: External Repos (40+ repos!)

**Repos to clone and archive**:

### **High Priority** (active development):
1. foolsgoldtoshi-star/foolsgoldtoshi-star-pond-highdesert
2. kae3g/12025-10
3. kae3g/unicornkoalas
4. kae3g/kae3g-young-jupiter--12025-10-01--learning-curriculum

### **Medium Priority** (recent projects):
5. mantraOS
6. JingxinOS (静心OS)
7. snow-druid
8. generate-for-read-on-kindle
9. ronin-compiler
10. risc-love-tutorial

### **Lower Priority** (older/experimental):
11-40. (All other repos from the list)

**Process for each**:
```bash
# Clone repo
git clone https://github.com/kae3g/{repo}

# Archive all .md files with their commit timestamps
cd {repo}
git log --all --name-only --format='%H %ci' | grep '\.md$' | while read ...; do
  # Copy to teamabsorb14/temporal-archive/external/{repo}/{date}/
done
```

---

## Implementation Strategy

### **Step 1: Create Archive Script** (This session)

**File**: `teamabsorb14/temporal-archive/scripts/archive-session.clj`

**Functions**:
1. `get-file-last-commit-time` - Get timestamp of last edit
2. `format-graintime-prefix` - Create 12025-10-DD--HHMM-PST prefix
3. `copy-with-timestamp` - Copy file with graintime prefix
4. `archive-session-files` - Archive all files from current session
5. `archive-git-history` - Archive all .md from full git history
6. `archive-external-repo` - Clone and archive external repo

---

### **Step 2: Archive Current Session** (Today)

**Target**: ~/temporal-archive/12025-10-26/

**Files**: 20+ from gkh session

**Time estimate**: 30 minutes (manual, first iteration)

---

### **Step 3: Archive Git History** (This weekend)

**Target**: ~/temporal-archive/12025-10-{01-26}/

**Files**: 500-1000+ from all commits

**Time estimate**: 1-2 hours (automated script)

---

### **Step 4: Clone External Repos** (Next week)

**Target**: ~/temporal-archive/external/{repo}/12025-{MM-DD}/

**Repos**: 40+ repos

**Time estimate**: 4-6 hours (cloning, processing, organizing)

---

### **Step 5: Cleanup Plan** (Following week)

**Actions**:
1. Identify duplicate content across repos
2. Mark repos for archival/deletion
3. Consolidate into grainkae3g or grain06pbc
4. Create deprecation notices

---

## Why This Matters

**Current problem**:
- Files scattered (personal-notes/, grainstore/, docs/, etc.)
- No temporal view (when was each doc written?)
- No cross-repo visibility (what exists in 12025-10 vs grainkae3g?)
- Hard to see evolution (how did thinking change over time?)

**After temporal archive**:
- ✅ All files in one place (teamabsorb14/temporal-archive/)
- ✅ Chronological organization (12025-10-26/, 12025-10-25/, etc.)
- ✅ Graintime prefixes (know EXACTLY when each file was edited)
- ✅ Easy to trace evolution (read folder by folder, day by day)

**Ketu wisdom** (team14): Descent into the past to understand the present

---

## Challenges

### **Challenge 1: File Conflicts**

**Problem**: Same filename in multiple commits (e.g., README.md)

**Solution**: Graintime prefix makes each unique
- `12025-10-26--0900-PST--README.md`
- `12025-10-25--1500-PST--README.md`
- Both can coexist in same folder!

---

### **Challenge 2: Binary Files**

**Problem**: Git has images, binaries, not just markdown

**Solution**: Archive ONLY .md files (skip binaries for now)

**Future**: Could archive .clj, .rs, .nix later (separate folders)

---

### **Challenge 3: Large Repos**

**Problem**: Some repos have 1000+ commits (long history)

**Solution**: 
- Process in batches (10 commits at a time)
- Show progress (commit 100/1000...)
- Can interrupt and resume

---

### **Challenge 4: Disk Space**

**Problem**: Duplicating ALL files = lots of disk usage

**Solution**:
- Calculate size first (git log --stat)
- Markdown is small (~1KB-100KB per file)
- Estimate: 1000 files × 50KB avg = 50MB (manageable!)

---

## Expected Outcomes

### **After Phase 1** (Current session):
```
temporal-archive/12025-10-26/
├── 12025-10-26--0900-PST--GRAINBARREL-KETOS-ARCHITECTURE.md
├── 12025-10-26--1015-PST--grainorder-core-clj.md
├── 12025-10-26--1130-PST--seb-alex-vegan-advocacy.md
└── ... (20 files)
```

**Benefit**: See today's flow chronologically

---

### **After Phase 2** (Full history):
```
temporal-archive/
├── 12025-10-26/ (20 files)
├── 12025-10-25/ (35 files)
├── 12025-10-24/ (18 files)
├── 12025-10-23/ (Session 810: 40+ files)
└── ... (back to first commit)
```

**Benefit**: Complete grainkae3g evolution visible

---

### **After Phase 3** (External repos):
```
temporal-archive/external/
├── 12025-10/ (from kae3g/12025-10 repo)
├── foolsgoldtoshi-star/ (constitutional sovereignty docs)
├── mantraOS/ (mindful computing)
├── JingxinOS/ (heart-mirror OS)
└── ... (40+ repos)
```

**Benefit**: See ALL your work in one unified temporal view

---

### **After Phase 4** (Cleanup):

**GitHub account**:
- 40+ repos → 10-15 core repos (deduplicated)
- Archived repos moved to grainkae3g/temporal-archive/
- Clear deprecation notices (redirect to grainkae3g)

---

## Next Actions

**Right now** (next 30 min):
1. Write `archive-session.clj` script
2. Get last commit times for today's 20 files
3. Copy to `12025-10-26/` with graintime prefixes

**This weekend** (2-3 hours):
1. Write `archive-git-history.clj` script
2. Process all commits from grainkae3g history
3. Organize into `12025-MM-DD/` folders

**Next week** (4-6 hours):
1. Clone 40+ external repos
2. Process their markdown files
3. Organize into `external/{repo}/12025-MM-DD/`

**Following week** (planning):
1. Analyze for duplicates
2. Create GitHub cleanup plan
3. Deprecate/archive old repos

---

🌾 **now == next + 1**

**This is Ketu work (team14): Descent into history to gain wisdom for the future.**

