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

### 💡 Works on all systemd-based and modern init-based Linux systems.  
*(Gentoo, Alpine, and some minimal BSD-like setups may require different approaches.)*

---

## ⚡ Quick Verification Commands
```bash
systemctl list-units --type=service | grep -E 'NetworkManager|systemd-resolved|dhcpcd|connman|netplan'
```
---

## 🌐 NetworkManager (nmcli)

View current connections:
```bash
nmcli connection show
```
Set custom DNS:
```bash
nmcli connection modify "YourConnectionName" ipv4.ignore-auto-dns yes
nmcli connection modify "YourConnectionName" ipv4.dns "1.1.1.1 1.0.0.1"
nmcli connection up "YourConnectionName"
```
Verify:
```bash
nmcli dev show | grep DNS
cat /etc/resolv.conf
```
Restore auto DNS:
```bash
nmcli connection modify "YourConnectionName" ipv4.ignore-auto-dns no
nmcli connection up "YourConnectionName"
```

## ⚙️ systemd-resolved

Enable and start:
```bash
sudo systemctl enable --now systemd-resolved
```
Configure DNS manually:
```bash
sudo resolvectl dns eth0 1.1.1.1 1.0.0.1
sudo resolvectl domain eth0 "~."
sudo resolvectl flush-caches
```
Check current DNS:
```bash
resolvectl status
```
Fix symlink if broken:
```bash
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```
Revert to auto:
```bash
sudo resolvectl revert eth0
```

## 🧩 dhcpcd

Edit config:
```bash
sudo nano /etc/dhcpcd.conf
```
Add or modify:
```bash
nohook resolv.conf
static domain_name_servers=1.1.1.1 1.0.0.1
```
Restart service:
```bash
sudo systemctl restart dhcpcd
```
Verify:
```bash
cat /etc/resolv.conf
```

## 🛰️ resolvconf

Edit config:
```bash
sudo nano /etc/resolvconf.conf
```
Add:
```bash
name_servers="1.1.1.1 1.0.0.1"
```
Apply changes:
```bash
sudo resolvconf -u
```
Check result:
```bash
cat /etc/resolv.conf
```

## 📡 connman

List services:
```bash
connmanctl services
```
Select your service and set DNS:
```bash
connmanctl config wifi_XXXXXXXX_YYYYYY --nameservers 1.1.1.1 1.0.0.1
```
Verify:
```bash
cat /var/lib/connman/*/settings | grep Nameservers
cat /etc/resolv.conf
```
Revert to default:
```bash
connmanctl config wifi_XXXXXXXX_YYYYYY --nameservers 8.8.8.8 8.8.4.4
```
## 🛜 netplan (Ubuntu/Debian YAML-based systems)

Edit config:
```bash
sudo nano /etc/netplan/01-network-manager-all.yaml
```
Example:
```yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: yes
      nameservers:
        addresses: [1.1.1.1, 1.0.0.1]
```
Apply changes:
```bash
sudo netplan apply
```
Verify:
```bash
cat /etc/resolv.conf
```

## 🧾 Manual /etc/resolv.conf (Static, No Manager)
If nothing controls your DNS, you can go fully manual.

Edit file directly:
```bash
sudo nano /etc/resolv.conf
```
Add:
```bash
nameserver 1.1.1.1
nameserver 1.0.0.1
```
Lock the file to prevent managers overwriting it:
```bash
sudo chattr +i /etc/resolv.conf
```
To unlock (if you ever need to change again):
```bash
sudo chattr -i /etc/resolv.conf
```

## 🔍 Verification (Universal Commands)

Test whether your DNS is actually being used:
```bash
resolvectl status
```
```bash
cat /etc/resolv.conf
```
```bash
ping -c 3 google.com
```
---

## 🤝 Contributing
Pull requests are welcome!  
If you’ve tested a setup on another distro or found a cleaner method — document it, don’t script it. 🧾

## 🪪 License
This project is licensed under the MIT License — see [LICENSE](./LICENSE) for details.

---

> 🧠 *“If you can’t configure your DNS manually, you don’t control your machine.”*
