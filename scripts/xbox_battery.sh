#!/bin/bash

# The warning that upower displays when the battery is low
BATTERY_LOW_WARNING=low

# 3 = slow pulse
# 2 = fast pulse
# 1 = static on
# 0 = static off
BATTERY_LOW_MODE=3
BATTERY_NORMAL_MODE=1

upower_path=$(upower -e | grep $1)

if [[ -n $upower_path ]]; then
    battery_warning=$(
        upower -i $upower_path | grep "warning-level" | awk '{print $2}'
    )

    class=/sys/class/leds
    mode_file=mode
    led_mode_file=$class/$(ls $class | grep $1)/$mode_file

    if [[ $battery_warning == $BATTERY_LOW_WARNING  ]]; then
        mode=$BATTERY_LOW_MODE
    else
        mode=$BATTERY_NORMAL_MODE
    fi

    echo $mode $led_mode_file
    echo $mode > $led_mode_file
fi
