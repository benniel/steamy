#!/bin/bash

# Configuration Lookup
USER_CONFIG="$HOME/.config/steamy/steamy.conf"
SYSTEM_CONFIG="/usr/share/steamy/default.conf"

if [[ -f "$USER_CONFIG" ]]; then
    source "$USER_CONFIG"
elif [[ -f "$SYSTEM_CONFIG" ]]; then
    source "$SYSTEM_CONFIG"
else
    # Hardcoded fallbacks
    launcher_exec=()
    launcher_name="Unknown"
    launcher_icon="/usr/share/steamy/icons/transparent-steam.png"
    controller_icon="/usr/share/steamy/icons/transparent-controller.png"
fi

Test() {
    notify-send "Steamy" "Steamy is running" \
        -i "$controller_icon" \
        -a steamy \
        -u normal
}

NewControllerConnected() {
    # Use controller number to prevent this notification from
    # being replaced by other controllers connecting around the
    # same time
    controllers=$(ls -l /dev/input | grep -E "^js[[:digit:]]+$" | wc -l)

    # Get the battery level for the latest controller
    upower_path=$(upower -e | grep gip | tail -n1)
    battery_level=$(upower -i "$upower_path" | grep "battery-level" | awk '{print $2}')

    notify-send "Controller connected" "Battery: $battery_level" \
        -i "$controller_icon" \
        -a "$controllers" \
        -u normal

    if false; then
        # Disabled for now, because controller key mapping and
        # window manager config is required for this to work.
        notify-send "Steamy" "Press 󰄝 to focus Steam" \
            -i "$steam_icon" \
            -u normal
    fi
}

ControllerDisconnected() {
    notify-send "Steamy" "Controller disconnected" \
        -i "$controller_icon" \
        -u normal
}

#################################

while getopts "dnt" opt; do
    case $opt in
        d) ControllerDisconnected ;;
        n) NewControllerConnected ;;
        t) Test ;;
        *)
            echo "Syntax: notify {-d | -n | -t}" >& 2
            exit 1 ;;
    esac
done
