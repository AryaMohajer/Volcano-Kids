#!/bin/bash

# Script to connect local repository to GitHub and push
# Usage: ./setup_github.sh

echo "🌋 Setting up GitHub repository for Volcano Kids..."

# Add remote (replace YOUR_USERNAME with your GitHub username)
read -p "Enter your GitHub username: " GITHUB_USERNAME

git remote add origin https://github.com/${GITHUB_USERNAME}/Volcano-Kids.git

# Push to GitHub
echo "📤 Pushing to GitHub..."
git branch -M main
git push -u origin main

echo "✅ Done! Your repository is now on GitHub:"
echo "   https://github.com/${GITHUB_USERNAME}/Volcano-Kids"

