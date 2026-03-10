# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AARK Electro Tech automation scripts running on a Mac Mini. The project handles Telegram alerting, system monitoring, and directories for electrical/electronics business operations.

## Telegram Bot

- **Bot:** `@aark_electro_tech_bot` (ID: `8602611023`)
- **Chat ID:** `8785206558`
- Token is hardcoded in `alert.sh` (`BOT_TOKEN`) — if it changes, only `alert.sh` needs updating since all other scripts call it.

## Scripts

### `alert.sh`
Core Telegram sender. All other scripts call this.
```sh
alert "Your message"
```

### `sysmon.sh`
Checks CPU, memory, disk, network, and public IP every 5 minutes via cron. Sends alert if any threshold is breached or IP changes.
- CPU threshold: 80%
- Memory threshold: 85%
- Disk threshold: 90%
- Network: pings `8.8.8.8`
- Public IP: compares against `~/.aark_public_ip`, alerts on change

```sh
sysmon   # run manually
```

Logs to `/tmp/sysmon.log`.

### `daily-summary.sh`
Sends a full system summary to Telegram every day at 9am. Includes CPU, memory, disk, uptime, network status, and public IP.
```sh
daily-summary   # run manually
```

Logs to `/tmp/daily-summary.log`.

## PATH

All scripts are symlinked to `~/bin/` which is added to `$PATH` in `~/.zshrc`. To add a new script:
```sh
chmod +x script.sh
ln -sf "/Users/aark/Desktop/AARK ELECTRO TECH/script.sh" ~/bin/script-name
```

## Cron Jobs

```
*/5 * * * *  sysmon        # system monitor
0 9 * * *    daily-summary # 9am daily summary
```

Edit with `crontab -e`. Logs are in `/tmp/`.

## LaunchAgents

### `com.aark.startup-alert.plist`
Sends a `🟢 Mac has started up` Telegram alert on every boot. Installed at `~/Library/LaunchAgents/`.

### `shutdown-alert.sh` + `com.aark.shutdown-alert.plist`
Persistent script that traps `SIGTERM` (sent by launchd on shutdown) and fires a `🔴 Mac is shutting down` Telegram alert. Runs continuously in the background.

### `sleep.sh` + `wakeup.sh`
Run by `sleepwatcher` (installed via Homebrew) on sleep and wake events. Symlinked to `~/.sleep` and `~/.wakeup`. Service runs via `brew services start sleepwatcher`.

### `order-alert.sh` + `com.aark.order-alert.plist`
LaunchAgent using `WatchPaths` to monitor `orders/`. When a new file appears, sends a `📦 NEW ORDER: filename` alert. Tracks state in `~/.aark_orders_state`.

### `bom-alert.sh` + `com.aark.bom-alert.plist`
LaunchAgent using `WatchPaths` to monitor `bom-output/`. When a new file appears, sends a `📋 NEW BOM OUTPUT: filename` alert. Tracks state in `~/.aark_bom_state`.

### `drawing-alert.sh` + `com.aark.drawing-alert.plist`
LaunchAgent using `WatchPaths` to monitor `drawings/`. When a new file appears, sends a `📐 NEW DRAWING: filename` alert. Tracks state in `~/.aark_drawings_state`.

### `pricelist-alert.sh` + `com.aark.pricelist-alert.plist`
LaunchAgent using `WatchPaths` to monitor `price-list/`. When a new file appears, sends a `💰 NEW PRICE LIST: filename` alert. Tracks state in `~/.aark_pricelist_state`.

### SSH Login Alert
`~/.ssh/rc` (not tracked in repo) fires on every SSH login and sends a `🔐 SSH LOGIN: user from IP` alert.

To reinstall on a new machine:
```sh
cp com.aark.startup-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.startup-alert.plist

cp com.aark.shutdown-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.shutdown-alert.plist

# Sleep/wake alerts
brew install sleepwatcher
cp sleep.sh ~/.sleep && cp wakeup.sh ~/.wakeup
brew services start sleepwatcher
```

## Directories

| Directory | Purpose |
|-----------|---------|
| `drawings/` | Electrical/technical drawings |
| `price-list/` | Component or service price lists |
| `bom-output/` | Bill of materials output files |
| `orders/` | Customer or supplier orders |
