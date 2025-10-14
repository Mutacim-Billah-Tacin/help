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
```bash
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
```
