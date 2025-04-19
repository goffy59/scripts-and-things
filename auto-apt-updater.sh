#!/bin/bash

#I do not like unattended updates because it seems like after upgrades or some major change the changes I set to them seem to become unset and it frustrates me so I asked AI to make me a script to do what I'd like unatteded updates to do especially for my many servers debian based like ubuntu or debian itself.

set -e

# Location for updater script
SCRIPT_PATH="/usr/local/bin/auto-updater.sh"
CRON_PATH="/etc/cron.d/auto-updater"
LOG_PATH="/var/log/auto-updater.log"

echo "[*] Installing auto-updater script..."

# Write updater logic
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash

LOGFILE="/var/log/auto-updater.log"
exec >> "$LOGFILE" 2>&1

echo "=== \$(date '+%Y-%m-%d %H:%M:%S') Starting auto-updater ==="

export DEBIAN_FRONTEND=noninteractive

apt-get update && \
apt-get -y dist-upgrade && \
apt-get -y autoremove --purge && \
apt-get -y autoclean

echo "=== \$(date '+%Y-%m-%d %H:%M:%S') Finished auto-updater ==="
EOF

chmod +x "$SCRIPT_PATH"

echo "[+] Updater script installed at $SCRIPT_PATH"

# Set up cronjob
echo "[*] Setting up cronjob..."
cat << EOF > "$CRON_PATH"
0 4 * * * root $SCRIPT_PATH
EOF

chmod 644 "$CRON_PATH"

# Make sure log file exists
touch "$LOG_PATH"
chmod 644 "$LOG_PATH"

echo "[+] Cronjob installed. Auto-updater will run daily at 4 AM."
echo "[✓] Done."
