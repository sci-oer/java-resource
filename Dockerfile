FROM ubuntu:focal

ARG NB_USER="student"
ARG NB_UID="1000"
ARG NB_GID="100"

ARG GRADLE_VERSION=7.2

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \ 
    apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    vim \
    nano \
    openssh-server \
    nginx \
    openjdk-8-jdk \
    man \
    unzip \
    gcc \
    g++ \
    make \
    build-essential \
    sqlite3 \
    python3 \
    pip \
    tini


# install gradle 
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest && \
    echo -e 'export GRADLE_HOME=/opt/gradle/latest\nexport PATH=${GRADLE_HOME}/bin:${PATH}\n' >> /etc/profile.d/02-gradle.sh


# install node 14
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm

# install wikijs
RUN wget https://github.com/Requarks/wiki/releases/download/2.5.219/wiki-js.tar.gz -P /tmp && \
    mkdir /opt/wiki && \
    tar xzf /tmp/wiki-js.tar.gz -C /opt/wiki && \
    mkdir /wiki
ADD wiki_config.yml /opt/wiki/config.yml
RUN cd /opt/wiki && \
    npm rebuild sqlite3
ADD database.sqlite /wiki/database.sqlite
EXPOSE 3000



# install jupyter
RUN pip3 install jupyter && \
    mkdir /jupyter
EXPOSE 8888

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER="${NB_USER}" \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN useradd -l -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" 

# USER ${NB_UID}
# setup the man pages 
#RUN echo -e "y\ny\n" | unminimize

# create service file
#RUN echo -e '#!/bin/bash\ncd /opt/wiki\nNODE_ENV=production node server\n' > wiki.sh && \
#    chmod +x wiki.sh


ADD wiki.sh jupyter.sh entrypoint.sh /

CMD ["./entrypoint.sh"]
