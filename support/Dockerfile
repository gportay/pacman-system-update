FROM archlinux/base:latest

ADD pacman-system-update /usr/bin/
ADD mirrorlist /etc/pacman.d/
RUN pacman --noconfirm -Sy sudo
RUN pacman-system-update
