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
    BATTERY_LOW_MODE=3
    BATTERY_NORMAL_MODE=1
fi

# The warning that upower displays when the battery is low
BATTERY_LOW_WARNING=low

upower_path=$(upower -e | grep "$1")

if [[ -n $upower_path ]]; then
    battery_warning=$(
        upower -i "$upower_path" | grep "warning-level" | awk '{print $2}'
    )

    class=/sys/class/leds
    mode_file=mode
    led_mode_file=$class/$(ls $class | grep "$1")/$mode_file

    if [[ $battery_warning == $BATTERY_LOW_WARNING  ]]; then
        mode=$BATTERY_LOW_MODE
    else
        mode=$BATTERY_NORMAL_MODE
    fi

    echo "$mode $led_mode_file"
    echo "$mode" > "$led_mode_file"
fi
