#!/bin/bash

# List of IPs
HOSTS=(
  "10.200.20.161"
  "10.200.20.162"
  "10.200.20.163"
  "10.200.20.164"
  "10.200.20.165"
  "10.200.20.166"
  "10.200.20.167"
  "10.200.20.168"
  "10.200.20.169"
  "10.200.20.170"
  "10.200.20.171"
  "10.200.20.172"
  "10.200.20.173"
  "10.200.20.174"
  "10.200.20.175"
  "10.200.20.176"
  "10.200.20.177"
  "10.200.20.178"
  "10.200.20.179"
  "10.200.20.180"
  "10.200.20.181"
)

# LED config block
CONFIG_BLOCK="
# Disable the Power LED (Red)
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=on

# Disable the Activity LED (Green)
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off

# Disable Ethernet port LEDs
dtparam=eth_led0=4
dtparam=eth_led1=4
"

for HOST in "${HOSTS[@]}"; do
  echo "🚀 Deploying to $HOST..."

  ssh -o StrictHostKeyChecking=no root@$HOST bash -s <<EOF
    mount -o remount,rw /flash

    if ! grep -q "dtparam=pwr_led_trigger=none" /flash/config.txt; then
      echo "$CONFIG_BLOCK" >> /flash/config.txt
      echo "✅ LED config added on $HOST"
    else
      echo "ℹ️ Config already present on $HOST"
    fi

    sync
    reboot
EOF

done
