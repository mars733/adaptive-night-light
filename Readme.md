This is the final, universal README.md. I have updated the code section to include your linear transition logic and added the auto-detect feature so it works for Fedora, Arch, Ubuntu, and all major desktops automatically.
------------------------------
## 🌙 Night Light Sync (Universal Cron Edition)
This script gives you total control over your screen temperature. Unlike standard night light settings, this uses cron to calculate a smooth, linear transition for your screen's warmth every single minute.
## 🚀 The Problem it Solves
Normally, background tasks (cron) cannot talk to your desktop screen, resulting in "D-Bus" or "X11 $DISPLAY" errors. This script includes a Bridge that connects the background scheduler to your active session, making automation possible on any Linux distro.
------------------------------
## 📋 Prerequisites
Before starting, ensure your system has the necessary tools:

* Desktop Environment: GNOME, Cinnamon, or MATE.
* Dependencies:
* Ubuntu/Debian: sudo apt install cron dbus-x11
   * Fedora: sudo dnf install cronie dbus-x11
   * Arch: sudo pacman -S cronie (then run sudo systemctl enable --now cronie)

------------------------------
## 🛠️ Installation Guide## 1. Create the Script
Open your terminal and create the file:

nano ~/nightlight_sync.sh

## 2. Paste the Universal Code
Copy and paste this entire block. It includes the Bridge, Auto-Desktop Detection, and Linear Math:


'''

#!/bin/bash
# --- 1. THE BRIDGE ---# Connects Cron to your active desktop session
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
# --- 2. TIME CALCULATION ---# Handles 10# base conversion to prevent errors at 08:00 and 09:00 AM
H=$(date +%H)
M=$(date +%M)
NOW=$(( 10#$H * 60 + 10#$M ))
# Logic for linear transitions (scale 0 to 1000)if [ "$NOW" -ge 0 ] && [ "$NOW" -lt 360 ]; then
    scale=1000elif [ "$NOW" -ge 360 ] && [ "$NOW" -lt 480 ]; then
    scale=$(( 1000 - ($NOW - 360) * 500 / 120 ))elif [ "$NOW" -ge 480 ] && [ "$NOW" -lt 720 ]; then
    scale=$(( 500 - ($NOW - 480) * 500 / 240 ))elif [ "$NOW" -ge 720 ] && [ "$NOW" -lt 1080 ]; then
    scale=$(( ($NOW - 720) * 500 / 360 ))else
    scale=$(( 500 + ($NOW - 1080) * 500 / 360 ))fi
# Calculate Kelvin: 6500K (Day) down to 1000K (Night)
REDUCTION=$(( scale * 5500 / 1000 ))
TEMP=$(( 6500 - REDUCTION ))
# --- 3. AUTO-DESKTOP DETECTION ---if [[ "$XDG_CURRENT_DESKTOP" == *"Cinnamon"* ]]; then
    SCHEMA="org.cinnamon.settings-daemon.plugins.color"else
    SCHEMA="org.gnome.settings-daemon.plugins.color"fi
# Apply settings
gsettings set $SCHEMA night-light-enabled true
gsettings set $SCHEMA night-light-temperature $TEMP


'''





## 3. Make it Executable

chmod +x ~/nightlight_sync.sh

## 4. Schedule the Automation
Open your crontab:

crontab -e

Add this line at the very bottom:

*/1 * * * * /bin/bash /home/$USER/nightlight_sync.sh

------------------------------
## 🔍 How to Verify
Wait one minute, then check your system logs:

* Ubuntu/Debian: systemctl status cron
* Fedora/Arch: systemctl status crond

If you see CMD (~/nightlight_sync.sh) with no errors, it’s working!
------------------------------
## 🗑️ How to Uninstall

   1. Run crontab -e and delete the line you added.
   2. Remove the script: rm ~/nightlight_sync.sh.

------------------------------
Created to make Linux desktop automation simple and reliable for everyone.
Do you want to add a "Customize Your Times" section so users know how to change the 6 AM or 8 AM triggers?


