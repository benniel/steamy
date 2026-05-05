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

# Ensure launcher_exec is treated as an array even if not defined in config
[[ -z "${launcher_exec[0]}" ]] && launcher_exec=()

notify-send "Steamy" "Launching $launcher_name..." \
    -i "$launcher_icon" \
    -u normal

"${launcher_exec[@]}"
