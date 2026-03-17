#!/bin/bash
# ============================================================
# log_monitor.sh
# Monitor system logs for suspicious SSH activity
# Designed to run via cron: 0 * * * * /opt/scripts/log_monitor.sh
# Author: Nilay Meshram | github.com/nilay-1998
# ============================================================

LOGFILE="/var/log/secure"           # RHEL/CentOS
# LOGFILE="/var/log/auth.log"       # Ubuntu/Debian — uncomment if needed
ALERT_EMAIL="nilay.meshram1998@gmail.com"
THRESHOLD=5
REPORT="/tmp/log_monitor_report.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Running log monitor check..." 

# Count failed SSH login attempts
FAILED=$(grep "Failed password" "$LOGFILE" 2>/dev/null | wc -l)
INVALID=$(grep "Invalid user" "$LOGFILE" 2>/dev/null | wc -l)
ROOT_ATTEMPTS=$(grep "Failed password for root" "$LOGFILE" 2>/dev/null | wc -l)

# Build report
{
  echo "Log Monitor Report - $DATE"
  echo "================================"
  echo "Failed password attempts : $FAILED"
  echo "Invalid user attempts    : $INVALID"
  echo "Root login attempts      : $ROOT_ATTEMPTS"
  echo ""
  echo "Top offending IPs:"
  grep "Failed password" "$LOGFILE" 2>/dev/null \
    | grep -oP '(\d+\.){3}\d+' \
    | sort | uniq -c | sort -rn | head -10
} > "$REPORT"

cat "$REPORT"

# Send alert if threshold exceeded
if [ "$FAILED" -gt "$THRESHOLD" ]; then
  echo "ALERT: $FAILED failed SSH login attempts on $(hostname)" | \
    mail -s "[Security Alert] SSH Brute Force Detected - $(hostname)" \
    "$ALERT_EMAIL" < "$REPORT"
  echo "[$DATE] Alert sent to $ALERT_EMAIL"
fi

# Auto-ban IPs with 20+ failures using fail2ban or manual iptables
if command -v fail2ban-client &>/dev/null; then
  echo "[$DATE] fail2ban is active — automatic banning enabled."
else
  echo "[$DATE] Tip: Install fail2ban for automatic IP blocking."
fi
