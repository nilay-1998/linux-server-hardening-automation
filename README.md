# Linux Server Hardening and Automation

> Bash scripts for automating Linux server administration and security hardening, aligned with CIS Benchmark best practices.
> Built as part of my RHCSA journey — by [Nilay Meshram](https://www.linkedin.com/in/nilay-meshram98)

---

## Scripts Overview

| Script | Purpose |
|---|---|
| `user_management.sh` | Automate user creation, deletion, and permission management |
| `firewall_setup.sh` | Apply iptables hardening rules (CIS-aligned) |
| `selinux_hardening.sh` | Enforce SELinux policies persistently |
| `auto_update.sh` | Scheduled automated system updates with logging |
| `log_monitor.sh` | Monitor auth logs for failed SSH/brute-force attempts |

---

## Usage

### 1. Clone the repo
```bash
git clone https://github.com/nilay-1998/linux-server-hardening-automation.git
cd linux-server-hardening-automation
chmod +x *.sh
```

### 2. User Management
```bash
# Create a user and add to a group
sudo ./user_management.sh create john developers

# Delete a user
sudo ./user_management.sh delete john

# Set permissions on home directory
sudo ./user_management.sh permissions john
```

### 3. Firewall Hardening
```bash
sudo ./firewall_setup.sh
```

### 4. SELinux Enforcement
```bash
sudo ./selinux_hardening.sh
```

### 5. Automated Updates (via cron)
```bash
# Run every Sunday at 2:00 AM
echo "0 2 * * 0 root /path/to/auto_update.sh" >> /etc/crontab
```

### 6. Log Monitoring (via cron)
```bash
# Run every hour
echo "0 * * * * root /path/to/log_monitor.sh" >> /etc/crontab
```

---

## Requirements

- RHEL / CentOS 7+ or Ubuntu 20.04+
- Root or sudo access
- `iptables`, `setfacl` (acl package), `sestatus` (policycoreutils)
- Optional: `mail` utility for email alerts, `fail2ban` for auto-banning

---

## Certification

Scripts align with skills from the **Red Hat Certified System Administrator (RHCSA)** certification.  
Cert ID: `250-093-952`

---

## Author

**Nilay Meshram** — AWS Cloud Engineer | Linux Administrator  
[LinkedIn](https://www.linkedin.com/in/nilay-meshram98) | [GitHub](https://github.com/nilay-1998)
