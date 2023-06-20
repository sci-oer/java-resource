FROM alpine:latest AS build-javadoc
COPY javadocs/jdk-17.0.7_doc-all.zip javadoc.zip
RUN unzip javadoc.zip -d javadoc

FROM alpine:latest AS unpack-gradle
ARG GRADLE_VERSION=8.1.1

RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle-${GRADLE_VERSION}-bin.zip
RUN unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && mv /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest

FROM scioer/base-resource:sha-40bb95e

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/java-resource.git"
LABEL org.opencontainers.image.vendor="sci-oer"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Java Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is the Java specific image that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"
LABEL org.opencontainers.image.base.name="registry-1.docker.io/scioer/base-resource:sha-40bb95e"

USER root

RUN echo 'export GRADLE_HOME=/opt/gradle/latest\nexport PATH=${GRADLE_HOME}/bin:${PATH}\n' >> /etc/profile.d/02-gradle.sh

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
&& rm -rf /var/lib/apt/lists/*

COPY --from=build-javadoc  --chown=${UID}:${UID} /javadoc/ /opt/static/
COPY --from=unpack-gradle /opt/gradle/latest /opt/gradle/latest

# install jupyter kernel
ARG KERNEL_VERSION=1.3.0
RUN curl -L "https://github.com/SpencerPark/IJava/releases/download/v$KERNEL_VERSION/ijava-$KERNEL_VERSION.zip" -o ijava.zip \
    && unzip ijava.zip \
    && python3 install.py --sys-prefix \
    && rm -rf java install.py ijava.zip

USER ${UNAME}

# these three labels will change every time the container is built
# put them at the end because of layer caching

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"

ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
