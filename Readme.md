# 🌙 Night Light Sync (Universal Edition)

A high-precision, linear-transition night light controller for Linux. Unlike default toggles, this script uses a mathematical bridge to calculate the perfect color temperature every single minute.

## 🚀 Why this version?
*   **The Session Bridge:** Bypasses "D-Bus" and "X11 $DISPLAY" errors that usually break background scripts.
*   **Linear Transitions:** No abrupt jumps; your screen temperature shifts smoothly over hours.
*   **Universal Support:** Auto-detects GNOME, Cinnamon, and MATE across Fedora, Arch, and Ubuntu.

## 📋 Prerequisites
Ensure your system has the necessary dependencies:


| Distro | Command |
| :--- | :--- |
| **Ubuntu / Debian** | `sudo apt install cron dbus-x11` |
| **Fedora** | `sudo dnf install cronie dbus-x11` |
| **Arch Linux** | `sudo pacman -S cronie && sudo systemctl enable --now cronie` |

---

## 🛠️ Installation Guide

### 1. Create the Script
```bash
nano ~/nightlight_sync.sh
```

### 2. Paste the Code
```bash
#!/bin/bash

# --- 1. THE SESSION BRIDGE ---
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# --- 2. TIME & TEMPERATURE CALCULATION ---
H=$(date +%H)
M=$(date +%M)
NOW=$(( 10#$H * 60 + 10#$M ))

# Linear transition logic (Scale 0 to 1000)
if [ "$NOW" -ge 0 ] && [ "$NOW" -lt 360 ]; then
    scale=1000
elif [ "$NOW" -ge 360 ] && [ "$NOW" -lt 480 ]; then
    scale=$(( 1000 - ($NOW - 360) * 500 / 120 ))
elif [ "$NOW" -ge 480 ] && [ "$NOW" -lt 720 ]; then
    scale=$(( 500 - ($NOW - 480) * 500 / 240 ))
elif [ "$NOW" -ge 720 ] && [ "$NOW" -lt 1080 ]; then
    scale=$(( ($NOW - 720) * 500 / 360 ))
else
    scale=$(( 500 + ($NOW - 1080) * 500 / 360 ))
fi

REDUCTION=$(( scale * 5500 / 1000 ))
TEMP=$(( 6500 - REDUCTION ))

# --- 3. AUTO-DESKTOP DETECTION ---
if [[ "$XDG_CURRENT_DESKTOP" == *"Cinnamon"* ]]; then
    SCHEMA="org.cinnamon.settings-daemon.plugins.color"
else
    SCHEMA="org.gnome.settings-daemon.plugins.color"
fi

gsettings set $SCHEMA night-light-enabled true
gsettings set $SCHEMA night-light-temperature $TEMP
```

### 3. Permissions & Automation
```bash
chmod +x ~/nightlight_sync.sh
crontab -e
```
Add this to the bottom (Replace `USER` with your username):
`*/1 * * * * /bin/bash /home/USER/nightlight_sync.sh`

---

## ⚙️ How to Customize Times
The script uses "minutes from midnight" for transitions. You can change these numbers in the `if/elif` section:
*   **360**: 6:00 AM
*   **480**: 8:00 AM
*   **720**: 12:00 PM
*   **1080**: 6:00 PM

To change a trigger, simply multiply the **Hour × 60**. For example, 10:00 PM would be **1320**.

---

## 🔍 Verification & Uninstallation
*   **Check Status:** `systemctl status cron` (or `crond`)
*   **Uninstall:** Remove the line from `crontab -e` and delete the file.
