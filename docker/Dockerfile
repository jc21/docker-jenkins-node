FROM centos:7

ENV SWARM_VERSION=3.39 \
	COMPOSE_VERSION=2.10.0 \
	LANG=en_US.utf8

ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# docker yum repo
COPY docker/rootfs/etc/yum.repos.d/docker-ce.repo /etc/yum.repos.d/

# yum, docker, ssh, extras
# RUN yum -y install epel-release \
# 	&& yum -y install docker-ce-cli bash openssh-clients git jq figlet moreutils zip dive docker-slim \
# 	&& yum clean all \
# 	&& docker --version

RUN yum -y install epel-release
RUN yum -y install docker-ce-cli bash openssh-clients git jq figlet moreutils zip dive docker-slim
RUN yum clean all
RUN docker --version

COPY docker/rootfs/usr/bin/common.sh /usr/bin/

# oracle java
COPY scripts/install-java /tmp/install-java
RUN /tmp/install-java "${TARGETPLATFORM}" && rm -f /tmp/install-java

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-$(uname -s | sed -e 's/\(.*\)/\L\1/')-$(uname -m | sed -e 's/\(.*\)/\L\1/')" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose \
	&& /usr/local/bin/docker-compose --version

# swarm client
RUN curl -L "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}.jar" -o /swarm-client.jar

# nodejs, yarn
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - \
	&& yum -y install nodejs gcc-c++ make \
	&& yum clean all \
	&& npm -g install yarn \
	&& node --version

# s6 overlay
COPY scripts/install-s6 /tmp/install-s6
RUN /tmp/install-s6 "${TARGETPLATFORM}" && rm -f /tmp/install-s6

# root fs files
COPY docker/rootfs /

ENV HOME=/home/jenkins
VOLUME /var/lib/jenkins-node
CMD [ "/init" ]
