FROM centos:7
LABEL maintainer="Nimbix, Inc."

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20190415.0900}

RUN curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
        | bash

ENV BRANCH=conda-test

ADD https://raw.githubusercontent.com/nimbix/notebook-common/${BRANCH:-master}/install-notebook-common /tmp/install-notebook-common
RUN bash /tmp/install-notebook-common -b "$BRANCH" -3 && rm /tmp/install-notebook-common

ADD NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
