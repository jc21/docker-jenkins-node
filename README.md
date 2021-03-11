# Jenkins Node/Agent running in a Docker container

This is useful for spinning up a jenkins agent easily without having to
install required software on a bare bones host.

The the [docker-compose.yml](docker-compose.yml) file for example usage.

This will use the [jenkins swarm plugin](https://plugins.jenkins.io/swarm/)
to connect to a jenkins server.

## Extending

To install any other required packages create your own `Dockerfile`:

```
FROM jc21/jenkins-node

RUN yum -y install nameofmypackage
```

## Caveats

Since this approach is using docker outside of docker, via a socket,
the paths of the jenkins workspace outside of the container must match
inside the container too.

eg: defining `/var/lib/docker` as the jenkins working folder inside
this container means that it will start docker containers on the host
with mounts inside the same path `/var/lib/docker`
