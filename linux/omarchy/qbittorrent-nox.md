# 🧲 qBittorrent-nox Service Setup

> **Explain like I'm 5:** Imagine your computer is a toy robot 🤖. We want this robot to **automatically start downloading stuff** every time it wakes up — without you having to press any buttons. This guide teaches the robot to do that!

---

## 🧸 What Is This?

`qBittorrent-nox` is a download helper that runs **silently in the background** (no window, no buttons). Think of it like a little elf 🧝 living inside your computer, quietly downloading things for you.

We are telling Linux: *"Hey, every time the computer turns on, wake up the elf automatically!"*

---

## 📋 Before You Start

Make sure these two "rooms" (drives/folders) are available when the computer boots:

| Room | Path |
|------|------|
| 🗂️ NOS Drive | `/mnt/nos` |
| 💾 Backup Drive | `/mnt/backup` |

> The elf **refuses to wake up** if these rooms are locked or missing!

---

## 🪜 Step 1 — Write the Elf's "Job Description"

Think of this file as a note that tells Linux:
*"Here's the elf's name, what it does, and how to start it."*

Open the file with this command:

```bash
sudo nvim /etc/systemd/system/qbittorrent-nox.service
```

> 🔑 `sudo` = "I'm the boss, do what I say"
> 📝 `nvim` = the notebook/editor we use to write
> 📂 The long path = where we put the note

Now **paste this inside** the file:

```ini
[Unit]
Description=qBittorrent-nox service
After=network.target mnt-nos.mount mnt-backup.mount
Requires=mnt-nos.mount mnt-backup.mount
RequiresMountsFor=/mnt/nos /mnt/backup

[Service]
Type=forking
User=taxin
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8080
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### 🧩 What does each part mean?

| Part | Plain English |
|------|---------------|
| `After=` | "Wake up AFTER the internet and drives are ready" |
| `Requires=` | "I NEED these drives. Don't start without them!" |
| `User=taxin` | "Run as the user named `taxin`, not as the big boss (root)" |
| `ExecStart=` | "This is the magic spell to wake up the elf" |
| `--webui-port=8080` | "Open a tiny website on port 8080 so I can control it" |
| `Restart=on-failure` | "If the elf trips and falls, wake it back up!" |

Save and exit nvim by typing `:wq` then pressing `Enter`.

---

## 🪜 Step 2 — Tell Linux About the New Note

Linux doesn't automatically read new notes. You have to say *"Hey, go re-read everything!"*:

```bash
sudo systemctl daemon-reload
```

Then tell it to **start the elf now AND every time the computer boots**:

```bash
sudo systemctl enable --now qbittorrent-nox
```

> `enable` = "Always wake the elf when the computer starts" 
> `--now` = "Also wake it up RIGHT NOW, don't wait"

---

## 🪜 Step 3 — Check If the Elf Is Awake

```bash
systemctl status qbittorrent-nox
```

You want to see something like:

```
● qbittorrent-nox.service - qBittorrent-nox service
     Active: active (running) ✅
```

If it says `active (running)` — **the elf is awake and working!** 🎉

---

## 🔄 How to Restart the Elf

If something feels wrong or you made changes, give the elf a little shake:

```bash
sudo systemctl restart qbittorrent-nox
```

---

## 🌐 Access the Control Panel

Once it's running, open your browser and go to:

```
http://localhost:8080
```

You'll see a website to control your downloads!

| Field | Default Value |
|-------|---------------|
| Username | `admin` |
| Password | `adminadmin` |

> ⚠️ **Change the password immediately!** Go to **Settings → WebUI → Password**. Leaving it as default is like leaving your front door wide open! 🚪

---

## 🆘 Quick Cheat Sheet

| What you want to do | Command |
|---------------------|---------|
| Start the service | `sudo systemctl start qbittorrent-nox` |
| Stop the service | `sudo systemctl stop qbittorrent-nox` |
| Restart the service | `sudo systemctl restart qbittorrent-nox` |
| Check if it's running | `systemctl status qbittorrent-nox` |
| See live logs | `journalctl -u qbittorrent-nox -f` |
| Disable auto-start | `sudo systemctl disable qbittorrent-nox` |

---

*Made with ❤️ for humans, not robots.*
