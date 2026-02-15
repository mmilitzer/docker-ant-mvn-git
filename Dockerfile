FROM almalinux/9-base:latest

LABEL name="Ant, Maven and Git Image on AlmaLinux 9" \    
      vendor="Xvid" \
      release="1" \
      summary="Ant, Maven and Git based image on AlmaLinux 9" 

# Setting Maven, GraalVM and Ant versions that needs to be installed
ARG MAVEN_VERSION=3.6.3
ARG ANT_VERSION=1.10.12
ARG GIT_NAME=GitLab
ARG GIT_EMAIL=gitlab@xvid.com
ARG GRAALVM_NODEJS_VERSION=24.2.2
ARG GRAALVM_RPM_NAME=oracle-graalvm
ARG GRAALVM_JDK_VERSION=21
ARG GRAALVM_DIR_PATH=/opt/xvid

# Changing user to root to install maven
USER root

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

# Install required tools
# which: otherwise 'mvn version' prints '/usr/share/maven/bin/mvn: line 93: which: command not found'
RUN dnf update -y && \
  dnf install -y which wget tree git libxcrypt-compat rpm libnsl rpm-build langpacks-en glibc-langpack-en glibc-langpack-de openssh-clients glibc-locale-source rpmdevtools openssl-devel bzip2-devel libffi-devel && \
  dnf group install -y "Development Tools" && \
  dnf clean all

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Python 2
RUN cd /tmp && wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz && tar -xf Python-2.7.18.tar.xz \
  && cd Python-2.7.18 && ./configure --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" \
  && make && make install

# GraalVM
RUN mkdir -p ${GRAALVM_DIR_PATH} && curl -fL "https://download.oracle.com/graalvm/${GRAALVM_JDK_VERSION}/latest/graalvm-jdk-${GRAALVM_JDK_VERSION}_linux-x64_bin.tar.gz" -o /tmp/graalvm-jdk-${GRAALVM_JDK_VERSION}_linux-x64_bin.tar.gz \
  && curl -fL "https://github.com/oracle/graaljs/releases/download/graal-${GRAALVM_NODEJS_VERSION}/graalnodejs-jvm-${GRAALVM_NODEJS_VERSION}-linux-amd64.tar.gz" -o /tmp/graalnodejs-jvm-${GRAALVM_NODEJS_VERSION}-linux-amd64.tar.gz \
  && tar -C ${GRAALVM_DIR_PATH}/ -xzf /tmp/graalnodejs-jvm-${GRAALVM_NODEJS_VERSION}-linux-amd64.tar.gz \
  && mv ${GRAALVM_DIR_PATH}/graal*-${GRAALVM_NODEJS_VERSION}* ${GRAALVM_DIR_PATH}/${GRAALVM_RPM_NAME} \
  && rm -rf ${GRAALVM_DIR_PATH}/${GRAALVM_RPM_NAME}/jvm \
  && tar -C ${GRAALVM_DIR_PATH}/ -xzf /tmp/graalvm-jdk-${GRAALVM_JDK_VERSION}_linux-x64_bin.tar.gz \
  && mv ${GRAALVM_DIR_PATH}/graalvm-jdk* ${GRAALVM_DIR_PATH}/${GRAALVM_RPM_NAME}/jvm

ENV PATH $GRAALVM_DIR_PATH/$GRAALVM_RPM_NAME/bin:$PATH

# Ant
RUN curl -fsSL https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant

ENV ANT_VERSION ${ANT_VERSION}
ENV ANT_HOME /usr/share/ant
ENV PATH $ANT_HOME/bin:$PATH

# Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_VERSION ${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# Sincerity
RUN curl -fsSL https://storage.sbg.cloud.ovh.net/v1/AUTH_2f09a59f038d477ba0b6754f757c5ac2/test/bzSS5rwgjn3aSwOEycwqih2UDZFvfSKiD/sincerity-1.0-beta15.rpm >./sincerity-1.0-beta15.rpm \
  && rpm -i sincerity-1.0-beta15.rpm && rm ./sincerity-1.0-beta15.rpm 

ENV GIT_AUTHOR_NAME ${GIT_NAME}
ENV GIT_AUTHOR_EMAIL ${GIT_EMAIL}
ENV GIT_COMMITTER_NAME ${GIT_NAME}
ENV GIT_COMMITTER_EMAIL ${GIT_EMAIL}

RUN git config --global user.name "Git Lab" && git config --global user.email "gitlab@xvid.com"

# Define default command, can be overriden by passing an argument when running the container
CMD ["mvn","-version"]
