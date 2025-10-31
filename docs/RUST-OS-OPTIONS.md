# rust operating system options - redox, aero, and more

**date**: 12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h  
**team**: teamcarry11 (t11aq, airbender mode)  
**source**: conversation with bjorn3 (redox os developer)

---

## key discovery: aero os

**github**: https://github.com/Andy-Python-Programmer/aero  
**description**: modern, experimental, unix-like operating system written in rust  
**kernel design**: **monolithic kernel** (like linux, but in rust!)

**important**: aero is **not** a linux distribution - it runs its own kernel written from scratch in rust!

---

## rust os comparison

### redox os
- **kernel**: microkernel
- **language**: rust
- **design**: capability-based, url scheme system
- **focus**: security through isolation, rust memory safety
- **concern**: microkernel = more syscalls = battery drain? (answered: no!)

### aero os
- **kernel**: **monolithic kernel** (like linux!)
- **language**: rust
- **design**: inspired by linux kernel, but written from scratch
- **focus**: modern pc features, performance, linux compatibility
- **advantage**: fewer syscalls (monolithic), familiar to linux developers
- **license**: **GPLv3** (copyleft - derivative works must be GPLv3)

---

## insights from redox developer (bjorn3)

### battery drain myth busted

**question**: does microkernel design mean more battery drain due to more syscalls?

**answer**: **no!** syscall count doesn't matter for battery drain.

**what actually matters**:
- good power management
- devices sleep when unused
- avoid unnecessary timer wakeups (coalescing timers)
- use big vs little cores correctly
- cpu cores in right sleep states

**key insight**: performance matters more than syscall count!

---

## hybrid approach possibility

**question**: what about a hybrid between microkernel and monolithic?

**answer**: there are many rust oses:
- **redox**: microkernel
- **aero**: monolithic kernel
- **hermit**: unikernel
- and more!

**insight**: the rust os ecosystem is diverse! we can choose based on needs.

---

## aero os features

from https://github.com/Andy-Python-Programmer/aero:

**features**:
- 64-bit higher half kernel
- 4/5 level paging
- preemptive per-cpu scheduler
- modern uefi bootloader
- acpi support (ioapic, lapic)
- symmetric multiprocessing (smp)
- on-demand paging

**goals**:
- modern, safe, beautiful, fast os
- target modern 64-bit architectures
- good source-level compatibility with linux
- usable os on real hardware (not just emulators)

**build**: `make distro-image && make qemu`

---

## implications for grain network

### redox (microkernel)
**pros**:
- security through isolation
- capability-based security
- pure rust stack
- url scheme system (interesting!)

**cons**:
- different from linux (learning curve)
- may need more syscalls (but doesn't matter for battery!)

**best for**: security-critical applications, learning new paradigms

---

### aero (monolithic)
**pros**:
- familiar to linux developers
- fewer syscalls (monolithic design)
- linux compatibility (easier porting)
- modern rust codebase

**cons**:
- newer project (less mature?)
- monolithic = single point of failure potential
- **GPLv3 license** (copyleft - derivative works must be GPLv3)

**best for**: linux developers, performance-critical applications  
**license note**: derivative works must be GPLv3 (important for grain network!)

---

## what this means for us

### for grain network development

**we have options**:
1. **redox**: pure rust microkernel, unique design
2. **aero**: rust monolithic kernel, linux-like
3. **both**: learn from both approaches!

**recommendation**: explore both!
- redox for unique rust os patterns
- aero for linux-compatible rust os
- learn what works best for grain network

---

## rust os ecosystem

**discovered rust oses**:
- **redox**: microkernel, capability-based
- **aero**: monolithic, linux-inspired
- **hermit**: unikernel (mentioned by bjorn3)
- more likely exist!

**insight**: rust os ecosystem is growing! we're not limited to one approach.

---

## questions answered

### myth: microkernel = more battery drain
**reality**: syscall count doesn't matter. power management does!

### question: hybrid monolithic/microkernel?
**reality**: both exist! choose based on needs.

### question: rust monolithic kernel?
**reality**: yes! aero exists and it's impressive!

---

## next steps

### immediate
- ✅ document rust os options
- ⬜ explore aero os (clone, build, test)
- ⬜ compare redox vs aero for grain network needs

### short term
- test aero os in qemu
- compare performance (syscalls, power management)
- evaluate linux compatibility (porting ease)

### long term
- decide which rust os fits grain network best
- or: support both redox and aero!
- contribute to chosen os community

---

## resources

### aero os
- github: https://github.com/Andy-Python-Programmer/aero
- website: https://andypy.dev/aero
- discord: mentioned in repo (community support)

### redox os
- gitlab: https://gitlab.redox-os.org/redox-os/redox
- docs: https://doc.redox-os.org/book/
- matrix: #redox-join:matrix.org

### hermit (unikernel)
- github: https://github.com/hermitcore (likely)
- unikernel design (mentioned by bjorn3)

---

## takeaways

1. **battery drain myth**: microkernel syscalls don't cause battery drain. power management does!

2. **rust os diversity**: we have options! microkernel (redox), monolithic (aero), unikernel (hermit)

3. **choose based on needs**: security (redox) vs performance/compatibility (aero)

4. **grain network**: we can support multiple rust oses! don't limit ourselves.

---

**airbender mode**: rust oses flow like water - many paths, all leading to rust! 🌊

**discovery**: thanks to bjorn3 for sharing knowledge about the rust os ecosystem!

