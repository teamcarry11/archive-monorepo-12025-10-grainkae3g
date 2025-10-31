# grain-monolithic-compat - monolithic-like compatibility for redox

**🌊 Airbender Mode**: Provide monolithic-like features using Redox + Steel  
**Kid-Friendly**: Make Redox look like a monolithic kernel, but keep MIT license!

**inspiration**: aero os (monolithic rust kernel) - https://github.com/Andy-Python-Programmer/aero  
**note**: we study aero's design, but write our own implementation (MIT/Apache 2.0)

---

## purpose

instead of using aero os directly (GPLv3), we:
- use redox as base (MIT ✅)
- write steel modules (MIT/Apache 2.0 ✅)
- provide monolithic-like features (our implementation ✅)
- achieve linux compatibility (via steel layer ✅)

**inspiration**: aero os's monolithic kernel design  
**result**: monolithic-like features, redox license, steel implementation!

---

## modules

### syscall-layer.scm
provides monolithic-like syscall interface:
- batches microkernel syscalls (reduces overhead)
- looks like monolithic kernel to applications
- reduces IPC overhead

### linux-compat.scm
provides linux compatibility:
- maps linux paths to redox (`/dev/null` → `/scheme/null`)
- maps linux syscalls to redox
- easier to port linux applications

### unified-services.scm (TODO)
monolithic-like service management:
- unified service interface
- efficient IPC batching
- familiar unix-like interface

### monolithic-features.scm (TODO)
monolithic kernel feature parity:
- modern pc features (redox already has!)
- linux compatibility (via compat layer)
- performance optimizations
- inspired by aero os design

---

## usage

### enable linux compatibility
```steel
(require "grain-monolithic-compat/linux-compat.scm")
(enable-linux-compat)
```

### use monolithic-like syscalls
```steel
(require "grain-monolithic-compat/syscall-layer.scm")
(open-file "/dev/null" 'read)
(read-file fd buffer 1024)
```

---

## strategy

**base**: redox (MIT)  
**modules**: steel (MIT/Apache 2.0)  
**goal**: monolithic-like features (inspired by aero os design)  
**license**: everything stays MIT/Apache 2.0 ✅

**result**: best of both worlds!

---

## attribution

**inspired by**: aero os (https://github.com/Andy-Python-Programmer/aero)  
**design study**: we study aero's monolithic kernel design  
**implementation**: our own code (MIT/Apache 2.0)  
**not affiliated**: grain network is not affiliated with aero os

---

**airbender mode**: study aero design, build on redox, implement in steel! 🌊

