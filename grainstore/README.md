# Grainstore: Verified Dependencies & Submodules

**Graintime**: `12025-10-27--0145--PDT--moon-p_ashadha----asc-leo023--sun-03h--teamabsorb14`  
**Grainbranch**: `glow-g2-kae3gcursor`

Hey! Welcome to the Grainstore. What is this place? Think of it as a curated library—every dependency here is open-source, verified, and built to last. We're not just collecting code; we're building a foundation you can trust and learn from. Does that make sense?

---

## 🌾 **PHILOSOPHY**

> *"From granules to grains to THE WHOLE GRAIN"*  
> *"Chaos coming out from outside calmly so it's feeling new and what's inside is staying really solid watching observing"*

Why does the Grainstore exist? What principles guide it? Let me walk you through:

**Transparency** - Every line of code here is open-source and auditable. You can see how it works, verify it yourself, and trust what you're building on. No black boxes.

**Sustainability** - We focus on tools that will last. Long-term maintainability matters more than trendy frameworks. Would you rather build on shifting sand or solid rock?

**Security** - All licenses are verified. All practices are vetted. We protect your work by choosing dependencies carefully.

**Education** - Each module teaches. You're not just using these tools—you're learning from them. The code itself is a teacher.

**Pure Rust+Steel Stack** - We've moved from Babashka/Clojure to Steel (a Rust-embedded Scheme). Why? Rust gives us safety and speed. Steel gives us Lisp's elegance. Together, they're powerful and teachable.

**Template/Personal Split** - Share defaults, preserve customization. Templates live in `grain06pbc`, personal implementations live in team grainstores.

**Real Resources Matter** - Our crypto philosophy: value should be backed by real hardware, electricity, and human labor. Digital scarcity means nothing without physical grounding.

---

## 📦 **MODULES**

### **Core Libraries**

#### **clojure-s6**
S6 supervision suite bindings for Clojure
- **Path**: `grainstore/clojure-s6/`
- **License**: MIT
- **Purpose**: Process supervision and service management
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/clojure-s6

#### **clojure-sixos**
SixOS integration and file system watching
- **Path**: `grainstore/clojure-sixos/`
- **License**: MIT
- **Purpose**: System-level integration, file watching, typo-catching
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/clojure-sixos

#### **clojure-icp**
Internet Computer Protocol (ICP/DFINITY) integration
- **Path**: `grainstore/clojure-icp/`
- **License**: MIT
- **Purpose**: ICP canister interaction, identity management
- **Aliases**: `clojure-dfinity`
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/clojure-icp

#### **clojure-google-drive-mcp**
Google Drive Model Context Protocol bindings
- **Path**: `grainstore/clojure-google-drive-mcp/`
- **License**: MIT
- **Purpose**: Google Drive API integration via MCP
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/clojure-google-drive-mcp

---

### **Transpilers & Compilers**

#### **steeltoko** (Future)
Steel-to-Motoko transpiler for ICP canisters
- **Path**: `grainstore/steeltoko/` (planned)
- **License**: MIT
- **Purpose**: Transpile Steel (Rust Scheme) to Motoko for ICP canister deployment
- **Status**: Design phase (future priority)
- **Replaces**: `clotoko` (Clojure → Motoko)
- **Why Steel?**: Pure Rust+Steel stack, embeddable, actively maintained
- **Repository**: https://github.com/grainpbc/steeltoko (planned)

---

### **Package Management**

#### **grainclay**
Networked rolling release package manager
- **Path**: `grainstore/grainclay/`
- **License**: MIT
- **Purpose**: Immutable versioning, Clay filesystem, package distribution
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/grainclay

#### **grainconv**
Universal type conversion system
- **Path**: `grainstore/grainconv/`
- **License**: MIT
- **Purpose**: Convert between file formats, Grainmarks, media types
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/grainconv

---

###  **Applications**

#### **grainweb**
Browser + Git explorer + Cursor/OpenAI Atlas alternative
- **Path**: `grainstore/grainweb/`
- **License**: MIT
- **Purpose**: Decentralized web client with Nostr, ICP, Urbit integration
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/grainweb

#### **grainmusic**
Decentralized music streaming platform
- **Path**: `grainstore/grainmusic/`
- **License**: MIT
- **Purpose**: Solana Audius integration, ICP payments, Phantom wallet
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/grainmusic

#### **grainspace**
Unified decentralized platform (grainstore + App Store + gallery)
- **Path**: `grainstore/grainspace/`
- **License**: MIT
- **Purpose**: Multi-platform deployment, Urbit identity integration
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/grainspace

#### **graindrive**
Google Drive collaboration system
- **Path**: `grainstore/graindrive/`
- **License**: MIT
- **Purpose**: Real-time collaborative editing with Humble UI
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/graindrive

---

### **Hardware**

#### **grainwriter**
RAM-only e-ink writing device
- **Path**: `grainstore/grainwriter/`
- **License**: CERN OHL v2
- **Purpose**: Open-hardware writing device with infinite battery life
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/grainwriter

#### **graindroid**
Open-hardware Android phone (Grainphone)
- **Path**: `grainstore/graindroid/`
- **License**: CERN OHL v2
- **Purpose**: Dual-display (OLED + E-ink) repairable Android phone
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/graindroid

#### **graincamera**
Open-hardware camera with native AVIF support
- **Path**: `grainstore/graincamera/`
- **License**: CERN OHL v2
- **Purpose**: Photography with open formats and full control
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/graincamera

#### **grainpack**
External GPU jetpack attachment for Grainwriter
- **Path**: `grainstore/grainpack/`
- **License**: CERN OHL v2
- **Purpose**: Refurbished AMD GPU in recyclable drop/water-resistant case
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/grainpack

---

### **Infrastructure**

#### **grain-metatypes**
Foundational type definitions (Marks, Grainframes)
- **Path**: `grainstore/grain-metatypes/`
- **License**: MIT
- **Purpose**: Type system, Mark definitions, Grainframe specs
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/grain-metatypes

#### **grainneovedic**
Neovedic timestamp system
- **Path**: `grainstore/grainneovedic/`
- **License**: MIT
- **Purpose**: Holocene calendar + Vedic nakshatras timestamps
- **Aliases**: `neovedic-timestamp`
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/grainneovedic

#### **grainsource**
Git-compatible decentralized version control
- **Path**: `grainstore/grainsource/`
- **License**: GPL v2
- **Purpose**: Alternative to Git with Grain Network integration
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/grainsource

---

### **Operating Systems**

#### **grainnixos-qemu-within-ubuntu-24-04-lts-for-framework-16-laptop**
NixOS QEMU virtualization template
- **Path**: `grainstore/grainnixos-qemu.../`
- **License**: MIT
- **Purpose**: NixOS development environment within Ubuntu host
- **Status**: Design phase
- **Repository**: https://github.com/grainpbc/grainnixos-qemu-within-ubuntu-24-04-lts-for-framework-16-laptop

---

### **Organization**

#### **grainpbc**
Public Benefit Corporation documentation
- **Path**: `grainstore/grainpbc/`
- **License**: CC BY-SA 4.0
- **Purpose**: Business plans, legal framework, branding, press materials
- **Status**: Active development
- **Repository**: https://github.com/grainpbc/grainpbc

---

## 🔧 **GRAINSTORE MANAGEMENT**

### **Adding Dependencies**

How do we manage all these dependencies? With Steel scripts! Every module is tracked, versioned, and verified through automation.

#### **grainstore.scm** (Steel Configuration)
```scheme
;; Grainstore module registry
;; Written in Steel - our Rust-embedded Scheme

(define modules
  (hash
    "clojure-s6" (hash
      "repo" "https://github.com/grainpbc/clojure-s6"
      "path" "grainstore/clojure-s6"
      "license" "MIT")
    "clojure-sixos" (hash
      "repo" "https://github.com/grainpbc/clojure-sixos"
      "path" "grainstore/clojure-sixos"
      "license" "MIT")
    ;; ... more modules
  ))
```

### **Steel Scripts** (Replacing Babashka)

We're migrating from Babashka to Steel. Why? Steel is embedded in Rust, actively maintained, and gives us a pure Rust+Lisp stack. Here's what's coming:

```bash
# Load all grainstore modules (future)
steel grainstore-load.scm

# Update all modules (future)
steel grainstore-update.scm

# Verify licenses (future)
steel grainstore-verify.scm

# List all modules (future)
steel grainstore-list.scm
```

**Note**: These scripts are in development. The old `bb` commands still work during the transition.

---

## 📊 **DEPENDENCY GRAPH**

```
grainkae3g (root)
├── grainstore/
│   ├── clojure-s6                    (daemon management)
│   │   └── used by: clojure-sixos, graindrive, grainweb
│   │
│   ├── clojure-sixos                 (file watching, typo-catching)
│   │   ├── depends on: clojure-s6
│   │   └── used by: graindrive, grainweb, grainclay
│   │
│   ├── clojure-icp                   (ICP integration)
│   │   └── used by: grainweb, grainmusic, grainspace
│   │
│   ├── clojure-google-drive-mcp      (Google Drive API)
│   │   └── used by: graindrive
│   │
│   ├── steeltoko (future)            (Steel→Motoko)
│   │   ├── depends on: clojure-icp
│   │   └── used by: grainweb, grainmusic (planned)
│   │
│   ├── grainclay                     (package manager)
│   │   ├── depends on: clojure-sixos, grain-metatypes
│   │   └── used by: graindrive, grainweb, grainsource
│   │
│   ├── grainconv                     (type conversion)
│   │   ├── depends on: grain-metatypes
│   │   └── used by: grainweb, grainmusic
│   │
│   ├── grainweb                      (web client)
│   │   ├── depends on: clojure-s6, clojure-sixos, clojure-icp
│   │   │              steeltoko (future), grainclay, grain-metatypes
│   │   └── standalone app
│   │
│   ├── grainmusic                    (music platform)
│   │   ├── depends on: clojure-icp, steeltoko (future), grain-metatypes
│   │   └── standalone app
│   │
│   ├── grainspace                    (unified platform)
│   │   ├── depends on: clojure-icp, grainweb, grainmusic
│   │   └── standalone app
│   │
│   ├── graindrive                    (Google Drive collaboration)
│   │   ├── depends on: clojure-s6, clojure-sixos, grainclay
│   │   │              clojure-google-drive-mcp, grain-metatypes
│   │   └── standalone app
│   │
│   ├── grain-metatypes               (type definitions)
│   │   └── used by: all modules
│   │
│   ├── grainneovedic                 (timestamps)
│   │   └── used by: all modules
│   │
│   └── [hardware, infrastructure, org modules]
```

---

## 🔒 **LICENSE VERIFICATION**

All Grainstore modules have been verified for permissive, allowing licenses:

### **Software Licenses**
- **MIT**: clojure-s6, clojure-sixos, clojure-icp, clojure-google-drive-mcp, steeltoko (future), grainclay, grainconv, grainweb, grainmusic, grainspace, graindrive, grain-metatypes, grainneovedic
- **GPL v2**: grainsource (Git compatibility)
- **CC BY-SA 4.0**: grainpbc (documentation)

**Note**: We're migrating from Babashka/Clojure to Steel (Rust-embedded Scheme) for all scripting. Clojure libraries remain for specific integrations (s6, ICP, Google Drive).

### **Hardware Licenses**
- **CERN OHL v2**: grainwriter, graindroid, graincamera, grainpack

All licenses allow:
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use

---

## 📚 **DOCUMENTATION**

Each module contains:
- `README.md` - Overview and quick start
- `docs/` - Comprehensive documentation
- `examples/` - Usage examples
- `API.md` - API reference (if applicable)

---

## 🧪 **TESTING**

How do we know the code works? We test it! Here's how:

```bash
# Run all Grainstore tests (transitioning to Steel)
steel test-all.scm

# Test specific module (future)
steel test-module.scm clojure-s6

# Integration tests (future)
steel test-integration.scm

# Coverage report (future)
steel test-coverage.scm
```

**Note**: These Steel test scripts are in development. Current tests still use Babashka during the migration period.

---

## 🚀 **DEPLOYMENT**

### **Multi-Platform Targets**

Where can you deploy Grainstore modules? Almost anywhere! Here's the list:

- **Linux**: Nix, APT (Ubuntu/Debian), Pacman (Arch), Homebrew (Linuxbrew), Alpine APK (preferred!)
- **macOS**: Homebrew, Nix
- **Android**: Graindroid Phone (our open-hardware device)
- **iOS**: Planned for future
- **Web**: SvelteKit (our choice), Clojure frameworks
- **ICP**: Canisters via `steeltoko` (Steel→Motoko transpiler, future)
- **Redox OS**: Pure Rust OS with Steel scripting support!

**Why Alpine?** We love Alpine Linux for its small footprint, musl libc, and security. When building packages, Alpine APK gets priority.

---

## 🔄 **SYNC & UPDATE STRATEGY**

### **Upstream Sync**

How do we stay up to date with all these dependencies? With Steel automation!

```bash
# Pull latest changes from all upstream repositories (future)
steel grainstore-sync.scm

# What happens when you run this?
# 1. Fetches from all upstream repos
# 2. Checks for conflicts
# 3. Updates local modules
# 4. Verifies licenses
# 5. Runs tests
# 6. Updates grainstore.scm configuration
```

### **Conflict Resolution**

What happens when two versions clash? We handle it gracefully:
- Auto-merge when changes are compatible
- Request your review when there are real conflicts
- Grainclay (our package manager) preserves all versions - you can always roll back!

Think of it like Git, where every version of every dependency is tracked and recoverable.

---

## 🌾 **GRAIN NETWORK INTEGRATION**

The Grainstore is the foundation of the Grain Network's:
1. **High School Course**: All modules used as teaching examples
2. **UIUC Club**: Real-world projects using Grainstore modules
3. **Grain PBC**: Business applications built on Grainstore
4. **Hardware Projects**: Grainwriter, Grainphone, Graincamera
5. **Educational Platform**: Learning by building with open-source

---

## 📖 **CONTRIBUTING**

Want to contribute? We'd love that! Here's how to get started:

See individual module READMEs for specific contribution guidelines. But here are some universal principles:

**Code Style** - Match the style you see in the existing code. Consistency helps everyone read and understand faster.

**Testing** - Add tests for new features. If you're fixing a bug, add a test that would have caught it. Future you (and everyone else) will thank you!

**Documentation** - Update docs when you change behavior. Good documentation teaches the next person who reads your code.

**Timestamps** - Use graintime format for commits (includes nakshatras, ascendant, house placement). This helps us track when and where changes happened in cosmic time.

**Signatures** - Sign your commits with a GPG key. This verifies you really made that commit. Security matters!

---

## 🔗 **LINKS**

- **Organization**: https://github.com/grainpbc
- **Website**: https://grain.network (planned)
- **Documentation**: https://kae3g.github.io/grainkae3g/
- **Codeberg Mirror**: https://kae3g.codeberg.page/grainkae3g/

---

---

**The Grainstore: Building the future with verified, open-source modules.** 🌾

Every dependency matters. Every module teaches. Every line of code is a choice to build something that lasts.

Thank you for being here.

---

*Created: 12025-10-22--1600--CDT--moon-vishakha--09thhouse16--kae3g*  
*Updated: 12025-10-27--0145--PDT--moon-p_ashadha----asc-leo023--sun-03h--teamabsorb14*  
*License: CC BY-SA 4.0*  
*Voice: Glow G2 (patient teacher, first principles)*  
*Part of the Grain Network ecosystem*

now == next + 1 🌾
