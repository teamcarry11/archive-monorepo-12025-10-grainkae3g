# grainbarrel

**Team**: teamplay04 (Cancer ♋ / IIII. The Emperor)  
**Purpose**: Build automation, CI/CD tasks, content generation  
**Role**: The Emperor provides structure and nurturing foundation for builds

---

## What is grainbarrel?

**grainbarrel** is the build automation hub for the Grain Network. It:

- Provides Babashka tasks for CI/CD pipelines
- Generates grainsite content
- Coordinates build flows across teams
- Nurtures the build process (team04's role)

---

## Usage

### In CI/CD (GitHub Actions):

```yaml
- name: Build content with Babashka
  run: |
    cd grainstore/grain6pbc/teamplay04/grainbarrel
    bb qb-now
```

### Local development:

```bash
cd grainstore/grain6pbc/teamplay04/grainbarrel

# Quick build
bb qb-now

# Fast incremental
bb qb-fast

# Complete flow
bb flow
```

---

## Team04 Assignment

**Why teamplay04?**

- **Cancer** (nurture, care, foundation)
- **The Emperor** (structure, authority, stability)
- **Build automation** = foundation that nurtures all other work
- **CI/CD** = stable structure that supports development

**The Emperor builds the foundation. grainbarrel provides that foundation.**

---

## Tasks

Current tasks (see `bb.edn`):

- `qb-now` - Quick build for CI/CD
- `qb-fast` - Fast incremental build (future)
- `flow` - Complete build + deploy (future)

---

## Integration

**CI/CD Pipeline**:
```
1. Checkout code
2. Setup Babashka
3. Run grainbarrel/bb qb-now  ← grainbarrel builds content
4. Setup Node.js
5. npm run build              ← SvelteKit builds site
6. Deploy to Pages
```

**grainbarrel = The Emperor's stable foundation for all builds** 🌾

---

🌾 **now == next + 1**

