FROM centos:7

MAINTAINER Chorke, Inc.<devs@chorke.org>

ADD assets /assets
RUN /assets/setup.sh

CMD /usr/sbin/startup.sh

