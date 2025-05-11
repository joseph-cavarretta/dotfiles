#!/bin/bash
set -e

# ────────────────────────────────────────────────
# 🧹 Cleanup any leftover installer sources
# ────────────────────────────────────────────────
sudo sed -i '/cdrom:/d' /etc/apt/sources.list
sudo rm -f /etc/apt/sources.list.d/cdrom*.list || true

echo "🔧  Updating and installing essentials..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  curl git wget gnupg lsb-release software-properties-common \
  apt-transport-https ca-certificates gnupg-agent build-essential

echo "📁  Creating ~/dev folder..."
mkdir -p "$HOME/dev"

# ────────────────────────────────────────────────
# 🌐 Google Chrome
# ────────────────────────────────────────────────
echo "🌐  Installing Google Chrome..."
if ! command -v google-chrome &>/dev/null; then
  wget -q -O /tmp/chrome.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y /tmp/chrome.deb
  rm /tmp/chrome.deb
  xdg-settings set default-web-browser google-chrome.desktop
fi

# ────────────────────────────────────────────────
# 🎵 Spotify
# ────────────────────────────────────────────────
echo "🎵  Installing Spotify..."
if ! dpkg -l spotify-client &>/dev/null; then
  # Remove stale Spotify sources/keys
  sudo rm -f /etc/apt/sources.list.d/spotify.list
  sudo apt-key del C85668DF69375001 2>/dev/null || true
  # Add official Spotify signing key
  sudo apt-key adv --keyserver keyserver.ubuntu.com \
    --recv-keys C85668DF69375001
  # Add the repo
  echo "deb http://repository.spotify.com stable non-free" \
    | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt update
  sudo apt install -y spotify-client
fi

# ────────────────────────────────────────────────
# 💬 Discord
# ────────────────────────────────────────────────
echo "💬  Installing Discord..."
if ! command -v discord &>/dev/null; then
  wget -O /tmp/discord.deb \
    "https://discord.com/api/download?platform=linux&format=deb"
  sudo apt install -y /tmp/discord.deb
  rm /tmp/discord.deb
fi

# ────────────────────────────────────────────────
# 📹 Zoom
# ────────────────────────────────────────────────
echo "📹  Installing Zoom..."
if ! command -v zoom &>/dev/null; then
  wget -O /tmp/zoom.deb \
    "https://zoom.us/client/latest/zoom_amd64.deb"
  chmod a+r /tmp/zoom.deb
  sudo apt install -y /tmp/zoom.deb
  rm /tmp/zoom.deb
fi

# ────────────────────────────────────────────────
# 📄 LibreOffice
# ────────────────────────────────────────────────
echo "📄  Installing LibreOffice..."
sudo apt install -y libreoffice

# ────────────────────────────────────────────────
# 📝 Visual Studio Code
# ────────────────────────────────────────────────
echo "📝  Installing Visual Studio Code..."
if ! command -v code &>/dev/null; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg \
    /etc/apt/trusted.gpg.d/
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list
  rm microsoft.gpg
  sudo apt update
  sudo apt install -y code
fi

# Ensure 'code' CLI is in PATH immediately
if ! command -v code &>/dev/null && [ -d "/usr/share/code/bin" ]; then
  echo 'export PATH="$PATH:/usr/share/code/bin"' >> "$HOME/.bashrc"
  export PATH="$PATH:/usr/share/code/bin"
fi

# ────────────────────────────────────────────────
# 🐳 Docker Engine & Compose (instead of Desktop)
# ────────────────────────────────────────────────
echo "🐳  Installing Docker Engine, CLI, containerd & Compose..."
if ! command -v docker &>/dev/null; then
  # remove any old Desktop leftovers
  sudo apt remove -y docker-desktop 2>/dev/null || true

  # install prerequisites
  sudo apt update
  sudo apt install -y \
    ca-certificates curl gnupg lsb-release

  # add Docker’s official GPG key
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  # set up the repository
  echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # install packages
  sudo apt update
  sudo apt install -y \
    docker-ce docker-ce-cli containerd.io \
    docker-compose-plugin

  # add your user to the docker group
  sudo usermod -aG docker "$USER"
fi

# ────────────────────────────────────────────────
# 🔐 Git & SSH
# ────────────────────────────────────────────────
echo "🔐  Setting up Git and SSH..."
git config --global user.name "joseph-cavarretta"
git config --global user.email "josephmc241@gmail.com"
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "josephmc241@gmail.com" \
    -f "$HOME/.ssh/id_ed25519" -N ""
  echo "👉  Add this SSH key to GitHub:"
  cat "$HOME/.ssh/id_ed25519.pub"
  read -p "Press ENTER after adding the SSH key to GitHub..."
fi

# ────────────────────────────────────────────────
# 🐍 Pyenv & Virtualenv
# ────────────────────────────────────────────────
echo "🐍  Installing pyenv + pyenv-virtualenv..."
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
fi

# ────────────────────────────────────────────────
# 📦 Dotfiles
# ────────────────────────────────────────────────
echo "📦  Cloning and applying dotfiles..."
cd "$HOME/dev"
if [ ! -d dotfiles ]; then
  git clone git@github.com:joseph-cavarretta/dotfiles.git
else
  cd dotfiles && git pull && cd ..
fi

echo "🛠️  Applying BASH settings from dotfiles..."
cp -f "$HOME/dev/dotfiles/bashrc" "$HOME/.bashrc"

echo "🛠️  Applying VIM settings from dotfiles..."
cp -f "$HOME/dev/dotfiles/vimrc" "$HOME/.vimrc"
cp -rf "$HOME/dev/dotfiles/vim" "$HOME/.vim"

echo "🛠️  Applying VS Code settings from dotfiles..."
mkdir -p "$HOME/.config/Code/User"
cp -f "$HOME/dev/dotfiles/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
if [ -f "$HOME/dev/dotfiles/vscode/vscode-extensions.txt" ]; then
  while read -r extension; do
    code --install-extension "$extension" \
      || echo "⚠️  Failed to install $extension"
  done < "$HOME/dev/dotfiles/vscode/vscode-extensions.txt"
fi

# ───────────────────────────────────────────────────
# 🌑 One Dark theme for GNOME Terminal via one-gnome-terminal
# ───────────────────────────────────────────────────
echo "🎨  Installing/Updating one-gnome-terminal…"
if [ ! -d "$HOME/.one-gnome-terminal" ]; then
  git clone https://github.com/denysdovhan/one-gnome-terminal.git \
    "$HOME/.one-gnome-terminal"
else
  git -C "$HOME/.one-gnome-terminal" pull
fi

echo "🎨  Applying One Dark theme…"
bash "$HOME/.one-gnome-terminal/one-dark.sh" --no-confirm

# grab the current default profile ID
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

# make sure this profile stays the default
gsettings set org.gnome.Terminal.ProfilesList default "'$PROFILE'"

# force 180×40 initial size
BASE="org.gnome.Terminal.Legacy.Profile:/org/gnome/Terminal/Legacy/Profiles:/:$PROFILE/"
gsettings set $BASE default-size-columns 180
gsettings set $BASE default-size-rows    40

echo "🎨  One Dark applied and profile configured (default, 180×40)."

# ────────────────────────────────────────────────
# 🔧 Touchscreen & Tablet-mode fix
# ────────────────────────────────────────────────
echo "🔧  Running touchscreen/tablet mode fix..."
chmod +x ~/disable-touchscreen.sh
sudo bash ~/disable-touchscreen.sh

# ────────────────────────────────────────────────
# 🧹 System Cleanup
# ────────────────────────────────────────────────
echo "🧹  Removing unnecessary packages..."
sudo apt autoremove -y

echo "✅  Setup complete! Please reboot to apply all changes."

