# This is a comment
FROM ubuntu:14.04
MAINTAINER Alexander Kittelmann

USER root

ADD customization /var/jenkins_home/customization/

COPY config.xml /var/jenkins_home/
COPY hudson.tasks.Maven.xml /var/jenkins_home/
COPY hudson.plugins.git.GitTool.xml /var/jenkins_home/

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN  mkdir /usr/local/java \
  && cd /usr/local/java  \
  && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz \
  && tar -xvzf jdk-8u77-linux-x64.tar.gz \
  && rm jdk-8u77-linux-x64.tar.gz

RUN  apt-get update \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

RUN  mkdir /usr/local/maven3 \
  && cd /usr/local/maven3  \
  && wget http://mirror.serversupportforum.de/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
  && tar -xvzf apache-maven-3.3.9-bin.tar.gz \
  && rm apache-maven-3.3.9-bin.tar.gz

RUN  cd /var/jenkins_home/ \
   && wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war

ENV JAVA_HOME=/usr/local/java/jdk1.8.0_77
ENV PATH=$PATH:/usr/local/java/jdk1.8.0_77/bin
ENV M2_HOME=/usr/local/maven3/apache-maven-3.3.9
ENV PATH=$PATH:/usr/local/maven3/apache-maven-3.3.9/bin
ENV JENKINS_HOME=/var/jenkins_home

EXPOSE 5432

CMD "sudo sh /var/jenkins_home/customization/execute.sh"
