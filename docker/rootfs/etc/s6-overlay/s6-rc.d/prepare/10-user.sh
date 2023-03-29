#!/command/with-contenv bash
# shellcheck shell=bash

set -e

PUID=${PUID:-911}
PGID=${PGID:-911}
JENKINS_DATA="${JENKINS_DATA:-/var/lib/jenkins-node}"

log_info 'Configuring user ...'

mkdir -p "${JENKINS_DATA}"
chown -R "${PUID}:${PGID}" "${JENKINS_DATA}" /home/jenkins

if id -u jenkins; then
	# user already exists
	usermod -u "${PUID}" jenkins || exit 1
else
	# Add npmuser user
	useradd -u "${PUID}" -U -d /home/jenkins -s /bin/false jenkins || exit 1
fi

usermod -G jenkins jenkins || exit 1
groupmod -o -g "$PGID" jenkins || exit 1
usermod -aG root jenkins

echo "-------------------------------------
User UID:   $(id -u jenkins)
User GID:   $(id -g jenkins)
Workspace:  ${JENKINS_DATA}
-------------------------------------
"
