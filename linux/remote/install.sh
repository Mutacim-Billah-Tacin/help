#!/bin/bash
set -euo pipefail

USERNAME=$(logname)
USERHOME=$(eval echo "~$USERNAME")

# === Package Manager Detection ===
if command -v apt &>/dev/null; then
  PKG="sudo apt install -y"
  DISTRO="debian"
elif command -v yay &>/dev/null; then
  PKG="yay -S --noconfirm"
  DISTRO="arch"
elif command -v paru &>/dev/null; then
  PKG="paru -S --noconfirm"
  DISTRO="arch"
else
  echo "❌ No supported package manager found."
  exit 1
fi

echo "🧪 OS Detected: $DISTRO"

echo "📦 Installing VNC and SSH tools..."
# Added openssh-server to the install list
eval "$PKG x11vnc autocutsel openssh-server"

echo "🔐 Setting VNC password..."
read -sp "Enter VNC password: " vncpass
echo
mkdir -p "$USERHOME/.vnc"
x11vnc -storepasswd "$vncpass" "$USERHOME/.vnc/passwd"

echo "🚀 Enabling SSH Server..."
sudo systemctl enable --now ssh

echo "🛡️ Configuring Firewall (UFW)..."
if command -v ufw &>/dev/null; then
  sudo ufw allow 22/tcp
  sudo ufw allow 5900/tcp
  echo "✅ Firewall rules added for SSH and VNC."
fi

echo "🧱 Creating x11vnc systemd service..."
sudo tee /etc/systemd/system/x11vnc.service > /dev/null <<EOF
[Unit]
Description=Local VNC Desktop Sharing
After=graphical.target network-online.target
Wants=network-online.target

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

LOCAL_IP=$(hostname -I | awk '{print $1}')

echo "------------------------------------------------"
echo "✅ SETUP COMPLETE!"
echo "1. Connect via SSH Tunnel (Secure):"
echo "   ssh -L 5900:localhost:5900 $USERNAME@$LOCAL_IP"
echo "   Then open VNC Viewer and connect to: localhost:5900"
echo ""
echo "2. Connect via Direct VNC (Fast):"
echo "   Address: $LOCAL_IP:5900"
echo "------------------------------------------------"
