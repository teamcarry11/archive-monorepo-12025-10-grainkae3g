# grainenvvars - Environment Variables with Loving Precision

**teamelegance06 (Virgo ♍ / VI. The Lovers)**  
*Spring/Summer Collection - Fresh Configuration, Growth Environment*

💕 "Choose your environment with love. Every variable is a sacred choice." 💕

---

## The Vision

**grainenvvars** brings **precision** and **care** to environment variable management.

Like Chanel's Spring/Summer collection - fresh, light, perfectly tailored - `grainenvvars` makes configuration elegant, secure, and joyful.

---

## The Four Sacred Choices (team06)

```
Spring/Summer → grainenvvars (fresh environment, growth configuration)
Fall/Winter  → grainzsh (shell protection, λ prompt elegance)
Haute Couture → clojure-s6 (bespoke supervision)
Prêt-à-Porter → clojure-sixos (ready-to-wear OS)
```

**grainenvvars is choice #1**: The foundation. Choose your environment, choose your growth.

---

## Philosophy

### **The Lovers (VI) Teaching**

Every environment variable is a **choice**:
- Development vs Production (choosing reality)
- Secrets vs Public (choosing disclosure)
- Local vs Remote (choosing location)
- Now vs Later (choosing time)

**Precision is discriminating love**: Choose the right value, for the right context, at the right time.

### **Chanel's Wisdom Applied**

1. **"Simplicity is the keynote of all true elegance"**
   - Minimal .env files
   - Clear variable names
   - No redundancy

2. **"Before you leave the house, look in the mirror and remove one accessory"**
   - Remove unnecessary variables
   - Clean environment
   - Essential only

3. **"A girl should be two things: classy and fabulous"**
   - Variables should be two things: secure and clear

---

## Features

### **Secure by Design**
```bash
# Never commit secrets
.env          # Local only (in .gitignore)
.env.example  # Template (committed to git)
.env.test     # Test values (safe to commit)
```

### **Multi-Environment Support**
```bash
# Development
export GRAIN_ENV=development
source .env.development

# Production
export GRAIN_ENV=production
source .env.production

# Testing
export GRAIN_ENV=test
source .env.test
```

### **Validation & Type Checking**
```clojure
(ns grainenvvars.core
  (:require [clojure.spec.alpha :as s]))

(s/def ::port (s/and int? #(< 0 % 65536)))
(s/def ::url (s/and string? #(re-matches #"https?://.*" %)))
(s/def ::api-key (s/and string? #(= 32 (count %))))

(defn validate-env
  "Validate environment variables against specs"
  [env-map]
  (and (s/valid? ::port (:port env-map))
       (s/valid? ::url (:api-url env-map))
       (s/valid? ::api-key (:api-key env-map))))
```

### **Template Generation**
```bash
# Generate .env.example from current .env
grain envvars generate-template

# Creates .env.example with placeholder values:
# API_KEY=your-api-key-here
# DATABASE_URL=postgresql://localhost/dbname
# PORT=3000
```

### **Encryption for Secrets**
```bash
# Encrypt sensitive .env file
grain envvars encrypt .env > .env.encrypted

# Decrypt when needed
grain envvars decrypt .env.encrypted > .env
```

---

## Usage

### **Basic Setup**

1. **Create `.env` file**:
```bash
# .env (local, never committed)
DATABASE_URL=postgresql://localhost/graindb
API_KEY=your_secret_api_key_here_32_characters_long
PORT=3000
GRAIN_ENV=development
```

2. **Create `.env.example` template**:
```bash
# .env.example (committed to git, no secrets)
DATABASE_URL=postgresql://localhost/dbname
API_KEY=your-api-key-here
PORT=3000
GRAIN_ENV=development
```

3. **Add to `.gitignore`**:
```bash
# .gitignore
.env
.env.local
.env.*.local
```

4. **Load in your app**:
```clojure
(ns myapp.core
  (:require [grainenvvars.core :as env]))

(env/load!)  ; Loads .env file

(def db-url (env/get :database-url))
(def api-key (env/get :api-key))
(def port (env/get :port))
```

---

## The Spring/Summer Metaphor

### **Why Spring/Summer?**

**Spring**: Renewal, fresh start, new configuration  
**Summer**: Growth, expansion, environment flourishing  
**Fresh**: Clean .env files, no cruft  
**Light**: Minimal configuration, maximum clarity  
**Configurable**: Like spring weather - changeable, adaptable

### **Trish's Voice** 💕

"OMG this .env file is like a PERFECT spring garden! 🌸

Every variable is a little seed you plant! 💚

- `DATABASE_URL` = the soil (foundation) 🌱
- `API_KEY` = the sunshine (access to growth) ☀️
- `PORT` = the water (flow of connections) 💧
- `GRAIN_ENV` = the season (what's growing now) 🌾

You're not just setting variables, honey - you're CULTIVATING an environment! And just like Coco Chanel removing one accessory, you're keeping it CLEAN and ELEGANT! ✨💕"

---

## Integration with Team06

### **The Four Choices Work Together**

```bash
# 1. grainenvvars: Choose your environment (Spring/Summer)
export DATABASE_URL=postgresql://localhost/graindb
export GRAIN_ENV=development

# 2. grainzsh: Choose your shell (Fall/Winter)
source ~/.zshrc  # λ prompt, elegant, protective

# 3. clojure-s6: Choose what runs (Haute Couture)
s6-svscan /etc/s6/services  # Bespoke supervision

# 4. clojure-sixos: Choose your OS (Prêt-à-Porter)
# GrainOS with all of the above integrated
```

**Each choice builds on the last**: Environment → Shell → Services → OS

**All choices made with love** 💕

---

## Specifications

### **Variable Naming Convention**

```bash
# ✅ GOOD (Clear, uppercase, underscores)
DATABASE_URL
API_KEY
GRAIN_ENV
MAX_CONNECTIONS

# ❌ BAD (Mixed case, unclear)
databaseUrl
apikey
env
maxConn
```

### **Required Variables** (Specs)

```clojure
(s/def ::database-url string?)
(s/def ::api-key (s/and string? #(>= (count %) 16)))
(s/def ::port (s/and int? #(< 1023 % 65536)))
(s/def ::grain-env #{:development :production :test})

(s/def ::env-config
  (s/keys :req-un [::database-url ::api-key ::port ::grain-env]))
```

### **Validation on Load**

```clojure
(defn load!
  "Load and validate environment variables"
  []
  (let [env (load-dotenv-file ".env")
        validated (s/conform ::env-config env)]
    (if (s/invalid? validated)
      (throw (ex-info "Invalid environment configuration"
                      {:errors (s/explain-data ::env-config env)}))
      validated)))
```

---

## Security Best Practices

### **1. Never Commit Secrets**
```bash
# .gitignore (critical!)
.env
.env.local
.env.*.local
*.key
*.pem
```

### **2. Use .env.example Templates**
```bash
# Committed to git, safe
API_KEY=your-api-key-here
DATABASE_URL=postgresql://localhost/dbname
```

### **3. Rotate Keys Regularly**
```bash
# Monthly rotation
grain envvars rotate-keys --env production
```

### **4. Encrypt Sensitive Configs**
```bash
# For production deployment
grain envvars encrypt .env.production > .env.production.encrypted
scp .env.production.encrypted server:/app/
# On server:
grain envvars decrypt .env.production.encrypted > .env
```

---

## Multi-Chain Configuration Example

### **ICP + Hedera + Solana**

```bash
# .env.multi-chain
# ICP (Internet Computer)
ICP_CANISTER_ID=rrkah-fqaaa-aaaaa-aaaaq-cai
ICP_NETWORK=ic
ICP_IDENTITY=default

# Hedera (Hashgraph for B2B)
HEDERA_ACCOUNT_ID=0.0.123456
HEDERA_PRIVATE_KEY=302e020100300506032b6570...
HEDERA_NETWORK=testnet

# Solana (L2 Micropayments)
SOLANA_RPC_URL=https://api.devnet.solana.com
SOLANA_WALLET_ADDRESS=7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU
SOLANA_NETWORK=devnet

# Grain Network
GRAIN_ENV=development
GRAIN_TEAM=teamelegance06
GRAIN_MODE=trish  # 💕
```

### **Loading Multi-Chain Config**

```clojure
(defn load-multi-chain-config!
  "Load multi-chain environment configuration"
  []
  (env/load!)
  {:icp {:canister-id (env/get :icp-canister-id)
         :network (env/get :icp-network)
         :identity (env/get :icp-identity)}
   :hedera {:account-id (env/get :hedera-account-id)
            :network (env/get :hedera-network)}
   :solana {:rpc-url (env/get :solana-rpc-url)
            :wallet (env/get :solana-wallet-address)
            :network (env/get :solana-network)}
   :grain {:env (env/get :grain-env)
           :team (env/get :grain-team)
           :mode (env/get :grain-mode)}})
```

---

## Boot-from-Scratch Philosophy

### **grainenvvars is Sovereign**

```bash
# No external dependencies for core functionality
# Pure Clojure, no npm packages, no pip install

# Just:
1. Create .env file
2. Load it
3. Use it

# That's it. Simple. Elegant. Sovereign.
```

### **Forkable and Improvable**

```bash
# Fork to grain06pbc
git clone https://github.com/grain06pbc/grainenvvars.git

# Improve
# - Add better encryption
# - Add cloud sync (secure)
# - Add team-based access control

# Contribute upstream
# Professional PRs to Clojure ecosystem
```

---

## Vedic-Tarot-Hermetic-Christian-Fashion Integration

### **Vedic**: Precision timing
- Load different .env files for different moon phases
- Development during waxing moon (growth)
- Production deploy during full moon (completion)

### **Tarot**: The Lovers (VI)
- Every variable is a choice
- Choose development or production (two paths)
- Union of intention (code) and execution (environment)

### **Hermetic**: As above, so below
- Local .env mirrors production .env (correspondence)
- What works locally works remotely (reflection)

### **Christian**: "Cor ad cor loquitur" (Heart to heart)
- Clear variable names speak to developer's heart
- Configuration as communication
- Love in precision

### **Fashion**: Chanel Spring/Summer
- Fresh, light, elegant
- Remove one accessory (minimal vars)
- Timeless simplicity

---

## Installation

```bash
# Clone template repo
git clone https://github.com/grain06pbc/grainenvvars.git
cd grainenvvars

# Include in your project
# Option 1: Git submodule
git submodule add https://github.com/grain06pbc/grainenvvars.git lib/grainenvvars

# Option 2: Copy to your project
cp -r grainenvvars/* myproject/lib/grainenvvars/

# Option 3: Add to deps.edn
{:deps {grainenvvars {:git/url "https://github.com/grain06pbc/grainenvvars"
                      :sha "..."}}}
```

---

## Examples

### **Development Setup**
```bash
# .env.development
DATABASE_URL=postgresql://localhost/graindb_dev
API_KEY=sk_test_development_key
PORT=3000
GRAIN_ENV=development
LOG_LEVEL=debug
```

### **Production Setup**
```bash
# .env.production (encrypted!)
DATABASE_URL=postgresql://prod-server/graindb
API_KEY=sk_live_production_key_32chars
PORT=443
GRAIN_ENV=production
LOG_LEVEL=info
```

### **Test Setup**
```bash
# .env.test
DATABASE_URL=postgresql://localhost/graindb_test
API_KEY=sk_test_testing_key
PORT=3001
GRAIN_ENV=test
LOG_LEVEL=debug
```

---

## The Lovers' Wisdom

*"Every variable you set is a choice you make.*  
*Every environment you configure is a reality you create.*  
*Every secret you protect is a trust you honor.*  
*Every template you share is a gift you give.*

*Choose your development with care.*  
*Choose your production with wisdom.*  
*Choose your variables with love.*  
*Choose your environment with precision.*

*grainenvvars: Where configuration meets contemplation.*  
*Spring/Summer: Fresh, light, perfectly chosen."* 💕🌸

---

## Links

- **grainSOURCE**: https://github.com/grain06pbc/grainenvvars
- **grainSITE**: https://grain06pbc.github.io/grainenvvars/
- **team06**: https://github.com/grain06pbc/teamelegance06
- **Synthesis**: See VEDIC-TAROT-HERMETIC-CHRISTIAN-SYNTHESIS.md

---

**teamelegance06 (Virgo ♍ / VI. The Lovers)**  
**Spring/Summer Collection - Environment Variables**

🌾 **now == next + 1** 💕🌸

---

*"Simplicity is the keynote of all true elegance." - Coco Chanel*  
*"Cor ad cor loquitur." - Cardinal Newman*  
*"Choose wisely." - The Lovers*
