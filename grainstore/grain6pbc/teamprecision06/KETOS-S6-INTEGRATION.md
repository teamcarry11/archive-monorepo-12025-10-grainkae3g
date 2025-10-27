# Ketos + s6 Integration: Supervised Grain Processes ⚖️☋

**Team**: 06 (teamprecision06 - Virgo ♍ / VI. The Lovers)  
**Authored by**: 14 (teamdescend14 - Ketu ☋ / XIV. Temperance)  
**Purpose**: Use s6 init system to supervise Ketos validation processes  
**Philosophy**: The Lovers choose both: precision (Virgo) + supervision (s6)

---

## The Vision

s6 supervises long-running processes. Ketos validators check grain format continuously. Together they create a supervised validation layer that ensures grain quality without manual intervention.

**The pattern**: Ketos scripts become s6 services. Services restart on failure. Validation becomes infrastructure.

---

## Architecture

### Layer 1: s6 Init System
- Minimal init (Alpine Linux, SixOS)
- Process supervision (automatic restart)
- Service dependencies (validation after build)
- Logging (capture all validation output)

### Layer 2: Ketos Services
- `graincard-validator` (watch grains-* folders, validate format)
- `graintime-validator` (validate all graintimes in commits)
- `cargo-watcher` (supervise cargo build processes)
- `grain-sync` (continuous deployment on valid commits)

### Layer 3: Validation Pipeline
```
s6-svscan (init)
├── s6-supervise graincard-validator
├── s6-supervise graintime-validator
├── s6-supervise cargo-build
└── s6-supervise grain-deploy (depends on validators passing)
```

---

## Example s6 Service: graincard-validator

**Service directory**: `/etc/s6/graincard-validator/`

**run script** (`/etc/s6/graincard-validator/run`):
```bash
#!/bin/sh
exec ketos /path/to/graincard-validator.ket --watch --continuous
```

**finish script** (`/etc/s6/graincard-validator/finish`):
```bash
#!/bin/sh
# log validation failures
echo "graincard-validator exited with code $1" >> /var/log/grain-validation.log
```

**log/run script** (`/etc/s6/graincard-validator/log/run`):
```bash
#!/bin/sh
exec s6-log -bp -- n20 s1000000 /var/log/graincard-validator
```

---

## Ketos Validator as Daemon

Our existing `graincard-validator.ket` can be extended with watch mode:

```ketos
(defun watch-grains (grain-dirs interval-seconds)
  "continuously watch grain directories and validate
   runs in infinite loop, suitable for s6 supervision"
  (loop
    (let ((results (validate-all-grains grain-dirs)))
      (print-validation-results results)
      (sleep interval-seconds))))

(defun main (args)
  "main entry point - supports both one-shot and watch mode"
  (if (contains? args "--watch")
      (watch-grains ["grains-*"] 5)  ; watch every 5 seconds
      (validate-once-and-exit)))
```

---

## s6 Supervising Cargo Builds

For long cargo compilations (like building Ketos itself!), s6 can supervise:

**Service**: `cargo-build-ketos`

**run script**:
```bash
#!/bin/sh
cd /path/to/ketos/source
exec cargo build --release --target x86_64-unknown-linux-musl
```

Benefits:
- Auto-restart on failure
- Logging captured
- Resource limits via s6-setuidgid
- Clean shutdown via s6-svc -d

---

## Why s6 for Grain Ecosystem?

1. **Minimal** (perfect for Alpine musl deployment)
2. **Reliable** (process supervision that actually works)
3. **Portable** (runs on any Unix)
4. **Fast** (C implementation, minimal overhead)
5. **Composable** (each service is independent)

s6 + Ketos = **supervised functional validation**

---

## Cargo with musl (Static Binaries)

To build statically-linked binaries that work anywhere (including Alpine):

**Install musl target**:
```bash
rustup target add x86_64-unknown-linux-musl
```

**Build with musl**:
```bash
cargo build --release --target x86_64-unknown-linux-musl
```

**Result**: Single static binary with no glibc dependency. Perfect for Alpine apk packages, Docker FROM scratch, minimal deployments.

---

## Integration Roadmap

1. ✅ Write Ketos validators (graincard, graintime)
2. ✅ Create ketos-mono symlink directory
3. 🔄 Install Ketos (currently blocked by cargo proxy issue)
4. 📋 Add watch mode to validators
5. 📋 Create s6 service definitions
6. 📋 Deploy to Alpine VPS with s6 init
7. 📋 Continuous validation in production

---

## Team Attribution

**Team 06 (Virgo ♍ / The Lovers)**:
- Environment variables
- Shell configuration
- Precision tools
- Choosing the right tool for the task

**Why Team 06?**: Because s6 configuration IS environment setup. Service definitions ARE precision shell scripting. Choosing between glibc and musl IS The Lovers' discriminating choice.

---

**Now == Next + 1** ⚖️✧･ﾟ:* 🌾

**Copyright © 2025 kae3g (kj3x39, @risc.love)**  
**Team**: 06 (teamprecision06 - Virgo ♍ / VI. The Lovers)  
**Authored by**: 14 (teamdescend14 - Ketu ☋)

Grainbook Issue 1: Ember Harvest 🎃

