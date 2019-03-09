FROM centos:7
LABEL maintainer="Nimbix, Inc."

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20190309.0700}

ARG GIT_BRANCH
ENV GIT_BRANCH ${GIT_BRANCH:-master}

RUN curl -H 'Cache-Control: no-cache' \
https://raw.githubusercontent.com/nimbix/image-common/$GIT_BRANCH/install-nimbix.sh \
#| bash -s -- --setup-nimbix-desktop  --image-common-branch $GIT_BRANCH
| bash

ADD NAE/help.html /etc/NAE/help.html
ADD NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

ENV NB_BRANCH=testing
ADD https://raw.githubusercontent.com/nimbix/notebook-common/$NB_BRANCH/install-centos.sh /tmp/install-centos.sh
#RUN bash /tmp/install-centos.sh && rm -f /tmp/install-centos.sh
RUN bash /tmp/install-centos.sh 3 && rm -f /tmp/install-centos.sh

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
