🛡️ Sober Watchdog
A lightweight, zero-dependency session manager for Sober (Roblox) on Linux.

Keep your productivity high and your gaming sessions intentional. This script tracks your daily usage and automatically terminates the game once your limit is reached.

✨ Features
Daily Tracking: Resets automatically every midnight.

Systemd Integration: Runs silently in the background.

Smart Detection: Works with both Flatpak and Native installations.

Lightweight: Uses negligible CPU resources (10s polling interval).

🚀 Quick Start
Download the script: Save the code above as sober-watchdog.sh in your home folder.

Make it executable:

Bash
chmod +x ~/sober-watchdog.sh
Create the Service (Background Mode): Create ~/.config/systemd/user/sober-limit.service and paste:

Ini, TOML
[Unit]
Description=Sober Daily Limit Watchdog
After=graphical-session.target

[Service]
ExecStart=%h/sober-watchdog.sh
Restart=always

[Install]
WantedBy=default.target
Activate:

Bash
systemctl --user daemon-reload
systemctl --user enable --now sober-limit.service
📊 Check Your Usage
Bash:

Bash
echo "$(( $(wc -c < /tmp/sober_usage_$(date +%F)) / 6 )) minutes used."
Fish:

Code snippet
echo (math (wc -c < /tmp/sober_usage_(date +%F)) / 6) "minutes used."
