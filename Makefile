#
# Copyright (c) 2020 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

PREFIX ?= /usr/local

.PHONY: all
all:

.PHONY: doc
doc: pacman-system-update.8.gz

.PHONY: install
install:
	install -D -m755 pacman-system-update $(DESTDIR)$(PREFIX)/bin/pacman-system-update
	install -D -m644 pacman-system-update.service $(DESTDIR)$(PREFIX)/lib/systemd/system/pacman-system-update.service
	install -d $(DESTDIR)$(PREFIX)/lib/systemd/system/system-update.target.wants/
	ln -sf ../pacman-system-update.service $(DESTDIR)$(PREFIX)/lib/systemd/system/system-update.target.wants/pacman-system-update.service
	install -d $(DESTDIR)/var/lib/system-update/
	install -D -m644 pacman-system-update.8.gz $(DESTDIR)$(PREFIX)/share/man/man8/pacman-system-update.8.gz
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) --variable=completionsdir bash-completion)}; \
	if [ -n "$$completionsdir" ]; \
	then \
		install -D -m644 bash-completion $(DESTDIR)$$completionsdir/pacman-system-update; \
	fi

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/pacman-system-update
	rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/pacman-system-update
	rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/system-update.target.wants/pacman-system-update
	rm -f $(DESTDIR)$(PREFIX)/share/man/man8/pacman-system-update.8.gz
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) --variable=completionsdir bash-completion)}; \
	if [ -n "$$completionsdir" ]; \
	then \
		rm -f $(DESTDIR)$$completionsdir/pacman-system-update; \
	fi

.PHONY: ci
ci: check

.PHONY: check
check:
	shellcheck pacman-system-update

ifneq (,$(BUMP_VERSION))
.SILENT: bump
.PHONY: bump
bump: export GPG_TTY ?= $(shell tty)
bump:
	! git tag | grep "^$(BUMP_VERSION)$$"
	old="$$(bash pacman-system-update --version)"; \
	sed -e "/^VERSION=/s,$$old,$(BUMP_VERSION)," -i pacman-system-update; \
	sed -e "/^:man source:/s,$$old,$(BUMP_VERSION)," -i pacman-system-update.8.adoc; \
	sed -e "/^pkgver=/s,$$old,$(BUMP_VERSION)," -e "/^pkgrel=/s,=.*,=1," -i PKGBUILD
	git commit --gpg-sign pacman-system-update pacman-system-update.8.adoc PKGBUILD --patch --message "Version $(BUMP_VERSION)"
	git tag --sign --annotate --message "$(BUMP_VERSION)" "v$(BUMP_VERSION)"
else
.SILENT: bump-major
.PHONY: bump-major
bump-major:
	old="$$(bash pacman-system-update --version)"; \
	new="$$(($${old%.*}+1))"; \
	$(MAKE) bump "BUMP_VERSION=$$new"

.SILENT: bump-minor
.PHONY: bump-minor
bump-minor:
	old="$$(bash pacman-system-update --version)"; \
	if [ "$${old%.*}" = "$$old" ]; then old="$$old.0"; fi; \
	new="$${old%.*}.$$(($${old##*.}+1))"; \
	$(MAKE) bump "BUMP_VERSION=$$new"

.SILENT: bump
.PHONY: bump
bump: bump-major
endif

.PHONY: commit-check
commit-check:
	git rebase -i -x "$(MAKE) check && $(MAKE) tests"

.PHONY: tests
tests:
	dosh --dockerfile support/Dockerfile -c 'sudo bash support/pacman-system-update-plymouth.bash --now'

.PHONY: rebuild
rebuild:
	dosh --dockerfile support/Dockerfile --rebuild </dev/null

.PHONY: clean
clean:
	rm -f PKGBUILD.tmp *.tar.gz src/*.tar.gz *.pkg.tar.xz \
	   -R src/pacman-system-update-*/ pkg/pacman-system-update-*/ pacman-system-update-git/

.PHONY: aur
aur: PKGBUILD
	makepkg --force --syncdeps 

.PHONY: aur-git
aur-git: PKGBUILD.tmp
	makepkg --force --syncdeps -p $^

PKGBUILD.tmp: PKGBUILD-git
	cp $< $@

%.8: %.8.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $< >$@

