#!/bin/bash
set -e

echo "🔧  Updating and installing essentials..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git wget gnupg lsb-release software-properties-common apt-transport-https ca-certificates gnupg-agent build-essential

echo "📁  Creating ~/dev folder..."
mkdir -p ~/dev

### CHROME
echo "🌐  Installing Google Chrome..."
wget -q -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./chrome.deb && rm chrome.deb
xdg-settings set default-web-browser google-chrome.desktop

### SPOTIFY
echo "🎵  Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey.gpg | gpg --dearmor > spotify.gpg
sudo install -o root -g root -m 644 spotify.gpg /etc/apt/trusted.gpg.d/
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install -y spotify-client
rm spotify.gpg

### DISCORD
echo "💬  Installing Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb && rm discord.deb

### ZOOM
echo "📹  Installing Zoom..."
wget -O zoom.deb "https://zoom.us/client/latest/zoom_amd64.deb"
sudo apt install -y ./zoom.deb && rm zoom.deb

### LIBREOFFICE
echo "📄  Installing LibreOffice..."
sudo apt install -y libreoffice

### VSCODE
echo "📝  Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update && sudo apt install -y code
rm microsoft.gpg

echo "🎨  Configuring Atom One Dark theme in VS Code..."
code --install-extension akamud.vscode-theme-onedark
code --install-extension ms-python.python

### DOCKER DESKTOP
echo "🐳  Installing Docker Desktop..."
curl -fsSL https://desktop.docker.com/linux/main/amd64/docker-desktop.deb -o docker-desktop.deb
sudo apt install -y ./docker-desktop.deb && rm docker-desktop.deb
sudo usermod -aG docker $USER

### GIT SETUP
echo "🔐  Setting up Git and SSH..."
git config --global user.name "joseph-cavarretta"
git config --global user.email "josephmc241@gmail.com"
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true

if [ ! -f ~/.ssh/id_ed25519 ]; then
  echo "Generating SSH key..."
  ssh-keygen -t ed25519 -C "josephmc241@gmail.com" -f ~/.ssh/id_ed25519 -N ""
  echo "👉  Add this SSH key to GitHub:"
  cat ~/.ssh/id_ed25519.pub
  read -p "Press enter after you've added the SSH key to GitHub..."
fi

### PYTHON SETUP
echo "🐍  Installing pyenv + pyenv-virtualenv..."
curl https://pyenv.run | bash


### DOTFILES
echo "📦  Cloning and applying dotfiles..."
cd ~/dev
git clone git@github.com:joseph-cavarretta/dotfiles.git || echo "⚠️   Dotfiles already cloned?"

echo " 🛠️  Applying .bashrc from dotfiles..."
cp ~/dev/dotfiles/bashrc ~/.bashrc

echo "🛠️  Applying vim settings from dotfiles..."
cp ~/dev/dotfiles/vimrc ~/.vimrc
cp -r ~/dev/dotfiles/vim ~/.vim

echo "🛠️  Applying vscode settings from dotfiles..."
mkdir -p ~/.config/Code/User

# Copy settings from your dotfiles repo
cp ~/dev/dotfiles/settings.json ~/.config/Code/User/settings.json

# Install extensions from saved list
if [ -f ~/dev/dotfiles/vscode-extensions.txt ]; then
  while read extension; do
    code --install-extension "$extension" || echo "⚠️   Failed to install $extension"
  done < ~/dev/dotfiles/vscode-extensions.txt
fi

### DISABLE TOUCHSCREEN
echo "🔧  Running touchscreen/tablet mode fix..."
chmod +x ./disable-touchscreen.sh
./disable-touchscreen.sh

### SYSTEM CLEANUP
echo "🧹  Removing unnecessary packages..."
sudo apt autoremove -y

echo "✅  Setup complete! Please reboot to finalize Docker group and VS Code settings."

