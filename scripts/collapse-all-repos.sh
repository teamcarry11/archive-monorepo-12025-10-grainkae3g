#!/bin/bash
# Collapse git history across all Grain Network repositories
# Run after midnight on Nov 1, 2025
#
# ⚠️  WARNING: This script rewrites git history!
# Always run with --dry-run first!

set -e

DRY_RUN="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS=(
    "teamkae3gtransform08"
    "grainkae3g"
    "teamkae3gdance03"
    "teamkae3gtravel12"
)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Check if repo exists and is git repo
check_repo() {
    local repo_path="$1"
    if [ ! -d "$repo_path" ]; then
        log_warning "Repo not found: $repo_path (skipping)"
        return 1
    fi
    
    cd "$repo_path"
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_warning "Not a git repo: $repo_path (skipping)"
        return 1
    fi
    
    return 0
}

# Get commit count
get_commit_count() {
    git rev-list --count HEAD 2>/dev/null || echo "0"
}

# Collapse single repo
collapse_repo() {
    local repo_name="$1"
    local repo_path="$HOME/github/kae3g/$repo_name"
    
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "Processing: $repo_name"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if ! check_repo "$repo_path"; then
        return 1
    fi
    
    cd "$repo_path"
    
    # Show current state
    local commit_count=$(get_commit_count)
    local current_branch=$(git branch --show-current)
    log_info "Current branch: $current_branch"
    log_info "Commit count: $commit_count"
    
    if [ "$commit_count" -eq 1 ]; then
        log_warning "Already collapsed (only 1 commit). Skipping."
        return 0
    fi
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        log_warning "Uncommitted changes detected! Stashing..."
        if [ "$DRY_RUN" != "--dry-run" ]; then
            git stash push -m "Autumn cleanup stash $(date +%Y%m%d-%H%M%S)"
        fi
    fi
    
    # Create backup branch
    local backup_name="backup-before-collapse-$(date +%Y%m%d-%H%M%S)"
    if [ "$DRY_RUN" != "--dry-run" ]; then
        git branch "$backup_name" 2>/dev/null || true
        log_success "Backup branch created: $backup_name"
    else
        log_info "[DRY RUN] Would create backup: $backup_name"
    fi
    
    # Get root commit
    local root_commit=$(git rev-list --max-parents=0 HEAD)
    log_info "Root commit: $root_commit"
    
    # Collapse history
    if [ "$DRY_RUN" != "--dry-run" ]; then
        git reset --soft "$root_commit"
        log_success "History collapsed. All changes staged."
        
        # Create unified commit
        local commit_msg="🌾⚒️ november 12025 - unified grain network foundation

Complete grain network architecture established with Redox OS + Steel Lisp unified stack.
All autumn 12025 development consolidated into single foundation commit.

Key achievements:
- Redox OS microkernel architecture (hybrid approach)
- Steel Lisp unified scripting language
- Grainorder alphabet: x b f g h q c l m n s v z (d→f, k→c, j→q)
- Graintime temporal referential transparency
- ICP + Solana distributed ledger integration
- Grain Network complete vision synthesis
- Angel Blue Computing philosophy (understanding through devotion)
- All team repositories synchronized

Starting fresh for November 12025 development cycle."
        
        git commit -m "$commit_msg"
        log_success "Unified commit created!"
        
        local new_count=$(get_commit_count)
        log_info "New commit count: $new_count"
        
        # Show log
        log_info "New history:"
        git log --oneline -3
        
    else
        log_info "[DRY RUN] Would reset to: $root_commit"
        log_info "[DRY RUN] Would create unified commit"
    fi
    
    echo ""
    return 0
}

# Main execution
main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🌾⚒️  Collapse All Repos - November 12025"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ "$DRY_RUN" == "--dry-run" ]; then
        log_warning "DRY RUN MODE - No changes will be made"
        echo ""
    else
        log_warning "⚠️  LIVE MODE - This will rewrite git history!"
        read -p "Continue? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "Aborted."
            exit 1
        fi
    fi
    
    local success_count=0
    local skip_count=0
    
    for repo in "${REPOS[@]}"; do
        if collapse_repo "$repo"; then
            success_count=$((success_count + 1))
        else
            skip_count=$((skip_count + 1))
        fi
    done
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "Completed: $success_count repos processed"
    if [ $skip_count -gt 0 ]; then
        log_warning "Skipped: $skip_count repos"
    fi
    
    if [ "$DRY_RUN" != "--dry-run" ]; then
        echo ""
        log_warning "Next steps for each repo:"
        log_info "  1. Review: git log --oneline"
        log_info "  2. Test: git status"
        log_info "  3. Push: git push --force-with-lease origin main"
        log_warning "  ⚠️  Force push rewrites remote history!"
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

main

