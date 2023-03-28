# Jenkins Node/Agent running in a Docker container

This is useful for spinning up a jenkins agent easily without having to
install required software on a bare bones host.

The the [docker-compose.yml](docker-compose.yml) file for example usage.

This will use the [jenkins swarm plugin](https://plugins.jenkins.io/swarm/)
to connect to a jenkins server.

[Docker image](https://hub.docker.com/r/jc21/jenkins-node) is built on Debian and
has support for the following architectures:
- amd64
- arm64
- armv7

## Extending

To install any other required packages create your own `Dockerfile`:

```
FROM jc21/jenkins-node

RUN apt-get install -y install nameofmypackage
```

## Caveats

Since this approach is using docker outside of docker, via a socket,
the paths of the jenkins workspace outside of the container must match
inside the container too.

eg: defining `/var/lib/docker` as the jenkins working folder inside
this container means that it will start docker containers on the host
with mounts inside the same path `/var/lib/docker`

## Example Usage

```yml
version: "3"

services:
  jenkins-node:
    image: jc21/jenkins-node:latest
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - JENKINS_DATA=/var/lib/jenkins-node
      # Space delimiters labels for this node. This will be automatically appended on start
      - LABELS=docker rpmbuild
      # Jenkins Host to connect to
      - MASTER=https://ci.jc21.com
      # Mode for this node: normal|exclusive. Default: normal
      - MODE=normal
      # Number of executors
      - EXECUTORS=2
      # Name of this jenkins node, default is the docker container hostname
      - NAME=taurus
      # Description of this node, defaults to something not very useful
      - DESCRIPTION=Linux 5.13.11-1.el8.elrepo.x86_64 x86_64
      # The Jenkins username for authentication.
      - USERNAME=swarmmaster
      # The Jenkins user API token or password
      - PASSWORD=somethingsecret
    volumes:
      # This is required for docker control
      - '/var/run/docker.sock:/var/run/docker.sock'
      # This mount should be the same inside and out
      # and should be the same as JENKINS_DATA above
      - '/var/lib/jenkins-node:/var/lib/jenkins-node'
```
