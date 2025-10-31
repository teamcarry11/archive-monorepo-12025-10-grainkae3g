# redox-keygen-rs - Pure Rust SSH Key Generator

**🌊 Airbender Mode**: Generate ed25519 SSH keys in pure Rust  
**Kid-Friendly**: Simple tool that generates keys the Rust way  
**Purpose**: Generate SSH keys for Redox without needing ssh-keygen

---

## why rust?

**pure rust**: no dependency on ssh-keygen or openssh  
**perfect for redox**: everything in rust, including key generation  
**ed25519**: small, fast, secure keys (perfect for redox!)

---

## build

```bash
cd scripts/redox-keygen-rs
cargo build --release
```

**output**: `target/release/redox-keygen-rs`

---

## usage

**generate keys**:
```bash
./target/release/redox-keygen-rs
```

**custom output directory**:
```bash
./target/release/redox-keygen-rs /custom/path/to/.ssh
```

**default location**: `~/.ssh/id_ed25519_redox` and `~/.ssh/id_ed25519_redox.pub`

---

## what it does

1. generates ed25519 private key (using ssh-key crate)
2. derives public key from private key
3. writes keys in openssh format
4. sets correct permissions (600 for private, 644 for public)
5. displays public key for easy copying

---

## dependencies

- `ssh-key` crate (pure rust ssh key handling)
- `anyhow` (error handling)

**features**: ed25519 support enabled

---

## integration

**used by**: `redox-add-ssh-keys.sh`  
**purpose**: generate keys in rust, then add to redox config

---

**airbender mode**: pure rust key generation, flowing into redox! 🌊

