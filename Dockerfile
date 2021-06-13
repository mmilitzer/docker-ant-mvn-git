FROM stakater/java-centos:7-1.8

LABEL name="Ant, Maven and Git Image on CentOS" \    
      vendor="Xvid" \
      release="1" \
      summary="Ant, Maven and Git based image on CentOS" 

# Setting Maven and Ant versions that needs to be installed
ARG MAVEN_VERSION=3.5.4
ARG ANT_VERSION=1.9.9

# Changing user to root to install maven
USER root

# Install required tools
# which: otherwise 'mvn version' prints '/usr/share/maven/bin/mvn: line 93: which: command not found'
RUN yum update -y && \
  yum install -y which wget git rpm glibc-locale-source && \
  yum clean all

# Ant
RUN curl -fsSL https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant

ENV ANT_VERSION=${ANT_VERSION}
ENV ANT_HOME=/usr/share/ant
ENV PATH=$ANT_HOME/bin:$PATH

# Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# Sincerity
RUN curl -fsSL https://storage.sbg.cloud.ovh.net/v1/AUTH_2f09a59f038d477ba0b6754f757c5ac2/test/bzSS5rwgjn3aSwOEycwqih2UDZFvfSKiD/sincerity-1.0-beta13.rpm >./sincerity-1.0-beta13.rpm \
  && rpm -i sincerity-1.0-beta13.rpm && rm ./sincerity-1.0-beta13.rpm && localedef -i en_US -f UTF-8 en_US.UTF-8

# Again using non-root user i.e. stakater as set in base image
USER 10001

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Define default command, can be overriden by passing an argument when running the container
CMD ["mvn","-version"]
