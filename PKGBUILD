# Maintainer: Gaël PORTAY <gael.portay@gmail.com>

pkgname=pacman-system-update
pkgver=1
pkgrel=1
pkgdesc='Implementation of Offline System Updates using pacman'
arch=('any')
url="https://github.com/gportay/$pkgname"
license=('LGPL2.1')
checkdepends=('shellcheck')
optdepends=('plymouth: boot splash screen')
source=("https://github.com/gportay/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('293a81054194329ecbd93b9b3acb855a57256d8945563adffbce848893ad144c')
validpgpkeys=('8F3491E60E62695ED780AC672FA122CA0501CA71')

build() {
	cd "$srcdir/$pkgname-$pkgver"
	make doc SHELL="/bin/sh"
}

check() {
	cd "$srcdir/$pkgname-$pkgver"
	make -k check
}

package() {
	cd "$srcdir/$pkgname-$pkgver"
	make DESTDIR="$pkgdir" PREFIX="/usr" install
	install -D -m 644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
