#!/command/with-contenv bash
# shellcheck shell=bash

set -e

. /usr/bin/common.sh

if [ "$(id -u)" != "0" ]; then
	log_fatal "This docker container must be run as root, do not specify a user.\nYou can specify PUID and PGID env vars to run processes as that user and group after initialization."
fi

. /etc/s6-overlay/s6-rc.d/prepare/10-user.sh
. /etc/s6-overlay/s6-rc.d/prepare/20-docker.sh
