#!/bin/zsh

# AARK Electro Tech - Install Script
# Run this from the project directory on a new machine

set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPTS_DIR/.." && pwd)"
echo "Installing from: $PROJECT_DIR"

# ── Homebrew ────────────────────────────────────────────────────────────────
echo "\n→ Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "  Homebrew already installed."
fi

echo "\n→ Installing dependencies..."
brew install sleepwatcher osx-cpu-temp gh 2>/dev/null || true

# ── ~/bin ────────────────────────────────────────────────────────────────────
echo "\n→ Setting up ~/bin..."
mkdir -p ~/bin

for SCRIPT in alert sysmon daily-summary inactivity-alert; do
  ln -sf "$SCRIPTS_DIR/${SCRIPT}.sh" ~/bin/$SCRIPT
  chmod +x "$SCRIPTS_DIR/${SCRIPT}.sh"
  echo "  Linked $SCRIPT"
done

# Add ~/bin to PATH
if ! grep -q 'HOME/bin' ~/.zshrc 2>/dev/null; then
  echo '\nexport PATH="$HOME/bin:$PATH"' >> ~/.zshrc
  echo "  Added ~/bin to PATH in ~/.zshrc"
else
  echo "  ~/bin already in PATH"
fi

export PATH="$HOME/bin:$PATH"

# ── LaunchAgents ─────────────────────────────────────────────────────────────
echo "\n→ Installing LaunchAgents..."
AGENTS=(
  com.aark.startup-alert
  com.aark.shutdown-alert
  com.aark.order-alert
  com.aark.bom-alert
  com.aark.drawing-alert
  com.aark.pricelist-alert
)

for AGENT in $AGENTS; do
  PLIST="$PROJECT_DIR/automation/${AGENT}.plist"
  DEST="$HOME/Library/LaunchAgents/${AGENT}.plist"
  cp "$PLIST" "$DEST"
  launchctl unload "$DEST" 2>/dev/null || true
  launchctl load "$DEST"
  echo "  Loaded $AGENT"
done

# ── Sleepwatcher ─────────────────────────────────────────────────────────────
echo "\n→ Setting up sleepwatcher..."
cp "$SCRIPTS_DIR/sleep.sh" ~/.sleep && chmod +x ~/.sleep
cp "$SCRIPTS_DIR/wakeup.sh" ~/.wakeup && chmod +x ~/.wakeup
brew services restart sleepwatcher
echo "  Sleepwatcher configured and started"

# ── SSH RC ───────────────────────────────────────────────────────────────────
echo "\n→ Setting up SSH login alert..."
mkdir -p ~/.ssh
cp "$SCRIPTS_DIR/ssh-rc" ~/.ssh/rc && chmod +x ~/.ssh/rc
echo "  SSH rc installed"

# ── Cron Jobs ────────────────────────────────────────────────────────────────
echo "\n→ Setting up cron jobs..."
CRON_SYSMON="*/5 * * * * export PATH=\"$HOME/bin:$PATH\" && $HOME/bin/sysmon >> /tmp/sysmon.log 2>&1"
CRON_SUMMARY="0 9 * * * export PATH=\"$HOME/bin:$PATH\" && $HOME/bin/daily-summary >> /tmp/daily-summary.log 2>&1"

CURRENT_CRON=$(crontab -l 2>/dev/null || true)

if ! echo "$CURRENT_CRON" | grep -q 'sysmon'; then
  (echo "$CURRENT_CRON"; echo "$CRON_SYSMON") | crontab -
  echo "  Added sysmon cron job"
else
  echo "  Sysmon cron job already exists"
fi

CURRENT_CRON=$(crontab -l 2>/dev/null || true)
if ! echo "$CURRENT_CRON" | grep -q 'daily-summary'; then
  (echo "$CURRENT_CRON"; echo "$CRON_SUMMARY") | crontab -
  echo "  Added daily-summary cron job"
else
  echo "  Daily-summary cron job already exists"
fi

CRON_INACTIVITY="0 9 * * * export PATH=\"$HOME/bin:$PATH\" && $HOME/bin/inactivity-alert >> /tmp/inactivity-alert.log 2>&1"
CURRENT_CRON=$(crontab -l 2>/dev/null || true)
if ! echo "$CURRENT_CRON" | grep -q 'inactivity-alert'; then
  (echo "$CURRENT_CRON"; echo "$CRON_INACTIVITY") | crontab -
  echo "  Added inactivity-alert cron job"
else
  echo "  Inactivity-alert cron job already exists"
fi

# ── Test Alert ───────────────────────────────────────────────────────────────
echo "\n→ Sending test alert..."
alert "✅ [$(hostname -s)] AARK install complete — $(date '+%A, %d %B %Y %H:%M')"

echo "\n✅ Installation complete!"
echo "   Restart your terminal or run: source ~/.zshrc"
