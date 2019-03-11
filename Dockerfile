FROM centos:7
LABEL maintainer="Nimbix, Inc."

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20190310.0900}

ARG GIT_BRANCH
ENV GIT_BRANCH ${GIT_BRANCH:-master}

RUN curl -H 'Cache-Control: no-cache' \
https://raw.githubusercontent.com/nimbix/image-common/$GIT_BRANCH/install-nimbix.sh \
    | bash

ARG SERIAL2
ENV SERIAL2 ${SERIAL2:-20190311.1000}

ENV NB_BRANCH=testing
ADD https://raw.githubusercontent.com/nimbix/notebook-common/$NB_BRANCH/install-centos.sh /tmp/install-centos.sh
RUN bash /tmp/install-centos.sh && rm -f /tmp/install-centos.sh

ADD NAE/help.html /etc/NAE/help.html
ADD NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
