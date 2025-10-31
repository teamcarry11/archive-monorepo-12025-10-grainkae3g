# open source naming guidelines

**date**: 12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h  
**team**: teamcarry11 (t11aq, airbender mode)  
**purpose**: guidelines for naming projects inspired by others

---

## key principle

**don't use other projects' names in your project names**

**why?**
- confusion (people think you're affiliated)
- trademark issues (names may be trademarked)
- clarity (your project is separate)

**instead**:
- use your own naming
- acknowledge inspiration in docs
- be clear about relationship (inspired by, not fork of)

---

## what we changed

### before (problematic)
- `grain-aero` (uses aero name)
- "mimic aero" (suggests copying)
- could imply affiliation with aero os

### after (better)
- `grain-monolithic-compat` (our own name)
- "inspired by aero os" (clear attribution)
- clear we're separate project

---

## best practices

### ✅ good practices

**naming**:
- use your own project name
- descriptive of what you're doing
- clear it's your project

**attribution**:
- acknowledge inspiration in docs
- link to original project
- be clear about relationship

**example**:
```
# grain-monolithic-compat
Inspired by aero os (https://github.com/Andy-Python-Programmer/aero)
We study aero's monolithic kernel design, but write our own implementation.
```

---

### ❌ avoid

**naming**:
- don't use other projects' names
- don't imply affiliation
- don't suggest you're official fork

**attribution**:
- don't forget to credit inspiration
- don't copy without attribution
- don't claim as your own design

---

## examples

### good: inspired by, clear separation

**project**: `grain-monolithic-compat`  
**description**: "Monolithic-like compatibility layer for Redox, inspired by aero os design"  
**attribution**: links to aero os, clear we're separate

---

### bad: uses other project's name

**project**: `grain-aero`  
**description**: "mimic aero using redox"  
**problem**: uses aero name, implies copying/affiliation

---

## for grain network

### naming convention

**format**: `grain-<feature>-<purpose>`

**examples**:
- `grain-monolithic-compat` (not `grain-aero`)
- `grain-linux-compat` (not `grain-linux`)
- `grain-redox-integration` (not `grain-redox`)

**why**: clear it's our project, descriptive, no confusion

---

### attribution format

**in documentation**:
```markdown
## inspiration

**inspired by**: [project name] (https://link-to-project)
**design study**: we study [project]'s [feature] design
**implementation**: our own code (MIT/Apache 2.0)
**not affiliated**: grain network is not affiliated with [project]
```

**example**:
```markdown
## inspiration

**inspired by**: aero os (https://github.com/Andy-Python-Programmer/aero)
**design study**: we study aero's monolithic kernel design
**implementation**: our own code (MIT/Apache 2.0)
**not affiliated**: grain network is not affiliated with aero os
```

---

## legal considerations

### trademarks

**some project names may be trademarked**:
- using trademarked names can cause legal issues
- even if not enforced, it's best practice to avoid
- better to use descriptive names

**solution**: use your own naming, acknowledge inspiration

---

### copyright

**code copyright**:
- don't copy code without permission/license
- study design (ok, no copyright issue)
- write your own implementation (ok)

**documentation copyright**:
- don't copy documentation verbatim
- paraphrase and cite source
- write your own docs

---

## open source community norms

### respect

**show respect**:
- acknowledge inspiration
- link to original project
- don't claim as your own idea
- contribute back when possible

---

### clarity

**be clear**:
- your project is separate
- you're inspired by, not affiliated with
- you write your own code
- you respect original licenses

---

## updated files

### renamed
- `grain-aero/` → `grain-monolithic-compat/`
- `GRAIN-AERO-STRATEGY.md` → `GRAIN-MONOLITHIC-COMPAT-STRATEGY.md`

### updated
- all references to "aero" → "monolithic-compat" or "inspired by aero"
- added attribution sections
- clarified we're not affiliated

---

## summary

**do**:
- ✅ use your own project names
- ✅ acknowledge inspiration in docs
- ✅ link to original projects
- ✅ be clear about relationship

**don't**:
- ❌ use other projects' names
- ❌ imply affiliation
- ❌ forget attribution
- ❌ copy without credit

---

**airbender mode**: respect flows like water - acknowledge inspiration, use your own names! 🌊

**key insight**: open source is about collaboration and respect. naming matters!

