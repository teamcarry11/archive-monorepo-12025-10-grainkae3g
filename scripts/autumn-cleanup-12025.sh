#!/bin/bash
# Autumn Cleanup Script - November 12025
# Collapses git history and performs cleanup tasks
#
# ⚠️  WARNING: This script modifies git history!
# Run with --dry-run first to preview changes.

set -e

DRY_RUN="${1:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if we're in a git repo
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository!"
        exit 1
    fi
}

# Create backup branch
create_backup() {
    local backup_name="backup-before-collapse-$(date +%Y%m%d-%H%M%S)"
    log_info "Creating backup branch: $backup_name"
    
    if [ "$DRY_RUN" != "--dry-run" ]; then
        git branch "$backup_name"
        log_success "Backup branch created: $backup_name"
        
        # Try to push backup (may fail if no remote, that's ok)
        if git remote | grep -q .; then
            git push origin "$backup_name" 2>/dev/null || log_warning "Could not push backup branch (remote may not exist)"
        fi
    else
        log_info "[DRY RUN] Would create backup branch: $backup_name"
    fi
}

# Archive git directory
archive_git() {
    local archive_name="git-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    log_info "Archiving .git directory: $archive_name"
    
    if [ "$DRY_RUN" != "--dry-run" ]; then
        tar -czf "$archive_name" .git/
        log_success "Git archive created: $archive_name"
    else
        log_info "[DRY RUN] Would create archive: $archive_name"
    fi
}

# Check for uncommitted changes
check_uncommitted() {
    if ! git diff-index --quiet HEAD --; then
        log_warning "You have uncommitted changes!"
        git status --short
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "Aborted. Commit or stash changes first."
            exit 1
        fi
    else
        log_success "No uncommitted changes"
    fi
}

# Collapse history to single commit
collapse_history() {
    log_info "Collapsing git history to single commit..."
    
    # Get root commit
    local root_commit=$(git rev-list --max-parents=0 HEAD)
    log_info "Root commit: $root_commit"
    
    if [ "$DRY_RUN" != "--dry-run" ]; then
        # Soft reset to root (keeps all changes)
        git reset --soft "$root_commit"
        log_success "History collapsed. All changes staged."
        
        # Show what will be committed
        log_info "Staged changes:"
        git status --short
    else
        log_info "[DRY RUN] Would reset to: $root_commit"
        log_info "[DRY RUN] Current commit count: $(git rev-list --count HEAD)"
    fi
}

# Create unified commit
create_unified_commit() {
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
    
    log_info "Creating unified commit..."
    
    if [ "$DRY_RUN" != "--dry-run" ]; then
        git commit -m "$commit_msg"
        log_success "Unified commit created!"
        
        # Show new history
        log_info "New git history:"
        git log --oneline -5
    else
        log_info "[DRY RUN] Would create commit with message:"
        echo "$commit_msg" | head -5
    fi
}

# Clean temp files
clean_temp_files() {
    log_info "Cleaning temporary files..."
    
    local files_found=0
    
    # Find .bak files
    while IFS= read -r -d '' file; do
        if [ "$DRY_RUN" != "--dry-run" ]; then
            rm "$file"
            log_success "Removed: $file"
        else
            log_info "[DRY RUN] Would remove: $file"
        fi
        files_found=$((files_found + 1))
    done < <(find . -name "*.bak" -type f -print0 2>/dev/null)
    
    # Find ~ files (editor backups)
    while IFS= read -r -d '' file; do
        if [ "$DRY_RUN" != "--dry-run" ]; then
            rm "$file"
            log_success "Removed: $file"
        else
            log_info "[DRY RUN] Would remove: $file"
        fi
        files_found=$((files_found + 1))
    done < <(find . -name "*~" -type f -print0 2>/dev/null)
    
    # Find .DS_Store (macOS)
    while IFS= read -r -d '' file; do
        if [ "$DRY_RUN" != "--dry-run" ]; then
            rm "$file"
            log_success "Removed: $file"
        else
            log_info "[DRY RUN] Would remove: $file"
        fi
        files_found=$((files_found + 1))
    done < <(find . -name ".DS_Store" -type f -print0 2>/dev/null)
    
    if [ $files_found -eq 0 ]; then
        log_success "No temporary files found"
    fi
}

# List stale branches
list_stale_branches() {
    log_info "Checking for stale branches..."
    
    local current_branch=$(git branch --show-current)
    local stale_branches=$(git branch | grep -v "main\|master\|$current_branch\|backup" | sed 's/^[ *]*//')
    
    if [ -z "$stale_branches" ]; then
        log_success "No stale branches found"
    else
        log_warning "Found potential stale branches:"
        echo "$stale_branches" | while read -r branch; do
            echo "  - $branch"
        done
        log_info "Review and delete manually with: git branch -d <branch>"
    fi
}

# Main execution
main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🧹 Autumn Cleanup Script - November 12025"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ "$DRY_RUN" == "--dry-run" ]; then
        log_warning "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    check_git_repo
    
    # Show current state
    log_info "Current repository: $(basename $(git rev-parse --show-toplevel))"
    log_info "Current branch: $(git branch --show-current)"
    log_info "Commit count: $(git rev-list --count HEAD)"
    echo ""
    
    # Safety checks
    log_info "Running safety checks..."
    check_uncommitted
    create_backup
    archive_git
    echo ""
    
    # Cleanup tasks
    log_info "Running cleanup tasks..."
    clean_temp_files
    list_stale_branches
    echo ""
    
    # Collapse history
    log_info "Collapsing git history..."
    collapse_history
    
    if [ "$DRY_RUN" != "--dry-run" ]; then
        create_unified_commit
        echo ""
        log_success "History collapsed! New commit count: $(git rev-list --count HEAD)"
        log_warning "Next steps:"
        log_info "  1. Review: git log --oneline"
        log_info "  2. Test: git status"
        log_info "  3. Push (force required): git push --force-with-lease origin main"
        log_warning "  ⚠️  Force push will rewrite remote history!"
    else
        echo ""
        log_info "[DRY RUN] History collapse preview complete"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Run main function
main

