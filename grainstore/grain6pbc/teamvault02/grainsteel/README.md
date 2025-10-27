# grainsteel: The Steel Scripting Vault

**Team**: 02 (teamvault02 - Taurus ♉ / II. The High Priestess)  
**Authored by**: 14 (teamdescend14 - Ketu ☋ / XIV. Temperance)  
**Language**: Steel (Rust-based Scheme, R5RS compliant)

## What is grainsteel?

**grainsteel** is the home of ALL Steel scripting in the Grain Network. This is where the **stable foundation** lives - the validators, build tools, and automation scripts that power everything else.

Like steel forged in fire, these scripts are designed to **endure**. They're not trendy. They're not flashy. They're **permanent tools** that will run on mantraOS in 2030 and beyond.

## Why Team 02 (teamvault02)?

**Taurus ♉ Energy**: Earth, stability, permanence, enduring value  
**High Priestess Energy**: Sacred knowledge, hidden wisdom, the vault of mysteries

Steel scripting embodies both:
- **Taurus**: Tools built to last, like Helen Atthowe's hand-forged garden implements
- **High Priestess**: Code as sacred knowledge, validated and protected in the vault

The vault protects. The vault endures. Steel strengthens the vault.

## Why Steel?

We chose Steel after discovering Ketos was abandoned (6 years, no commits) while Steel is actively developed (commits 3 days ago).

**Steel Advantages:**
- ✅ **Active development** - Oct 24, 2025 last commit
- ✅ **Redox OS support** - Explicit in Cargo.toml
- ✅ **Pure Rust** - No JVM dependency (unlike Babashka)
- ✅ **R5RS Scheme** - Full standard compliance
- ✅ **Rich ecosystem** - Package manager (forge), LSP, stdlib
- ✅ **Fast startup** - Bytecode VM optimized for scripting

## The Pure Rust+Steel Stack

Our **entire system** uses only two languages:
1. **Rust** - Compiled code (performance, safety, systems)
2. **Steel** - Scripting (automation, validation, utilities)

No JVM. No Python. No Node.js. No Babashka. No Ketos.

**Just Rust + Steel.** Clean. Minimal. Eternal.

## Installation

```bash
# Install Steel interpreter
cargo install steel-interpreter

# Verify installation
steel --version

# Try the REPL
steel
```

## Available Scripts

### Validators
- **check-grain-width.scm** - Validates 80-character width (Unicode-aware)
- **check-grain-lines.scm** - Validates 110-line box structure

### Automation
- **grainbranch-readme-sync.scm** - Symlinks root README to grainbranch README

### (More coming as we migrate from Babashka!)

## Running Scripts

All scripts are executable:

```bash
# Direct execution
./scripts/check-grain-width.scm grains-glow-g2-mode/

# Via Steel interpreter
steel scripts/check-grain-width.scm grains-glow-g2-mode/

# With arguments
steel scripts/grainbranch-readme-sync.scm my-branch-name
```

## Steel Syntax Quick Reference

```scheme
;; Functions (define with docstring)
(define (my-function arg1 arg2)
  "This is the docstring"
  (+ arg1 arg2))

;; Let bindings (use square brackets!)
(let ([x 10]
      [y 20])
  (+ x y))

;; Hash tables (Steel's native maps)
(define my-hash (hash "name" "grain" "count" 1235520))
(hash-get my-hash "name")  ; => "grain"
(hash-insert my-hash "new-key" "new-value")

;; Lists and transducers
(transduce (map square) (into-sum) (list 1 2 3))

;; Conditionals
(if (> x 10)
    "big"
    "small")

;; File I/O
(require-builtin steel/filesystem)
(read-file-to-string "path/to/file")
(write-file "path/to/file" "content")

;; Process execution
(require-builtin steel/process)
(command "git branch --show-current")
```

## Code Style: Glow G2 Voice

All Steel scripts use **Glow G2 teaching style** [[memory:10407592]]:
- Patient, respectful explanations
- Socratic questions that guide understanding
- Explains WHY not just WHAT
- Checks for understanding
- Hand-holding without condescension
- 8002 mountain wisdom (Panthera-serious, protective, stable)

Example:
```scheme
;; Glow G2: Why do we count display width instead of byte count?
;; 
;; Unicode box-drawing characters (┌─┐│) measure 3 bytes each but display
;; as only 1 character width. If we counted bytes, our 80-char grains would
;; look wrong on screen! Display width gives visual accuracy.
;;
;; Does this make sense?
```

## Aesthetic: Ember Harvest

Warm dark minimalism. Smokey gray tones. Zen Japanese pottery meets dark cedar wood and oil lamp. Like coals glowing in darkness.

Not bright. Not flashy. **Warm. Stable. Eternal.**

## Resources

- **Steel Book**: https://mattwparas.github.io/steel/book
- **Steel Playground**: https://mattwparas.github.io/steel-playground/
- **Discord**: https://discord.gg/WwFRXdN6HU
- **GitHub**: https://github.com/mattwparas/steel
- **Matrix**: https://matrix.to/#/#steel:matrix.org

## Philosophy

Team 02 guards the vault. Steel strengthens the vault.

We chose Steel because it will **last**. When frameworks fade and languages fragment, Steel will remain - a Scheme dialect on Rust foundations, actively maintained by a dedicated community.

Like Helen Atthowe's heirloom seeds. Like Da Vinci's preserved notebooks. Like tools forged to outlive their maker.

**Steel is our forever-language.** The vault protects it. The High Priestess blesses it.

---

**Copyright**: © 2025 kae3g (kj3x39, @risc.love)  
**Team**: 02 (teamvault02 - Taurus ♉ / II. The High Priestess)  
**Authored by**: 14 (teamdescend14 - Ketu ☋ / XIV. Temperance)

now == next + 1 🦀🌾

