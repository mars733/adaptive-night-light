#!/bin/bash

# ================================================
#   git_setup.sh — General Git Repo Setup Script
#   Works for NEW or EXISTING repositories
# ================================================

echo ""
echo "=============================="
echo "   🚀 Git Repo Setup Script   "
echo "=============================="
echo ""

# ---------- Step 1: Check if Git is installed ----------
if ! command -v git &> /dev/null; then
  echo "❌ Git is not installed. Please install it first."
  echo "   Ubuntu/Debian: sudo apt install git"
  echo "   Mac:           brew install git"
  exit 1
fi

echo "✅ Git is installed: $(git --version)"
echo ""

# ---------- Step 2: Init repo if not already one ----------
if [ ! -d ".git" ]; then
  echo "📁 No git repo found here. Initializing a new one..."
  git init
  echo "✅ Git repo initialized."
else
  echo "📁 Existing git repo detected. Skipping init."
fi
echo ""

# ---------- Step 3: Create .gitignore ----------
echo "📝 Creating .gitignore..."

cat > .gitignore << 'EOF'
# ===== Python =====
__pycache__/
*.py[cod]
*.pyo
*.pyd
.Python
env/
venv/
.venv/
pip-log.txt
*.egg-info/
dist/
build/
*.egg
.eggs/

# ===== Node.js =====
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm
.yarn-integrity
dist/
.cache/

# ===== Environments & Secrets =====
.env
.env.*
*.env
.secret
secrets/
config/secrets.*

# ===== IDEs & Editors =====
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
*.sublime-project
*.sublime-workspace
.DS_Store
Thumbs.db

# ===== Logs =====
logs/
*.log
*.log.*

# ===== OS Files =====
.DS_Store
Desktop.ini
ehthumbs.db

# ===== Build & Coverage =====
coverage/
.coverage
htmlcov/
*.out
*.bak
*.tmp
EOF

echo "✅ .gitignore created."
echo ""

# ---------- Step 4: Set user identity (if not set) ----------
GIT_USER=$(git config user.name)
GIT_EMAIL=$(git config user.email)

if [ -z "$GIT_USER" ]; then
  read -rp "👤 Enter your Git username: " GIT_USER
  git config --global user.name "$GIT_USER"
fi

if [ -z "$GIT_EMAIL" ]; then
  read -rp "📧 Enter your Git email: " GIT_EMAIL
  git config --global user.email "$GIT_EMAIL"
fi

echo "✅ Git identity: $GIT_USER <$GIT_EMAIL>"
echo ""

# ---------- Step 5: Stage and commit ----------
echo "📦 Staging all files..."
git add .

read -rp "💬 Enter a commit message (or press Enter for default): " COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-"Initial commit 🎉"}

git commit -m "$COMMIT_MSG"
echo "✅ Committed: \"$COMMIT_MSG\""
echo ""

# ---------- Step 6: Rename branch to main ----------
git branch -M main
echo "✅ Branch set to: main"
echo ""

# ---------- Step 7: Optionally add GitHub remote ----------
EXISTING_REMOTE=$(git remote get-url origin 2>/dev/null)

if [ -n "$EXISTING_REMOTE" ]; then
  echo "🔗 Remote already set: $EXISTING_REMOTE"
else
  read -rp "🌐 Enter your GitHub repo URL (or press Enter to skip): " REMOTE_URL
  if [ -n "$REMOTE_URL" ]; then
    git remote add origin "$REMOTE_URL"
    echo "✅ Remote added: $REMOTE_URL"
    echo ""
    echo "⬆️  Pushing to GitHub..."
    git push -u origin main && echo "✅ Pushed to GitHub!" || echo "⚠️  Push failed. Check your URL and credentials."
  else
    echo "⏭️  Skipped remote. To add GitHub later, run:"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo "   git push -u origin main"
  fi
fi

echo ""
echo "=============================="
echo "        All Done! ✅          "
echo "=============================="
echo ""
echo "📌 Useful commands to remember:"
echo "   git status              — see what's changed"
echo "   git add .               — stage all changes"
echo "   git commit -m 'msg'     — save a snapshot"
echo "   git push                — upload to GitHub"
echo "   git log --oneline       — see commit history"
echo ""
