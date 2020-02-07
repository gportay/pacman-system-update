#!/bin/bash
#
# Copyright (c) 2020 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

set -e
set -u
set -o pipefail

systemctl() {
	echo "(not) $1..."
}

plymouth() {
	if [[ "$1" == "--ping" ]]
	then
		return 0
	fi

	echo "$@"
}

source ./pacman-system-update "$@"
