# This is a comment
FROM ubuntu:14.04
MAINTAINER Alexander Kittelmann

USER root

ADD customization /var/jenkins/jenkins_home/customization/

COPY config.xml /var/jenkins/jenkins_home/
COPY hudson.tasks.Maven.xml /var/jenkins/jenkins_home/
COPY hudson.plugins.git.GitTool.xml /var/jenkins/jenkins_home/

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
  
RUN  apt-get update \
     && apt-get install -y curl 

RUN  mkdir /var/jenkins/java \
  && cd /var/jenkins/java  \
  && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz \
  && tar -xvzf jdk-8u77-linux-x64.tar.gz \
  && rm jdk-8u77-linux-x64.tar.gz

RUN  apt-get update \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

RUN  mkdir /var/jenkins/maven3 \
  && cd /var/jenkins/maven3  \
  && wget http://mirror.serversupportforum.de/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
  && tar -xvzf apache-maven-3.3.9-bin.tar.gz \
  && rm apache-maven-3.3.9-bin.tar.gz
  

RUN  cd /var/jenkins/jenkins_home/ \
   && wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war
   

RUN  chmod +x /var/jenkins/jenkins_home/customization/execute.sh

ENV JAVA_HOME=/var/jenkins/java/jdk1.8.0_77
ENV PATH=$PATH:/var/jenkins/java/jdk1.8.0_77/bin
ENV M2_HOME=/var/jenkins/maven3/apache-maven-3.3.9
ENV PATH=$PATH:/var/jenkins/maven3/apache-maven-3.3.9/bin
ENV JENKINS_HOME=/var/jenkins/jenkins_home

VOLUME /var/jenkins

EXPOSE 5432

CMD  /var/jenkins/jenkins_home/customization/execute.sh
