# Grain Network Directory - All Projects & Locations

**Date**: 2025-10-26  
**Purpose**: Comprehensive directory of all Grain Network repositories, modules, and tools  
**Maintained**: team14 (descent/wisdom/documentation)

---

## GitHub Organizations

### **grain6pbc** (Template/Spec Organization)
- **URL**: https://github.com/grain6pbc
- **Purpose**: Public templates, specifications, base definitions
- **Type**: Public, shared, reusable
- **Location**: `grainstore/grain6pbc/` (local mirror)

### **chartcourse-io** (Personal/Implementation Organization)
- **URL**: https://github.com/chartcourse-io
- **Purpose**: Personalized implementations, custom configurations
- **Type**: Personal, customized
- **Domains**: chartcourse.io, chartcourse.net, chartcourse.org
- **Created**: 2025-10-25

### **kae3g** (Personal Development)
- **URL**: https://github.com/kae3g
- **Purpose**: Personal projects, experiments, development
- **Main Repo**: https://github.com/kae3g/grainkae3g
- **Type**: Personal workspace

---

## Core Repositories

### **grainkae3g** (Main Site & Documentation)
- **GitHub**: https://github.com/kae3g/grainkae3g
- **GitHub Pages**: https://kae3g.github.io/grainkae3g/
- **Codeberg**: https://codeberg.org/kae3g/grainkae3g
- **Codeberg Pages**: https://kae3g.codeberg.page/grainkae3g/
- **Local**: `/home/xy/kae3g/grainkae3g/`
- **Branch**: `ketos-vision-session--2025-10-26--1040--PST--moon-mula--asc-erro00--sun-03h--teamtransform08`
- **Purpose**: Main documentation site, essays, vision documents
- **Tech**: SvelteKit + Babashka build pipeline
- **CI/CD**: GitHub Actions → dual deploy (GitHub Pages + Codeberg Pages)

---

## Team-Organized Modules (14 Teams)

### **Team01 - teamfire01** (Aries ♈ / I. The Magician)
**Location**: `grainstore/grain6pbc/teamfire01/`

#### **grain6**
- **Path**: `teamfire01/grain6/`
- **Purpose**: Core Grain OS specification
- **Status**: Specification phase

#### **grainbarrel** (Original)
- **Path**: `teamfire01/grainbarrel/`
- **Purpose**: Original grainbarrel implementation (Babashka)
- **Status**: Active (transition to team04)
- **Key File**: `bb.edn` (382 lines, comprehensive task system)

#### **grainconfig**
- **Path**: `teamfire01/grainconfig/`
- **Purpose**: Configuration management
- **Status**: Active

---

### **Team02 - teamvault02** (Taurus ♉ / II. The High Priestess)
**Location**: `grainstore/grain6pbc/teamvault02/`

#### **grainclay**
- **Path**: `teamvault02/grainclay/`
- **Purpose**: Content structure and publishing
- **Status**: Active

#### **graindrive**
- **Path**: Not yet created
- **Purpose**: Encrypted storage, secrets management
- **Status**: Planned (TODO: deploy template)

---

### **Team03 - teamnetwork03** (Gemini ♊ / III. The Empress)
**Location**: `grainstore/grain6pbc/teamnetwork03/`

#### **grainp2p** (Planned)
- **Purpose**: P2P networking (IPFS + Urbit + Hypercore)
- **Status**: Specification phase
- **Tech**: Rust + Hoon integration

---

### **Team04 - teamnurture04** (Cancer ♋ / IV. The Emperor)
**Location**: `grainstore/grain6pbc/teamnurture04/`

#### **grainbarrel** (New Home)
- **Path**: `teamnurture04/grainbarrel/`
- **Purpose**: Build automation, deployment pipeline (Emperor/Foundation)
- **Status**: In progress (team04 assignment 2025-10-26)
- **Key Files**:
  - `bb.edn` (delegates to qb-now)
  - `README.md` (Emperor foundation philosophy)
- **Architecture Docs**:
  - `GRAINBARREL-KETOS-ARCHITECTURE.md` (740 lines)
  - `UNIVERSAL-PACKAGE-ABSTRACTION.md` (890 lines)
  - `PACKAGE-NAME-AVAILABILITY.md` (comprehensive)

#### **graincontacts**
- **Path**: `teamnurture04/graincontacts/`
- **Purpose**: Contact management (graincontacts)
- **Files**: `*.edn` (kae3g, foolsgoldtoshi-star, etc.)

#### **graindaemon**
- **Path**: `teamnurture04/graindaemon/`
- **Purpose**: Daemon/service management
- **Status**: Specification phase

#### **graintalent**
- **Path**: `teamnurture04/graintalent/`
- **Purpose**: Sovereign artist management (Taylor Swift case study)
- **Created**: 2025-10-25
- **Status**: Active documentation

---

### **Team05 - teamshine05** (Leo ♌ / V. The Hierophant)
**Location**: `grainstore/grain6pbc/teamshine05/`

#### **graindisplay**
- **Path**: `teamshine05/graindisplay/`
- **Purpose**: Display configuration, visual management
- **Status**: Active

#### **grain-nightlight**
- **Path**: `teamshine05/grain-nightlight/`
- **Purpose**: UI theming, dark mode, color schemes
- **Status**: Active

---

### **Team06 - teamprecision06** (Virgo ♍ / VI. The Lovers)
**Location**: `grainstore/grain6pbc/teamprecision06/`

#### **grainenvvars**
- **Path**: `teamprecision06/grainenvvars/`
- **Purpose**: Environment variable management
- **Created**: 2025-10-25
- **Key File**: `README.md` (Chanel Spring/Summer metaphors, security)

#### **grainzsh**
- **Path**: `teamprecision06/grainzsh/`
- **Purpose**: Zsh configuration, shell precision
- **Created**: 2025-10-25
- **Key File**: `README.md` (λ prompt specs, Fall/Winter aesthetic)

#### **grainchart**
- **Path**: `teamprecision06/grainchart/`
- **Purpose**: Navigation, chart course documentation
- **Created**: 2025-10-25
- **Key Files**:
  - `index.html` (Cursor Red theme, responsive)
  - `LVMH-INSPIRED-ARCHITECTURE.md` (14 teams as luxury brands)
  - `CHART-COURSE-INDEX.md` (569 lines, navigation)
- **GitHub Pages**: Deployed (pending URL)

#### **graindualwifi** ⭐ NEW!
- **Path**: `teamprecision06/graindualwifi/`
- **Purpose**: Dual-wifi failover daemon (Starlink + cellular)
- **Created**: 2025-10-26 (17:00 PDT)
- **Language**: **Ketos** (Rust Lisp) - First real Ketos program! 🎉
- **Target**: Ubuntu 24.04 LTS (Framework 16)
- **Key Files**:
  - `SPEC.md` (Complete technical specification, 410 lines)
  - `src/graindualwifi.ket` (Ketos program, ~200 lines)
  - `src/main.rs` (Rust entry point with stub mode)
  - `config/graindualwifi.edn` (Configuration)
  - `systemd/graindualwifi.service` (System daemon)
- **Philosophy**: VI. The Lovers - Choose wisely between two paths
- **Status**: Complete (needs Rust + Ketos to build)

#### **chartcourse**
- **Path**: `teamprecision06/chartcourse/`
- **Purpose**: New brand for precision navigation + education
- **Created**: 2025-10-25
- **Key Files**:
  - `TRINITY-HELEN-LEONARDO-ARIANA.md`
  - `DOMAIN-STRATEGY.md`
  - `PROFESSIONAL-PATH-TRINITY.md`

---

### **Team07 - teambalance07** (Libra ♎ / VII. The Chariot)
**Location**: `grainstore/grain6pbc/teambalance07/`

#### **clotoko**
- **Path**: `teambalance07/clotoko/`
- **Purpose**: Clojure + Motoko integration (ICP smart contracts)
- **Status**: Active development

#### **clotoko-icp**
- **Path**: `teambalance07/clotoko-icp/`
- **Purpose**: ICP canister deployment
- **Status**: Active (local dfx state tracked)

---

### **Team08 - teamtransform08** (Scorpio ♏ / VIII. Strength)
**Location**: `grainstore/grain6pbc/teamtransform08/`

**Status**: Directory exists, modules pending

---

### **Team09 - teamtruth09** (Sagittarius ♐ / IX. The Hermit)
**Location**: `grainstore/grain6pbc/teamtruth09/`

**Status**: Directory exists, modules pending

---

### **Team10 - teamstructure10** (Capricorn ♑ / X. Wheel of Fortune)
**Location**: `grainstore/grain6pbc/teamstructure10/`

#### **graintime** ⭐ MAJOR UPDATE (2025-10-26)
- **GitHub**: https://github.com/grain6pbc/teamstructure10/graintime
- **Path**: `teamstructure10/graintime/`
- **Purpose**: Vedic astrology graintime generator with triple-redundancy ascendant
- **Status**: **Active** (LST perfect, ascendant debugging)
- **Core Files**:
  - `src/graintime/generator.clj` (graintime generation, LST PERFECT ✅)
  - `src/graintime/format76.clj` (76-char format)
  - `src/graintime/solar_houses.clj` (diurnal sun houses ✅)
  - `src/graintime/sunset.clj` (solar time calculations ✅)
- **NEW Triple-Redundancy Ascendant** (2025-10-26):
  - `src/graintime/swiss_ephemeris_real.clj` (Method A: Professional-grade)
  - `src/graintime/ascendant_api.clj` (Method C: API fallback)
  - `src/graintime/ascendant_unified.clj` (Unified calculator)
  - `src/graintime/ascendant_houses.clj` (Method B: Manual formula)
  - `test/graintime/nakshatra_ascendant_tests.clj` (Comprehensive test suite)
- **Documentation** (2025-10-26):
  - `GRAINTIME-ALGORITHM-COMPLETE.md` (Complete specification)
  - `TRIPLE-REDUNDANCY-ASCENDANT.md` (Architecture)
  - `SESSION-SUMMARY-OCT26-2025.md` (Session notes)
- **Accuracy Status**:
  - LST: ✅ PERFECT (18.2051h matches astro-seek 18:12:18)
  - Diurnal Houses: ✅ WORKING (8th house at 17:00 PDT)
  - Ascendant: 🚧 Triple redundancy built, formula debugging
  - Moon Nakshatra: 🚧 Pending (Swiss Eph or API)

#### **grainbranch** ✨ NEW (2025-10-26)
- **Path**: `teamstructure10/grainbranch/`
- **Purpose**: Grainbranch name validation and formatting
- **Status**: **Active**
- **Key Files**:
  - `src/grainbranch/validator.clj` (300+ lines, comprehensive specs)
  - `bb.edn` (CLI tools: validate, format, format-quick)
  - `deps.edn` (Clojure dependencies)
- **Features**:
  - Enforces 19-char padding (title + moon-nakshatra)
  - Validates all graintime components (nakshatra, asc, sun, team)
  - Pre-commit hook support (prevents malformed branches)
  - CLI tools for formatting/validation
- **Usage**: `bb format-quick gkh chartcourse 12025-10-26 1048 PST mula erro 00 03 teamdescend14`

#### **grainpersona** ✨ NEW (2025-10-26)
- **Path**: `teamstructure10/grainpersona/`
- **Purpose**: AI persona specifications (Trish, Glow, others)
- **Status**: **Active**
- **Key Files**:
  - `GLOW-PERSONA-V2.md` (262 lines, updated persona)
- **Personas**:
  - **Glow V2**: Listening teacher, respectful, asks questions, hand-holding, Panthera-serious
  - **Trish**: Enthusiastic, encouraging, feminine energy (team06)
- **Philosophy**: Code comments should teach, not just describe

#### **grainsource-vegan**
- **Path**: `teamstructure10/grainsource-vegan/`
- **Purpose**: Vegan terminology, plant-based development
- **Status**: Active

---

### **Team11 - teamfuture11** (Aquarius ♒ / XI. Justice)
**Location**: `grainstore/grain6pbc/teamfuture11/`

**Status**: Directory exists, modules pending

---

### **Team12 - teamflow12** (Pisces ♓ / XII. The Hanged Man)
**Location**: `grainstore/grain6pbc/teamflow12/`

#### **grainflow**
- **Path**: `teamflow12/grainflow/`
- **Purpose**: Flow state management, build pipelines
- **Status**: Specification phase

#### **grain-metatypes**
- **Path**: `teamflow12/grain-metatypes/`
- **Purpose**: Type systems, meta-level abstractions
- **Status**: Documentation

#### **grainneovedic**
- **Path**: `teamflow12/grainneovedic/`
- **Purpose**: Vedic astrology integration
- **Status**: Documentation

#### **grainsource-separation**
- **Path**: `teamflow12/grainsource-separation/`
- **Purpose**: Template/personal separation patterns
- **Status**: Documentation

---

### **Team13 - teamascend13** (Aries ♈ / XIII. Death)
**Location**: `grainstore/grain6pbc/teamascend13/`

#### **grainorder** ✨ NEW (2025-10-26)
- **Path**: `teamascend13/grainorder/`
- **Purpose**: Universal alphabetical ordering system
- **Status**: **Active development**
- **Key Files**:
  - `GRAINORDER-SPEC.md` (comprehensive specification)
  - `deps.edn` (Clojure dependencies)
  - `src/grainorder/core.clj` (300+ lines)
- **Features**:
  - Configurable alphabets (`:xbdghk-alphabetical`, `:full-alphabet`, etc.)
  - Base-26 encoder/decoder
  - NO vowels, NO y (user preference)
  - NO repeated consonants in same string
  - Prefix system: `g` (chartcourse), `x` (Ketos), `y` (hidden), `z` (graincards)
- **Math**: 6 chars × 5 distinct = **30 permutations** (2-letter suffix)
- **TODO**: CLI tool, multi-platform deployment

---

### **Team14 - teamdescend14** (Pisces ♓ / XIV. Temperance)
**Location**: `grainstore/grain6pbc/teamdescend14/`

#### **Documentation Hub**
- **Path**: `teamdescend14/`
- **Purpose**: Descent wisdom, deep documentation, synthesis
- **Key Files**:
  - `GRAINOS-UNIFIED-SPEC.md` (322 lines)
  - `CLOUD-VS-LOCAL-ANALYSIS.md` (Augustinian framework)
  - `REDOX-DEPLOYMENT-QUESTIONS-ANSWERED.md`
  - `CLOJURE-RUNTIME-ANALYSIS.md`
  - `RUST-CLOJURE-RECONSIDERED.md`
  - `KK-KETOS-FAST.md` (Babashka analog for Ketos)
  - `KETOS-VS-CLOJURE-ANALYSIS.md` (479 lines)
  - `KETOS-CLOJURE-FEATURES-IMPLEMENTATION.md` (816 lines)
  - `CLOJURE-KETOS-LAYERING-STRATEGY.md` (543 lines)
  - `GRAINTIME-ASCENDANT-DEBUG.md` (288 lines) ✨ NEW
  - `NAMES-REFERENCE.md` (copied from docs/reference/)
  - `GRAIN-NETWORK-DIRECTORY.md` (THIS FILE) ✨ NEW

#### **Ketos Vision Synthesis** ✨ NEW (2025-10-26)
- **Path**: `teamdescend14/KETOS-VISION-SYNTHESIS/`
- **Purpose**: 14-part series, one doc per team, Ketos architecture alignment
- **Files**:
  - `INDEX.md` (navigation, cross-team connections)
  - `xaa-team14-ketos-descent-philosophy.md` (300+ lines) ✅
  - `xbc-xhb` (13 more docs, pending)
- **Order**: 14→12→06→08→04→10→02→03→11→07→09→05→01→13 (descent→ascent)

#### **Chartcourse Tracking** ✨ NEW (2025-10-26)
- **Path**: `teamdescend14/`
- **Purpose**: Chart course documentation (sorted above TODOs)
- **Files**:
  - `gbb-chartcourse-ketos-vision-session.md` (session summary) ✅
  - `gbd-*` (next chartcourse, pending)

---

## Cross-Team Modules

### **grainlib**
- **Path**: `grainstore/grain6pbc/grainlib/`
- **Purpose**: Shared libraries, common utilities
- **Status**: Active

### **grainsync**
- **Path**: `grainstore/grain6pbc/grainsync/`
- **Purpose**: Multi-repo synchronization
- **Status**: Active

### **qb** (Quick Build - being renamed to `gb`)
- **Path**: `grainstore/grain6pbc/qb/`
- **Purpose**: Quick build system (transitioning to grainbarrel/team04)
- **Status**: Legacy (being superseded by team04/grainbarrel)

### **qb-now**
- **Path**: `grainstore/grain6pbc/qb-now/`
- **Purpose**: Immediate build execution
- **Status**: Active (referenced by team04/grainbarrel)

### **graintranscribe-youtube**
- **Path**: `grainstore/grain6pbc/graintranscribe-youtube/`
- **Purpose**: YouTube transcription tools
- **Status**: Active

---

## Personal/Customized Modules

### **grainstore/kae3g/**
**Location**: `grainstore/kae3g/`

#### **grainkae3g-12025-10**
- **Path**: `kae3g/grainkae3g-12025-10/`
- **Purpose**: October 2025 session content
- **Status**: Archived/reference

#### **grainkae3gwifi**
- **Path**: `kae3g/grainkae3gwifi/`
- **Purpose**: WiFi configuration management
- **Status**: Active

#### **grainkae3g-icp-workspace**
- **Path**: `kae3g/grainkae3g-icp-workspace/`
- **Purpose**: ICP development workspace
- **Status**: Active

#### **grainkae3gsource-nixos-qemu-kvm**
- **Path**: `kae3g/grainkae3gsource-nixos-qemu-kvm/`
- **Purpose**: NixOS VM management
- **Status**: Specification

---

## Team-Personalized Modules

### **grainstore/teamstructure10/**
**Location**: `grainstore/teamstructure10/`

#### **grainteamstructure10mode**
- **Path**: `teamstructure10/grainteamstructure10mode/`
- **Purpose**: Team10-specific modes and configurations
- **Status**: Active

---

### **grainstore/teamprecision06/**
**Location**: `grainstore/teamprecision06/`

#### **grainteamprecision06mode**
- **Path**: `teamprecision06/grainteamprecision06mode/`
- **Purpose**: Team06-specific modes and configurations
- **Status**: Active

---

## External Dependencies & Mirrors

### **Urbit Source** (Team09 / Wisdom)
- **Path**: `grainstore/urbit-source/`
- **Purpose**: Urbit/Hoon source code reference
- **Origin**: https://github.com/urbit/urbit
- **Status**: Local mirror (813 .hoon files)
- **Note**: Marked as vendored in `.gitattributes` (linguist-vendored)

### **HumbleUI** (Team05 / Radiance)
- **Path**: `grainstore/HumbleUI-org/HumbleUI/`
- **Purpose**: Clojure UI framework reference
- **Origin**: https://github.com/HumbleUI/HumbleUI
- **Status**: Local mirror

---

## Documentation Locations

### **Main Docs**
- **Path**: `docs/`
- **Structure**:
  - `core/philosophy/PSEUDO.md` (project status, aspirations)
  - `reference/NAMES-REFERENCE.md` (people, inspirations)
  - `z-hidden-publish/` (9XXX series essays)

### **Personal Notes**
- **Path**: `personal-notes/`
- **Recent Files**:
  - `seb-alex-animal-rights-vegan-advocacy.md` (257 lines) ✨
  - `shell-strategy-qb-gb-nushell.md` (209 lines) ✨
  - `ye-cody-wyoming.md`
  - `writing-9001-pluta-wild-priestess.md`
  - `king-combs-never-stop-ep.md`
  - `kendrick-hiiipower.md`

### **Web App**
- **Path**: `web-app/`
- **Purpose**: SvelteKit site (grainkae3g front-end)
- **Status**: Active
- **Theme**: Cleveland Browns warm (2025-10-26)

---

## Build & Deployment

### **CI/CD**
- **File**: `.github/workflows/deploy.yml`
- **Purpose**: Automated deployment to GitHub Pages + Codeberg Pages
- **Triggers**: Push to `main` or `glow-calm-session*` branches
- **Process**:
  1. Setup Babashka
  2. Setup Node.js
  3. Install npm dependencies
  4. Build content with Babashka (`bb qb-now`)
  5. Build SvelteKit site
  6. Deploy to GitHub Pages

### **Build Tools**
- **Babashka**: `bb` command (delegated to `grainstore/grain6pbc/teamnurture04/grainbarrel/`)
- **Flow**: `bb flow "message"` (dual-deploy to GitHub + Codeberg)

---

## Package Deployment Roadmap

**Priority 1** (Core tooling):
1. **grainbarrel** - Build automation and deployment pipeline
2. **graintime** - Vedic astrology timestamp generator
3. **grainorder** - Universal alphabetical ordering system ✨ NEW

**Priority 2** (Development tools):
4. **graincursor** - Sovereign code editor (Redox OS target)
5. **grainp2p** - P2P networking daemon (IPFS + Urbit)
6. **graincrypto** - Multi-chain transaction manager (ICP, Hedera, Solana)

**Priority 3** (Infrastructure):
7. **grainsync** - Multi-repo git sync daemon
8. **grainwatch** - File system observer daemon
9. **grainbackup** - Encrypted backup to IPFS

**Target Package Managers**:
- ✅ Cargo (crates.io) - Rust packages
- ✅ Homebrew - macOS/Linux (formula)
- ✅ Nixpkgs - NixOS (derivation)
- ✅ Alpine APK - Alpine Linux (.apk)
- ⏳ Debian APT - Debian/Ubuntu (.deb)
- ⏳ Fedora DNF - Fedora/RHEL (.rpm)
- ⏳ Arch AUR - Arch Linux (PKGBUILD)

---

## Repository Patterns

### **Template vs Personal Separation**

**Template Side** (grain6pbc org):
- Location: `grainstore/grain6pbc/team[NAME]##/grain[concept]/`
- Contains: Specs, base definitions, schema, template docs
- Purpose: Shared, reusable, general-purpose
- Example: `grain6pbc/teamstructure10/graintime/` (graintime specs)

**Personal Side** (teamstructure10 org):
- Location: `grainstore/teamstructure10/grainteam[NAME]##[concept]/`
- Contains: Implementation, personal configs, extended functionality
- Purpose: Customized, specific, personalized
- Example: `teamstructure10/grainteamstructure10mode/` (personal mode configs)

**Flow**:
1. Create template in grain6pbc (specs + base)
2. Create personalized in team org grainstore (implementation + custom)
3. Template defines WHAT (specs, schemas, interfaces)
4. Personal defines HOW (implementation, configuration, extensions)
5. Both get separate grainbranches
6. Both deployed to their respective orgs

---

## Grainbranch System

**Current Branch**: 
```
ketos-vision-session--2025-10-26--1040--PST--moon-mula--asc-erro00--sun-03h--teamtransform08
```

**Format**:
```
[session-name]--YYYY-MM-DD--HHMM--TZ--moon-[nakshatra]--asc-[sign][deg]--sun-[house]--team[name]##
```

**Previous Branches**:
- `glow-calm-session--12025-10-26--0409-PDT--moon-mula--asc-gemi04-sun-03h--teamtransform08`
- `tundra` (main branch)

---

## External Integrations

### **Codeberg** (Git forge)
- **URL**: https://codeberg.org/kae3g/grainkae3g
- **Purpose**: Decentralized git hosting alternative
- **Pages**: https://kae3g.codeberg.page/grainkae3g/

### **GitHub** (Git forge)
- **URL**: https://github.com/kae3g/grainkae3g
- **Purpose**: Primary git hosting
- **Pages**: https://kae3g.github.io/grainkae3g/

---

## Future Repositories (Planned)

### **chartcourse-io Organization**
- **grainbarrel** - Build tool (Priority 1)
- **graintime** - Time tool (Priority 1)
- **grainorder** - Ordering system (Priority 1)
- **grain**** - Future grain modules

### **Redox OS Targets**
- All grain tools compiled for Redox OS (x86_64-unknown-redox)
- Ketos-based implementations (grainbarrel on kk)

---

## Quick Reference

**Main Development**:
- Local: `/home/xy/kae3g/grainkae3g/`
- GitHub: https://github.com/kae3g/grainkae3g
- Site: https://kae3g.github.io/grainkae3g/

**Organizations**:
- Templates: https://github.com/grain6pbc
- Personal: https://github.com/chartcourse-io (new!)

**Current Focus** (2025-10-26):
- grainorder (team13) - Universal ordering ✨
- Ketos Vision Synthesis (team14) - 14-part series
- Vegan advocacy research (Seb Alex, Al-Ma'arri)

---

🌾 **now == next + 1**

**Last Updated**: 2025-10-26 (Ketos Vision Session)

