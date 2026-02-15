```bash

#!/bin/bash
set -euo pipefail

USERNAME=$(logname)
USERHOME=$(eval echo "~$USERNAME")

# === Package Manager Detection (Optimized for Arch/Omarchy) ===
if command -v yay &>/dev/null; then
  PKG="yay -S --noconfirm"
  DISTRO="arch"
elif command -v paru &>/dev/null; then
  PKG="paru -S --noconfirm"
  DISTRO="arch"
elif command -v apt &>/dev/null; then
  PKG="sudo apt install -y"
  DISTRO="debian"
else
  echo "❌ No supported package manager found."
  exit 1
fi

echo "🧪 OS Detected: $DISTRO"

echo "📦 Installing Local VNC tools..."
eval "$PKG x11vnc autocutsel"

echo "🔐 Setting VNC password..."
# This password is only for your local network
read -sp "Enter VNC password: " vncpass
echo
mkdir -p "$USERHOME/.vnc"
x11vnc -storepasswd "$vncpass" "$USERHOME/.vnc/passwd"

echo "🧱 Creating x11vnc systemd service..."
sudo tee /etc/systemd/system/x11vnc.service > /dev/null <<EOF
[Unit]
Description=Local VNC Desktop Sharing
After=graphical.target

[Service]
Type=simple
Environment=DISPLAY=:0
ExecStartPre=/bin/sleep 5
ExecStart=/usr/bin/x11vnc -display :0 -auth $USERHOME/.Xauthority -rfbauth $USERHOME/.vnc/passwd -forever -loop -noxdamage -repeat -shared
User=$USERNAME
Group=$USERNAME
Restart=always

[Install]
WantedBy=graphical.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now x11vnc

# Get Local IP for convenience
LOCAL_IP=$(hostname -I | awk '{print $1}')

echo "------------------------------------------------"
echo "✅ LOCAL SETUP COMPLETE!"
echo "Your PC is now broadcasting on your home network."
echo "Connect from your phone or another PC using:"
echo "  Address: $LOCAL_IP"
echo "  Port:    5900"
echo "------------------------------------------------"

```
