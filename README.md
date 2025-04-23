# 🔐 GitHub SSH Setup Script

A simple interactive Bash script to generate an SSH key, add it to the SSH agent, copy the public key to clipboard, and help you connect your GitHub account via SSH.

---

## 📦 Features

- Checks for existing SSH key
- Generates a new `ed25519` SSH key if none found
- Starts and uses `ssh-agent`
- Copies the public key to clipboard using `xclip`
- Guides you to add the key to GitHub
- Tests the SSH connection after setup

---

## 🛠️ Requirements

This script is intended for **Linux systems** (specifically tested on Arch Linux).  
Make sure you have the following installed:

- `bash`
- `openssh`
- `xclip` (used to copy the SSH public key to clipboard)
- `sudo` privileges (for installing `xclip` if not installed)

### 🐧 On Arch Linux:

```bash
sudo pacman -S --needed openssh xclip
```

### 🐧 On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install openssh-client xclip
```

---

## 🚀 How to Use

1. Clone or download the script.

2. Give the script execution permission:

```bash
chmod +x setup_github_ssh.sh
```

3. Run the script:

```bash
./setup_github_ssh.sh
```

4. Follow the instructions:
   - Enter your GitHub email.
   - Paste the SSH key on GitHub under:  
     **Settings → SSH and GPG keys → New SSH key**
   - Press Enter when you're done.

5. The script will test the connection with GitHub using SSH.

---

## 📎 Notes

- Your SSH key will be created at: `~/.ssh/id_ed25519`
- If the key already exists, the script won't overwrite it.
- The script uses `ssh-agent` to manage your key securely.

---

## ✅ TODO

Planned features and enhancements for future versions:

- [ ] Support GitLab and Bitbucket (SSH setup flow for each)
- ✅ Add option to create a unique SSH key for each project
- ✅ Automatically set SSH as the remote URL for existing Git repos
- [ ] Add `fzf` interface to pick SSH keys or Git remotes
- ✅ Detect Linux distro and install `xclip` dynamically (`apt`, `dnf`, `pacman`)
- [ ] Add optional GUI mode using `zenity` or `kdialog`
- [ ] Export key fingerprint or metadata in terminal after creation
- [ ] Add option to remove/reset existing SSH keys
- [ ] Make script fully idempotent and safe to rerun

---

## 👨‍💻 Author

[Afash ツ](https://afash.ir)
