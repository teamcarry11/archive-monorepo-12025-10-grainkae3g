# redox vs aero - rust os comparison

**date**: 12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h  
**team**: teamcarry11 (t11aq, airbender mode)  
**source**: conversation with bjorn3 (redox os developer) + aero github

---

## quick comparison

| feature | redox | aero |
|---------|--------|------|
| **kernel** | microkernel | monolithic |
| **language** | rust | rust |
| **inspiration** | capability-based os | linux kernel |
| **syscalls** | more (microkernel) | fewer (monolithic) |
| **battery drain** | same (power management matters) | same (power management matters) |
| **linux compatibility** | different paradigm | good source-level compatibility |
| **learning curve** | steeper (new paradigm) | easier (linux-like) |
| **security** | capability-based isolation | traditional unix permissions |
| **filesystem** | url scheme system (`/scheme/`) | traditional unix paths |
| **license** | MIT (permissive) | **GPLv3** (copyleft) |

---

## key insights from bjorn3

### battery drain myth

**myth**: microkernel = more syscalls = more battery drain

**reality**: **syscall count doesn't matter!**

**what actually matters**:
- power management (devices sleep when unused)
- timer coalescing (avoid unnecessary wakeups)
- big/little core usage
- cpu sleep states

**insight**: if redox has same performance as linux, battery drain is similar!

---

## for grain network development

### when to choose redox

**choose redox if**:
- security is critical (capability-based isolation)
- you want pure rust stack (no c dependencies)
- you're building new applications (not porting linux apps)
- you want to learn new paradigms

**grain network fit**: 
- secure by default (capability-based)
- pure rust matches our steel/rust focus
- unique design fits grain network philosophy

---

### when to choose aero

**choose aero if**:
- you need linux compatibility (easier porting)
- you're familiar with linux kernel design
- you want monolithic kernel performance
- you're porting existing linux applications

**grain network fit**:
- easier to port existing tools
- familiar to linux developers
- good performance (monolithic)

---

## both are valid!

**insight**: we don't have to choose one!

**options**:
1. support both redox and aero
2. use redox for security-critical modules
3. use aero for linux-compatible modules
4. learn from both approaches

**grain network**: flexible architecture can support multiple rust oses!

---

## technical details

### redox microkernel

**architecture**:
```
applications
    ↓
ion shell (rust)
    ↓
relibc (rust c library)
    ↓
redox kernel (rust microkernel)
    ↓
hardware
```

**key features**:
- capability-based security
- url scheme system (`/scheme/null`, `/scheme/file`, etc.)
- pure rust stack
- memory safety at every layer

---

### aero monolithic kernel

**architecture**:
```
applications
    ↓
shell (linux-compatible)
    ↓
libc (rust c library?)
    ↓
aero kernel (rust monolithic)
    ↓
hardware
```

**key features**:
- linux source-level compatibility
- monolithic kernel (like linux)
- modern rust codebase
- familiar to linux developers

---

## build comparison

### redox
```bash
git clone https://gitlab.redox-os.org/redox-os/redox.git
cd redox
git submodule update --init --recursive
make all CONFIG_NAME=minimal PODMAN_ENV="--env CI=1 ..."
make qemu CONFIG_NAME=minimal
```

**build time**: 45-90 minutes (first build)

---

### aero
```bash
git clone https://github.com/Andy-Python-Programmer/aero
cd aero
make distro-image
make qemu
```

**build time**: unknown (need to test!)

---

## license implications

### redox: MIT (permissive)
- **can use**: yes, mix with any license
- **can modify**: yes, keep changes private if needed
- **can distribute**: yes, with or without source
- **grain network fit**: ✅ compatible (we use MIT/Apache 2.0)

### aero: GPLv3 (copyleft)
- **can use**: yes, but derivative works must be GPLv3
- **can modify**: yes, but must release source
- **can distribute**: yes, but must include source
- **grain network fit**: ⚠️ requires GPLv3 for derivative works

**important**: if we modify aero code or create derivative works, we must release under GPLv3!

**reference**: https://github.com/Andy-Python-Programmer/aero (GPL-3.0 license)

---

## which for grain network?

### recommendation: explore both!

**license consideration**: 
- redox (MIT) is more compatible with our MIT/Apache 2.0 stack
- aero (GPLv3) requires GPLv3 for derivative works
- decision: use aero as-is, or accept GPLv3 for aero-based components

**phase 1**: build and test both
- build redox (we already did this!)
- build aero (next step!)
- compare performance, developer experience

**phase 2**: evaluate for grain network
- which fits our architecture better?
- which has better tooling?
- which community is more active?

**phase 3**: decide (or support both!)
- choose primary os
- or support both redox and aero
- contribute to chosen os community

---

## questions to explore

### aero os
- how mature is aero compared to redox?
- what's the build time?
- how easy is it to port linux applications?
- what's the community like?

### redox os
- how does capability-based security work in practice?
- what's the url scheme system like?
- how easy is it to learn ion shell?
- what's the development workflow?

---

## next steps

### immediate
- ✅ document both options
- ⬜ build aero os (test in qemu)
- ⬜ compare build times
- ⬜ test basic functionality

### short term
- compare developer experience
- evaluate porting ease
- test performance
- check community activity

### long term
- decide primary os (or support both!)
- contribute to chosen os
- build grain network on chosen os

---

## resources

### aero os
- github: https://github.com/Andy-Python-Programmer/aero
- website: https://andypy.dev/aero
- build: `make distro-image && make qemu`

### redox os
- gitlab: https://gitlab.redox-os.org/redox-os/redox
- docs: https://doc.redox-os.org/book/
- matrix: #redox-join:matrix.org

---

**airbender mode**: both redox and aero flow in rust! choose based on needs! 🌊

**insight**: thanks to bjorn3 for sharing knowledge about rust os ecosystem!

