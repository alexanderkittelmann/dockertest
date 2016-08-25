# This is a comment
FROM ubuntu:14.04
MAINTAINER Alexander Kittelmann
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
RUN --name mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=root -d mysql/mysql-server:5.6
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - && \
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && \
sudo apt-get update && \
sudo apt-get install -y jenkins && cd etc/default && sed -i "s/HTTP_PORT=8080/HTTP_PORT=5432/" /etc/default/jenkins && sudo service jenkins restart
