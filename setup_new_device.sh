#!/bin/bash

read -p "Enter the IP of the new LibreELEC device: " HOST

echo "🔐 Step 1: Push SSH key..."
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$HOST

echo "📁 Step 2: Prepare directories..."
ssh root@$HOST "mkdir -p /storage/.config /storage/backup /storage/NAS"

echo "📦 Step 3: Upload backup file..."
scp fresh_start_backup.tar root@$HOST:/storage/backup/

echo "🧠 Step 4: Restore backup (this will overwrite configs)..."
ssh root@$HOST "tar -xvf /storage/backup/fresh_start_backup.tar -C / && sync"

echo "📄 Step 5: Upload .config scripts..."
scp .config/autostart.sh root@$HOST:/storage/.config/
scp .config/unmount_nas.sh root@$HOST:/storage/.config/

echo "🔧 Step 6: Apply LED config if not present..."
ssh root@$HOST 'mount -o remount,rw /flash && grep -q "dtparam=pwr_led_trigger" /flash/config.txt || echo "
# Disable the Power LED (Red)
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=on
# Disable the Activity LED (Green)
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
# Disable Ethernet port LEDs
dtparam=eth_led0=4
dtparam=eth_led1=4
" >> /flash/config.txt && sync'

echo "🔐 Step 7: Profile Lock Options"
read -p "Do you want to lock Kodi profile with PIN 2737? (Y/n): " lock_choice
if [[ "$lock_choice" =~ ^[Yy]$ || -z "$lock_choice" ]]; then
    echo "👉 Locking Kodi profile..."
    scp profiles.xml root@$HOST:/storage/.kodi/userdata/profiles.xml
else
    echo "👉 Deploying unlocked Kodi profile..."
    scp clean_profiles.xml root@$HOST:/storage/.kodi/userdata/profiles.xml
fi

echo "🔁 Step 8: Rebooting $HOST..."
ssh root@$HOST "reboot"

echo "✅ All done! $HOST is now fully configured."
