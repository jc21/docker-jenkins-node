#!/command/with-contenv bash
# shellcheck shell=bash

set -e

log_info 'Checking docker ...'

if [ -S /var/run/docker.sock ]; then
	# Docker socket exists, let's match the group id on the socket to
	# the docker group inside this container
	HOST_DOCKER_GROUP=$(stat -c "%g" /var/run/docker.sock)
	if [ "${HOST_DOCKER_GROUP}" != "0" ]; then
		# This gives the jenkins user the ability to run docker
		# commands against the socket without changing permissions
		# on the socket
		groupadd -f docker || true
		usermod -aG docker jenkins
		groupmod -o -g "${HOST_DOCKER_GROUP}" docker
	else
		echo '(!) Not applying docker group changes as socket group is root'
	fi
fi
