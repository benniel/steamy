#!/bin/bash

BATTERY_LOW_LEVEL_PERCENT=10
BATTERY_CRITICAL_LEVEL_PERCENT=5

BATTERY_NORMAL_MODE=1
BATTERY_LOW_MODE=3
BATTERY_CRITICAL_MODE=2

upower_path=$(upower -e | grep $1)

if [[ -n $upower_path ]]; then
    battery_level=$(
        upower -i $upower_path | grep percentage | awk '{print $2}' | sed 's/%//'
    )

    class=/sys/class/leds
    mode_file=mode
    led_mode_file=$class/$(ls $class | grep $1)/$mode_file

    if [[ $battery_level -le $BATTERY_CRITICAL_LEVEL_PERCENT ]]; then
        mode=$BATTERY_CRITICAL_MODE
    elif [[ $battery_level -le $BATTERY_LOW_LEVEL_PERCENT ]]; then
        mode=$BATTERY_LOW_MODE
    else
        mode=$BATTERY_NORMAL_MODE
    fi

    echo $mode > $led_mode_file
fi
