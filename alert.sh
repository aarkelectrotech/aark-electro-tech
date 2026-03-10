#!/bin/zsh

# AARK Electro Tech - Telegram Alert Script
# Usage: ./alert.sh "Your message here"

BOT_TOKEN="8602611023:AAHV2BOF4zc4YegCCDxISjJy7fGKchKe3gc"
CHAT_ID="8785206558"

if [[ -z "$1" ]]; then
  echo "Usage: $0 \"Your message\""
  exit 1
fi

MESSAGE="$1"

RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d text="${MESSAGE}")

if echo "$RESPONSE" | grep -q '"ok":true'; then
  echo "Alert sent: $MESSAGE"
else
  echo "Failed to send alert."
  echo "$RESPONSE"
  exit 1
fi
