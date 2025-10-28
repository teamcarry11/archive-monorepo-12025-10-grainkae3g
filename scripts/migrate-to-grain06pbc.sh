#!/bin/bash
# Migration Script: grain6pbc → grain06pbc
# 
# This script migrates all 44 repositories from grain6pbc to grain06pbc organization.
# 
# WARNING: This is a destructive operation! Make sure you have:
# 1. Created grain06pbc organization
# 2. Have admin access to both organizations
# 3. Created a backup of all local repos
#
# Voice: Glow G2 (patient teacher, first principles)

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
OLD_ORG="grain6pbc"
NEW_ORG="grain06pbc"
REPOS_JSON="grain6pbc-repos-list.json"

echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Grain Network Organization Migration${NC}"
echo -e "${GREEN}  ${OLD_ORG} → ${NEW_ORG}${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Step 1: Verify prerequisites
echo -e "${YELLOW}Step 1: Verifying prerequisites...${NC}"

if [ ! -f "$REPOS_JSON" ]; then
    echo -e "${RED}Error: $REPOS_JSON not found!${NC}"
    echo "Run: gh repo list ${OLD_ORG} --limit 100 --json name,url,description > ${REPOS_JSON}"
    exit 1
fi

REPO_COUNT=$(jq -r '. | length' "$REPOS_JSON")
echo -e "${GREEN}✓ Found ${REPO_COUNT} repositories to migrate${NC}"

# Check gh CLI is authenticated
if ! gh auth status &>/dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub CLI${NC}"
    echo "Run: gh auth login"
    exit 1
fi

echo -e "${GREEN}✓ GitHub CLI authenticated${NC}"
echo ""

# Step 2: Create repositories in new organization
echo -e "${YELLOW}Step 2: Creating repositories in ${NEW_ORG}...${NC}"

jq -c '.[]' "$REPOS_JSON" | while read -r repo; do
    NAME=$(echo "$repo" | jq -r '.name')
    DESC=$(echo "$repo" | jq -r '.description')
    
    echo -n "Creating ${NEW_ORG}/${NAME}... "
    
    # Check if repo already exists
    if gh repo view "${NEW_ORG}/${NAME}" &>/dev/null; then
        echo -e "${YELLOW}already exists${NC}"
    else
        gh repo create "${NEW_ORG}/${NAME}" --public --description "$DESC"
        echo -e "${GREEN}created!${NC}"
    fi
done

echo ""

# Step 3: Show what will be updated
echo -e "${YELLOW}Step 3: Preparing to update git remotes...${NC}"
echo ""
echo -e "${RED}⚠️  WARNING: The next step will update git remotes!${NC}"
echo -e "${RED}⚠️  This affects any local clones of these repositories.${NC}"
echo ""
echo -e "This script does NOT automatically update local clones."
echo -e "You'll need to update them manually using:"
echo -e "  ${GREEN}cd /path/to/repo && git remote set-url origin https://github.com/${NEW_ORG}/REPO_NAME.git${NC}"
echo ""

# Step 4: Generate migration commands
echo -e "${YELLOW}Step 4: Generating migration commands...${NC}"

cat > migrate-repos-manual.sh <<'EOF'
#!/bin/bash
# Manual migration script for local repositories
# Run this for each repository you have cloned locally

set -e

OLD_ORG="grain6pbc"
NEW_ORG="grain06pbc"

# Function to migrate a single repo
migrate_repo() {
    local repo_name=$1
    local repo_path=$2
    
    if [ -d "$repo_path" ]; then
        echo "Migrating: $repo_name"
        cd "$repo_path"
        
        # Update origin
        git remote set-url origin "https://github.com/${NEW_ORG}/${repo_name}.git"
        
        # Push all branches
        git push origin --all
        
        # Push all tags
        git push origin --tags
        
        echo "✓ Migrated: $repo_name"
    else
        echo "⚠ Skipped (not found locally): $repo_name"
    fi
}

EOF

# Add each repo to the migration script
jq -r '.[] | .name' "$REPOS_JSON" | while read -r name; do
    echo "# migrate_repo \"$name\" \"/path/to/$name\"" >> migrate-repos-manual.sh
done

chmod +x migrate-repos-manual.sh

echo -e "${GREEN}✓ Created migrate-repos-manual.sh${NC}"
echo -e "  Edit this file and uncomment the repos you have locally cloned"
echo ""

# Step 5: Create redirect README for old organization
echo -e "${YELLOW}Step 5: Creating redirect README for ${OLD_ORG}...${NC}"

cat > grain6pbc-redirect-README.md <<'EOF'
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
EOF

echo -e "${GREEN}✓ Created grain6pbc-redirect-README.md${NC}"
echo -e "  Upload this to grain6pbc/.github/profile/README.md"
echo ""

# Summary
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Migration Preparation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "1. Review migrate-repos-manual.sh"
echo "2. Update any local clones you have"
echo "3. Create .github repo in ${OLD_ORG}"
echo "4. Upload grain6pbc-redirect-README.md to ${OLD_ORG}/.github/profile/README.md"
echo "5. Update all references in grainkae3g codebase"
echo "6. After verification, archive/delete old repos"
echo ""
echo -e "${YELLOW}Remember: Don't delete old repos until everything is verified!${NC}"
echo ""

echo "now == next + 1 🌾"

