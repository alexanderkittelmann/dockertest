# This is a comment
FROM akittelm/ubuntu-java:1.0
MAINTAINER Alexander Kittelmann

USER root

ADD customization /var/jenkins_home/customization/
ADD CI_EXERCISE /usr/local/CI_EXERCISE/
ADD CI_DEMO /usr/local/CI_DEMO/
ADD CI_EXERCISE/Jenkinsfile /var/jenkins_home/jobs/Pipetest/workspace@script/

COPY config.xml /var/jenkins_home/
COPY hudson.tasks.Maven.xml /var/jenkins_home/
COPY hudson.plugins.git.GitTool.xml /var/jenkins_home/

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

ENV M2_HOME=/usr/local/maven3/apache-maven-3.3.9
ENV PATH=$PATH:/usr/local/maven3/apache-maven-3.3.9/bin
ENV JENKINS_HOME=/var/jenkins_home

EXPOSE 5432

CMD /var/jenkins_home/customization/execute.sh
