LibreELEC NAS Auto-Mount & Unmount Scripts
========================================

Included Files:
---------------
1. .config/nas_credentials
2. .config/autostart.sh
3. .config/unmount_nas.sh

Instructions:
-------------
1. SSH into your LibreELEC device:
   ssh root@<libreelec_ip>

2. Copy the contents of '.config/' to:
cp -r /media/sda1-usb-Generic_Flash_Di/libreelec_nas_scripts/.config /storage/

cd /media

3. Set correct permissions:
chmod 600 /storage/.config/nas_credentials
chmod +x /storage/.config/autostart.sh
chmod +x /storage/.config/unmount_nas.sh

4. Create the mount point:
mkdir -p /storage/NAS

5. Test the mount script:
/storage/.config/autostart.sh

6. To unmount manually:
/storage/.config/unmount_nas.sh

7. Reboot to confirm auto-mount:
reboot
ls /storage/NAS

--- 
NAS Details:
------------
- NAS IP: 10.200.20.241
- Share: libreelec
- Username: libreelec
- Password: Mistral2024
- Mount Point: /storage/NAS


systemctl disable storage-recordings.mount

# Disable it so it doesn't start on boot
systemctl disable storage-libreelec.mount

# Stop it immediately (if currently mounted)
systemctl stop storage-libreelec.mount

# Remove the mount file completely
rm /storage/.config/system.d/storage-libreelec.mount

# Remote the directory 
rmdir nas 
