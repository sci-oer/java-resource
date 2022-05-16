FROM alpine:latest AS build-javadoc
COPY javadocs/jdk-11.0.14_doc-all.zip javadoc.zip
RUN unzip javadoc.zip -d javadoc

FROM marshallasch/base-resource:main

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.url="https://github.com/sci-oer/java-resource.git"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/java-resource.git"
LABEL org.opencontainers.image.vendor="University of Guelph School of Computer Science"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Java Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is the Java specific image that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"

ARG GRADLE_VERSION=7.4.1

# setup the man pages
# RUN yes | unminimize

USER root

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
&& rm -rf /var/lib/apt/lists/*

# install gradle
RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip --output /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest && \
    echo 'export GRADLE_HOME=/opt/gradle/latest\nexport PATH=${GRADLE_HOME}/bin:${PATH}\n' >> /etc/profile.d/02-gradle.sh

COPY --from=build-javadoc /javadoc/ /opt/static/

COPY database.sqlite /opt/wiki/database.sqlite

# install jupyter dependancies
RUN pip3 install beakerx-kernel-java

# Install jupyter kernels
RUN beakerx_kernel_java install

# copy all the builtin jupyter notebooks
COPY builtinNotebooks /builtin/jupyter
RUN chown -R ${UID}:${UID} /builtin /opt/static /opt/wiki

COPY motd.txt /scripts/
RUN chown -R ${UID}:${UID} /scripts

USER ${UNAME} 

# these two labels will change every time the container is built
# put them at the end because of layer caching
ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
