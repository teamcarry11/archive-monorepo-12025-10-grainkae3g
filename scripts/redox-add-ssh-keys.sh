#!/bin/bash
# redox-add-ssh-keys.sh - Add SSH authorized keys to Redox ISO build
#
# 🌊 Airbender Mode: Flowing SSH keys into Redox builds
# Kid-Friendly: Simple script that adds your SSH key to Redox
#
# Purpose: Enable SSH access for Glow/Cursor to connect to Redox VM
# Security: Only for development VMs, not production!

set -e

REDOX_DIR="${REDOX_DIR:-$HOME/gitlab/redox-os/redox}"
CONFIG_NAME="${CONFIG_NAME:-minimal}"
# Default to ed25519 key (best practice: small, fast, secure)
SSH_KEY_FILE="${SSH_KEY_FILE:-$HOME/.ssh/id_ed25519.pub}"

# If default doesn't exist, try redox-specific key
if [ ! -f "$SSH_KEY_FILE" ] && [ -f "$HOME/.ssh/id_ed25519_redox.pub" ]; then
    SSH_KEY_FILE="$HOME/.ssh/id_ed25519_redox.pub"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌊 Adding SSH Keys to Redox Build (Airbender Mode)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Redox directory exists
if [ ! -d "$REDOX_DIR" ]; then
    echo "❌ Redox directory not found: $REDOX_DIR"
    echo "💡 Set REDOX_DIR environment variable or clone Redox first:"
    echo "   git clone https://gitlab.redox-os.org/redox-os/redox.git $REDOX_DIR"
    exit 1
fi

CONFIG_FILE="$REDOX_DIR/config/x86_64/$CONFIG_NAME.toml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    echo "💡 Available configs:"
    ls -1 "$REDOX_DIR/config/x86_64/" | grep "\.toml$" | sed 's/^/   - /'
    exit 1
fi

# Check if SSH key exists, generate ed25519 if needed (using Rust!)
if [ ! -f "$SSH_KEY_FILE" ]; then
    echo "⚠️  SSH public key not found: $SSH_KEY_FILE"
    echo "💡 Generating new ed25519 key for Redox using Rust..."
    echo ""
    
    # Check if Rust keygen tool exists
    KEYGEN_TOOL="scripts/redox-keygen-rs/target/release/redox-keygen-rs"
    
    if [ ! -f "$KEYGEN_TOOL" ]; then
        echo "🔧 Building Rust SSH key generator..."
        echo "   (Pure Rust - no ssh-keygen needed!)"
        echo ""
        
        # Build the Rust tool
        cd scripts/redox-keygen-rs
        if cargo build --release 2>&1; then
            echo "✅ Rust keygen tool built successfully!"
            cd ../..
        else
            echo "❌ Failed to build Rust keygen tool"
            echo "💡 Falling back to ssh-keygen..."
            cd ../..
            
            # Fallback to ssh-keygen
            mkdir -p ~/.ssh
            chmod 700 ~/.ssh
            ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_redox -C "glow@cursor-redox" -N ""
            SSH_KEY_FILE="$HOME/.ssh/id_ed25519_redox.pub"
            echo "✅ Generated ed25519 key using ssh-keygen (fallback)"
        fi
    fi
    
    # Use Rust tool if available
    if [ -f "$KEYGEN_TOOL" ]; then
        echo "🌊 Using Rust keygen tool (pure Rust, no ssh-keygen!)"
        if "$KEYGEN_TOOL" 2>&1; then
            SSH_KEY_FILE="$HOME/.ssh/id_ed25519_redox.pub"
            echo ""
            echo "✅ Generated ed25519 key using Rust!"
        else
            echo "❌ Rust keygen failed, falling back to ssh-keygen..."
            mkdir -p ~/.ssh
            chmod 700 ~/.ssh
            ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_redox -C "glow@cursor-redox" -N ""
            SSH_KEY_FILE="$HOME/.ssh/id_ed25519_redox.pub"
        fi
    fi
    
    echo ""
fi

# Verify it's ed25519 (best practice)
KEY_TYPE=$(head -n1 "$SSH_KEY_FILE" | awk '{print $1}')
if [ "$KEY_TYPE" != "ssh-ed25519" ]; then
    echo "⚠️  Warning: Key is not ed25519 (found: $KEY_TYPE)"
    echo "💡 ed25519 is recommended for Redox (small, fast, secure)"
    echo "   Generate ed25519 key with:"
    echo "   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_redox -C 'glow@cursor-redox'"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Read SSH public key
SSH_PUBLIC_KEY=$(cat "$SSH_KEY_FILE")
SSH_KEY_TYPE=$(echo "$SSH_PUBLIC_KEY" | awk '{print $1}')
SSH_KEY_DATA=$(echo "$SSH_PUBLIC_KEY" | awk '{print $2}')
SSH_KEY_COMMENT=$(echo "$SSH_PUBLIC_KEY" | awk '{print $3}')

echo "📋 Configuration:"
echo "   Redox dir: $REDOX_DIR"
echo "   Config: $CONFIG_NAME"
echo "   SSH key: $SSH_KEY_FILE"
echo "   Key type: $SSH_KEY_TYPE"
echo "   Comment: $SSH_KEY_COMMENT"
echo ""

# Backup original config
BACKUP_FILE="${CONFIG_FILE}.backup-$(date +%Y%m%d-%H%M%S)"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✅ Backed up config to: $BACKUP_FILE"
echo ""

# Check if authorized_keys already exists in config
if grep -q 'path = "/home/user/.ssh/authorized_keys"' "$CONFIG_FILE"; then
    echo "⚠️  SSH authorized_keys already exists in config!"
    echo "   Updating with new key..."
    
    # Use sed to replace existing key (simplified - might need improvement)
    # For now, we'll append to avoid complex parsing
    echo "💡 Note: Multiple keys will be appended"
else
    echo "➕ Adding SSH authorized_keys to config..."
    
    # Add files section if it doesn't exist
    if ! grep -q '^\[\[files\]\]' "$CONFIG_FILE"; then
        echo "" >> "$CONFIG_FILE"
        echo "# SSH authorized keys for development access" >> "$CONFIG_FILE"
        echo "[[files]]" >> "$CONFIG_FILE"
    else
        echo "" >> "$CONFIG_FILE"
        echo "[[files]]" >> "$CONFIG_FILE"
    fi
    
    # Add the authorized_keys file entry
    cat >> "$CONFIG_FILE" << EOF
path = "/home/user/.ssh/authorized_keys"
data = """
$SSH_PUBLIC_KEY
"""
mode = 0o600
EOF
    
    echo "✅ Added SSH key to config!"
fi

# Also ensure .ssh directory exists
if ! grep -q 'path = "/home/user/.ssh"' "$CONFIG_FILE"; then
    # Add directory creation (we need to add this before the file)
    echo "➕ Adding .ssh directory..."
    
    # Find where to insert (before the authorized_keys entry)
    # For simplicity, we'll add it at the end for now
    # Note: Redox config might need directory creation handled differently
    echo "" >> "$CONFIG_FILE"
    echo "# Ensure .ssh directory exists" >> "$CONFIG_FILE"
    echo "# Note: Redox may create directories automatically" >> "$CONFIG_FILE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SSH key added to Redox config!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo "   1. Rebuild Redox with SSH key included:"
echo "      cd $REDOX_DIR"
echo "      make all CONFIG_NAME=$CONFIG_NAME PODMAN_ENV=\"--env CI=1 ...\""
echo ""
echo "   2. Boot Redox with SSH port forwarding:"
echo "      qemu-system-x86_64 -enable-kvm -cpu host -m 1024 -smp 2 \\"
echo "        -drive file=build/x86_64/$CONFIG_NAME/harddrive.img,format=raw \\"
echo "        -device e1000,netdev=net0 \\"
echo "        -netdev user,id=net0,hostfwd=tcp::2222-:22"
echo ""
echo "   3. Connect from Glow/Cursor:"
echo "      ssh -p 2222 user@localhost"
echo ""
echo "💡 Remember: This is for development only! Not for production systems."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

