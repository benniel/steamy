# This should only run for normal users
[[ $(id -u) == 0 ]] && return

systemctl --user import-environment XDG_CURRENT_DESKTOP
