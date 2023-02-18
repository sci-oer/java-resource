FROM alpine:latest AS build-javadoc
COPY javadocs/jdk-11.0.14_doc-all.zip javadoc.zip
RUN unzip javadoc.zip -d javadoc

FROM alpine:latest AS unpack-gradle
ARG GRADLE_VERSION=7.5.1

RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle-${GRADLE_VERSION}-bin.zip
RUN unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && mv /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest

FROM marshallasch/base-resource:sha-6ae2b4c

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.url="https://github.com/sci-oer/java-resource.git"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/java-resource.git"
LABEL org.opencontainers.image.vendor="University of Guelph School of Computer Science"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Java Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is the Java specific image that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"


USER root

RUN echo 'export GRADLE_HOME=/opt/gradle/latest\nexport PATH=${GRADLE_HOME}/bin:${PATH}\n' >> /etc/profile.d/02-gradle.sh

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
&& rm -rf /var/lib/apt/lists/*


COPY --from=build-javadoc  --chown=${UID}:${UID} /javadoc/ /opt/static/

COPY --from=unpack-gradle /opt/gradle/latest /opt/gradle/latest

# install jupyter dependancies
RUN pip3 install beakerx-kernel-java

# Install jupyter kernels
RUN beakerx_kernel_java install

USER ${UNAME}

# these three labels will change every time the container is built
# put them at the end because of layer caching

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"

ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
