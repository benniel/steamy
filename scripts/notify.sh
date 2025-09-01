#!/bin/bash

Test() {
    notify-send "Steamy" "Steamy is running" \
        -i $controller_icon \
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
    battery_level=$(upower -i $upower_path | grep percentage | awk '{print $2}')

    notify-send "Controller conntected" "Battery: $battery_level" \
        -i $controller_icon \
        -a $controllers \
        -u normal

    if false; then
        # Disabled for now, because controller key mapping and
        # window manager config is required for this to work.
        notify-send "Steamy" "Press 󰄝 to focus Steam" \
            -i $steam_icon \
            -u normal
    fi
}

ControllerDisconnected() {
    notify-send "Steamy" "Controller disconnected" \
        -i $controller_icon \
        -u normal
}

#################################

while getopts "c:dnt" opt; do
    case $opt in
        c)
            source $OPTARG
            [[ $? != 0 ]] && exit 1 ;;
        d) ControllerDisconnected ;;
        n) NewControllerConnected ;;
        t) Test ;;
        *)
            echo Syntax: notify -c \<config file\> {-d \| -n \| -t} $option >& 2
            exit 1 ;;
    esac
done
