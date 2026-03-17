#!/bin/bash
# ============================================================
# firewall_setup.sh
# iptables hardening - CIS Benchmark aligned
# Author: Nilay Meshram | github.com/nilay-1998
# ============================================================

echo "[*] Applying iptables firewall rules..."

# Flush existing rules
iptables -F
iptables -X
iptables -Z

# Default policies: deny all incoming and forwarding, allow outgoing
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (port 22) - restrict to specific IP in production
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP and HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow ICMP (ping) - optional, remove for stricter hardening
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Log dropped packets (optional, useful for monitoring)
iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

# Save rules persistently
if command -v iptables-save &>/dev/null; then
  iptables-save > /etc/iptables/rules.v4
  echo "[+] Rules saved to /etc/iptables/rules.v4"
elif command -v service &>/dev/null; then
  service iptables save
  echo "[+] Rules saved via service."
fi

echo "[+] Firewall rules applied successfully."
iptables -L -v --line-numbers
