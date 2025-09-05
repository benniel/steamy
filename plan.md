# Project Modernization Plan: Steamy

This document outlines the plan to transition Steamy from a manual script-based installation to an industry-standard Linux utility.

Note that this project uses jujutsu for version control.

## 1. Architecture Goals
- **Stateless Installation**: The installation process should not modify user home directories.
- **Configuration Hierarchy**: Implement a "System Default $\rightarrow$ User Override" lookup pattern.
- **Package Manager Readiness**: Move away from `install.sh` toward a structure compatible with standard Linux package managers (e.g., Arch PKGBUILD, Debian .deb).
- **Principle of Least Privilege**: Ensure system files are owned by root and user files are owned by the user.

## 2. Proposed File Structure Changes

### New Target Installation Paths
| Current Path | New System Path | Purpose |
| :--- | :--- | :--- |
| `scripts/*` | `/usr/share/steamy/` | Application logic (Read-only) |
| `config/default.conf` | `/usr/share/steamy/default.conf` | System-wide default settings |
| `icons/*` | `/usr/share/steamy/icons/` | Static assets |
| `udev/rules.d/*` | `/etc/udev/rules.d/` | Local system hardware rules |
| `systemd/system/*` | `/usr/lib/systemd/user/` | User-level systemd services |
| `etc/profile.d/*` | *Remove* | Replace with service-based environment handling |

## 3. Technical Implementation Details

### A. Configuration Logic Update
Update all scripts in `scripts/` to implement the following lookup order:
1. Check for `~/.config/steamy/steamy.conf`
2. Fallback to `/usr/share/steamy/default.conf`
3. Use a hardcoded safe default if both are missing.

### B. Systemd & Udev Refinement
- **Udev**: Relocate rules to `/etc/udev/rules.d/` to adhere to the FHS (Filesystem Hierarchy Standard) for local admin rules.
- **Systemd**: Keep services in `/usr/lib/systemd/user/` but remove the `sudo` requirement for starting them. The user should run `systemctl --user enable --now steamy`.

### C. Removal of `install.sh` and `uninstall.sh`
- Replace these with a `Makefile` and a package definition file.
- The `Makefile` will serve as a developer tool to install the project locally for testing, while the package manager handles production deployment.

### D. Environment Variables
- Remove the `/etc/profile.d/steamy.sh` injection. 
- If the scripts need specific environment variables, they should be defined within the `default.conf` or the systemd service file's `Environment=` directive.

## 4. Execution Roadmap

### Phase 1: Logic Refactoring
- [ ] Modify `notify.sh`, `launch.sh`, and `xbox_battery.sh` to use the new configuration hierarchy.
- [ ] Update scripts to reference `/usr/share/steamy/` as the base directory.
- [ ] Remove dependency on `profile.d` scripts.

### Phase 2: Packaging & Deployment
- [ ] Create a `Makefile` to automate the installation of files to the new paths.
- [ ] Draft a package specification (e.g., a PKGBUILD) to formalize dependencies (`notify-send`, `systemd`, `udev`).
- [ ] Implement a "Post-Install" hook to reload udev rules.

### Phase 3: Documentation & Cleanup
- [ ] Update `README.md` with instructions on how to create a user override config.
- [ ] Delete `install.sh` and `uninstall.sh`.
- [ ] Verify the "Clean Uninstall" experience via the package manager.
- [ ] **Environment Verification**: 
    - Test if `notify-send` works correctly from the systemd user services.
    - **Critical**: Verify that Steam (or other GUI launchers) starts correctly. Since systemd user services lack session environment variables (`DISPLAY`, `WAYLAND_DISPLAY`), ensure the launch logic handles this or document the requirement to run `systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP`.

## 5. Success Criteria
- [ ] `sudo pacman -R` or `apt remove` leaves no trace of the app except for the optional `~/.config/steamy` folder.
- [ ] App works immediately after install without any user configuration.
- [ ] User can change settings in `~/.config/steamy/steamy.conf` without needing root privileges.
