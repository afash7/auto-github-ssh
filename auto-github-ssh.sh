#!/bin/bash

set -e

EMAIL=""
KEY_PATH="$HOME/.ssh/id_ed25519"

function install_xclip() {
  echo "📦 Installing xclip..."
  if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y xclip
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y xclip
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm xclip
  else
    echo "❌ Unsupported package manager. Please install xclip manually."
    exit 1
  fi
}

function generate_ssh_key() {
  echo "🔨 Generating new SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
}

function copy_key_to_clipboard() {
  if ! command -v xclip &> /dev/null; then
    install_xclip
  fi
  xclip -sel clip < "${KEY_PATH}.pub"
  echo "📋 Public key copied to clipboard!"
}

function setup_ssh_agent() {
  echo "🚀 Starting ssh-agent..."
  eval "$(ssh-agent -s)"
  ssh-add "$KEY_PATH"
}

function test_ssh_connection() {
  echo "🔄 Testing SSH connection to GitHub..."
  ssh -T git@github.com
}

function update_git_remote_to_ssh() {
  if [ -d ".git" ]; then
    echo "🔁 Updating Git remote from HTTPS to SSH (if needed)..."
    current_url=$(git remote get-url origin)
    if [[ "$current_url" == https://github.com/* ]]; then
      repo_path="${current_url#https://github.com/}"
      new_url="git@github.com:${repo_path}"
      git remote set-url origin "$new_url"
      echo "✅ Remote URL updated to: $new_url"
    else
      echo "ℹ️ Remote is already using SSH or is not a GitHub repo."
    fi
  else
    echo "📁 Not inside a Git repository, skipping remote update."
  fi
}

function main() {
  echo "🔐 Setting up SSH access to GitHub"

  read -p "📧 Enter your GitHub email: " EMAIL

  if [ -f "$KEY_PATH" ]; then
    echo "⚠️ SSH key already exists at: $KEY_PATH"
  else
    generate_ssh_key
  fi

  setup_ssh_agent
  copy_key_to_clipboard

  echo ""
  echo "🧠 Open GitHub and add the SSH key:"
  echo "👉 Navigate to: Settings > SSH and GPG keys > New SSH key"
  echo "🔑 The key is already copied, just paste it!"
  echo ""

  read -p "✅ Press Enter once you’ve added the SSH key to GitHub..."

  echo ""
  test_ssh_connection
  update_git_remote_to_ssh

  echo ""
  echo "🎉 Success! SSH access to GitHub is now working."
}

main
