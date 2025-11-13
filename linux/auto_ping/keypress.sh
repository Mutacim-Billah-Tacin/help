#!/bin/bash

# ====== CONFIGURATION ======
STARTUP_DELAY=10                 # Delay before starting (seconds)
TOTAL_DURATION=$((5 * 60 * 60))  # Total duration
INTERVAL=1800                    # Base interval between W presses
RANDOM_VARIATION=2               # Random variation ± seconds
DELAY_BEFORE_ENTER=0.2           # Delay between key and Enter
# ============================

echo "🕒 Waiting $STARTUP_DELAY seconds before starting..."
sleep $STARTUP_DELAY

START_TIME=$(date +%s)
END_TIME=$((START_TIME + TOTAL_DURATION))

echo "▶️ Auto keypress started at $(date)"
echo "Will run for $((TOTAL_DURATION / 60)) minutes."

# Type "Start" + Enter once
xdotool type "Start"
xdotool key Return
notify-send "Auto Keypress" "Start sent ✅"

# Loop sending W after interval, End at the last cycle
while true; do
  CURRENT_TIME=$(date +%s)
  TIME_LEFT=$((END_TIME - CURRENT_TIME))

  if (( TIME_LEFT <= INTERVAL )); then
    # Wait remaining time then type End
    sleep $TIME_LEFT
    xdotool type "End"
    xdotool key Return
    notify-send "Auto Keypress" "End sent 🛑"
    break
  fi

  # Wait before pressing W for the first time and all subsequent cycles
  RANDOM_SLEEP=$((INTERVAL + RANDOM % (2 * RANDOM_VARIATION + 1) - RANDOM_VARIATION))
  sleep $RANDOM_SLEEP

  # Press W + Enter
  xdotool key W
  sleep $DELAY_BEFORE_ENTER
  xdotool key Return
  notify-send "Auto Keypress" "W sent ✔️"
done

echo "🛑 Auto keypress ended at $(date)"

