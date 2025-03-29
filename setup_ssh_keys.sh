#!/bin/bash

# Ensure you have a public key
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  echo "🔐 No SSH key found. Generating one..."
  ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
fi

# List of Kodi box IPs or hostnames
HOSTS=(
  "10.200.20.161" "10.200.20.162" "10.200.20.163" "10.200.20.164"
  "10.200.20.165" "10.200.20.166" "10.200.20.167" "10.200.20.168"
  "10.200.20.169" "10.200.20.170" "10.200.20.171" "10.200.20.172"
  "10.200.20.173" "10.200.20.174" "10.200.20.175" "10.200.20.176"
  "10.200.20.177" "10.200.20.178" "10.200.20.179" "10.200.20.180"
  "10.200.20.181"
)

echo "🚀 Beginning SSH key deployment to LibreELEC devices..."

for HOST in "${HOSTS[@]}"; do
  echo "🔑 Deploying SSH key to $HOST"
  ssh-copy-id -i ~/.ssh/id_rsa.pub root@$HOST
  if [ $? -eq 0 ]; then
    echo "✅ SSH key deployed to $HOST"
  else
    echo "❌ Failed to deploy SSH key to $HOST"
  fi
  echo "-----------------------------"
done

echo "🎉 SSH key setup complete! You can now run your deployment scripts without typing passwords."
