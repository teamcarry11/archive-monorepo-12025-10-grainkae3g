#!/bin/bash
# redox-ssh-setup-complete.sh - Complete SSH setup for Redox with ed25519 keys
#
# 🌊 Airbender Mode: Complete SSH flow for Redox development
# Kid-Friendly: One script to set up everything!
#
# This script:
# 1. Generates ed25519 SSH keys (if needed)
# 2. Adds keys to Redox config
# 3. Sets up russh recipe (if needed)
# 4. Provides instructions for building and connecting

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌊 Complete Redox SSH Setup (Airbender Mode)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will set up SSH access for Glow/Cursor to connect to Redox VM"
echo "Using ed25519 keys (small, fast, secure - perfect for Redox!)"
echo ""

# Check if we're in the right directory
if [ ! -f "scripts/redox-add-ssh-keys.sh" ]; then
    echo "❌ Please run from grainkae3g root directory"
    exit 1
fi

# Step 1: Generate ed25519 key if needed
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Setting up ed25519 SSH keys"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

REDOX_KEY="$HOME/.ssh/id_ed25519_redox"
if [ ! -f "$REDOX_KEY.pub" ]; then
    echo "🔑 Generating ed25519 SSH key for Redox using Rust..."
    echo "   (Pure Rust - no ssh-keygen needed!)"
    echo ""
    
    # Try Rust keygen first
    KEYGEN_TOOL="scripts/redox-keygen-rs/target/release/redox-keygen-rs"
    
    if [ -f "$KEYGEN_TOOL" ]; then
        echo "🌊 Using Rust keygen tool..."
        "$KEYGEN_TOOL"
    else
        echo "⚠️  Rust keygen not built yet, building it..."
        cd scripts/redox-keygen-rs
        if cargo build --release 2>&1; then
            echo "✅ Rust keygen built!"
            cd ../..
            "$KEYGEN_TOOL"
        else
            echo "❌ Rust build failed, falling back to ssh-keygen..."
            cd ../..
            mkdir -p ~/.ssh
            chmod 700 ~/.ssh
            ssh-keygen -t ed25519 -f "$REDOX_KEY" -C "glow@cursor-redox" -N ""
        fi
    fi
    
    echo ""
    echo "🔐 Security: Private key should stay on your host machine"
    echo "            Public key will be added to Redox VM"
else
    echo "✅ ed25519 key already exists: $REDOX_KEY.pub"
fi

echo ""

# Step 2: Add SSH keys to Redox config
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Adding SSH keys to Redox config"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

export SSH_KEY_FILE="$REDOX_KEY.pub"
./scripts/redox-add-ssh-keys.sh

echo ""

# Step 3: Check if russh recipe exists
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Checking russh (Rust SSH) support"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

REDOX_DIR="${REDOX_DIR:-$HOME/gitlab/redox-os/redox}"
RUSSH_RECIPE="$REDOX_DIR/cookbook/recipes/russh/recipe.toml"

if [ -f "$RUSSH_RECIPE" ]; then
    echo "✅ russh recipe already exists"
else
    echo "⚠️  russh recipe not found"
    echo "💡 To add russh support, run:"
    echo "   ./scripts/redox-install-russh.sh"
    echo ""
    read -p "Install russh now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./scripts/redox-install-russh.sh
    else
        echo "⚠️  Skipping russh installation"
        echo "   Note: You'll need an SSH server in Redox to connect"
    fi
fi

echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SSH Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Summary:"
echo "   ✅ ed25519 SSH key: $REDOX_KEY.pub"
echo "   ✅ Added to Redox config: $(basename ${CONFIG_FILE:-minimal.toml})"
if [ -f "$RUSSH_RECIPE" ]; then
    echo "   ✅ russh recipe ready"
else
    echo "   ⚠️  russh recipe needed (run redox-install-russh.sh)"
fi
echo ""
echo "📝 Next steps:"
echo ""
echo "   1. Rebuild Redox with SSH support:"
echo "      cd ${REDOX_DIR:-~/gitlab/redox-os/redox}"
echo "      make all CONFIG_NAME=minimal \\"
echo "        PODMAN_ENV=\"--env CI=1 --env PATH=/home/poduser/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env PODMAN_BUILD=0\""
echo ""
echo "   2. Boot Redox with SSH port forwarding:"
echo "      qemu-system-x86_64 -enable-kvm -cpu host -m 1024 -smp 2 \\"
echo "        -drive file=build/x86_64/minimal/harddrive.img,format=raw \\"
echo "        -device e1000,netdev=net0 \\"
echo "        -netdev user,id=net0,hostfwd=tcp::2222-:22"
echo ""
echo "   3. Connect from Glow/Cursor (using ed25519 key):"
echo "      ssh -p 2222 -i $REDOX_KEY user@localhost"
echo ""
echo "🌊 Airbender mode: SSH keys flow into Redox, enabling development access!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

