# AARK Electro Tech

Automation scripts for system monitoring and Telegram alerting on a Mac Mini.

## Scripts

| Script | Description |
|--------|-------------|
| `alert.sh` | Send a Telegram message via `@aark_electro_tech_bot` |
| `sysmon.sh` | Monitor CPU, memory, disk, network, and public IP — alerts on issues |
| `daily-summary.sh` | Send a full system summary to Telegram every morning at 9am |
| `com.aark.startup-alert.plist` | LaunchAgent that sends a Telegram alert on every Mac boot |
| `shutdown-alert.sh` | Persistent script that sends a Telegram alert on shutdown |
| `com.aark.shutdown-alert.plist` | LaunchAgent that runs `shutdown-alert.sh` persistently |
| `sleep.sh` | Sends a Telegram alert when the Mac goes to sleep |
| `wakeup.sh` | Sends a Telegram alert when the Mac wakes up |
| `order-alert.sh` | Sends a Telegram alert when a new file is added to `orders/` |
| `com.aark.order-alert.plist` | LaunchAgent that watches `orders/` via `WatchPaths` |
| `bom-alert.sh` | Sends a Telegram alert when a new file is added to `bom-output/` |
| `com.aark.bom-alert.plist` | LaunchAgent that watches `bom-output/` via `WatchPaths` |

## Usage

```sh
alert "Your message"       # send a Telegram alert
sysmon                     # run system check manually
daily-summary              # send daily summary manually
```

## Monitoring Thresholds

| Metric | Threshold |
|--------|-----------|
| CPU | 80% |
| Memory | 85% |
| Disk | 90% |
| Network | pings 8.8.8.8 |
| Public IP | alerts on change |

## Setup

All scripts are symlinked to `~/bin/` and available system-wide. Cron jobs and LaunchAgents run automatically:

```
*/5 * * * *   sysmon          # every 5 minutes
0   9 * * *   daily-summary   # every day at 9am
```

The startup and shutdown alerts run via launchd, and sleep/wake alerts run via `sleepwatcher`. To install on a new machine:

```sh
cp com.aark.startup-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.startup-alert.plist

cp com.aark.shutdown-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.shutdown-alert.plist

# Sleep/wake alerts
brew install sleepwatcher
cp sleep.sh ~/.sleep && cp wakeup.sh ~/.wakeup
brew services start sleepwatcher

# Order alert
cp com.aark.order-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.order-alert.plist

# Order alert
cp com.aark.bom-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.bom-alert.plist

# SSH login alert
cp ssh-rc ~/.ssh/rc && chmod +x ~/.ssh/rc
```

## Directories

| Directory | Purpose |
|-----------|---------|
| `drawings/` | Electrical/technical drawings |
| `price-list/` | Component or service price lists |
| `bom-output/` | Bill of materials output files |
| `orders/` | Customer or supplier orders |
