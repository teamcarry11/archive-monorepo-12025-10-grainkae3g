// graindualwifi - Dual-wifi failover daemon
// Written in Ketos (Rust Lisp) for Ubuntu
// Team 06 - Precision (Virgo ♍ / VI. The Lovers)

use ketos::{Interpreter, Error};
use std::fs;
use std::path::Path;

/// Load and run the Ketos program
fn main() -> Result<(), Error> {
    // Initialize logging
    env_logger::init();
    log::info!("🌾 graindualwifi starting...");
    
    // Create Ketos interpreter
    let interp = Interpreter::new();
    
    // Load configuration
    let config_path = std::env::var("GRAINDUALWIFI_CONFIG")
        .unwrap_or_else(|_| "config/graindualwifi.edn".to_string());
    
    log::info!("📋 Loading configuration from: {}", config_path);
    
    // Load the main Ketos program
    let ketos_program_path = "src/graindualwifi.ket";
    
    if !Path::new(ketos_program_path).exists() {
        log::error!("❌ Ketos program not found: {}", ketos_program_path);
        log::info!("💡 Running in stub mode (logging only)...");
        run_stub_mode();
        return Ok(());
    }
    
    log::info!("📜 Loading Ketos program: {}", ketos_program_path);
    let ketos_code = fs::read_to_string(ketos_program_path)
        .expect("Failed to read Ketos program");
    
    // Execute the Ketos program
    log::info!("🚀 Executing Ketos program...");
    interp.run_code(&ketos_code, None)?;
    
    // Call the main function from Ketos
    log::info!("💕 Starting dual-wifi monitor (The Lovers choose wisely)...");
    interp.call("main", vec![])?;
    
    Ok(())
}

/// Stub mode - runs basic logging without full Ketos program
/// This allows testing the daemon infrastructure before Ketos is complete
fn run_stub_mode() {
    log::info!("🌾 STUB MODE - graindualwifi daemon");
    log::info!("   This would monitor:");
    log::info!("   - Primary: Starlink (wlp1s0)");
    log::info!("   - Secondary: Cellular (wlp2s0)");
    log::info!("");
    log::info!("   Health checks every 10 seconds");
    log::info!("   Failover after 3 consecutive failures");
    log::info!("   Failback after 3 consecutive successes");
    log::info!("");
    log::info!("✨ The Lovers bless both paths!");
    log::info!("💕 Choose the working connection with love and precision.");
    log::info!("");
    log::info!("🚧 Full Ketos implementation pending...");
    log::info!("   Create: src/graindualwifi.ket");
    log::info!("");
    
    // Keep the daemon alive in stub mode
    loop {
        std::thread::sleep(std::time::Duration::from_secs(60));
        log::info!("💕 Stub mode heartbeat - graindualwifi is running");
    }
}

