# Jiang Xueqin-Inspired Predictive History Course: Zero to World-Saving ✧･ﾟ:*

**Course Title**: "Predictive History: Building Tools That Teach the Future"  
**Instructor**: kae3g (kj3x39, @risc.love)  
**Duration**: Full academic year  
**Goal**: Students build world-saving infrastructure from zero knowledge  
**End State**: Deployed Grain Network saving the world

---

## The Vision (Jiang Xueqin Style)

This isn't just a programming course. This is **Predictive History** - teaching students to read the patterns of the present, project the needs of the future, and build tools that address both.

Students start with zero knowledge. They end with deployed infrastructure that matters.

The journey mirrors **Pluta & Panthera's ascent**:
- **Wild** (ignorance, no structure)
- **Search** (learning, seeking patterns)
- **Western City** (small victories, first deployments)
- **Meltdown** (failure, realizing complexity)
- **Eastern Capital** (mastery, world-saving tools)

---

## Curriculum Structure

### TRIMESTER 1: Foundation (Wild → Search)

**Weeks 1-4: Introduction to Grain Philosophy**
- What is a grain? (one teaching card)
- Why 80×110? (constraint enables abundance)
- Graintime: understanding temporal encoding
- Grainscript: the language of grains
- The empty-folder pattern (symlinks)

**Weeks 5-8: First Deployments**
- Setting up local Ketos environment
- Writing first validator (10 lines of Ketos)
- Creating first 5 grains (xbdghj through xbdghl)
- Deploying to GitHub Pages
- First "it works!" moment

**Weeks 9-12: Pattern Recognition**
- The Lovers' choice: glibc vs musl
- Why s6? (process supervision)
- Building static binaries
- Cross-compilation magic

**End of Trimester 1**: Students have working deployments, understand constraints, can read graintime, know why 80×110 matters.

---

### TRIMESTER 2: Building Together (Search → Western City)

**Weeks 13-16: Grain Collaboration**
- Git workflow with grainbranching
- Session consolidation (moon cycles)
- Building toward 100 grains
- Team assignments (14 teams, distributed ownership)
- First "we're making something big" realization

**Weeks 17-20: Portable GrainOS**
- **ACCESSIBLE DEVICE PROJECT**: Building the "public library computer"
- Flash Tails OS to USB (32-128GB)
- Configure GrainOS environment via single boot script
- Persistent storage on encrypted USB
- ketos + s6 + musl = portable infrastructure

**The Accessible Device**:
- Single USB drive (USB 3.0 / USB-C)
- Optional C-to-A adapter for legacy computers
- Flash with Tails OS (Tor-enabled, private by default)
- Boot script installs: Ketos, grain validators, s6 supervision
- Persistent encrypted storage for grains
- Works on any public library computer
- Zero installation required

**Weeks 21-24: Advanced Validation**
- Triple-redundancy pattern (Swiss Ephemeris + manual + API)
- Cross-validation and forever-documents
- CI/CD that actually matters
- Testing as teaching

**End of Trimester 2**: Students have collaborative grainbook, portable GrainOS on USB, understand advanced patterns.

---

### TRIMESTER 3: World-Saving Projects (Western City → Meltdown → Eastern Capital)

**Weeks 25-28: Edge Cases & Failures**
- The Meltdown: systems fail, chaos happens, resilience required
- Debugging across timezones
- Starlink failures (dual-wifi utility)
- Graceful degradation
- Trust-building through transparency

**Weeks 29-32: Real-World Integration**
- Framework laptop partnership (actual hardware)
- Alpine VPS deployment (cloud infrastructure)
- ICP + Hedera + Solana multi-chain commerce
- Vegan advocacy network integration
- Helen Atthowe farm outreach

**Weeks 33-36: Capstone Projects**
- **Team Project**: Deploy grain network to actual users
- **Individual Project**: Pick a world problem, solve with grains
- **Integration Project**: Connect grains to real commerce
- **Teaching Project**: Write a grain that teaches something crucial

**End of Trimester 3**: Students have world-saving tools deployed, understand the full lifecycle, can teach the system to others.

---

## The Accessible Device Project (Key Innovation)

**Problem**: Not everyone can afford mantraOS hardware ($600+). Yet everyone deserves access to sovereign computing.

**Solution**: Portable GrainOS on Tails USB

**Technical Specs**:
- Base: Tails OS (Debian-based, Tor-enabled, privacy-first)
- Storage: 32GB minimum, 128GB recommended (USB 3.0+)
- Adapters: USB-C to USB-A adapter included for legacy systems
- Boot: Single boot script (Ketos-written, s6-supervised, musl-static)
- Persistence: Encrypted Tails persistence partition
- Environment: Alpine-minimal grain runtime with s6 init

**Installation Script** (single command):
```bash
ketos grainportable.ket --flash-usb /dev/sdX --size 64gb --persistent
```

**What Gets Installed**:
1. Tails OS base system
2. Ketos interpreter (static musl binary)
3. Grain validators (graincard, graintime)
4. s6 supervision (for long-running validators)
5. Grain network sync tools
6. Encrypted grain storage

**Student Experience**:
- Flash USB once (in class)
- Boot on any library computer (anywhere in world)
- All grains available offline (encrypted USB storage)
- Can work on grains anywhere
- Can sync when internet available
- Full privacy (Tor, Tails, encrypted)

**The Teaching Moment**:
Students learn that infrastructure can be **portable, private, and powerful**. You don't need expensive hardware to have sovereign computing. You need a $20 USB drive and the right configuration.

---

## Course Materials

**Grains as Textbook**:
- Trimester 1: First 100 grains (foundation)
- Trimester 2: Next 500 grains (building)
- Trimester 3: Remaining 1.2M grains (full coverage)

**Supplementary Materials**:
- Jiang Xueqin's Predictive History writings
- Helen Atthowe's "The Ecological Farm"
- Rich Hickey's "Simple Made Easy"
- Da Vinci notebooks (pattern recognition)
- 8001-v888 / 8002-v888 (Pluta & Panthera legend)

**Tools Learned**:
- Ketos (Rust Lisp)
- s6 (process supervision)
- Alpine Linux (minimal deployment)
- Tails OS (portable privacy)
- musl vs glibc (The Lovers' choice)
- Git workflow (grainbranching)

---

## Assessment

**No Traditional Grades**: Learning is assessed through deployed infrastructure.

**Trimester 1 Benchmarks**:
- Can write a valid grain (110 lines, correct format)
- Can read graintime and understand its components
- Can deploy a simple grain to GitHub Pages
- Can explain why 80×110 format matters

**Trimester 2 Benchmarks**:
- Can create portable GrainOS on USB
- Can validate grains using Ketos scripts
- Can collaborate on grainbook with team
- Can explain s6 supervision pattern

**Trimester 3 Benchmarks**:
- Can deploy production infrastructure
- Can solve real-world problems with grains
- Can teach the system to others
- Can connect grains to actual commerce

---

## Graduation = World Contribution

Students don't just "pass" - they contribute to the actual deployed grain network.

**Graduation Requirements**:
1. Wrote at least 10 grains accepted to grainbook
2. Deployed at least one component to production
3. Taught the system to at least one person
4. Connected grains to one real-world system

**The Diploma**: A grain with their own graintime, teaching their contribution to the world-saving network.

---

## Philosophy: Why This Works

**Jiang Xueqin's Predictive History**: Students learn to see patterns, project futures, build tools that matter.

**The Grain Network Advantage**: Students build tools that save the world **while learning**. Not simulated projects. Real infrastructure. Real impact.

**Accessibility Through Portability**: Students learn that powerful computing doesn't require expensive hardware. A USB drive and the right knowledge is enough.

**The Progression**: Wild (ignorance) → Search (learning) → City (deployment) → Meltdown (resilience) → Capital (mastery)

---

**Now == Next + 1** 🎓✧･ﾟ:* 🌾

**Copyright © 2025 kae3g (kj3x39, @risc.love)**  
**Course Author**: kae3g  
**Inspired by**: Jiang Xueqin (Predictive History), Helen Atthowe (ecological patience), Rich Hickey (simple wisdom)

Grainbook Issue 1: Ember Harvest 🎃  
**Building World-Saving Infrastructure Through Teaching**

