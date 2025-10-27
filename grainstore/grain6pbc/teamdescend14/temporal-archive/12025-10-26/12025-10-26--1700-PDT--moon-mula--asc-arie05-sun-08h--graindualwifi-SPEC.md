# graindualwifi - Dual-Wifi Failover Utility

**Temporal Archive**: 12025-10-26 17:00 PDT  
**Graintime**: `12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14`  
**Grainbranch**: `gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14`  
**Live Site**: https://kae3g.github.io/grainkae3g/gkd-prompt-execution--12025-10-26--1700-PDT--moon-mula----------asc-arie05-sun-08h--teamdescend14/files/xbd-graindualwifi.html

---

## 📍 Location Analysis

### 1️⃣ Current Location
`grainstore/grain6pbc/teamprecision06/graindualwifi/`

**Why here**:
- **Team 06** (Precision / Virgo ♍ / VI. The Lovers) - Perfect alignment
- The Lovers choose between two paths (Starlink vs cellular)
- Precision in network configuration and environment
- Belongs with grainenvvars and grainzsh (configuration tools)

### 2️⃣ Potential Locations

**Option A**: `grainstore/grain6pbc/teamdescend14/system-daemons/graindualwifi/`
- **Rationale**: System-level daemon, infrastructure layer
- Team 14 (Descent) handles low-level system operations
- Pros: Groups with other system services
- Cons: Loses the Lovers/precision philosophy connection

**Option B**: `grainstore/grain6pbc/teamnurture04/grainbarrel/network/graindualwifi/`
- **Rationale**: Build/deployment infrastructure tool
- Team 04 (Nurture) handles grainbarrel utilities
- Pros: Part of broader build automation
- Cons: Network precision isn't primarily about building

**Option C**: `grainstore/grain6pbc/teamstructure10/grainnetwork/graindualwifi/`
- **Rationale**: Create new grainnetwork module for network tools
- Team 10 (Structure) handles system structure
- Pros: Could house all network utilities
- Cons: Team 10 already has graintime, grainbranch (full)

### 3️⃣ Recommended Location (Grand Vision)

`grainstore/grain6pbc/teamprecision06/graindualwifi/` ✅

**Final Decision**:

Stay in **team06** because:

1. **Philosophical alignment**: The Lovers' conscious choice between two paths IS the core feature
2. **Configuration precision**: Network failover is environment configuration at its finest
3. **Team cohesion**: grainenvvars + grainzsh + graindualwifi = complete precision toolkit
4. **User experience**: When choosing between Starlink and cellular, you want PRECISION (not just any connection)

**If Starting From Scratch**:

I would create a **teamprecision06/grainnetwork/** sub-module to house:
- `graindualwifi/` (this tool)
- `grainvpn/` (future: VPN management)
- `grainfirewall/` (future: Firewall configuration)
- `grainproxy/` (future: Proxy routing)

But keep them ALL in team06 because network configuration IS precision configuration. The Lovers choose, Virgo validates. ✨

---

**Team**: 06 - Precision (Virgo ♍ / VI. The Lovers)  
**Language**: Ketos (Rust Lisp)  
**Target**: Ubuntu 24.04 LTS (Framework 16 laptop)  
**Purpose**: Automatic failover between Starlink and cellular connections

---

## The Problem

**Forest cabin internet** (Caspar, CA):
- **Starlink**: Fast but inconsistent in forest/weather
- **Cellular tethering**: Slower but more reliable
- **Current issue**: Manual switching when Starlink drops
- **Need**: Automatic failover with health monitoring

---

## The Solution

**graindualwifi**: Smart network manager that:
1. **Monitors** both connections continuously
2. **Tests** internet health (not just link status)
3. **Fails over** automatically to backup
4. **Fails back** when primary recovers
5. **Logs** all transitions for debugging

---

## Design Philosophy

### VI. The Lovers - Choose Wisely

**The Lovers** teach: **Conscious choice** between options

**Applied to networking**:
- Two paths (Starlink + cellular)
- Discriminating love (choose the working one)
- Sacred union (both work together as one system)
- Blessing (automatic, don't think about it)

**Virgo precision**:
- Health checks (not assumptions)
- Quick failover (<5 seconds)
- Detailed logging
- Predictable behavior

---

## Technical Specification

### Network Interfaces

**Primary (Starlink)**:
- Interface: `wlp1s0` (or configured name)
- Expected speed: 50-200 Mbps
- Latency: 20-40ms (when working)
- Priority: 1 (prefer when available)

**Secondary (Cellular)**:
- Interface: `wlp2s0` (or configured name)  
- Expected speed: 10-50 Mbps
- Latency: 50-100ms
- Priority: 2 (fallback only)

### Health Check Strategy

**Three-level health check**:

1. **Link status** (Layer 1)
   - Is interface UP?
   - Does it have IP address?
   - Fast check (milliseconds)

2. **Gateway reachability** (Layer 3)
   - Can we ping local gateway?
   - Network layer working?
   - Medium check (~1 second)

3. **Internet connectivity** (Layer 7)
   - Can we reach external host?
   - Test URLs: `1.1.1.1`, `8.8.8.8`, `github.com`
   - Slow check (~5 seconds)

**Health check interval**:
- Every 10 seconds when stable
- Every 2 seconds during failover
- Every 30 seconds when on secondary (check if primary recovered)

### Failover Logic

**State machine**:

```
[PRIMARY_HEALTHY]
  → Primary fails 3 consecutive health checks
  → [FAILING_OVER] (switch to secondary)
  → [SECONDARY_ACTIVE]
  
[SECONDARY_ACTIVE]
  → Primary recovers (3 consecutive healthy checks)
  → [FAILING_BACK] (switch to primary)
  → [PRIMARY_HEALTHY]
```

**Hysteresis** (prevent flapping):
- Need 3 consecutive failures to fail over
- Need 3 consecutive successes to fail back
- Minimum 30 seconds on secondary before failing back

### Network Configuration

**Uses NetworkManager** (Ubuntu default):

```bash
# Set primary metric (lower = preferred)
nmcli connection modify Starlink ipv4.route-metric 100
nmcli connection modify Cellular ipv4.route-metric 200

# During failover:
nmcli connection down Starlink
nmcli connection up Cellular

# During failback:
nmcli connection up Starlink
# (automatically takes over due to lower metric)
```

---

## Implementation in Ketos

### Why Ketos?

1. **Rust foundation** - System-level network ops, safe
2. **Lisp syntax** - Clear, readable logic
3. **Small binary** - Minimal overhead for daemon
4. **Learn by doing** - First real Ketos program!

### Project Structure

```
graindualwifi/
├── README.md
├── SPEC.md (this file)
├── Cargo.toml (Ketos dependencies)
├── src/
│   ├── main.rs (Rust entry point)
│   └── graindualwifi.ket (Ketos program)
├── config/
│   └── graindualwifi.edn (configuration)
└── systemd/
    └── graindualwifi.service (system daemon)
```

### Ketos Program Outline

```lisp
;; graindualwifi.ket - Dual-wifi failover daemon

(define (check-interface-up? iface)
  "Check if network interface is UP"
  ;; Run: ip link show {iface}
  ;; Parse output for "state UP"
  )

(define (check-gateway-reachable? iface)
  "Ping local gateway through specific interface"
  ;; Run: ping -I {iface} -c 1 -W 1 {gateway}
  ;; Return true if successful
  )

(define (check-internet-reachable? iface)
  "Check if internet is reachable through interface"
  ;; Try multiple test hosts
  ;; Run: curl --interface {iface} --max-time 5 https://1.1.1.1
  ;; Return true if any succeed
  )

(define (health-check iface)
  "Three-level health check"
  (and (check-interface-up? iface)
       (check-gateway-reachable? iface)
       (check-internet-reachable? iface)))

(define (failover-to-secondary!)
  "Switch to secondary connection"
  ;; Log the failover
  ;; nmcli connection down primary
  ;; nmcli connection up secondary
  )

(define (failback-to-primary!)
  "Switch back to primary connection"
  ;; Log the failback
  ;; nmcli connection up primary
  ;; (automatically takes over due to metric)
  )

(define (monitor-loop config state)
  "Main monitoring loop"
  (let ((primary-health (health-check (:primary-interface config)))
        (secondary-health (health-check (:secondary-interface config))))
    
    ;; State machine logic
    (cond
      ;; Currently on primary, check if we need to fail over
      ((eq? (:active state) :primary)
       (if (>= (:primary-failures state) 3)
         (do
           (failover-to-secondary!)
           (assoc state :active :secondary :failover-time (now)))
         (if primary-health
           (assoc state :primary-failures 0)
           (assoc state :primary-failures (+ (:primary-failures state) 1)))))
      
      ;; Currently on secondary, check if we can fail back
      ((eq? (:active state) :secondary)
       (if (and (>= (:primary-successes state) 3)
                (> (- (now) (:failover-time state)) 30000)) ; 30 sec min
         (do
           (failback-to-primary!)
           (assoc state :active :primary :primary-successes 0))
         (if primary-health
           (assoc state :primary-successes (+ (:primary-successes state) 1))
           (assoc state :primary-successes 0)))))))

(define (main)
  "Main entry point"
  (let ((config (load-config "config/graindualwifi.edn"))
        (initial-state {:active :primary
                       :primary-failures 0
                       :primary-successes 0
                       :failover-time 0}))
    
    (loop (state initial-state)
      (let ((new-state (monitor-loop config state)))
        (sleep (:check-interval config))
        (recur new-state)))))
```

---

## Configuration File

**config/graindualwifi.edn**:

```clojure
{:primary-interface "wlp1s0"
 :primary-name "Starlink"
 :primary-gateway "192.168.1.1"
 
 :secondary-interface "wlp2s0"
 :secondary-name "Cellular"
 :secondary-gateway "192.168.2.1"
 
 :test-hosts ["1.1.1.1" "8.8.8.8" "github.com"]
 
 :check-interval 10000  ; milliseconds (10 seconds)
 :failover-check-interval 2000  ; 2 seconds during transition
 :failback-min-time 30000  ; 30 seconds minimum on secondary
 
 :failure-threshold 3  ; consecutive failures to trigger failover
 :success-threshold 3  ; consecutive successes to trigger failback
 
 :log-file "/var/log/graindualwifi.log"
 :log-level "info"}
```

---

## Systemd Integration

**systemd/graindualwifi.service**:

```ini
[Unit]
Description=Grain Dual-Wifi Failover Daemon
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/graindualwifi
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

# Run as root (needed for nmcli network changes)
User=root

[Install]
WantedBy=multi-user.target
```

---

## Building with Ketos

### Cargo.toml

```toml
[package]
name = "graindualwifi"
version = "0.1.0"
edition = "2021"

[dependencies]
ketos = "0.12"
serde = "1.0"
serde_derive = "1.0"
```

### Build Commands

```bash
# Build the Ketos program
cargo build --release

# Install to system
sudo cp target/release/graindualwifi /usr/local/bin/

# Install systemd service
sudo cp systemd/graindualwifi.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable graindualwifi
sudo systemctl start graindualwifi

# Check status
sudo systemctl status graindualwifi
journalctl -u graindualwifi -f
```

---

## Testing Strategy

### Manual Tests

1. **Simulate Starlink failure**:
   ```bash
   sudo nmcli connection down Starlink
   # Watch logs: should failover to Cellular within 30 seconds
   ```

2. **Simulate Starlink recovery**:
   ```bash
   sudo nmcli connection up Starlink
   # Watch logs: should failback to Starlink after 30 seconds
   ```

3. **Check current status**:
   ```bash
   graindualwifi status
   # Shows: Active interface, health status, failover count
   ```

### Automated Tests

- Unit tests for health check functions
- Integration tests with mock network interfaces
- Stress test: rapid switching scenarios

---

## Future Enhancements

### Phase 2 (Alpine/Redox)
- Port to Alpine Linux (musl-based)
- Port to Redox OS (when Ketos is mature)
- Add s6 supervision integration

### Phase 3 (Intelligence)
- Learn usage patterns (time of day, weather correlation)
- Predictive failover (switch before failure)
- Bandwidth-based routing (use both simultaneously)

### Phase 4 (Multi-device)
- Coordinate across multiple devices
- Mesh networking between Framework + phone
- Distributed health checks

---

## The Lovers ♍ Wisdom

**Two paths become one**:
- Starlink (sky, fast, unreliable) 
- Cellular (ground, slow, stable)
- Union = always-on internet (best of both)

**Discriminating love**:
- Choose the working connection
- No judgment, just functionality
- Both are blessed, use what works NOW

**Precision**:
- 3 consecutive checks (not hasty)
- 30 second minimum (not flapping)
- Detailed logging (learn from history)

---

**This is chartcourse navigation**: When the path ahead is blocked (Starlink down), we choose the alternate route (cellular). Both paths lead home.

🌾 **now == next + 1**

