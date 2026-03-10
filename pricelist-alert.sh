#!/bin/zsh

# AARK Electro Tech - Price List Alert
# Triggered by launchd WatchPaths when price-list/ directory changes

PRICELIST_DIR="/Users/aark/Desktop/AARK ELECTRO TECH/price-list"
STATE_FILE="$HOME/.aark_pricelist_state"
ALERT_SCRIPT="$HOME/bin/alert"
HOSTNAME=$(hostname -s)

# Get current files
CURRENT=$(ls "$PRICELIST_DIR" 2>/dev/null | sort)

# Load previous state
if [[ -f "$STATE_FILE" ]]; then
  PREVIOUS=$(cat "$STATE_FILE")
else
  PREVIOUS=""
fi

# Find new files
NEW_FILES=$(comm -13 <(echo "$PREVIOUS") <(echo "$CURRENT") | grep -v '^$')

if [[ -n "$NEW_FILES" ]]; then
  while IFS= read -r FILE; do
    $ALERT_SCRIPT "💰 [$HOSTNAME] NEW PRICE LIST: $FILE"
  done <<< "$NEW_FILES"
fi

# Save current state
echo "$CURRENT" > "$STATE_FILE"
