#!/bin/bash
# ============================================================
# selinux_hardening.sh
# Enforce SELinux policies and verify status
# Author: Nilay Meshram | github.com/nilay-1998
# ============================================================

echo "[*] Configuring SELinux..."

# Check if SELinux is available
if ! command -v sestatus &>/dev/null; then
  echo "[-] SELinux tools not found. Install with: yum install policycoreutils -y"
  exit 1
fi

# Set SELinux to enforcing mode immediately
setenforce 1
echo "[+] SELinux set to enforcing (runtime)."

# Persist enforcing mode across reboots
SELINUX_CONFIG="/etc/selinux/config"
if [ -f "$SELINUX_CONFIG" ]; then
  sed -i 's/^SELINUX=.*/SELINUX=enforcing/' "$SELINUX_CONFIG"
  echo "[+] SELinux config updated: SELINUX=enforcing"
else
  echo "[-] $SELINUX_CONFIG not found. Manual config required."
fi

# Set SELINUXTYPE to targeted (default, recommended)
sed -i 's/^SELINUXTYPE=.*/SELINUXTYPE=targeted/' "$SELINUX_CONFIG"

# Relabel filesystem if needed (uncomment for fresh installs)
# touch /.autorelabel

echo ""
echo "[*] Current SELinux Status:"
sestatus

echo ""
echo "[+] SELinux hardening complete."
