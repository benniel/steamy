# Maintainer: Bennie <bennie@example.com>
pkgname=steamy
pkgver=1.0.0
pkgrel=1
pkgdesc="A config utility for quality-of-life improvements to Linux controller gaming"
arch=('any')
url="https://github.com/yourusername/steamy"
license=('MIT') # Adjusted based on LICENSE file in project
depends=('upower' 'libnotify' 'systemd')
options=('!strip')

pkgversion() {
    echo "1.0.0"
}

package() {
    # When running makepkg in the project root, the files are in the parent
    # directory of the build directory.
    local project_root="${srcdir}/.."

    # Install scripts and config to /usr/share/steamy
    install -d "${pkgdir}/usr/share/steamy"
    cp -a "$project_root/scripts/." "${pkgdir}/usr/share/steamy/"
    install -m 644 "$project_root/config/default.conf" "${pkgdir}/usr/share/steamy/default.conf"
    
    # Install icons
    install -d "${pkgdir}/usr/share/steamy/icons"
    cp -a "$project_root/icons/." "${pkgdir}/usr/share/steamy/icons/"

    # Install udev rules to /etc/udev/rules.d/
    install -d "${pkgdir}/etc/udev/rules.d"
    install -m 644 "$project_root/udev/rules.d/99-steamy-xbox-controller.rules" "${pkgdir}/etc/udev/rules.d/"

    # Install systemd user services to /usr/lib/systemd/user/
    install -d "${pkgdir}/usr/lib/systemd/user"
    cp -a "$project_root/systemd/system/." "${pkgdir}/usr/lib/systemd/user/"
}
