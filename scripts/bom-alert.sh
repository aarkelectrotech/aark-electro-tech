#!/bin/zsh

# AARK Electro Tech - BOM Output Alert
# Triggered by launchd WatchPaths when bom-output/ directory changes

BOM_DIR="/Users/aark/Desktop/AARK ELECTRO TECH/bom-output"
STATE_FILE="$HOME/.aark_bom_state"
ALERT_SCRIPT="$HOME/bin/alert"
HOSTNAME=$(hostname -s)

# Get current files
CURRENT=$(ls "$BOM_DIR" 2>/dev/null | sort)

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
    $ALERT_SCRIPT "📋 [$HOSTNAME] NEW BOM OUTPUT: $FILE"
  done <<< "$NEW_FILES"
fi

# Find deleted files
DELETED_FILES=$(comm -23 <(echo "$PREVIOUS") <(echo "$CURRENT") | grep -v '^$')

if [[ -n "$DELETED_FILES" ]]; then
  while IFS= read -r FILE; do
    $ALERT_SCRIPT "🗑️ [$HOSTNAME] BOM OUTPUT DELETED: $FILE"
  done <<< "$DELETED_FILES"
fi

# Save current state
echo "$CURRENT" > "$STATE_FILE"
