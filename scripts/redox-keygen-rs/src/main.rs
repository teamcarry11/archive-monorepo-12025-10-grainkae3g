// redox-keygen-rs - Generate ed25519 SSH keys in Rust
//
// 🌊 Airbender Mode: Flowing keys through Rust (pure Rust, no ssh-keygen!)
// Kid-Friendly: Simple tool that generates SSH keys the Rust way
//
// Purpose: Generate ed25519 SSH keys for Redox using pure Rust
// Library: ssh-key crate (pure Rust SSH key handling)

use anyhow::{Context, Result};
use ssh_key::{rand_core::OsRng, Algorithm, LineEnding, PrivateKey, PublicKey};
use std::fs;
use std::path::PathBuf;

fn main() -> Result<()> {
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("🌊 Generating ed25519 SSH Keys in Rust (Airbender Mode)");
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("");

    // Get output directory from args or use default
    let output_dir = std::env::args()
        .nth(1)
        .map(PathBuf::from)
        .unwrap_or_else(|| {
            let home = std::env::var("HOME").unwrap_or_else(|_| ".".to_string());
            PathBuf::from(home).join(".ssh")
        });

    // Create output directory if it doesn't exist
    fs::create_dir_all(&output_dir)
        .context("Failed to create output directory")?;

    // Set permissions on .ssh directory (700)
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mut perms = fs::metadata(&output_dir)?.permissions();
        perms.set_mode(0o700);
        fs::set_permissions(&output_dir, perms)?;
    }

    let private_key_path = output_dir.join("id_ed25519_redox");
    let public_key_path = output_dir.join("id_ed25519_redox.pub");

    // Check if keys already exist
    if private_key_path.exists() || public_key_path.exists() {
        println!("⚠️  SSH keys already exist:");
        if private_key_path.exists() {
            println!("   Private: {}", private_key_path.display());
        }
        if public_key_path.exists() {
            println!("   Public:  {}", public_key_path.display());
        }
        println!("");
        println!("💡 Delete existing keys first if you want to regenerate:");
        println!("   rm {} {}", private_key_path.display(), public_key_path.display());
        return Ok(());
    }

    println!("🔑 Generating ed25519 key pair...");
    println!("   Output directory: {}", output_dir.display());
    println!("");

    // Generate ed25519 private key
    // Algorithm::Ed25519 - perfect for Redox: small, fast, secure!
    // Using OsRng (cryptographically secure random number generator)
    let mut rng = OsRng;
    let private_key = PrivateKey::random(&mut rng, Algorithm::Ed25519)
        .context("Failed to generate ed25519 private key")?;

    // Get public key from private key
    let public_key = private_key.public_key();

    // Serialize private key to OpenSSH format
    let private_key_openssh = private_key
        .to_openssh(LineEnding::LF)
        .context("Failed to serialize private key")?;

    // Serialize public key to OpenSSH format
    let public_key_openssh = public_key
        .to_openssh()
        .context("Failed to serialize public key")?;

    // Write private key (with comment for Redox)
    let private_key_with_comment = format!("{}\n", private_key_openssh);
    fs::write(&private_key_path, private_key_with_comment)
        .context("Failed to write private key file")?;

    // Set permissions on private key (600 - owner read/write only)
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mut perms = fs::metadata(&private_key_path)?.permissions();
        perms.set_mode(0o600);
        fs::set_permissions(&private_key_path, perms)?;
    }

    // Write public key (with comment for Redox)
    let public_key_with_comment = format!("{} glow@cursor-redox\n", public_key_openssh.trim());
    fs::write(&public_key_path, public_key_with_comment)
        .context("Failed to write public key file")?;

    // Set permissions on public key (644 - owner read/write, others read)
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mut perms = fs::metadata(&public_key_path)?.permissions();
        perms.set_mode(0o644);
        fs::set_permissions(&public_key_path, perms)?;
    }

    println!("✅ Ed25519 SSH key pair generated successfully!");
    println!("");
    println!("📋 Key details:");
    println!("   Algorithm: ed25519 (small, fast, secure!)");
    println!("   Private key: {}", private_key_path.display());
    println!("   Public key:  {}", public_key_path.display());
    println!("   Comment: glow@cursor-redox");
    println!("");

    // Display public key (for easy copying)
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("📋 Public Key (add this to Redox authorized_keys):");
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("{}", public_key_with_comment.trim());
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("");

    println!("💡 Next steps:");
    println!("   1. Add public key to Redox config:");
    println!("      ./scripts/redox-add-ssh-keys.sh");
    println!("");
    println!("   2. Rebuild Redox with SSH support");
    println!("");
    println!("   3. Connect to Redox VM:");
    println!("      ssh -p 2222 -i {} user@localhost", private_key_path.display());
    println!("");
    println!("🌊 Airbender mode: Keys generated in pure Rust, flowing into Redox!");
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    Ok(())
}

