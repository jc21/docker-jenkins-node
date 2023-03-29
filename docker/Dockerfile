FROM debian:bullseye-slim

ENV LANG=en_US.utf8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8 \
	LC_CTYPE=en_US.UTF-8

ARG TARGETPLATFORM
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY docker/rootfs/usr/bin/common.sh /usr/bin/
COPY scripts/install-things /tmp/install-things
RUN /tmp/install-things "${TARGETPLATFORM}" \
	&& rm -f /tmp/install-things

# root fs files
COPY docker/rootfs /

ENV HOME=/home/jenkins
VOLUME /var/lib/jenkins-node
CMD [ "/init" ]
