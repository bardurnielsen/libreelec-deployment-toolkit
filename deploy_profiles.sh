#!/bin/bash

# Local path to final locked profile file (hashed PIN version)
LOCAL_PROFILE="/mnt/d/profiles.xml"
REMOTE_PATH="/storage/.kodi/userdata/profiles.xml"

# Host list
HOSTS=(
  "10.200.20.161" "10.200.20.162" "10.200.20.163" "10.200.20.164"
  "10.200.20.165" "10.200.20.166" "10.200.20.167" "10.200.20.168"
  "10.200.20.169" "10.200.20.170" "10.200.20.171" "10.200.20.172"
  "10.200.20.173" "10.200.20.174" "10.200.20.175" "10.200.20.176"
  "10.200.20.177" "10.200.20.178" "10.200.20.179" "10.200.20.180"
  "10.200.20.181"
)

USER="root"

# Confirm local file exists
if [ ! -f "$LOCAL_PROFILE" ]; then
  echo "❌ Error: $LOCAL_PROFILE not found"
  exit 1
fi

for HOST in "${HOSTS[@]}"; do
  echo "🚀 Deploying to $HOST..."

  ssh "$USER@$HOST" "systemctl stop kodi && sleep 2"

  ssh "$USER@$HOST" "rm -f $REMOTE_PATH $REMOTE_PATH.bak $REMOTE_PATH~"

  scp "$LOCAL_PROFILE" "$USER@$HOST:$REMOTE_PATH"

  ssh "$USER@$HOST" "chmod 644 $REMOTE_PATH && sync && systemctl start kodi"

  if [ $? -eq 0 ]; then
    echo "✅ Success on $HOST"
  else
    echo "❌ Failed on $HOST"
  fi

  echo "--------------------------"
done

echo "🎉 Deployment complete!"
