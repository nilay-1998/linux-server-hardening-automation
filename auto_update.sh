#!/bin/bash
# ============================================================
# auto_update.sh
# Automated system updates with logging
# Designed to run via cron: 0 2 * * 0 /opt/scripts/auto_update.sh
# Author: Nilay Meshram | github.com/nilay-1998
# ============================================================

LOGFILE="/var/log/auto_update.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] ===== Starting system update =====" >> "$LOGFILE"

# Detect package manager
if command -v yum &>/dev/null; then
  PKG_CMD="yum update -y"
elif command -v apt-get &>/dev/null; then
  PKG_CMD="apt-get update && apt-get upgrade -y"
else
  echo "[$DATE] ERROR: No supported package manager found." >> "$LOGFILE"
  exit 1
fi

# Run update
eval "$PKG_CMD" >> "$LOGFILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "[$DATE] Update completed successfully." >> "$LOGFILE"
else
  echo "[$DATE] ERROR: Update failed with exit code $EXIT_CODE." >> "$LOGFILE"
fi

echo "[$DATE] ===== Update finished =====" >> "$LOGFILE"
echo "" >> "$LOGFILE"

# Rotate log if over 10MB
LOG_SIZE=$(stat -c%s "$LOGFILE" 2>/dev/null || echo 0)
if [ "$LOG_SIZE" -gt 10485760 ]; then
  mv "$LOGFILE" "${LOGFILE}.bak"
  echo "[$DATE] Log rotated." > "$LOGFILE"
fi
