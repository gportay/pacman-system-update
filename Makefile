#
# Copyright (c) 2020 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

PREFIX ?= /usr/local

.PHONY: all
all:

.PHONY: install
install:
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 755 pacman-system-update $(DESTDIR)$(PREFIX)/bin/
	install -d $(DESTDIR)$(PREFIX)/lib/systemd/system/
	install -m 644 pacman-system-update.service $(DESTDIR)$(PREFIX)/lib/systemd/system/
	install -d $(DESTDIR)$(PREFIX)/lib/systemd/system/system-update.target.wants/
	ln -sf ../pacman-system-update.service $(DESTDIR)$(PREFIX)/lib/systemd/system/system-update.target.wants/pacman-system-update.service
	install -d $(DESTDIR)/var/lib/system-update/

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/pacman-system-update
	rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/pacman-system-update
	rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/system-update.target.wants/pacman-system-update

.PHONY: ci
ci: check

.PHONY: check
check:
	shellcheck pacman-system-update

.PHONY: commit-check
commit-check:
	git rebase -i -x "$(MAKE) check && $(MAKE) tests"

.PHONY: clean
clean:
	rm -f PKGBUILD *.tar.gz src/*.tar.gz *.pkg.tar.xz \
	   -R src/pacman-system-update-*/ pkg/pacman-system-update-*/ pacman-system-update-git/

.PHONY: aur
aur: PKGBUILD
	makepkg --force --syncdeps 

.PHONY: PKGBUILD
PKGBUILD: PKGBUILD-git
	cp $< $@

