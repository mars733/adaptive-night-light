#!/bin/bash

# gitupdate.sh - Auto Git Backup Script
# Usage: ./gitupdate.sh "your commit message"
# Or just: ./gitupdate.sh  (uses a default timestamped message)

# --- CONFIG ---
COMMIT_MSG="${1:-Auto update: $(date '+%Y-%m-%d %H:%M:%S')}"

echo "=============================="
echo "  Git Update Script Starting  "
echo "=============================="

# Check if this is a git repo
if [ ! -d ".git" ]; then
  echo "⚠️  No git repo found. Initializing..."
  git init
  echo "✅ Git initialized."
fi

# Stage all changes
echo ""
echo "📦 Staging all changes..."
git add .

# Show what's being committed
echo ""
echo "📋 Changes to be committed:"
git status --short

# Commit
echo ""
echo "💾 Committing with message: \"$COMMIT_MSG\""
git commit -m "$COMMIT_MSG"

# Push if a remote exists
REMOTE=$(git remote)
if [ -n "$REMOTE" ]; then
  echo ""
  echo "🚀 Pushing to remote: $REMOTE..."
  git push
  echo "✅ Pushed successfully!"
else
  echo ""
  echo "ℹ️  No remote (e.g. GitHub) set up yet. Changes saved locally only."
  echo "   To add GitHub: git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
fi

echo ""
echo "=============================="
echo "        All Done! ✅          "
echo "=============================="
