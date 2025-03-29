#!/bin/sh

# Wait for network to be ready
(
sleep 10

# Mount NAS SMB Share using credentials file
mount -t cifs //10.200.20.241/libreelec /storage/NAS \
-o credentials=/storage/.config/nas_credentials,vers=2.0

) &
