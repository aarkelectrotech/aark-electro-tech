#!/bin/zsh

# AARK Electro Tech - Shutdown Alert
# Runs persistently and sends a Telegram alert when SIGTERM is received on shutdown

trap '/Users/aark/bin/alert "🔴 [Aarks-Mac-mini] Mac is shutting down — $(date +'"'"'%A, %d %B %Y %H:%M'"'"')"' TERM

while true; do
  sleep 60 &
  wait $!
done
