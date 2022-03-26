FROM alpine:latest AS build-javadoc
COPY javadocs/jdk-11.0.14_doc-all.zip javadoc.zip
RUN unzip javadoc.zip -d javadoc

FROM ubuntu:focal

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.url="https://github.com/sci-oer/oo-resources.git"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/oo-resources.git"
LABEL org.opencontainers.image.vendor="University of Guelph School of Computer Science"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is a base that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"


ARG GRADLE_VERSION=7.4.1
ARG WIKI_VERSION=v2.5.276
ARG NODE_VERSION=16
ARG JUPYTER_PORT=8888

ENV DEBIAN_FRONTEND=noninteractive  \
    TERM=xterm-256color \
    UID=1000 \
    UNAME=student \
    JUPYTER_PORT=${JUPYTER_PORT}


WORKDIR /course
VOLUME [ "/course", "/wiki_data" ]
ENTRYPOINT [ "/scripts/entrypoint.sh" ]


EXPOSE 3000
EXPOSE 8000
EXPOSE ${JUPYTER_PORT}
EXPOSE 22

# create a 'normal' user so everything does not need to be run as root
RUN useradd -m -s /bin/bash -u "${UID}" "${UNAME}" && \
    echo "${UNAME}:password" | chpasswd

RUN mkdir -p \
        /wiki_data \
        /builtin/jupyter \
        /builtin/coursework \
        /builtin/lectures  \
        /builtin/practiceProblems

# setup the man pages
# RUN yes | unminimize

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    vim \
    nano \
    openssh-server \
    nginx \
    openjdk-11-jdk \
    man \
    unzip \
    gcc \
    g++ \
    make \
    build-essential \
    sqlite3 \
    python3-dev \
    python-dev \
    pip \
    tini \
    sudo \
&& rm -rf /var/lib/apt/lists/*

RUN echo "${UNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME}

COPY --from=build-javadoc /javadoc/ /opt/javadocs/11/

# install gradle
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest && \
    echo 'export GRADLE_HOME=/opt/gradle/latest\nexport PATH=${GRADLE_HOME}/bin:${PATH}\n' >> /etc/profile.d/02-gradle.sh


# install node
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm


# install wikijs
RUN wget https://github.com/Requarks/wiki/releases/download/${WIKI_VERSION}/wiki-js.tar.gz -P /tmp && \
    mkdir -p /opt/wiki/sideload && \
    tar xzf /tmp/wiki-js.tar.gz -C /opt/wiki && \
    rm /tmp/wiki-js.tar.gz

COPY configs/wiki_config.yml /opt/wiki/config.yml
RUN cd /opt/wiki && \
    npm rebuild sqlite3
COPY database.sqlite /opt/wiki/database.sqlite

# add the sideload files
ADD https://raw.githubusercontent.com/Requarks/wiki-localization/master/en.json /opt/wiki/sideload/
ADD https://raw.githubusercontent.com/Requarks/wiki-localization/master/locales.json /opt/wiki/sideload/

# install jupyter dependancies
RUN pip3 install \
    jupyter \
    jupyterlab \
    ipykernel \
    beakerx-kernel-java \
    beakerx

# Install jupyter kernerls
RUN beakerx install && \
    beakerx_kernel_java install

COPY configs/jupyter_lab_config.py /opt/jupyter/jupyter_lab_config.py

# copy all the builtin jupyter notebooks
COPY builtinNotebooks /builtin/jupyter
RUN chown -R ${UID}:${UID} /builtin /course /opt/wiki /wiki_data

COPY scripts /scripts/
COPY motd.txt /scripts/
RUN chown -R ${UID}:${UID} /scripts

USER ${UNAME} 
RUN ln -s /course ~/course

RUN echo 'export PS1="\[\033[01;32m\]oer\[\033[00m\]-\[\033[01;34m\]\W\[\033[00m\]\$ "' >> ~/.bashrc

# these two labels will change every time the container is built
# put them at the end because of layer caching
ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
