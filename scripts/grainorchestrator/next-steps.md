# next steps for grainorchestrator and graindaemon

**date**: 12025-10-31--1450--pdt--moon-shatabhisha--asc-aqua21--sun-10h  
**status**: package ready, sync working, ready for next phase

---

## immediate priorities

### 1. test steel scripts
**priority**: high  
**status**: needs testing

test the actual steel scripts to verify they work:
```bash
# test transform08 sync
steel scripts/grainmirror-transform08.scm sync

# test carry11 sync  
steel scripts/grainmirror-carry11.scm sync

# test daemon mode
steel scripts/graindaemon-grainmirror-transform08.scm
```

**if steel file operations don't work**:
- use shell wrapper scripts as interim solution
- create `grainmirror-transform08.sh` that calls bash commands
- update s6 run script to use shell wrapper

---

### 2. set up s6 service
**priority**: high  
**status**: service config exists, not linked

enable supervised daemon mode:
```bash
# create service link (if s6-rc installed)
sudo ln -s /home/xy/kae3g/grainkae3g/configs/s6/grainmirror-transform08 /etc/s6/sv/grainmirror-transform08

# or use s6-supervise directly
s6-supervise /home/xy/kae3g/grainkae3g/configs/s6/grainmirror-transform08
```

**also create carry11 service**:
- create `configs/s6/grainmirror-carry11/run`
- same structure as transform08 service

---

### 3. implement steel file operations
**priority**: medium  
**status**: using shell commands as fallback

when steel file api is available:
- replace shell `test`, `cp`, `find` commands
- use native steel file operations
- improve error handling
- add atomic file operations (copy to temp, then rename)

**check steel documentation** for:
- `file-exists?` function
- `copy-file` function  
- `list-directory` function
- `command` function for shell execution

---

### 4. add graintime logging
**priority**: medium  
**status**: using simple timestamps

implement full graintime logging:
- astronomical context (moon phase, zodiac)
- timezone information
- temporal transparency
- query logs by graintime

**requires**: graintime library/module for steel

---

## grainorchestrator development

### 5. implement core modules
**priority**: high  
**status**: placeholders exist

implement actual functionality:
- **state.scm**: grainDB integration for pod/node state
- **supervision.scm**: s6-style supervision loop
- **scheduler.scm**: pod scheduling algorithm
- **events.scm**: event sourcing with kafka/file/icp backends

**first step**: implement grainDB connection and basic CRUD operations

---

### 6. platform abstraction testing
**priority**: medium  
**status**: macros defined, needs testing

test platform abstraction on both:
- **host mode**: ubuntu/linux posix environment
- **redox mode**: redox os with url-based file system

**requires**: redox os development environment or emulator

---

### 7. cli testing
**priority**: medium  
**status**: code exists, needs testing

test interactive and non-interactive modes:
```bash
# interactive mode
grainorchestrator --interactive

# non-interactive mode
grainorchestrator list-pods
grainorchestrator create-pod pod-xbdghj '{"cpu-request": 1.0}'
```

---

## documentation and polish

### 8. package deployment
**priority**: low  
**status**: package metadata ready

when grain package manager is ready:
- test `grain install grainorchestrator`
- verify dependencies install correctly
- test service setup with `--enable-service` flag

---

### 9. examples and tutorials
**priority**: low  
**status**: basic readme exists

create:
- example pod configurations
- example node registration
- tutorial: "your first pod"
- troubleshooting guide

---

## research and design

### 10. urbit arvo bowl deep dive
**priority**: low  
**status**: comparison document created

study urbit bowl model more deeply:
- event sourcing patterns
- deterministic state computation
- how bowl state relates to our orchestrator state
- apply bowl concepts to scheduler

---

### 11. s6 integration patterns
**priority**: low  
**status**: basic supervision implemented

study s6 more deeply:
- dependency resolution algorithms
- service directory structure
- signal handling patterns
- logging best practices

---

## quick wins (can do now)

1. **test steel scripts** - verify they work or fix them
2. **set up s6 service** - enable daemon mode
3. **create carry11 daemon** - duplicate transform08 setup
4. **add shell wrappers** - if steel doesn't work, use bash

---

## blocked items

- **steel file api**: waiting for steel to provide file operations
- **graintime library**: needs to be created or integrated
- **grainDB**: needs to be implemented/available
- **grain package manager**: needs to be ready for deployment
- **redox os**: needs development environment for testing

---

**recommended order**:
1. test steel scripts (immediate)
2. set up s6 service (quick win)
3. implement grainDB integration (core functionality)
4. test platform abstraction (verify design)
5. polish and document (make it usable)

---

**now == next + 1 🌾**

