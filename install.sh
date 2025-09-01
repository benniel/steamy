#!/bin/bash

if [[ -a /usr/share/steamy/ ]]; then
    echo /usr/share/steamy/ already exists.
    exit 1
fi

echo Admin is required to install steamy
sudo mkdir -p /usr/share/steamy

if [[ -a /usr/share/steamy/ ]]; then
    echo Installing steamy...
    sudo cp ./scripts/* /usr/share/steamy/
    mkdir -p ~/.config/steamy
    cp ./config/default.conf ~/.config/steamy/steamy.conf
    sudo cp -r ./icons/ /usr/share/steamy/

    echo Configuring system...
    sudo cp ./etc/profile.d/steamy.sh /etc/profile.d/
    sudo cp ./udev/rules.d/99-steamy-xbox-controller.rules /usr/lib/udev/rules.d/
    sudo udevadm control --reload

    echo Creating user services...
    sudo cp ./systemd/system/* /usr/lib/systemd/user/
    sudo systemctl --user --machine=$(id -u -n)@.host import-environment XDG_CURRENT_DESKTOP
    sudo systemctl --user --machine=$(id -u -n)@.host daemon-reload

    echo Testing. You should see a notification from steamy.
    /usr/share/steamy/notify.sh -c ~/.config/steamy/steamy.conf -t &
else
    echo Error creating /usr/share/steamy >& 2
    exit 1
fi
