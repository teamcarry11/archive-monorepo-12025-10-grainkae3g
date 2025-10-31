# graindaemon-grainmirror-transform08

**Grain Network daemon for syncing teamkae3gtransform08 files to grainstore**

## Overview

This daemon automatically syncs markdown files from the GitHub repo (`~/github/kae3g/teamkae3gtransform08/`) to the grainstore (`grainstore/kae3g/teamkae3gtransform08/`).

**Why Steel?** Steel is the unified scripting language for Grain Network. This daemon runs natively on Redox OS, compiles to WASM for ICP canisters, and provides memory safety through Rust's ownership system.

## Files

- `scripts/grainmirror-transform08.scm` - Main sync logic (can run standalone)
- `scripts/graindaemon-grainmirror-transform08.scm` - Daemon wrapper (signal handling, service management)
- `configs/s6/grainmirror-transform08/run` - s6 run script (supervision integration)

## Usage

### Standalone (run once)

```bash
steel scripts/grainmirror-transform08.scm sync
```

### Daemon mode (manual)

```bash
steel scripts/grainmirror-transform08.scm daemon 300  # Sync every 5 minutes
```

### s6 supervision (recommended)

```bash
# Start daemon
s6-svc -u /home/xy/kae3g/grainkae3g/configs/s6/grainmirror-transform08

# Stop daemon
s6-svc -d /home/xy/kae3g/grainkae3g/configs/s6/grainmirror-transform08

# Check status
s6-svstat /home/xy/kae3g/grainkae3g/configs/s6/grainmirror-transform08
```

## Configuration

Set environment variables:

- `GRAINMIRROR_INTERVAL` - Sync interval in seconds (default: 300 = 5 minutes)
- `GRAINMIRROR_SOURCE_DIR` - Source directory (default: `/home/xy/github/kae3g/teamkae3gtransform08`)
- `GRAINMIRROR_TARGET_DIR` - Target directory (default: `/home/xy/kae3g/grainkae3g/grainstore/kae3g/teamkae3gtransform08`)

## Architecture

**Why this structure?**

1. **Main script** (`grainmirror-transform08.scm`): Pure sync logic, testable, reusable
2. **Daemon wrapper** (`graindaemon-grainmirror-transform08.scm`): Service concerns (signals, supervision)
3. **s6 run script**: Integration with supervision system

**Separation of concerns**: We can test sync logic independently, then wrap it in daemon infrastructure when needed.

## Future Enhancements

- Graintime-stamped logs (full astronomical context)
- Checksum verification (detect file changes)
- Atomic copies (copy to temp, then rename)
- Bidirectional sync (grainstore → GitHub)
- Progress reporting for large syncs
- Health checks for monitoring

## Notes

- Written in Steel Lisp (Scheme R5RS) for Grain Network
- Uses Glow G2 voice in comments (teaching through questions, explaining WHY)
- Follows Grain Network patterns (graintime, grainorder, etc.)

