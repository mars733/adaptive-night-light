#!/bin/bash

# 1. Environment Bridge (Works on Ubuntu, Fedora, Arch, etc.)
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# 2. Time Calculation Logic
H=$(date +%H)
M=$(date +%M)
NOW=$(( 10#$H * 60 + 10#$M ))

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

# 3. Universal Desktop Apply
# This checks if you are using Cinnamon, GNOME, or MATE and applies correctly
if [[ "$XDG_CURRENT_DESKTOP" == *"Cinnamon"* ]]; then
    SCHEMA="org.cinnamon.settings-daemon.plugins.color"
elif [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    SCHEMA="org.gnome.settings-daemon.plugins.color"
else
    # Fallback to GNOME schema as many desktops (like MATE/Budgie) use it
    SCHEMA="org.gnome.settings-daemon.plugins.color"
fi

gsettings set $SCHEMA night-light-enabled true
gsettings set $SCHEMA night-light-temperature $TEMP
y
