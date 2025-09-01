#!/bin/bash

rm /etc/profile.d/steamy.sh

rm /usr/lib/systemd/user/steamy.service
rm /usr/lib/systemd/user/steamy-notify@.service

rm /usr/lib/udev/rules.d/99-steamy-xbox-controller.rules
udevadm control --reload

rm -r /usr/share/steamy

echo done
