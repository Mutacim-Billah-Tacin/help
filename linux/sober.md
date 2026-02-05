nvim ~/.sober-watchdog.sh

---

```bash
#!/bin/bash

# 30 minutes = 1800 seconds. 1800 / 10s interval = 180 dots.

LIMIT=180
WARNING=150
TRACKER="/tmp/sober*usage*$(date +%F)"
SENT_LIMIT_NOTIFY=false
SENT_WARN_NOTIFY=false

touch "$TRACKER"

while true; do

# Search for ANY process with 'sober' in the name

if pgrep -x "sober" >/dev/null; then
echo -n "." >>"$TRACKER"
    USED=$(wc -c <"$TRACKER")

    # 1. Limit Check (30 mins)
    if [ "$USED" -ge "$LIMIT" ]; then
      if [ "$SENT_LIMIT_NOTIFY" = false ]; then
        notify-send -u critical "Sober" "30-Minute Limit Reached! Closing."
        SENT_LIMIT_NOTIFY=true
      fi
      # Kill the flatpak AND the binary specifically
      flatpak kill org.vinegarhq.Sober 2>/dev/null
      pkill -9 -fi "sober" 2>/dev/null

    # 2. Warning Check (25 mins)
    elif [ "$USED" -ge "$WARNING" ]; then
      if [ "$SENT_WARN_NOTIFY" = false ]; then
        notify-send -u normal "Sober" "5 minutes left for today!"
        SENT_WARN_NOTIFY=true
      fi
    fi

else # Game is closed, reset flags
SENT_LIMIT_NOTIFY=false
SENT_WARN_NOTIFY=false
fi

sleep 10
done
```

---

chmod +x ~/.sober-watchdog.sh

---

mkdir -p ~/.config/systemd/user/

---

nvim ~/.config/systemd/user/sober-limit.service

---

```shell
[Unit]
Description=Sober 1-Hour Daily Limit Watchdog
After=graphical-session.target

[Service]
ExecStart=%h/.sober-watchdog.sh
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
```

---

systemctl --user daemon-reload
systemctl --user enable --now sober-limit.service

---

wc -c /tmp/sober*usage*$(date +%F)
