#!/bin/bash

set -e

EMAIL=""
KEY_PATH="$HOME/.ssh/id_ed25519"

echo "🔐 Setting up SSH access to GitHub"

# Get email from user
read -p "📧 Enter your GitHub email: " EMAIL

# Check if key exists
if [ -f "$KEY_PATH" ]; then
  echo "⚠️ SSH key already exists at: $KEY_PATH"
else
  echo "🔨 Generating new SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

# Start ssh-agent
echo "🚀 Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add "$KEY_PATH"

# Install xclip if not available
if ! command -v xclip &> /dev/null; then
  echo "📦 Installing xclip..."
  sudo pacman -Sy --noconfirm xclip
fi

# Copy public key to clipboard
xclip -sel clip < "${KEY_PATH}.pub"
echo "📋 Public key copied to clipboard!"

# Prompt user to add it to GitHub
echo ""
echo "🧠 Open GitHub and add the SSH key:"
echo "👉 Navigate to: Settings > SSH and GPG keys > New SSH key"
echo "🔑 The key is already copied, just paste it!"
echo ""

read -p "✅ Press Enter once you’ve added the SSH key to GitHub..."

# Test connection
echo ""
echo "🔄 Testing SSH connection to GitHub..."
ssh -T git@github.com

echo ""
echo "🎉 Success! SSH access to GitHub is now working."

