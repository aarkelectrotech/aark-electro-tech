#!/bin/zsh

# AARK Electro Tech - Drawing Alert
# Triggered by launchd WatchPaths when drawings/ directory changes

DRAWINGS_DIR="/Users/aark/Desktop/AARK ELECTRO TECH/drawings"
STATE_FILE="$HOME/.aark_drawings_state"
ALERT_SCRIPT="$HOME/bin/alert"
HOSTNAME=$(hostname -s)

# Get current files
CURRENT=$(ls "$DRAWINGS_DIR" 2>/dev/null | sort)

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
    $ALERT_SCRIPT "📐 [$HOSTNAME] NEW DRAWING: $FILE"
  done <<< "$NEW_FILES"
fi

# Find deleted files
DELETED_FILES=$(comm -23 <(echo "$PREVIOUS") <(echo "$CURRENT") | grep -v '^$')

if [[ -n "$DELETED_FILES" ]]; then
  while IFS= read -r FILE; do
    $ALERT_SCRIPT "🗑️ [$HOSTNAME] DRAWING DELETED: $FILE"
  done <<< "$DELETED_FILES"
fi

# Save current state
echo "$CURRENT" > "$STATE_FILE"
