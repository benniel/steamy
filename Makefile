# Variables
PREFIX ?= /usr
SHARE_DIR = $(PREFIX)/share/steamy
ETC_DIR = $(PREFIX)/etc/udev/rules.d
SYSTEMD_DIR = $(PREFIX)/lib/systemd/user

# Files
CONFIG_FILE = config/default.conf
ICONS_DIR = icons
SCRIPTS_DIR = scripts
UDEV_RULE = udev/rules.d/99-steamy-xbox-controller.rules
SYSTEMD_FILES = $(wildcard systemd/system/*.service)

.PHONY: all install uninstall clean

all:
	@echo "Use 'sudo make install' to install Steamy to the system."

install:
	@echo "Installing Steamy..."
	# Create directories
	sudo mkdir -p $(SHARE_DIR)
	sudo mkdir -p $(ETC_DIR)
	sudo mkdir -p $(SYSTEMD_DIR)

	# Install scripts and config
	sudo cp $(SCRIPTS_DIR)/* $(SHARE_DIR)/
	sudo cp $(CONFIG_FILE) $(SHARE_DIR)/default.conf
	
	# Install icons
	sudo cp -r $(ICONS_DIR) $(SHARE_DIR)/

	# Install udev rules
	sudo cp $(UDEV_RULE) $(ETC_DIR)/

	# Install systemd user services
	sudo cp $(SYSTEMD_FILES) $(SYSTEMD_DIR)/

	# Reload udev
	sudo udevadm control --reload
	@echo ""
	@echo "-----------------------------------------------------------"
	@echo "Installation complete!"
	@echo "To ensure Steamy starts when a controller is connected,"
	@echo "please run the following command once:"
	@echo ""
	@echo "  systemctl --user daemon-reload"
	@echo "-----------------------------------------------------------"

uninstall:
	@echo "Uninstalling Steamy..."
	sudo rm -rf $(SHARE_DIR)
	sudo rm -f $(ETC_DIR)/99-steamy-xbox-controller.rules
	sudo rm -f $(SYSTEMD_DIR)/steamy*
	sudo udevadm control --reload
	@echo "Uninstallation complete."

clean:
	# Nothing to clean in this project currently
	@echo "Nothing to clean."
