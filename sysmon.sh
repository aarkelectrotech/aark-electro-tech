#!/bin/zsh

# AARK Electro Tech - System Monitor
# Sends Telegram alert if CPU or Memory exceeds thresholds

CPU_THRESHOLD=80   # percent
MEM_THRESHOLD=85   # percent
DISK_THRESHOLD=90  # percent

ALERT_SCRIPT="$HOME/bin/alert"

# CPU usage (average over 5 seconds)
CPU=$(top -l 2 -n 0 | grep "CPU usage" | tail -1 | awk '{print $3}' | tr -d '%')
CPU=${CPU%.*}  # trim decimals

# Memory usage
MEM_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $NF}' | tr -d '%')
MEM_USED=$((100 - MEM_PRESSURE))

HOSTNAME=$(hostname -s)
ALERT_SENT=0

if (( CPU >= CPU_THRESHOLD )); then
  $ALERT_SCRIPT "⚠️ [$HOSTNAME] HIGH CPU: ${CPU}% (threshold: ${CPU_THRESHOLD}%)"
  ALERT_SENT=1
fi

if (( MEM_USED >= MEM_THRESHOLD )); then
  $ALERT_SCRIPT "⚠️ [$HOSTNAME] HIGH MEMORY: ${MEM_USED}% used (threshold: ${MEM_THRESHOLD}%)"
  ALERT_SENT=1
fi

# Disk usage
DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if (( DISK >= DISK_THRESHOLD )); then
  $ALERT_SCRIPT "⚠️ [$HOSTNAME] LOW DISK SPACE: ${DISK}% used (threshold: ${DISK_THRESHOLD}%)"
  ALERT_SENT=1
fi

# Network connectivity
if ! ping -c 1 -W 3 8.8.8.8 &>/dev/null; then
  $ALERT_SCRIPT "🔴 [$HOSTNAME] NETWORK DOWN: No internet connectivity"
  ALERT_SENT=1
fi

# Public IP monitor
IP_FILE="$HOME/.aark_public_ip"
CURRENT_IP=$(curl -s https://api.ipify.org)

if [[ -n "$CURRENT_IP" ]]; then
  if [[ -f "$IP_FILE" ]]; then
    LAST_IP=$(cat "$IP_FILE")
    if [[ "$CURRENT_IP" != "$LAST_IP" ]]; then
      $ALERT_SCRIPT "🌍 [$HOSTNAME] PUBLIC IP CHANGED: $LAST_IP → $CURRENT_IP"
      ALERT_SENT=1
    fi
  else
    $ALERT_SCRIPT "🌍 [$HOSTNAME] PUBLIC IP REGISTERED: $CURRENT_IP"
  fi
  echo "$CURRENT_IP" > "$IP_FILE"
fi

if (( ALERT_SENT == 0 )); then
  echo "$(date '+%Y-%m-%d %H:%M:%S') OK — CPU: ${CPU}% | MEM: ${MEM_USED}% | DISK: ${DISK}% | NET: OK | IP: ${CURRENT_IP}"
fi
