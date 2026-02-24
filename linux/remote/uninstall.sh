#!/bin/bash
set -euo pipefail

USERNAME=$(logname)
USERHOME=$(eval echo "~$USERNAME")

echo "🛑 Stopping and disabling x11vnc service..."
sudo systemctl stop x11vnc || true
sudo systemctl disable x11vnc || true

echo "🗑️ Removing systemd service file..."
sudo rm -f /etc/systemd/system/x11vnc.service
sudo systemctl daemon-reload

echo "🔐 Removing VNC password and config directory..."
rm -rf "$USERHOME/.vnc"

echo "🛡️ Cleaning up firewall rules..."
if command -v ufw &>/dev/null; then
  sudo ufw delete allow 5900/tcp || true
  # Note: Keeping Port 22 open is usually safer, 
  # but if you want it closed, uncomment the line below:
  # sudo ufw delete allow 22/tcp || true
fi

echo "📦 Uninstalling VNC tools..."
if command -v apt &>/dev/null; then
  sudo apt purge -y x11vnc autocutsel
  sudo apt autoremove -y
elif command -v yay &>/dev/null; then
  yay -Rs --noconfirm x11vnc autocutsel
elif command -v paru &>/dev/null; then
  paru -Rs --noconfirm x11vnc autocutsel
fi

echo "------------------------------------------------"
echo "✅ REMOVAL COMPLETE!"
echo "x11vnc has been uninstalled and the service removed."
echo "NOTE: SSH server (Port 22) was left installed for"
echo "safety, but you can remove it manually if needed."
echo "------------------------------------------------"
