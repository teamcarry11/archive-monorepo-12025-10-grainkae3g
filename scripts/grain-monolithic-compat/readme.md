# grain-monolithic-compat - monolithic-like compatibility for redox

**🌊 airbender mode**: provide monolithic-like features using redox + steel  
**kid-friendly**: make redox look like a monolithic kernel, but keep mit license!

**inspiration**: aero os (monolithic rust kernel) - 
https://github.com/Andy-Python-Programmer/aero  
**note**: we study aero's design, but write our own implementation 
(mit/apache 2.0)

**insight from redox community**: syscall count doesn't directly affect
battery drain if performance is similar. power management (sleep states,
timer coalescing) matters more than raw syscall overhead.

---

## purpose

instead of using aero os directly (gplv3), we:
- use redox as base (mit ✅)
- write steel modules (mit/apache 2.0 ✅)
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
- reduces ipc overhead

### linux-compat.scm
provides linux compatibility:
- maps linux paths to redox (`/dev/null` → `/scheme/null`)
- maps linux syscalls to redox
- easier to port linux applications

### benchmarks/
microkernel vs monolithic performance benchmarks:
- **⚠️  important**: benchmarks only meaningful when comparing
  results from redox os (microkernel) vs linux (monolithic)
- running on ubuntu/linux measures abstraction overhead,
  not real ipc differences
- see `benchmarks/readme.md` for details

### unified-services.scm (todo)
monolithic-like service management:
- unified service interface
- efficient ipc batching
- familiar unix-like interface

### monolithic-features.scm (todo)
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

**base**: redox (mit)  
**modules**: steel (mit/apache 2.0)  
**goal**: monolithic-like features (inspired by aero os design)  
**license**: everything stays mit/apache 2.0 ✅

**result**: best of both worlds!

---

## attribution

**inspired by**: aero os (https://github.com/Andy-Python-Programmer/aero)  
**design study**: we study aero's monolithic kernel design  
**implementation**: our own code (mit/apache 2.0)  
**not affiliated**: grain network is not affiliated with aero os

**redox community insights**: thanks to bjorn3 and the redox os/general
matrix room for clarifying that syscall count vs battery drain is more
nuanced than raw overhead. power management matters more!

---

**airbender mode**: study aero design, build on redox, implement in steel! 🌊
