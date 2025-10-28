# Template Deployment Plan - Getting Specs Right

**teamrebel10 (The Wheel X) - Foundation First** 🏗️

---

## ✅ COMPLETED

### **teamtravel12/grainflow**
- ✅ Organization exists: https://github.com/orgs/teamtravel12
- ✅ Repo created: https://github.com/teamtravel12/grainflow
- ✅ Live site: https://teamtravel12.github.io/grainflow/
- ✅ grainURL set in description
- ✅ 4 versions deployed (README, LISTEN, GRAINCARD, GRAINCARD-AUDIO)

### **teamrebel10/graintime**
- ✅ Organization exists: https://github.com/orgs/teamrebel10
- ✅ Repo created: https://github.com/teamrebel10/graintime
- ✅ grainURL set in description
- ✅ 63 files, 15,084 lines committed
- ✅ Perfect specs documented

---

## 🔄 ORGANIZATIONS TO CREATE

### **Manual Creation Required** (via GitHub web interface):

1. **teamelegance06** - https://github.com/organizations/plan
   - For: grainenvvars, grainzsh, grainchart
   - Theme: The Lovers (VI), Virgo, Precision with Love
   
2. **teamtreasure02** - https://github.com/organizations/plan
   - For: graindrive, grainvault
   - Theme: High Priestess (II), Taurus, Secrets & Storage

3. **teamplay04** - https://github.com/organizations/plan
   - For: graincontacts
   - Theme: The Emperor (IV), Cancer, Care & Relationships

4. **All 14 teams** (eventually)
   - Each team gets their own org
   - Template repos for public sharing
   - Personal repos stay in personal orgs/accounts

---

## 📋 READY TO DEPLOY (Once Orgs Exist)

### **teamelegance06 Templates**:

#### **grainenvvars**
```bash
cd grainstore/grain6pbc/teamelegance06/grainenvvars
git init
git checkout -b "env-specs---------[GRAINTIME]--teamprecision10"
git add -A
git commit -m "🔐 grainenvvars - Environment Variables with Precision"
gh repo create teamelegance06/grainenvvars --public --source=. --remote=origin
git push -u origin [BRANCH]
bb ../../../teamrebel10/graintime/scripts/set-default-grainbranch.bb
```

**Specs**:
- Environment variable management
- 1Password integration
- Template/personal split
- Security validation
- bb.edn tasks

#### **grainzsh**
```bash
cd grainstore/grain6pbc/teamelegance06/grainzsh
git init
git checkout -b "shell-specs-------[GRAINTIME]--teamprecision10"
# ... same pattern
```

**Specs**:
- λ (lambda) prompt
- Minimal, fast (~50ms startup)
- Template/personal split
- Grain Network integration
- bb.edn installation tasks

#### **grainchart**
```bash
cd grainstore/grain6pbc/teamelegance06/grainchart
git init
git checkout -b "chart-specs-------[GRAINTIME]--teamprecision10"
# ... same pattern
```

**Specs**:
- "Chart your course" (navigation) + "Teach your course" (education)
- VM visualization (QEMU/KVM)
- Commerce flows (multi-layer, multi-chain)
- SixOS evolution path
- Nostr integration

---

### **teamtreasure02 Templates**:

#### **graindrive**
```bash
cd grainstore/grain6pbc/teamtreasure02/graindrive
git init
git checkout -b "drive-specs-------[GRAINTIME]--teamrebel10"
# ... same pattern
```

**Specs**:
- Secure file synchronization
- Zero knowledge encryption
- Template/personal split
- Google Drive + local + decentralized
- Integration with grainflow

---

## 🎯 The Wheel's Wisdom

**Structure before flow. Specs before code. Foundation before features.**

We're doing this RIGHT:
1. Get the specs perfect (team10 energy)
2. Create template repos (shared, public)
3. Deploy with grainbranches (timestamped, immutable)
4. Set grainURLs (proper indexing)
5. THEN personal implementations

**The Wheel teaches**: *"Foundation first. Everything else follows."*

---

## 📊 Deployment Checklist

### For Each Template Repo:

- [ ] Create organization (manual, via web)
- [ ] `cd` to module directory
- [ ] `git init`
- [ ] Generate graintime for that team
- [ ] `git checkout -b [GRAINBRANCH]`
- [ ] `git add -A`
- [ ] `git commit` with specs message
- [ ] `gh repo create [ORG]/[MODULE]`
- [ ] `git push -u origin [BRANCH]`
- [ ] `bb set-default-grainbranch.bb`
- [ ] Verify grainURL in About section
- [ ] Check repo loads from grainbranch subdirectory

---

## 🌾 Why This Matters

**Template repos** = Shared wisdom for the community

**Personal repos** = Individual implementations

**The split** = Everyone benefits from specs while keeping sovereignty

**For @max21e8 and others**: They can use our templates without needing our personal configs. Clean. Shareable. Perfect.

---

**Next Step**: Create the organizations via web interface, then we'll flow through deploying all the template repos! 🌊💕

**now == next + 1** 🌾🏗️💕✨

