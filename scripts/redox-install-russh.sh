#!/bin/bash
# redox-install-russh.sh - Install and test russh (Rust SSH library) in Redox
#
# 🌊 Airbender Mode: Flowing russh into Redox
# Kid-Friendly: Simple script to add russh SSH support
#
# Purpose: Add pure Rust SSH server to Redox for development access
# Library: russh (https://github.com/warp-tech/russh) - pure Rust SSH

set -e

REDOX_DIR="${REDOX_DIR:-$HOME/gitlab/redox-os/redox}"
COOKBOOK_DIR="$REDOX_DIR/cookbook"
RUSSH_VERSION="${RUSSH_VERSION:-0.44.0}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌊 Installing russh (Rust SSH) for Redox (Airbender Mode)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Redox directory exists
if [ ! -d "$REDOX_DIR" ]; then
    echo "❌ Redox directory not found: $REDOX_DIR"
    echo "💡 Clone Redox first:"
    echo "   git clone https://gitlab.redox-os.org/redox-os/redox.git $REDOX_DIR"
    exit 1
fi

# Check if cookbook exists
if [ ! -d "$COOKBOOK_DIR" ]; then
    echo "❌ Cookbook directory not found: $COOKBOOK_DIR"
    echo "💡 Initialize submodules:"
    echo "   cd $REDOX_DIR && git submodule update --init --recursive"
    exit 1
fi

echo "📋 Configuration:"
echo "   Redox dir: $REDOX_DIR"
echo "   Cookbook dir: $COOKBOOK_DIR"
echo "   russh version: $RUSSH_VERSION"
echo ""

# Step 1: Create russh recipe directory
RUSSH_RECIPE_DIR="$COOKBOOK_DIR/recipes/russh"
echo "📦 Step 1: Creating russh recipe..."

if [ -d "$RUSSH_RECIPE_DIR" ]; then
    echo "⚠️  russh recipe already exists at: $RUSSH_RECIPE_DIR"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping recipe creation..."
    else
        rm -rf "$RUSSH_RECIPE_DIR"
    fi
fi

if [ ! -d "$RUSSH_RECIPE_DIR" ]; then
    mkdir -p "$RUSSH_RECIPE_DIR"
    
    # Create recipe.toml for russh
    cat > "$RUSSH_RECIPE_DIR/recipe.toml" << EOF
# russh - Pure Rust SSH Server for Redox
# https://github.com/warp-tech/russh

[package]
name = "russh"
version = "$RUSSH_VERSION"
license = "MIT OR Apache-2.0"
source = "https://crates.io/api/v1/crates/russh/$RUSSH_VERSION/download"
source-name = "russh-$RUSSH_VERSION.tar.gz"

[build]
dependencies = [
    "rust",
    "openssl",
]

# Build russh as SSH server daemon
[build.script]
build = '''
cd russh-$RUSSH_VERSION
cargo build --release --target x86_64-unknown-redox
cp target/x86_64-unknown-redox/release/russh-server /install/bin/russhd
chmod +x /install/bin/russhd
'''

[install]
files = [
    { path = "/usr/bin/russhd", source = "/install/bin/russhd" },
]

# Service configuration (for s6 or redox init)
[install.files]
path = "/etc/russhd/config.toml"
data = """
# russh SSH server configuration
port = 22
host_key_path = "/etc/ssh/ssh_host_ed25519_key"
authorized_keys_path = "/home/user/.ssh/authorized_keys"
"""

# Create service directory
[install.dirs]
"/etc/russhd" = {}
"/var/run/russhd" = {}
EOF
    
    echo "✅ Created russh recipe at: $RUSSH_RECIPE_DIR/recipe.toml"
else
    echo "✅ russh recipe already exists"
fi

echo ""

# Step 2: Add russh to minimal config
CONFIG_FILE="$REDOX_DIR/config/x86_64/minimal.toml"
echo "📦 Step 2: Adding russh to minimal config..."

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

# Backup config
BACKUP_FILE="${CONFIG_FILE}.backup-$(date +%Y%m%d-%H%M%S)"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✅ Backed up config to: $BACKUP_FILE"

# Check if russh already in packages
if grep -q '^russh' "$CONFIG_FILE"; then
    echo "⚠️  russh already in config packages"
else
    # Add russh to packages section
    if grep -q '^\[packages\]' "$CONFIG_FILE"; then
        # Add after [packages] line
        sed -i '/^\[packages\]/a russh = {}' "$CONFIG_FILE"
        echo "✅ Added russh to packages"
    else
        # Add packages section
        echo "" >> "$CONFIG_FILE"
        echo "[packages]" >> "$CONFIG_FILE"
        echo "russh = {}" >> "$CONFIG_FILE"
        echo "✅ Created packages section and added russh"
    fi
fi

echo ""

# Step 3: Generate ed25519 host key for russh
echo "📦 Step 3: Generating ed25519 host key..."

HOST_KEY_DIR="$REDOX_DIR/build/host_keys"
mkdir -p "$HOST_KEY_DIR"

if [ ! -f "$HOST_KEY_DIR/ssh_host_ed25519_key" ]; then
    # Generate ed25519 host key (for SSH server)
    ssh-keygen -t ed25519 -f "$HOST_KEY_DIR/ssh_host_ed25519_key" -N "" -C "redox-host-key"
    echo "✅ Generated ed25519 host key"
else
    echo "✅ Host key already exists"
fi

# Add host key to config
if ! grep -q 'path = "/etc/ssh/ssh_host_ed25519_key"' "$CONFIG_FILE"; then
    echo "" >> "$CONFIG_FILE"
    echo "# SSH host key (ed25519)" >> "$CONFIG_FILE"
    cat >> "$CONFIG_FILE" << EOF
[[files]]
path = "/etc/ssh/ssh_host_ed25519_key"
source = "$HOST_KEY_DIR/ssh_host_ed25519_key"
mode = 0o600

[[files]]
path = "/etc/ssh/ssh_host_ed25519_key.pub"
source = "$HOST_KEY_DIR/ssh_host_ed25519_key.pub"
mode = 0o644
EOF
    echo "✅ Added host key files to config"
fi

echo ""

# Step 4: Test build (optional)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ russh recipe created and added to config!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo ""
echo "   1. Test the recipe (build russh package):"
echo "      cd $REDOX_DIR"
echo "      make cook CONFIG_NAME=minimal PACKAGE=russh"
echo ""
echo "   2. Rebuild Redox with russh included:"
echo "      cd $REDOX_DIR"
echo "      make all CONFIG_NAME=minimal \\"
echo "        PODMAN_ENV=\"--env CI=1 --env PATH=/home/poduser/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env PODMAN_BUILD=0\""
echo ""
echo "   3. Boot Redox with SSH port forwarding:"
echo "      qemu-system-x86_64 -enable-kvm -cpu host -m 1024 -smp 2 \\"
echo "        -drive file=build/x86_64/minimal/harddrive.img,format=raw \\"
echo "        -device e1000,netdev=net0 \\"
echo "        -netdev user,id=net0,hostfwd=tcp::2222-:22"
echo ""
echo "   4. Start russh server in Redox:"
echo "      # Login to Redox VM"
echo "      russhd --config /etc/russhd/config.toml &"
echo ""
echo "   5. Connect from Glow/Cursor (using ed25519 key):"
echo "      ssh -p 2222 -i ~/.ssh/id_ed25519_redox user@localhost"
echo ""
echo "💡 Note: You'll need to:"
echo "   - Add your ed25519 public key to Redox authorized_keys (use redox-add-ssh-keys.sh)"
echo "   - Test russh functionality (key exchange, authentication, etc.)"
echo "   - Contribute improvements back to Redox cookbook!"
echo ""
echo "🌊 Airbender mode: russh flows into Redox, enabling SSH access for development!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
