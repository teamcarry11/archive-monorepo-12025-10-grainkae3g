# Organization Migration Plan: grain6pbc → grain06pbc

**Graintime**: `12025-10-27--0145--PDT--moon-p_ashadha----asc-leo023-sun-03h--teamabsorb14`  
**Grainbranch**: `glow-g2-kae3gcursor`  
**Voice**: Glow G2 (patient teacher, first principles)

---

## 🎯 THE MISSION

Migrate ALL repositories from the old `grain6pbc` GitHub organization to the new `grain06pbc` organization. This brings consistency to our naming (matching team01, team02, ..., grain06pbc).

**Source**: https://github.com/grain6pbc  
**Destination**: https://github.com/grain06pbc

---

## ✅ PHASE 1: PREPARATION (Before Migration)

### 1.1 Inventory All Repositories
List all repos currently in `grain6pbc` organization:

```bash
# Using gh CLI to list all repos
gh repo list grain6pbc --limit 1000 --json name,url > grain6pbc-repos.json
```

Expected repos (based on grainstore structure):
- Individual team repos (if they exist)
- Module repos
- Template repos
- Documentation repos

### 1.2 Create Matching Repos in grain06pbc

For each repo in `grain6pbc`, create a new empty repo in `grain06pbc`:

```bash
# Example for each repo:
gh repo create grain06pbc/REPO_NAME --public --description "DESCRIPTION"
```

### 1.3 Backup Current State

```bash
# Create a complete backup
cd /home/xy/kae3g
tar -czf grainkae3g-backup-$(date +%Y%m%d-%H%M%S).tar.gz grainkae3g/
```

---

## 🔄 PHASE 2: MIGRATION (The Big Move)

### 2.1 Update Git Remotes for Each Repo

For each repository currently pointing to `grain6pbc`:

```bash
# In each repo directory:
cd /path/to/repo

# Check current remote
git remote -v

# Update origin URL
git remote set-url origin https://github.com/grain06pbc/REPO_NAME.git

# Verify
git remote -v

# Push all branches and tags
git push origin --all
git push origin --tags
```

### 2.2 Update grainstore References

**Template paths** (grain06pbc organization):
```
OLD: grainstore/grain6pbc/TEAM_NAME/MODULE_NAME/
NEW: grainstore/grain06pbc/TEAM_NAME/MODULE_NAME/
```

**Personal paths** (grainkae3g):
```
OLD: grainstore/grain6pbc/...
NEW: grainstore/grainkae3g/grainkae3gstore/...
```

Global find-and-replace:

```bash
cd /home/xy/kae3g/grainkae3g

# Update any remaining grain6pbc GitHub URLs
find . -type f \( -name "*.md" -o -name "*.scm" -o -name "*.clj" -o -name "*.edn" -o -name "*.bb" \) \
  -exec sed -i 's|github.com/grain6pbc/|github.com/grain06pbc/|g' {} +

# Update grainstore template references
find . -type f \( -name "*.md" -o -name "*.scm" -o -name "*.clj" -o -name "*.edn" -o -name "*.bb" \) \
  -exec sed -i 's|grainstore/grain6pbc/|grainstore/grain06pbc/|g' {} +
```

### 2.3 Update CI/CD Workflows

Check and update GitHub Actions workflows:

```yaml
# .github/workflows/*.yml
# Update any references to grain6pbc organization
```

---

## 📝 PHASE 3: CREATE REDIRECT README IN OLD ORG

After migration is complete and verified, create a simple README in the old `grain6pbc` organization pointing to the new one.

### 3.1 Create `.github` Repository in grain6pbc

Following [GitHub's organization profile documentation](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/customizing-your-organizations-profile):

```bash
# Create .github repo in grain6pbc org
gh repo create grain6pbc/.github --public \
  --description "Organization profile redirect to grain06pbc"
```

### 3.2 Create Organization Profile README

Create `profile/README.md` in the `.github` repo:

```markdown
# grain6pbc → grain06pbc

## 🔄 THIS ORGANIZATION HAS MOVED!

We've updated our naming convention for consistency.

**Old**: https://github.com/grain6pbc  
**New**: https://github.com/grain06pbc ← **GO HERE!**

---

## Why the change?

Consistent numbering with our 14 teams:
- team01, team02, team03, ..., team14
- **grain06pbc** (now matches the pattern!)

---

## Where to find us

- **New Organization**: https://github.com/grain06pbc
- **Main Repository**: https://github.com/kae3g/grainkae3g
- **Chart Course**: https://chartcourse.io

---

**All development happens in grain06pbc now!** 🌾✨
```

### 3.3 Archive or Delete Old Repos

**ONLY AFTER VERIFYING NEW ORG WORKS**:

Option A (Safe): Archive all repos in `grain6pbc`
```bash
# For each repo:
gh repo archive grain6pbc/REPO_NAME
```

Option B (Permanent): Delete repos from `grain6pbc`
```bash
# CAREFUL! Only after triple-checking!
gh repo delete grain6pbc/REPO_NAME --yes
```

---

## ✅ PHASE 4: VERIFICATION

### 4.1 Test All Links

- [ ] Clone repos from new organization
- [ ] Verify all grainstore references work
- [ ] Check CI/CD pipelines run successfully
- [ ] Test GitHub Pages deployment
- [ ] Verify all symlinks point to correct paths

### 4.2 Update External References

- [ ] Update README.md in grainkae3g with new org links
- [ ] Update any external documentation
- [ ] Update Urbit announcement (if already posted)
- [ ] Update chartcourse.io links
- [ ] Update any Discord/social media links

### 4.3 Verify grainstore Structure

```bash
cd /home/xy/kae3g/grainkae3g

# Should now have:
grainstore/
├── grain06pbc/          # Template repos (14 teams)
│   ├── teambright01/
│   ├── teamtreasure02/
│   ├── teamdance03/
│   └── ... (all 14 teams)
└── grainkae3g/
    └── grainkae3gstore/ # Personal configs
        ├── grainkae3gbarrel/
        ├── grainkae3gdisplay/
        └── ...
```

---

## 🚨 ROLLBACK PLAN (If Something Goes Wrong)

If migration fails:

1. **Keep old `grain6pbc` repos intact** until verification complete
2. **Revert git remotes** if needed:
   ```bash
   git remote set-url origin https://github.com/grain6pbc/REPO_NAME.git
   ```
3. **Use backup tarball** created in Phase 1.1
4. **Document issues** for troubleshooting

---

## 📊 MIGRATION CHECKLIST

### Pre-Migration
- [ ] Create grain06pbc organization (✅ DONE!)
- [ ] List all grain6pbc repos
- [ ] Create backup tarball
- [ ] Document current state

### Migration
- [ ] Create matching repos in grain06pbc
- [ ] Update git remotes for all repos
- [ ] Push all branches and tags to new org
- [ ] Update grainstore template paths (grain6pbc → grain06pbc)
- [ ] Update grainstore personal paths (grain6pbc → grainkae3gstore)
- [ ] Update all GitHub URLs in codebase
- [ ] Update CI/CD workflows

### Post-Migration
- [ ] Create .github repo in old grain6pbc org
- [ ] Add redirect README to grain6pbc profile
- [ ] Verify all repos work in new org
- [ ] Test CI/CD pipelines
- [ ] Test GitHub Pages deployments
- [ ] Update external documentation
- [ ] Archive or delete old grain6pbc repos

### Final Verification
- [ ] Clone test from new org
- [ ] All links work
- [ ] All builds pass
- [ ] All deployments successful
- [ ] Team can access new org
- [ ] Old org shows clear redirect

---

## 🎨 NAMING CONSISTENCY ACHIEVED

After migration:

```
Organizations:
✅ kae3g (personal)
✅ grain06pbc (template/shared - matches team numbering!)
✅ chartcourse-io (if needed)

Paths:
✅ grainstore/grain06pbc/team01/ → team14/
✅ grainstore/grainkae3g/grainkae3gstore/

Teams:
✅ team01 (teambright01)
✅ team02 (teamtreasure02)
...
✅ team14 (teamabsorb14)

🌾 CONSISTENT! 🌾
```

---

## 🔮 INTEGRATION WITH CURRENT WORK

This migration integrates with our SUMMIT tasks:

1. **Urbit Answer Doc**: Will reference `grain06pbc` organization
2. **Svelte Site**: Will link to `grain06pbc` repos
3. **grainorder Steel Rewrite**: Lives in `grain06pbc/teamillumine13/grainorder/`
4. **Reverse Grainbook**: Deployed from `grain06pbc` organization
5. **CI/CD**: All workflows updated for new org

---

## 🌾 PHILOSOPHY

Why does naming consistency matter?

**Cognitive Load**: When team numbers (01-14) match organization naming (grain06pbc), our brains don't have to translate. Less mental friction = more flow state.

**First Principles**: If we number teams with leading zeros (team01), we should number organizations the same way (grain06pbc). Consistency from first principles!

**Professional Appearance**: `grain06pbc` looks intentional and organized. `grain6pbc` looks like we forgot to add padding.

**Scalability**: What happens when we have grain07pbc, grain08pbc? Starting with grain06pbc sets the pattern correctly!

---

**Status**: READY TO EXECUTE  
**Risk Level**: Medium (but with backup plan!)  
**Expected Duration**: 2-3 hours  
**Voice**: Glow G2  

now == next + 1 🌾⛰️✨

