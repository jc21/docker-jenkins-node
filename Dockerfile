FROM centos:7

SHELL ["/bin/bash", "-c"]

ENV COMPOSE_VERSION=1.28.5 \
	S6_VERSION=2.2.0.3

# docker yum repo
COPY rootfs/etc/yum.repos.d/docker-ce.repo /etc/yum.repos.d/

# yum, docker, ssh, extras
RUN yum -y localinstall 'https://yum.jc21.com/jc21-yum.rpm' \
	&& yum -y install epel-release \
	&& yum -y install docker-ce-cli bash openssh-server openssh-clients git jq figlet moreutils zip \
	&& yum clean all

# oracle java
RUN curl -L "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=244057_89d678f2be164786b292527658ca1605" -o /tmp/java.rpm \
	&& yum -y localinstall /tmp/java.rpm \
	&& rm -f /tmp/java.rpm

# ssh config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
	&& sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config \
	&& sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

# nodejs, yarn
RUN curl -fsSL https://rpm.nodesource.com/setup_15.x | bash -
RUN yum -y install nodejs gcc-c++ make
RUN npm -g install yarn

# s6 overlay
ENV SUPPRESS_NO_CONFIG_WARNING=1
ENV S6_FIX_ATTRS_HIDDEN=1
RUN echo "fs.file-max = 65535" > /etc/sysctl.conf
RUN curl -L -o /tmp/s6-overlay-amd64.tar.gz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz" \
	&& tar -xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
	&& tar -xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
	&& rm -f /tmp/s6-overlay-amd64.tar.gz

# root fs files
COPY rootfs /

RUN docker --version
RUN java -version
RUN node --version

EXPOSE 22
VOLUME /jenkins
CMD [ "/init" ]
