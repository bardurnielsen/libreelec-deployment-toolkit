# 🎛️ LibreELEC Deployment Toolkit

![Repo Size](https://img.shields.io/github/repo-size/bardurnielsen/libreelec-deployment-toolkit)
![Last Commit](https://img.shields.io/github/last-commit/bardurnielsen/libreelec-deployment-toolkit)
![License](https://img.shields.io/badge/license-Custom-blue)
![Status](https://img.shields.io/badge/status-Production-green)
![Made for LibreELEC](https://img.shields.io/badge/Made%20for-LibreELEC-orange?style=flat-square&logo=kodi)
![ShellCheck](https://github.com/bardurnielsen/libreelec-deployment-toolkit/actions/workflows/validate-scripts.yml/badge.svg)


A complete, automated toolkit to remotely configure and clone Raspberry Pi 4 devices running **LibreELEC**.

> Designed for environments with multiple Kodi clients (like ships, digital signage, or classrooms) where centralized, repeatable setup is essential.

---

## 🚀 Features

- 🔐 Deploy passwordless SSH access
- 💡 Disable all device LEDs (power, activity, ethernet)
- 📂 Lock down Kodi profiles with PIN protection
- 🗂 Auto-mount network shares (NAS) at boot
- 💾 Fully restore from a master backup (`.tar`)
- 🧠 Set up new devices with one single command
- ♻️ Safe to re-run — scripts are idempotent

---

## 📁 Project Structure

```
libreelec_deployment_toolkit/
├── .config/
│   ├── autostart.sh            # Mounts NAS at boot
│   ├── unmount_nas.sh          # Manual NAS unmount
│   └── README_nas.txt          # NAS mount instructions
├── clean_profiles.xml          # Unlocked Kodi profile (for reset)
├── deploy_led_config.sh        # Disables LEDs via config.txt
├── deploy_profiles.sh          # Pushes locked profile.xml
├── profiles.xml                # Locked profile (PIN 2737)
├── setup_new_device.sh         # One-command setup for new Pis
├── setup_ssh_keys.sh           # Installs your SSH key on all devices
├── .gitignore                  # Optional ignore rules
├── fresh_start_backup.tar      # Master image backup (to restore Pi)
└── README.md                   # This file
```

---

## 🧰 Requirements

- A **Linux/macOS/WSL server** (control node)
- SSH keypair (`~/.ssh/id_rsa.pub`) set up locally
- Fresh LibreELEC installed on target RPis (booted once)
- IP or hostname access to the devices
- Your backup file (e.g. `fresh_start_backup.tar`) created from a configured master Pi

---

## ⚙️ Usage

### 1️⃣ Set Up a Fresh LibreELEC Pi

- Flash the latest LibreELEC image
- Boot the Pi once to initialize `/storage`
- Note its IP address

---

### 2️⃣ Run Full Setup from Your Server

```bash
chmod +x setup_new_device.sh
./setup_new_device.sh
```

> You'll be prompted for the target Pi's IP address. The script does the rest:
> - Pushes your SSH key
> - Uploads and restores the full backup
> - Sets up NAS mounting
> - Locks the profile
> - Disables LEDs
> - Reboots the device

---

### 3️⃣ Lock or Unlock Profiles

If needed, you can manually push:

```bash
# Lock with PIN
scp profiles.xml root@<pi-ip>:/storage/.kodi/userdata/

# Reset/unlock
scp clean_profiles.xml root@<pi-ip>:/storage/.kodi/userdata/
```

---

### 4️⃣ LED Control (optional re-run)

```bash
./deploy_led_config.sh
```

---

### 5️⃣ Push SSH Key to All Devices (bulk)

```bash
./setup_ssh_keys.sh
```

---

### 🗂 Optional: NAS Auto-Mount Setup

- Configured in `.config/autostart.sh` and `unmount_nas.sh`
- Store your NAS username/password in `/storage/.config/nas_credentials`
- Format:
  ```
  username=myuser
  password=mypass
  ```

More details in `.config/README_nas.txt`

---

## 🔁 Restore a Backup Manually

```bash
scp fresh_start_backup.tar root@<pi-ip>:/storage/backup/
ssh root@<pi-ip> "tar -xvf /storage/backup/fresh_start_backup.tar -C / && sync && reboot"
```

---

## ✅ Good to Know

- 💥 Script is **safe to re-run** (idempotent)
- 🔐 Your SSH key is only installed once
- 🔁 Restoring a backup **overwrites** Kodi configs
- 💾 Reboots only occur when needed

---

## 📞 Support

If you need help extending this:
- Add custom skins or addons
- Pull EPG or M3U configs
- Deploy via Docker

Feel free to fork, contribute, or open an issue!

---

## 🔐 PIN: `2737` (default)
Change this by editing `profiles.xml` before deploying.
