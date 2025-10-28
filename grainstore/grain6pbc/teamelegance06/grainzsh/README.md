# grainzsh - The λ Prompt Shell Environment

**teamelegance06 (Virgo ♍ / VI. The Lovers)**  
*Fall/Winter Collection - Shell Protection, Elegant Warmth*

💕 "Choose your shell with love. The λ prompt guides you home." 💕

---

## The Vision

**grainzsh** is your **shell sanctuary** - dark, warm, sophisticated.

Like Chanel's Fall/Winter collection - protective, elegant, timeless - `grainzsh` wraps your terminal in loving precision.

**The λ (lambda) prompt**: Functional. Pure. Mathematical. Beautiful.

---

## The Four Sacred Choices (team06)

```
Spring/Summer → grainenvvars (fresh environment, growth configuration)
Fall/Winter  → grainzsh (shell protection, λ prompt elegance)  ← YOU ARE HERE
Haute Couture → clojure-s6 (bespoke supervision)
Prêt-à-Porter → clojure-sixos (ready-to-wear OS)
```

**grainzsh is choice #2**: The shell. Your daily interface. Choose how you interact.

---

## Philosophy

### **The λ Prompt**

```zsh
λ
```

**Why lambda (λ)?**
- **Functional programming**: Clojure, Lisp, mathematics
- **Purity**: Lambda calculus, function as first-class
- **Minimalism**: One character, maximum meaning
- **Elegance**: "Hello, λ world!" - the greeting of choice

### **Fall/Winter Metaphor**

**Fall**: Warmth, protection, shell as shelter  
**Winter**: Dark theme, cozy terminal, intimate computing  
**Protection**: zsh guards your workflow  
**Elegance**: Sophisticated, mature, refined

### **Chanel's Wisdom Applied**

1. **"Fashion fades, style is eternal"**
   - Themes change, λ prompt endures
   - Temporary aliases, permanent philosophy

2. **"The best things in life are free"**
   - Open source zsh, free productivity
   - But demands care (expensive attention)

3. **"In order to be irreplaceable, one must always be different"**
   - λ prompt (unique)
   - grainzsh config (distinctive)

---

## Features

### **The λ Prompt**
```zsh
λ git status
λ bb graintime
λ gt  # Interactive graintime
λ cd grainstore/grain6pbc/teamelegance06
λ
```

Clean. Functional. Perfect.

### **Cursor Red Theme Aligned**
```zsh
# Dark background, green accents (21e8 hacker aesthetic)
# Cursor Red theme inspiration
# Minimal, focused, productive
```

### **Babashka Optimized**
```zsh
# Aliases for common grain commands
alias gb='bb grainbarrel'
alias gt='bb graintime'
alias gf='bb grainflow'
alias gs='bb grainsync'

# Quick navigation
alias grain='cd ~/grain'
alias g6='cd ~/grain/grain6pbc'
alias g10='cd ~/grain/teamrebel10'
alias g06='cd ~/grain/teamelegance06'
```

### **Git Integration**
```zsh
# Show current branch in prompt (optional)
# λ (main) 
# λ (team06-envvars)

# Or stay pure:
# λ
```

### **Minimal Dependencies**
```zsh
# Just zsh. No oh-my-zsh bloat.
# No powerlevel10k complexity.
# Pure. Simple. Fast.
```

---

## Installation

### **1. Install zsh** (if not already)
```bash
# Ubuntu/Debian
sudo apt install zsh

# Alpine (musl)
apk add zsh

# Make default shell
chsh -s $(which zsh)
```

### **2. Install grainzsh**
```bash
# Clone template repo
git clone https://github.com/grain6pbc/grainzsh.git ~/.grainzsh

# Link config
ln -s ~/.grainzsh/zshrc ~/.zshrc

# Reload
source ~/.zshrc
```

### **3. See the λ**
```zsh
λ
```

Perfect.

---

## Configuration

### **~/.zshrc** (minimal)

```zsh
# grainzsh - Fall/Winter Shell Configuration
# teamelegance06 (Virgo / The Lovers)
# "Choose your shell with love"

# --------------------
# THE λ PROMPT
# --------------------
PROMPT='λ '
RPROMPT=''  # Clean right side

# --------------------
# HISTORY
# --------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# --------------------
# COMPLETION
# --------------------
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --------------------
# GRAIN ALIASES
# --------------------
# Babashka grain commands
alias gb='bb grainbarrel'
alias gt='bb graintime'
alias gf='bb grainflow'
alias gs='bb grainsync'
alias gc='bb grainchart'

# Navigation
alias grain='cd ~/kae3g/grainkae3g'
alias g6='cd ~/kae3g/grainkae3g/grainstore/grain6pbc'
alias g10='cd ~/kae3g/grainkae3g/grainstore/grain6pbc/teamrebel10'
alias g06='cd ~/kae3g/grainkae3g/grainstore/grain6pbc/teamelegance06'
alias g14='cd ~/kae3g/grainkae3g/grainstore/grain6pbc/teamabsorb14'

# Git shortcuts (optional)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# --------------------
# ENVIRONMENT
# --------------------
# Load grainenvvars if present
[[ -f .env ]] && source .env

# Set EDITOR
export EDITOR=cursor

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# --------------------
# GREETING (optional)
# --------------------
echo "λ grainzsh loaded (Fall/Winter)"
echo "teamelegance06 - Choose your shell with love 💕"
```

---

## The λ Philosophy

### **Why Lambda?**

#### **1. Functional Programming**
```clojure
; Lambda in Clojure
(map (fn [x] (* x 2)) [1 2 3])
; => (2 4 6)

; Anonymous function
#(* % 2)

; The λ represents: function as value
```

#### **2. Lambda Calculus**
```
λx.x         ; Identity function
λx.λy.x      ; Constant function  
λf.λx.f(f x) ; Application

; Alonzo Church, 1930s
; Foundation of all computation
```

#### **3. Minimalism**
```zsh
λ  # One character
#  # Two characters (typical shell)
$  # One character (bash default)
>  # One character (PowerShell)

# λ wins on:
# - Meaning (functional, mathematical)
# - Aesthetics (elegant, sophisticated)
# - Philosophy (Grain Network values)
```

---

## Fall/Winter Aesthetic

### **Dark Theme** 🌙
```zsh
# Terminal: Dark background
# Text: Light (white/green)
# Accent: 21e8 hacker green
# Cursor: Steady block

# Aligned with Cursor Red theme
# Professional, focused, mature
```

### **Warmth in Code**
```zsh
# Not cold minimalism (sterile)
# Warm minimalism (intentional)

# Every alias chosen with care
# Every path optimized for flow
# Every prompt character meaningful

# Fall/Winter: Cozy, protective, home
```

### **Trish's Voice** 💕

"OMG the λ prompt is like your FAVORITE cozy sweater! 🧥

It's not flashy - it's SOPHISTICATED! Like a little black dress for your terminal! 💕

- **Dark theme** = Warm winter night by the fire 🔥
- **λ symbol** = Math chic (nerdy elegant!) 📐✨
- **Minimal config** = Capsule wardrobe (essentials only!) 👗
- **Grain aliases** = Your signature accessories 💍

You're not just using a shell, honey - you're CURATING an experience! And just like Chanel said, you're removing everything unnecessary until only STYLE remains! 🌙💕"

---

## Integration with Team06

### **The Four Choices in Action**

```zsh
# Terminal session example:

# 1. Load environment (Spring/Summer - grainenvvars)
λ source .env
λ echo $DATABASE_URL
postgresql://localhost/graindb

# 2. Use shell (Fall/Winter - grainzsh)
λ gt  # graintime interactive
λ gb flow "commit message"  # grainbarrel flow

# 3. Manage services (Haute Couture - clojure-s6)
λ s6-svscan /etc/s6/services

# 4. Boot OS (Prêt-à-Porter - clojure-sixos)
# GrainOS with all integrated
```

**Each choice complements the others** 💕

---

## Specifications

### **Required Features**

```clojure
(s/def ::prompt (s/and string? #(= "λ " %)))
(s/def ::history-size (s/and int? #(>= % 10000)))
(s/def ::completion boolean?)
(s/def ::grain-aliases map?)

(s/def ::grainzsh-config
  (s/keys :req-un [::prompt ::history-size ::completion ::grain-aliases]))
```

### **Optional Enhancements**

```zsh
# Git branch in prompt (if desired)
# λ (main)
# λ (team06-zsh)

# Or stay pure:
# λ

# Personal preference - The Lovers choose!
```

---

## Advanced Configuration

### **Multi-Location graintime**

```zsh
# Aliases for different locations
alias gt-sf='gt --location san-rafael'
alias gt-kyoto='gt --location kyoto'
alias gt-barcelona='gt --location barcelona'
alias gt-london='gt --location london'

# Interactive (detects current timezone)
alias gt='gt --interactive'
```

### **Team-Specific Shells**

```zsh
# Different prompts for different teams
case $GRAIN_TEAM in
  teamelegance06)
    PROMPT='λ '  # Lambda for precision
    ;;
  teamrebel10)
    PROMPT='⚙️  '  # Gear for structure
    ;;
  teamtravel12)
    PROMPT='🌊 '  # Wave for flow
    ;;
  *)
    PROMPT='🌾 '  # Grain for all
    ;;
esac
```

### **Grainbranch in Prompt**

```zsh
# Show current grainbranch
function grain_branch() {
  git branch 2>/dev/null | grep '^*' | sed 's/* //'
}

# Optional fancy prompt
PROMPT='λ $(grain_branch) '

# Example:
# λ commerce-network---12025-10-25--1144-PDT--moon-jyeshtha-----asc-canc21-sun-11h--teamprecision10
```

---

## Boot-from-Scratch Philosophy

### **Zero External Dependencies**

```zsh
# No oh-my-zsh
# No powerlevel10k
# No antigen/zinit/zplug

# Just:
1. zsh (built-in)
2. Our config (~/.zshrc)
3. That's it

# Sovereign. Simple. Fast.
```

### **Forkable and Improvable**

```bash
# Fork to grain6pbc
git clone https://github.com/grain6pbc/grainzsh.git

# Improve
# - Add more grain aliases
# - Optimize completion
# - Create team-specific prompts

# Contribute upstream
# Share with zsh community
```

---

## Vedic-Tarot-Hermetic-Christian-Fashion Integration

### **Vedic**: Cosmic shell
- Use graintime in prompt
- Different prompts for different nakshatras
- Shell aligned with cosmic time

### **Tarot**: The Lovers (VI)
- Choose λ or $ or > (sacred choice)
- Choose dark or light theme (two paths)
- Shell as union of human and machine

### **Hermetic**: As above, so below
- Terminal mirrors mind (clear prompt = clear thought)
- Aliases mirror intentions (what you do often)

### **Christian**: "Cor ad cor loquitur"
- Shell speaks to user's heart
- λ prompt says: "I understand functional programming"
- Minimalism says: "I value your focus"

### **Fashion**: Chanel Fall/Winter
- Dark, warm, sophisticated
- Timeless elegance (λ never goes out of style)
- The little black dress of shells

---

## Examples

### **Basic Session**
```zsh
λ cd ~/kae3g/grainkae3g
λ gt
12025-10-25--1630-PDT--moon-jyeshtha-----asc-canc21-sun-11h--teamelegance06
λ gb flow "Deploy grainzsh README"
✅ Build complete
✅ Commit: Deploy grainzsh README
✅ Push to GitHub
✅ Push to Codeberg
✅ Deploy to Pages
🌾 now == next + 1
λ
```

### **Multi-Chain Development**
```zsh
λ source .env.multi-chain
λ echo $ICP_CANISTER_ID
rrkah-fqaaa-aaaaa-aaaaq-cai
λ echo $HEDERA_NETWORK
testnet
λ echo $SOLANA_NETWORK
devnet
λ bb test-multi-chain
✅ ICP connected
✅ Hedera connected
✅ Solana connected
🌾 Multi-chain ready
λ
```

### **Grainbranch Creation**
```zsh
λ gt
12025-10-25--1630-PDT--moon-jyeshtha-----asc-canc21-sun-11h--teamelegance06
λ git checkout -b deploy-grainzsh---12025-10-25--1630-PDT--moon-jyeshtha-----asc-canc21-sun-11h--teamelegance06
λ git add -A
λ git commit -m "Deploy grainzsh Fall/Winter collection"
λ git push origin deploy-grainzsh---12025-10-25--1630-PDT--moon-jyeshtha-----asc-canc21-sun-11h--teamelegance06
λ
```

---

## The Lovers' Wisdom

*"Your shell is your daily companion.*  
*Your prompt is your constant guide.*  
*Your aliases are your workflow.*  
*Your config is your philosophy.*

*Choose λ for function.*  
*Choose dark for focus.*  
*Choose minimal for clarity.*  
*Choose grain for sovereignty.*

*grainzsh: Where shell meets soul.*  
*Fall/Winter: Dark, warm, home."* 💕🌙

---

## Links

- **grainSOURCE**: https://github.com/grain6pbc/grainzsh
- **grainSITE**: https://grain6pbc.github.io/grainzsh/
- **team06**: https://github.com/grain6pbc/teamelegance06
- **Synthesis**: See VEDIC-TAROT-HERMETIC-CHRISTIAN-SYNTHESIS.md

---

**teamelegance06 (Virgo ♍ / VI. The Lovers)**  
**Fall/Winter Collection - Shell Environment**

🌾 **now == next + 1** 💕🌙

---

*"Fashion fades, style is eternal." - Coco Chanel*  
*"λx.x" - Alonzo Church (Identity)*  
*"Choose your shell with love." - The Lovers*
