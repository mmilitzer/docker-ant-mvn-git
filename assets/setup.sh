#!/bin/bash
: '
 @author   "Chorke, Inc."<devs@chorke.org>
 @web       http://chorke.org
 @vendor    Chorke, Inc.
 @version   0.0.00
 @since     0.0.00
'

# disable fastest mirror
rm -rf /etc/yum/pluginconf.d/fastestmirror.conf &&
yum clean all && rm -rf /var/cache/yum &&

# install zip, git and openjdk
yum -y install zip &&
yum -y install git &&
yum -y install nano &&
yum -y install wget &&
yum -y install unzip &&
yum -y install tar &&
yum -y install java-1.8.0-openjdk &&


# download, install apache maven and ant from chorke development network
wget -q http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-3.5.4-bin.tar.gz -P /chorke/cli/ &&
wget -q https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.9-bin.tar.gz -P /chorke/cli/ &&
tar xvfz /chorke/cli/apache-maven-3.5.4-bin.tar.gz -d /chorke/cli/ &&
tar xvfz /chorke/cli/ -d /chorke/cli/apache-ant-1.9.9-bin.tar.gz &&
rm -rf /chorke/cli/apache-maven-3.5.4-bin.tar.gz  &&
rm -rf /chorke/cli/apache-ant-1.9.9-bin.tar.gz &&


echo ''  >> /etc/bash.bashrc &&
echo ''  >> /etc/bash.bashrc &&
echo '# env for chorke workspaces and application'  >> /etc/bash.bashrc &&
echo 'export TMPDIR=/tmp' >> /etc/bash.bashrc &&
echo 'export ANT_HOME=/chorke/cli/apache-ant-1.9.9' >> /etc/bash.bashrc &&
echo 'export M2_HOME=/chorke/cli/apache-maven-3.5.4' >> /etc/bash.bashrc &&
echo 'export JRE_HOME=$(dirname $(dirname $(readlink -e $(which java))))' >> /etc/bash.bashrc &&
echo 'export JAVA_HOME=$(dirname $(dirname $(readlink -e $(which javac))))' >> /etc/bash.bashrc &&
echo 'export CKI_WORKSPACES=/chorke/dev/jee/cki_workspaces' >> /etc/bash.bashrc &&
echo 'export EBIS_HOME=/chorke/pro/ebis' >> /etc/bash.bashrc &&


echo ''  >> /etc/bash.bashrc &&
echo ''  >> /etc/bash.bashrc &&
echo '# add executable path'  >> /etc/bash.bashrc &&
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/bash.bashrc &&
echo 'export PATH=$JRE_HOME/bin:$PATH'  >> /etc/bash.bashrc &&
echo 'export PATH=$ANT_HOME/bin:$PATH'  >> /etc/bash.bashrc &&
echo 'export PATH=$M2_HOME/bin:$PATH'   >> /etc/bash.bashrc &&
echo 'export PATH=$EBIS_HOME/bin:$PATH' >> /etc/bash.bashrc &&


echo ''  >> /etc/bash.bashrc &&
echo ''  >> /etc/bash.bashrc &&


# copy default home config
mv /assets/.m2     $HOME &&
mv /assets/.ssh    $HOME &&
mv /assets/.chorke $HOME &&

wget http://149.202.181.9/sincerity-1.0beta13-0.noarch.tgz &&
tar -zxvf sincerity-1.0beta13-0.noarch.tgz --directory / &&
rm sincerity-1.0beta13-0.noarch.tgz

exit $?

