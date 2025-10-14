# 🧠 Mastering DNS Configuration on Linux (Manual Guide)

This repo teaches you how to **manually change DNS** on any Linux system — no scripts, no shortcuts.  
If you understand DNS, you control your network. ⚙️

---

## 🧩 Why Manual?
Because automation makes you lazy.  
This repo is made for *people who actually want to understand how Linux networking works* — not just copy-paste commands.

---

## 📚 Topics
| # | Guide | Description |
|---|--------|-------------|
| 1 | [Detecting your network manager](./01-detecting-active-manager.md) | Identify what’s managing your DNS |
| 2 | [NetworkManager](./networkmanager.md) | For most modern distros (nmcli) |
| 3 | [systemd-resolved](./systemd-resolved.md) | For distros using systemd |
| 4 | [dhcpcd](./dhcpcd.md) | Lightweight daemon used on minimal systems |
| 5 | [resolvconf](./resolvconf.md) | Classic DNS handler |
| 6 | [connman](./connman.md) | Embedded/IoT style connection manager |
| 7 | [netplan](./netplan.md) | YAML-based system (Ubuntu, Debian) |
| 8 | [Manual `/etc/resolv.conf`](./manual-resolvconf.md) | When nothing manages DNS |
| 9 | [Troubleshooting](./troubleshooting.md) | Fix common DNS conflicts |

---

## 🧰 Tested On
- 🟦 Arch Linux  
- 🟥 Debian & Ubuntu  
- 🟧 Fedora  
- 🟨 Void Linux  

---

## ⚡ Quick Verification Commands
```bash
systemctl list-units --type=service | grep -E 'NetworkManager|systemd-resolved|dhcpcd|connman|netplan'
```
