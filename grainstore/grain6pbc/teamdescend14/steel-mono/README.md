# steel-mono: All Steel Scripts in One Place

This folder contains symlinks to every Steel (`.scm`) script in the Grain Network.

## Why steel-mono?

When you're working with grainscript, you want to discover all available Steel utilities in one location. Instead of hunting through team folders, come here.

## What is Steel?

**Steel** is an embeddable Scheme dialect built in Rust. It's our ONE scripting language for:
- Validators (graincard format, graintime accuracy)
- Build automation (grainbarrel tasks)
- CLI utilities (search, formatting, analysis)
- Everything previously done with Babashka or Ketos

## Why Steel over Babashka/Ketos?

- ✅ **Active development** (commits 3 days ago vs Ketos abandoned 6 years)
- ✅ **Redox OS support** (explicit in Cargo.toml)
- ✅ **Pure Rust stack** (no JVM dependency like Babashka)
- ✅ **R5RS Scheme** (full standard compliance)
- ✅ **Rich ecosystem** (package manager, LSP, standard library)
- ✅ **Fast startup** (bytecode VM, instant like Babashka)

## Installation

```bash
# Install Steel interpreter
cargo install steel-interpreter

# Verify installation
steel --version
```

## Running Scripts

All scripts are executable:

```bash
# Direct execution
./graincard-validator.scm grains/

# Via Steel interpreter
steel graincard-validator.scm grains/

# With arguments
steel grainbranch-readme-sync.scm my-branch-name
```

## Available Scripts

Symlinks will appear here as we create them. Current scripts live in:
- `grainstore/grain6pbc/teamvault02/grainsteel/scripts/*.scm` ⭐ PRIMARY
- `grainstore/grain6pbc/teamstructure10/graincard-spec/src/*.scm`
- `grainstore/grain6pbc/teambalance07/grainsearch/src/*.scm`

**Team 02 (teamvault02)** owns all Steel scripting infrastructure!

## Steel Syntax Quick Reference

```scheme
;; Functions
(define (my-function arg1 arg2)
  "Docstring here"
  (+ arg1 arg2))

;; Let bindings
(let ([x 10]
      [y 20])
  (+ x y))

;; Conditionals
(if (> x 10)
    "big"
    "small")

;; Lists
(map (lambda (x) (* x 2)) (list 1 2 3))

;; Hash tables (not Clojure maps!)
(hash "key" "value" "count" 42)
(hash-get my-hash "key")

;; Transducers (functional data processing)
(transduce (map square) (into-sum) (list 1 2 3))
```

## Resources

- **Steel Book**: https://mattwparas.github.io/steel/book
- **Steel Playground**: https://mattwparas.github.io/steel-playground/
- **Discord**: https://discord.gg/WwFRXdN6HU
- **GitHub**: https://github.com/mattwparas/steel

## Philosophy

We chose **ONE language** (Steel) to rule all scripting. This creates:
- **Consistency**: Same syntax everywhere
- **Simplicity**: Learn once, use everywhere
- **Portability**: Rust-based, runs on Redox OS
- **Longevity**: Actively maintained, modern design

Steel + Rust = The complete stack. Nothing else needed.

---

**Team**: 14 (teamdescend14 - Ketu ☋ / XIV. Temperance)  
**Author**: kae3g (kj3x39, @risc.love)

now == next + 1 🦀🌾

