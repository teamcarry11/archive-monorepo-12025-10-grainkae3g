# Steel Migration TODO

**Created**: `12025-10-27--1831--PDT--moon-p_ashadha----asc-libr013--sun-08h--teamabsorb14`  
**Voice**: Glow G2  
**Goal**: Replace ALL Babashka (.bb) and Ketos references with Steel (.scm)

---

## 🎯 STRATEGY

### Phase 1: Core Validators (DONE ✅)
- [x] `check-grain-width.scm` - Unicode display width
- [x] `check-grain-lines.scm` - 110-line validation
- [x] `grainbranch-readme-sync.scm` - Symlink automation

### Phase 2: Documentation (IN PROGRESS)
- [x] `grainstore/README.md` - Steel references
- [x] Grain files - Updated to Steel syntax
- [ ] `bb.edn` - Note Steel migration
- [ ] All README files mentioning Babashka

### Phase 3: Critical Scripts (HIGH PRIORITY)
Replace these 15 most-used scripts first:

#### Team 04 (teamplay04) - Build/Deployment
- [ ] `grainbarrel/scripts/grainbranch-readme-sync.bb` → `.scm` ✅ (DONE)
- [ ] `grainbarrel/scripts/graincard-generator.bb` → `.scm`
- [ ] `grainbarrel/scripts/fix-writings-links.bb` → `.scm`
- [ ] `graindaemon/src/graindaemon/grainbranch-manager.bb` → `.scm`
- [ ] `graindaemon/src/graindaemon/github-description-sync.bb` → `.scm`

#### Team 01 (teambright01) - Core Utilities
- [ ] `grainbarrel/scripts/n-kg-go.bb` → `.scm` (k ng go!)
- [ ] `grainbarrel/scripts/qb-kk-grainbook.bb` → `.scm` (kk command)
- [ ] `grainbarrel/scripts/draw.bb` → `.scm` (ASCII art)
- [ ] `grainbarrel/scripts/grainconfig-graintime.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainconfig-grainsync.bb` → `.scm`

#### Team 10 (teamrebel10) - Time & Validation
- [ ] `graintime/scripts/set-default-grainbranch.bb` → `.scm`
- [ ] `graincard-spec/src/graincard-validator.bb` → `.scm`
- [ ] `grainbranch/set-grain-urls.bb` → `.scm`

#### Team 09 (teamquest09) - Course Management
- [ ] `graincourse/template/scripts/build-course.bb` → `.scm`
- [ ] `graincourse/template/scripts/deploy-github.bb` → `.scm`

###Phase 4: Specialized Scripts (MEDIUM PRIORITY)
Convert these 30 domain-specific scripts:

#### Display & Mode (Team 05)
- [ ] `graindisplay/apply-theme.bb` → `.scm`
- [ ] `graindisplay/scripts/set-scaling.bb` → `.scm`
- [ ] `graindisplay/scripts/display-info.bb` → `.scm`
- [ ] `grainmode/src/grainmode/core.bb` → `.scm`

#### Clay & Config (Team 02)
- [ ] `grainclay/scripts/grainclay-flow.bb` → `.scm`
- [ ] `grainclay/scripts/grainclay-config-update.bb` → `.scm`
- [ ] `grainconfig/scripts/grainconfig-grainsync.bb` → `.scm`
- [ ] `grainconfig/scripts/grainconfig-graintime.bb` → `.scm`

#### Env & Validation (Team 06)
- [ ] `grainenvvars/template/grainenvvars-validator.bb` → `.scm`
- [ ] `grainbranch-linker/grainbranch-linker.bb` → `.scm`

#### Transform (Team 08)
- [ ] `grainsynonym/src/grainsynonym/core.bb` → `.scm`

#### Time & Tests (Team 10)
- [ ] `graintime/parse-astroccult.bb` → `.scm`
- [ ] `graintime/test/run_tests.bb` → `.scm`

#### Vegan & Audit (Team 10)
- [ ] `grainsource-vegan/vegan-audit.bb` → `.scm`

#### Aspirational (Team 14)
- [ ] `aspirational-pseudo/scripts/configure-personal-preferences.bb` → `.scm`
- [ ] `aspirational-pseudo/scripts/generate-personalized-grainclay.bb` → `.scm`

### Phase 5: Helper Scripts (LOWER PRIORITY)
Convert these 28 utility scripts:

#### QB Commands
- [ ] `qb/scripts/course-sync-personal.bb` → `.scm`
- [ ] `qb/scripts/test-npm-equivalence.bb` → `.scm`
- [ ] `qb-now/scripts/qb-now.bb` → `.scm`

#### Grainbarrel Utilities
- [ ] `grainbarrel/scripts/qb-shot.bb` → `.scm`
- [ ] `grainbarrel/scripts/qb-path-flow-cleaning-re.bb` → `.scm`
- [ ] `grainbarrel/scripts/plz-glow.bb` → `.scm`
- [ ] `grainbarrel/scripts/plz-trish.bb` → `.scm`
- [ ] `grainbarrel/scripts/plz-trish-SOLAR-HOUSE-EDUCATION.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainai-vocab-guidelines.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainlexicon-synonyms.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainsync-course-new.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainstore-stats.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainstore-generate-docs.bb` → `.scm`
- [ ] `grainbarrel/scripts/grainstore-validate.bb` → `.scm`
- [ ] `grainbarrel/scripts/test-github-description.bb` → `.scm`
- [ ] `grainbarrel/scripts/setup-github-token.bb` → `.scm`

#### Graincourse Setup
- [ ] `graincourse/symlinks/setup-symlinks.bb` → `.scm`
- [ ] `graincourse/template/scripts/setup-reminder.bb` → `.scm`
- [ ] `graincourse/template/scripts/create-course.bb` → `.scm`
- [ ] `graincourse/template/scripts/deploy-codeberg.bb` → `.scm`

#### Display & Night Light
- [ ] `graindisplay/scripts/gnome-warm-direct.bb` → `.scm`
- [ ] `graindisplay/scripts/build-simple.bb` → `.scm`
- [ ] `graindisplay/scripts/build-appimage.bb` → `.scm`
- [ ] `graindisplay/scripts/create-grainmark-with-metadata.bb` → `.scm`
- [ ] `grain-nightlight/scripts/install-systemd.bb` → `.scm`
- [ ] `grain-nightlight/scripts/diagnose.bb` → `.scm`
- [ ] `grain-nightlight/scripts/enable-on-boot.bb` → `.scm`

#### Misc Utilities
- [ ] `grainkey/scripts/grainkey.bb` → `.scm`
- [ ] `graintranscribe-youtube/scripts/transcribe-video.bb` → `.scm`
- [ ] `graintranscribe-youtube/scripts/config-validate.bb` → `.scm`
- [ ] `graintranscribe-youtube/scripts/config-setup.bb` → `.scm`
- [ ] `graindevname/check-username.bb` → `.scm`
- [ ] `grainsync/grainstore-sync.bb` → `.scm`
- [ ] `graindaemon/scripts/graindisplay-daemon.bb` → `.scm`
- [ ] `graindaemon/src/graindaemon/grainpath_sync.bb` → `.scm`
- [ ] `grainos-compatibility/src/grainos-compatibility/hosting-strategy.bb` → `.scm`
- [ ] `grain6/aspirational-recursive-batch-improve.bb` → `.scm`

---

## 📊 PROGRESS

**Total Scripts**: 73  
**Completed**: 3 (4%)  
**Remaining**: 70 (96%)

### By Priority:
- **Phase 1**: 3/3 (100%) ✅
- **Phase 2**: 2/4 (50%)
- **Phase 3**: 0/15 (0%)
- **Phase 4**: 0/30 (0%)
- **Phase 5**: 0/28 (0%)

---

## 🔧 MIGRATION PATTERN

For each `.bb` file:

1. **Read the Babashka code**
2. **Translate to Steel syntax**:
   - `(defn ...)` → `(define (fn args) ...)`
   - `{:key val}` → `(hash "key" val)`
   - `[let bindings]` → `[let ([x val]) ...]`
   - `sh` → `command`
   - `println` → `displayln`
3. **Test the Steel version**
4. **Update documentation**
5. **Delete the .bb file** (after confirmation)

---

## 🎯 NEXT STEPS

1. Start with Phase 3 (critical scripts)
2. Begin with `n-kg-go.bb` (you use it often!)
3. Test each conversion thoroughly
4. Update `bb.edn` with migration notes
5. Document learnings

---

**Why Steel over Babashka?**

Steel is actively maintained (2025), embeddable in Rust, supports Redox OS, has a package manager and LSP. Babashka requires Java/Clojure runtime. We're building a pure Rust+Steel stack!

---

now == next + 1 🌾

