#!/bin/bash

# NOTE: This script requires ydotool to be installed and running on Wayland (Hyprland).
# Installation (Arch/Omarchy): sudo pacman -S ydotool
# Daemon startup: sudo systemctl enable --now ydotool.service

# ====== CONFIGURATION ======
STARTUP_DELAY=10                   # Delay before starting (seconds)
TOTAL_DURATION=$((5 * 60 * 60))    # Total duration (5 hours)
INTERVAL=1800                      # Base interval between W presses (30 minutes)
RANDOM_VARIATION=60                # Random variation ± seconds (1 minute)
DELAY_BEFORE_ENTER=0.2             # Delay between key and Enter
# ============================

echo "🕒 Waiting $STARTUP_DELAY seconds before starting..."
sleep $STARTUP_DELAY

START_TIME=$(date +%s)
END_TIME=$((START_TIME + TOTAL_DURATION))

echo "▶️ Auto keypress started at $(date)"
echo "Will run for $((TOTAL_DURATION / 60)) minutes."

# Type "Start" + Enter once
ydotool type "Start"
ydotool key 28:1 28:0 # Key press (Return)
notify-send "Auto Keypress" "Start sent ✅"

# Loop sending W after interval, End at the last cycle
while true; do
  CURRENT_TIME=$(date +%s)
  TIME_LEFT=$((END_TIME - CURRENT_TIME))

  if (( TIME_LEFT <= 0 )); then
    echo "🛑 Total duration reached. Exiting gracefully."
    break
  fi

  if (( TIME_LEFT <= INTERVAL )); then
    # Wait remaining time then type End
    echo "⏳ Last cycle. Waiting $TIME_LEFT seconds to send 'End'."
    sleep $TIME_LEFT
    ydotool type "End"
    ydotool key 28:1 28:0 # Key press (Return)
    notify-send "Auto Keypress" "End sent 🛑"
    break
  fi

  # Calculate and wait for the randomized interval
  RANDOM_SLEEP=$((INTERVAL + RANDOM % (2 * RANDOM_VARIATION + 1) - RANDOM_VARIATION))
  echo "⏳ Waiting $RANDOM_SLEEP seconds before sending 'W'..."
  sleep $RANDOM_SLEEP

  # Press W + Enter
  ydotool key W:1 W:0          # Key press (W)
  sleep $DELAY_BEFORE_ENTER
  ydotool key Return:1 Return:0 # Key press (Return)
  notify-send "Auto Keypress" "W sent ✔️"
done

echo "🛑 Auto keypress ended at $(date)"
