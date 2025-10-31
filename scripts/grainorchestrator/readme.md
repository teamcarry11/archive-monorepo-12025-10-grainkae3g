# grainorchestrator - kubernetes replacement in steel

**package name**: grainorchestrator  
**version**: 0.1.0  
**grainorder**: xzvsbg (design), xzvsbf (implementation spec)  
**graintime**: 12025-10-31--1450--pdt--moon-shatabhisha--asc-aqua21--sun-10h  
**author**: kae3g (kj3x39, @risc.love)  
**team**: teamtransform08 (scorpio ♏ / VIII. strength)  
**license**: apache-2.0  
**status**: implementation in progress

---

## installation (grain package manager)

install grainorchestrator via grain package manager:

```bash
# install grainorchestrator
grain install grainorchestrator

# install with dependencies (graindb)
grain install grainorchestrator --with-deps

# verify installation
grain list | grep grainorchestrator
```

after installation, grainorchestrator is available as:

- **command**: `grainorchestrator` (cli or daemon mode)
- **service**: `grainorchestrator` (s6/systemd service)
- **library**: `(require "grainorchestrator/core/state.scm")` (steel modules)

---

## package information

this package provides:

- **orchestrator daemon**: background service for pod supervision and scheduling
- **cli tool**: interactive and non-interactive command-line interface
- **steel library**: programmatic api for orchestration (state, supervision, scheduler)

**dependencies**:
- graindb (required): immutable database for orchestrator state

**platforms**:
- host mode: traditional posix systems (ubuntu, linux, macos)
- redox mode: redox os with url-based file system

---

## overview

grainorchestrator is a kubernetes replacement written entirely in steel. it combines:

- **s6 supervision semantics**: crash-only design, auto-restart, dependency-aware
- **arvo event sourcing**: deterministic state from event log
- **graindb queryability**: fine-grained facts, time-travel queries
- **steel implementation**: unified language, rust performance

**think of it as**: s6 scaled to clusters, with arvo's determinism and graindb's queryability.

---

## architecture

```
grainorchestrator/
├── core/
│   ├── state.scm           ; orchestrator state (graindb integration)
│   ├── supervision.scm     ; s6-style supervision
│   ├── scheduler.scm       ; pod scheduling logic
│   └── events.scm          ; event sourcing
├── api/
│   ├── pods.scm            ; pod management api
│   ├── nodes.scm           ; node management api
│   └── services.scm        ; service discovery api
└── utils/
    ├── resources.scm        ; resource tracking
    └── health.scm           ; health checks
```

---

## core concepts

### event-sourced state

all orchestrator state is stored in graindb as facts (eavt tuples). state changes produce events. nodes sync via event log replay.

**example**:
```steel
;; create pod (adds facts)
(create-pod db "pod-xbdghj" pod-spec)

;; query current state
(get-running-pods db)

;; time-travel: what pods were running yesterday?
(q (as-of db yesterday-tx) '[:find ?pod ...])
```

### platform abstraction

grainorchestrator supports two platform modes:
- **host mode**: traditional posix systems (ubuntu, linux, macos)
- **redox mode**: redox os with url-based file system and scheme system

the platform abstraction layer uses macros and specs to decouple platform-specific code:

**example**:
```steel
;; save database (works on both platforms)
(platform-save-db db "/var/lib/grainorchestrator/state.db")
;; host: saves to "/var/lib/grainorchestrator/state.db"
;; redox: saves to "file:///var/lib/grainorchestrator/state.db"

;; connect to event log (works on both platforms)
(platform-connect-event-log "localhost:9092")
;; host: connects to "localhost:9092"
;; redox: connects to "tcp://localhost:9092"
```

platform differences are handled automatically by the abstraction layer. your code stays clean and works on both platforms.

### crash-only supervision

pods are expected to crash. supervisor automatically restarts them (unless restart-policy :never).

**example**:
```steel
;; pod crashes
(update-pod-status db "pod-xbdghj" ':crashed)

;; supervision loop restarts it automatically
(supervision-tick db)  ; restarts crashed pods
```

### dependency resolution

pods start only when their dependencies are running.

**example**:
```steel
;; web pod depends on database pod
(create-pod db "web-pod" {:depends-on ["db-pod"]})

;; supervision waits for db-pod to be running before starting web-pod
```

---

## implementation status

### ✅ completed

- [x] comparison study (urbit arvo vs graindb vs s6)
- [x] implementation specification
- [x] core/state.scm (graindb integration)
- [x] core/supervision.scm (s6-style supervision)

### 🚧 in progress

- [ ] core/scheduler.scm (pod scheduling)
- [ ] core/events.scm (event sourcing)
- [ ] api modules (pods, nodes, services)
- [ ] graindb integration (waiting for graindb implementation)

### 📋 planned

- [ ] daemon entry point
- [ ] s6 service integration
- [ ] event log (kafka/icp)
- [ ] health checks
- [ ] resource tracking
- [ ] tests

---

## usage

after installation via grain package manager, grainorchestrator is available as the `grainorchestrator` command.

### interactive mode (terminal dialog)

run grainorchestrator interactively to explore pods and nodes:

```bash
# start interactive mode (auto-detected if stdin is tty)
grainorchestrator

# or explicitly enable interactive mode
GRAINORCHESTRATOR_INTERACTIVE=1 grainorchestrator
```

interactive mode shows a menu:
```
🌾 grainorchestrator - interactive mode

1. list pods
2. create pod
3. get pod status
4. list nodes
5. register node
6. supervision status
7. exit

choose option (1-7):
```

### non-interactive mode (scripting)

use grainorchestrator in scripts for automation:

```bash
# list pods
grainorchestrator list-pods

# create pod
grainorchestrator create-pod pod-xbdghj '{"cpu-request": 1.0, "memory-request": 512}'

# get pod status
grainorchestrator pod-status pod-xbdghj

# register node
grainorchestrator register-node node-1 '{"cpu-total": 4.0, "memory-total": 8192}'
```

non-interactive mode outputs plain text, perfect for scripting:
```bash
#!/bin/bash
# example script using grainorchestrator

POD_ID=$(grainorchestrator create-pod pod-xbdghj '{"cpu-request": 1.0}')
STATUS=$(grainorchestrator pod-status "$POD_ID")
echo "pod $POD_ID status: $STATUS"
```

### daemon mode (background service)

run grainorchestrator as a background service:

```bash
# start daemon mode
steel scripts/grainorchestrator/api/cli-daemon.scm --daemon

# or set environment variable
GRAINORCHESTRATOR_DAEMON=1 steel scripts/grainorchestrator/api/cli-daemon.scm
```

daemon mode runs supervision and scheduler loops in the background.

### run as s6 service

```bash
# create service directory
mkdir -p /etc/s6/sv/grainorchestrator

# create run script
cat > /etc/s6/sv/grainorchestrator/run << 'EOF'
#!/bin/sh
exec steel /usr/local/bin/grainorchestrator/api/cli-daemon.scm --daemon
EOF

chmod +x /etc/s6/sv/grainorchestrator/run

# enable service
ln -s /etc/s6/sv/grainorchestrator /service/grainorchestrator
```

### programmatic api

use grainorchestrator programmatically in steel:

```steel
(require "core/state.scm")

(let ([db (make-orchestrator-db)])
  (create-pod db "pod-xbdghj"
    {:cpu-request 1.0
     :memory-request 512
     :restart-policy ':always
     :depends-on ["pod-xbdghk"]}))
```

---

## design principles

1. **crash-only**: pods crash, supervisor restarts them. simple, reliable.
2. **event-sourced**: state computed from events. deterministic, debuggable.
3. **dependency-aware**: pods start only when dependencies ready.
4. **steel-native**: all code in steel. unified language, rust performance.

---

## references

- **comparison study**: `xzvsbg-12025-10-31--2130-pdt--urbit-arvo-bowl-graindb-s6-comparison-grainorchestrator-design.md`
- **implementation spec**: `xzvsbf-12025-10-31--2145-pdt--grainorchestrator-steel-implementation-spec.md`
- **graindb design**: `xzvsml-12025-10-28--0045-pdt--graindb-steel-database-whitepaper.md`

---

---

## license

this project is dual-licensed under mit and apache 2.0. see [license.md](license.md) for details.

**copyright © 12025 kae3g**  
**authors**: kae3g (kj3x39, @risc.love)  
**team**: teamtransform08 (scorpio ♏ / VIII. strength)  
**now == next + 1 🌾⚒️**

