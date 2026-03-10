# AARK Electro Tech

Automation scripts for system monitoring and Telegram alerting on a Mac Mini.

## Scripts

| Script | Description |
|--------|-------------|
| `alert.sh` | Send a Telegram message via `@aark_electro_tech_bot` |
| `sysmon.sh` | Monitor CPU, memory, disk, network, and public IP — alerts on issues |
| `daily-summary.sh` | Send a full system summary to Telegram every morning at 9am |
| `com.aark.startup-alert.plist` | LaunchAgent that sends a Telegram alert on every Mac boot |

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

The startup alert runs via launchd. To install it on a new machine:

```sh
cp com.aark.startup-alert.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.aark.startup-alert.plist
```

## Directories

| Directory | Purpose |
|-----------|---------|
| `drawings/` | Electrical/technical drawings |
| `price-list/` | Component or service price lists |
| `bom-output/` | Bill of materials output files |
| `orders/` | Customer or supplier orders |
