# graindualwifi 📡💕

**Dual-wifi failover daemon for forest internet**

*Choose wisely between Starlink and cellular. The Lovers bless both paths.* ✨

---

## ✨ What It Does

Automatically switches between two internet connections when one fails!

💕 **Perfect for**:
- Forest cabins with inconsistent Starlink
- Dual-wifi laptops (Framework 16!)
- Any situation with primary + backup internet

---

## 🌾 Quick Start

### Prerequisites

```bash
# Install Rust (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verify
rustc --version
cargo --version
```

### Installation

```bash
# Clone and build
cd grainstore/grain06pbc/teamelegance06/graindualwifi
cargo build --release

# Install
sudo cp target/release/graindualwifi /usr/local/bin/

# Install systemd service
sudo cp systemd/graindualwifi.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable graindualwifi
sudo systemctl start graindualwifi
```

### Check Status

```bash
# View logs
sudo journalctl -u graindualwifi -f

# Check which connection is active
ip route | grep default
```

---

## ⚙️ Configuration

Edit `config/graindualwifi.edn`:

```clojure
{:primary-interface "wlp1s0"      ; Your Starlink interface
 :primary-name "Starlink"
 
 :secondary-interface "wlp2s0"    ; Your cellular interface
 :secondary-name "Cellular"
 
 :check-interval 10000             ; 10 seconds
 :failure-threshold 3              ; 3 failures = failover
 :success-threshold 3              ; 3 successes = failback
 
 :test-hosts ["1.1.1.1" "8.8.8.8" "github.com"]}
```

---

## 🏗️ Development Status

**Current Phase**: 🚧 Initial development

**What's ready**:
- ✅ Specification complete
- ✅ Design documented
- ✅ Project structure created

**What's next**:
- 🚧 Install Rust + Ketos
- 🚧 Implement Ketos program
- 🚧 Test on Ubuntu
- 🚧 Deploy as systemd service

---

## 🎯 Architecture

### The Lovers ♍ Design

```
┌─────────────────────────────────────────┐
│  graindualwifi daemon                   │
│                                         │
│  ┌─────────────┐     ┌─────────────┐  │
│  │  Starlink   │     │  Cellular   │  │
│  │  (primary)  │     │ (secondary) │  │
│  │  wlp1s0     │     │  wlp2s0     │  │
│  └──────┬──────┘     └──────┬──────┘  │
│         │                   │          │
│         └──────┬────────────┘          │
│                │                        │
│         [Health Monitor]                │
│                │                        │
│         [State Machine]                 │
│                │                        │
│         [NetworkManager]                │
│                │                        │
└────────────────┼────────────────────────┘
                 │
                 ▼
           Always-On Internet 💕
```

---

## 🌾 Philosophy

**The Lovers teach conscious choice**:
- Not "Starlink OR cellular" (duality)
- But "Starlink AND cellular" (union)
- Choose the working one (discrimination)
- Both paths blessed (no judgment)

**Virgo precision**:
- Health checks (verify, don't assume)
- Hysteresis (prevent flapping)
- Logging (learn from patterns)
- Predictable (no surprises)

**For chartcourse**:
- Navigation requires reliable connection
- Education requires stable access
- This tool enables both

---

## 📁 Files

- `SPEC.md` - Complete technical specification
- `README.md` - This file
- `Cargo.toml` - Rust dependencies (pending)
- `src/main.rs` - Rust entry point (pending)
- `src/graindualwifi.ket` - Ketos program (pending)
- `config/graindualwifi.edn` - Configuration (pending)
- `systemd/graindualwifi.service` - Systemd service (pending)

---

## 🙏 Dedication

**For the forest cabin** in Caspar, California.

Where the internet comes from the sky (Starlink) and the earth (cellular), and we need both to chart our course.

---

🌾 **now == next + 1**

