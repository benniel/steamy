#!/bin/bash

unset $launcher_exec
unset $launcher_name

while getopts c: opt; do
    case $opt in
        c)
            source $OPTARG
            [[ $? != 0 ]] && exit 1 ;;
        *)
            echo Syntax: launch.sh -c \<config file\> >& 2
            exit 1 ;;
    esac
done

[[ -n $launcher_exec ]] || exit 0

notify-send "Steamy" "Launching $launcher_name..." \
    -i $launcher_icon \
    -u normal

${launcher_exec[@]}
