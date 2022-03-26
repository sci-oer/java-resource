
FROM marshallasch/oo-resources:main

LABEL org.opencontainers.version="v1.0.0"
LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca"
LABEL org.opencontainers.image.url="docker.io/MarshallAsch/sample_container"
LABEL org.opencontainers.image.source="https://github.com/MarshallAsch/oo-resources.git"
LABEL org.opencontainers.image.vendor="University of Guelph School of Computer Science"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Offline Course Resouce for my example course"
LABEL org.opencontainers.image.description="This image containes all the content for my example course"

COPY builtinNotebooks /jupyter/builtin
COPY database.sqlite /opt/wiki/database.sqlite
COPY motd.txt /scripts/motd.txt

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
