# Steamy
A config utility to make some quality-of-life improvements to the Linux controller gaming experience.

## Current features
- Show a notification whenever a controller connects
- Show controller battery level in the connect notification
- Start Steam (or any other launcher application) when the first controller connects
- Flash the controller LED (slow) when the battery reaches 10% capacity
- Flash the controller LED (fast) when the battery reaches 5% capacity

# Installation Instructions
## Using a Package Manager
If you are using a distribution that supports `PKGBUILD` (like Arch Linux), you can build and install the package using `makepkg -si`.

**Important**: After installing via a package manager, you must run the following command so systemd recognizes the services:
```bash
systemctl --user daemon-reload
```

### Manual Installation
You can install Steamy manually using the provided Makefile:
```bash
sudo make install
```
The installation script will provide the necessary commands to prepare the system.

**Note**: Do NOT enable the `steamy` service manually. It is designed to be triggered automatically by udev when a controller is connected.

## Configuration
Steamy uses a configuration hierarchy. It first looks for a user-specific configuration file; if not found, it falls back to the system default.

**System Default:** `/usr/share/steamy/default.conf`
**User Override:** `~/.config/steamy/steamy.conf`

To customize Steamy:
1. Create the config directory: `mkdir -p ~/.config/steamy`
2. Copy the default config: `cp /usr/share/steamy/default.conf ~/.config/steamy/steamy.conf`
3. Edit `~/.config/steamy/steamy.conf` with your preferred settings.

### Note on GUI Launching
If you find that Steam or other GUI applications fail to launch automatically, ensure your systemd user session has imported the necessary environment variables. You can do this by adding the following to your session startup:
```bash
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
```

## Tested controllers
1. Microsoft wireless dongle
- Microsoft Xbox 360
- Microsoft Xbox Series X
