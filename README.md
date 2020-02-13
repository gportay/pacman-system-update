# pacman-system-update

## NAME

[pacman-system-update][pacman-system-update(8)] - offline updates in systemd
using pacman

## DESCRIPTION

[pacman-system-update(8)] can be used to upgrade an Arch Linux system or any of
its derivatives.

It implements the "offline" updates in systemd, [systemd.offline-updates(7)].

pacman-system-update tells [plymouth(8)] about update progress if the plymouth
daemon is up and running.

## LINKS

Check for [man-pages][pacman-system-update(8)] and its [examples].

Enjoy!

## BUGS

Report bugs at *https://github.com/gportay/pacman-system-update/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@gmail.com*

## COPYRIGHT

Copyright (c) 2020 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation, either version 2.1 of the License, or (at your option) any
later version.

## SEE ALSO

[pacman(8)], [systemd.offline-updates(7)], [plymouth(8)]

[pacman-system-update(8)]: pacman-system-update.8.adoc
[examples]: pacman-system-update.8.adoc#examples
[pacman(8)]: https://www.mankier.com/8/pacman
[systemd.offline-updates(7)]: https://www.mankier.com/7/systemd.offline-updates
[plymouth(8)]: https://www.mankier.com/8/plymouth
