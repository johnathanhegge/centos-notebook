FROM centos:7
LABEL maintainer="Nimbix, Inc."

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20190310.0900}

ENV NB_BRANCH=redir
ADD https://raw.githubusercontent.com/nimbix/notebook-common/$NB_BRANCH/install-centos.sh /tmp/install-centos.sh
RUN bash /tmp/install-centos.sh -b $NB_BRANCH && rm -f /tmp/install-centos.sh

ADD NAE/help.html /etc/NAE/help.html
ADD NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
