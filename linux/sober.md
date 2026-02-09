# 🛡️ Sober Watchdog v2.0

> **Enforce your focus.** A lightweight, automated session manager for [Sober](https://sober.vinegarhq.org/) on Linux.

Sober Watchdog monitors your gameplay in the background and enforces a strict daily time limit. Once your time is up, the game is gracefully closed (and then forced closed) to ensure you stay on track.

---

## ✨ Features

* 📅 **Daily Persistence:** Tracks usage across multiple sessions; resets automatically at midnight.
* 🚀 **Zero Overhead:** Written in pure Bash with a 10s polling interval—uses 0% CPU.
* 🔔 **Smart Notifications:** Sends a 5-minute warning and a final termination alert via `libnotify`.
* 📦 **Universal:** Works for both **Flatpak** and **Native** installations of Sober.
* 🛠️ **Systemd Powered:** Runs as a user-level service that starts automatically on login.

---

## 🛠️ Installation

### 1. The Watchdog Script
Create the script in your home directory:

```bash
nvim ~/sober-watchdog.sh
```

```bash
#!/bin/bash
# =================================================================
# SOBER WATCHDOG - A Portable Session Limiter for Linux
# =================================================================

# --- CONFIGURATION ---
LIMIT_MINUTES=60   # <------- Change it to you desired amount of time 
CHECK_INTERVAL=10  # Seconds between checks
TRACKER_DIR="/tmp" # Volatile storage (resets on reboot)
# ---------------------

# Math: Convert minutes to byte-count for the tracker file
# Calculation: (Minutes * 60) / Interval
LIMIT=$(( (LIMIT_MINUTES * 60) / CHECK_INTERVAL ))
WARNING=$(( LIMIT - (5 * 60 / CHECK_INTERVAL) )) # 5 minute warning
TRACKER="$TRACKER_DIR/sober_usage_$(date +%F)"
SENT_LIMIT_NOTIFY=false
SENT_WARN_NOTIFY=false

# Ensure tracker exists
touch "$TRACKER"

while true; do
  # Look for 'sober' but ignore this script and other common tools
  if pgrep -x "sober" >/dev/null || pgrep -fi "org.vinegarhq.Sober" >/dev/null; then
    
    # Log 1 unit of time
    echo -n "." >> "$TRACKER"
    USED=$(wc -c < "$TRACKER" 2>/dev/null || echo 0)

    # 1. FINAL LIMIT CHECK
    if [ "$USED" -ge "$LIMIT" ]; then
      if [ "$SENT_LIMIT_NOTIFY" = false ]; then
        notify-send -u critical -i dialog-warning "Sober Watchdog" "Daily limit ($LIMIT_MINUTES min) reached. Closing game."
        SENT_LIMIT_NOTIFY=true
      fi
      
      # Kill attempts: Flatpak first, then native binary
      flatpak kill org.vinegarhq.Sober 2>/dev/null
      pkill -9 -x "sober" 2>/dev/null
      sleep 5

    # 2. WARNING CHECK (5 Minutes Left)
    elif [ "$USED" -ge "$WARNING" ]; then
      if [ "$SENT_WARN_NOTIFY" = false ]; then
        notify-send -u normal -i dialog-information "Sober Watchdog" "Warning: Only 5 minutes left for today!"
        SENT_WARN_NOTIFY=true
      fi
    fi
  else
    # Game is closed: reset flags so notifications work if they reopen
    SENT_LIMIT_NOTIFY=false
    SENT_WARN_NOTIFY=false
  fi

  sleep $CHECK_INTERVAL
done
```

---

### 2. Make it Executable

```bash
chmod +x ~/sober-watchdog.sh
```

---

### 3. Setup the Systemd Service
This ensures the script runs in the background without needing a terminal open.

```bash
mkdir -p ~/.config/systemd/user/
nvim ~/.config/systemd/user/sober-limit.service
```

```Ini, TOML
[Unit]
Description=Sober Daily Limit Watchdog
After=graphical-session.target

[Service]
ExecStart=%h/sober-watchdog.sh
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

---

### 4. Activation
Enable and start the service:

```bash
systemctl --user daemon-reload
systemctl --user enable --now sober-limit.service
```

Check the status to ensure it's active:

```bash
systemctl --user status sober-limit.service
```

---

### 5. Check Your Usage
Add this to your shell config (.bashrc or config.fish) for a quick status update:

#### For Fish Shell:
```fish
alias sobertime='echo (math -s0 (wc -c < /tmp/sober_usage_(date +%F) 2>/dev/null || echo 0) / 6) "minutes used."'
```

```fish
funcsave sobertime
```
Now Reboot the PC

#### For Bash Shell:
```bash
alias sobertime='echo "$(( $(wc -c < /tmp/sober_usage_$(date +%F) 2>/dev/null || echo 0) / 6 )) minutes used."'
```

---

## To Check the Remaining Time
```shell
sobertime
```

---

## 🤝 Contributing
Feel free to fork this and add more features like weekly limits or GUI trackers.

# Stay sober, stay productive.
