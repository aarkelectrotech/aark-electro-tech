#!/bin/zsh

# AARK Electro Tech - Inactivity Alert
# Sends a Telegram alert if no new files have appeared in key folders within X days

ORDERS_THRESHOLD=3    # days
DRAWINGS_THRESHOLD=7  # days

ORDERS_DIR="/Users/aark/Desktop/AARK ELECTRO TECH/orders"
DRAWINGS_DIR="/Users/aark/Desktop/AARK ELECTRO TECH/drawings"
ALERT_SCRIPT="$HOME/bin/alert"
HOSTNAME=$(hostname -s)

# Check if any file in a directory is newer than X days
check_inactivity() {
  local DIR="$1"
  local DAYS="$2"
  local LABEL="$3"

  # Find files modified within the last DAYS days
  RECENT=$(find "$DIR" -maxdepth 1 -type f -mtime -${DAYS} 2>/dev/null | head -1)

  if [[ -z "$RECENT" ]]; then
    $ALERT_SCRIPT "⏰ [$HOSTNAME] INACTIVITY: No new $LABEL in the last ${DAYS} days"
  fi
}

check_inactivity "$ORDERS_DIR" "$ORDERS_THRESHOLD" "orders"
check_inactivity "$DRAWINGS_DIR" "$DRAWINGS_THRESHOLD" "drawings"
