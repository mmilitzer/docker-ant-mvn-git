FROM webratio/ant

RUN apt-get update -y && \
    apt-get install -y git wget less openssl openssh-server && \
    apt-get clean -y

RUN apt-get install ca-certificates -y

RUN apt-get install gnupg -y

ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN apt-get install zip tar -y

RUN ln -s /usr/lib/mvn/bin/mvn /usr/bin/mvn

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN wget http://149.202.181.9/sincerity-1.0beta13-0.noarch.tgz && \
  tar -zxvf sincerity-1.0beta13-0.noarch.tgz --directory / && \
  rm sincerity-1.0beta13-0.noarch.tgz
