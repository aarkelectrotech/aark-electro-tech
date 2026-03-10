#!/bin/zsh

# AARK Electro Tech - Daily Summary Alert

ALERT_SCRIPT="$HOME/bin/alert"
HOSTNAME=$(hostname -s)

# CPU
CPU=$(top -l 2 -n 0 | grep "CPU usage" | tail -1 | awk '{print $3}' | tr -d '%')
CPU=${CPU%.*}

# Memory
MEM_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $NF}' | tr -d '%')
MEM_USED=$((100 - MEM_PRESSURE))

# Disk
DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')

# Uptime
UPTIME=$(uptime | sed 's/.*up //' | sed 's/,.*//')

# Network
if ping -c 1 -W 3 8.8.8.8 &>/dev/null; then
  NET="✅ Online"
else
  NET="🔴 Offline"
fi

# Public IP
PUBLIC_IP=$(curl -s https://api.ipify.org)
[[ -z "$PUBLIC_IP" ]] && PUBLIC_IP="Unavailable"

# Date
DATE=$(date '+%A, %d %B %Y')

$ALERT_SCRIPT "📊 AARK Daily Summary — $DATE

🖥 Host: $HOSTNAME
⏱ Uptime: $UPTIME
🔥 CPU: ${CPU}%
🧠 Memory: ${MEM_USED}% used
💾 Disk: ${DISK}% used (${DISK_FREE} free)
🌐 Network: $NET
🌍 Public IP: $PUBLIC_IP

🔔 Active Alerts (14)
🟢 Startup — LaunchAgent
🔴 Shutdown — LaunchAgent
😴 Sleep / ☀️ Wake — sleepwatcher
⚠️ Sysmon CPU/MEM/Disk/Net/IP/SSH — cron */5min
📊 Daily Summary — cron 9am
⏰ Inactivity (orders 3d, drawings 7d) — cron 9am
📦 New Order / 🗑️ Deleted — WatchPaths
📋 New BOM / 🗑️ Deleted — WatchPaths
📐 New Drawing / 🗑️ Deleted — WatchPaths
💰 New Price List / 🗑️ Deleted — WatchPaths
🔐 SSH Login — ~/.ssh/rc
🚨 Failed SSH — sysmon"
