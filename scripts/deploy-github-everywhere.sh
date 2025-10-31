#!/bin/bash
# Deploy to GitHub Everywhere!
# Airbender Mode: Flowing to all GitHub remotes 🌊
#
# Note: Not ready for real package managers yet (needs more testing)
# But GitHub deployment is ready!

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌊 Deploying to GitHub Everywhere (Airbender Mode)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CURRENT_BRANCH=$(git branch --show-current)
echo "📌 Current branch: $CURRENT_BRANCH"
echo ""

# List all GitHub remotes
echo "🔍 Finding GitHub remotes..."
GITHUB_REMOTES=$(git remote -v | grep github.com | awk '{print $1}' | sort -u)

if [ -z "$GITHUB_REMOTES" ]; then
    echo "❌ No GitHub remotes found!"
    exit 1
fi

echo "Found GitHub remotes:"
for remote in $GITHUB_REMOTES; do
    URL=$(git remote get-url $remote)
    echo "  • $remote → $URL"
done
echo ""

# Push to all GitHub remotes
echo "🚀 Pushing to all GitHub remotes..."
for remote in $GITHUB_REMOTES; do
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🌊 Flowing to $remote..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if git push "$remote" "$CURRENT_BRANCH" 2>&1; then
        echo "✅ Successfully pushed to $remote/$CURRENT_BRANCH"
    else
        echo "⚠️  Push to $remote failed (continuing to next remote...)"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Deployment complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Note: Not ready for real package managers yet"
echo "   Need more testing on multiple distros and VMs"
echo "   But GitHub deployment is working! 🌊✨"

