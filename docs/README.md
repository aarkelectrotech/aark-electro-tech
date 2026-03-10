# AARK Electro Tech

Automation scripts for system monitoring and Telegram alerting on a Mac Mini.

## Scripts

| Script | Description |
|--------|-------------|
| `alert.sh` | Send a Telegram message via `@aark_electro_tech_bot` |
| `sysmon.sh` | Monitor CPU, memory, disk, network, public IP, and failed SSH logins — alerts on issues |
| `inactivity-alert.sh` | Alerts if no new orders (3 days) or drawings (7 days) have arrived |
| `daily-summary.sh` | Send a full system summary to Telegram every morning at 9am |
| `com.aark.startup-alert.plist` | LaunchAgent that sends a Telegram alert on every Mac boot |
| `shutdown-alert.sh` | Persistent script that sends a Telegram alert on shutdown |
| `com.aark.shutdown-alert.plist` | LaunchAgent that runs `shutdown-alert.sh` persistently |
| `sleep.sh` | Sends a Telegram alert when the Mac goes to sleep |
| `wakeup.sh` | Sends a Telegram alert when the Mac wakes up |
| `order-alert.sh` | Sends a Telegram alert when files are added or deleted in `orders/` |
| `com.aark.order-alert.plist` | LaunchAgent that watches `orders/` via `WatchPaths` |
| `bom-alert.sh` | Sends a Telegram alert when files are added or deleted in `bom-output/` |
| `com.aark.bom-alert.plist` | LaunchAgent that watches `bom-output/` via `WatchPaths` |
| `drawing-alert.sh` | Sends a Telegram alert when files are added or deleted in `drawings/` |
| `com.aark.drawing-alert.plist` | LaunchAgent that watches `drawings/` via `WatchPaths` |
| `pricelist-alert.sh` | Sends a Telegram alert when files are added or deleted in `price-list/` |
| `com.aark.pricelist-alert.plist` | LaunchAgent that watches `price-list/` via `WatchPaths` |

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
| Failed SSH logins | alerts if any in last 5 min |
| Orders inactivity | 3 days |
| Drawings inactivity | 7 days |

## Setup

Clone the repo and run the install script — it handles everything automatically:

```sh
git clone https://github.com/aarkelectrotech/aark-electro-tech.git
cd aark-electro-tech
./scripts/install.sh
```

`install.sh` installs Homebrew dependencies, symlinks scripts to `~/bin/`, loads all LaunchAgents, configures sleepwatcher, sets up the SSH login alert, adds cron jobs, and sends a confirmation alert to Telegram when complete.

## Directories

| Directory | Purpose |
|-----------|---------|
| `drawings/` | Electrical/technical drawings |
| `price-list/` | Component or service price lists |
| `bom-output/` | Bill of materials output files |
| `orders/` | Customer or supplier orders |
