#!/bin/bash

JENKINS_HOME=/var/jenkins/jenkins_home
JENKINS_CLI=$JENKINS_HOME/war/WEB-INF/jenkins-cli.jar

function wait_for_jenkins() {
  while [[ $(curl -s -w "%{http_code}" http://localhost:5432 -o /dev/null) != "200" ]]; do
     sleep 5
  done
}

echo "=> Starting Jenkins"
cd /var/jenkins/jenkins_home/
java -jar jenkins.war --httpPort=5432 --ajp13Port=-1 > /dev/null &

echo "=> Waiting for the server to boot"
wait_for_jenkins

echo "=> Executing the commands"
java -jar $JENKINS_CLI -s 'http://localhost:5432' install-plugin git
java -jar $JENKINS_CLI -s 'http://localhost:5432' install-plugin workflow-aggregator
java -jar $JENKINS_CLI -s 'http://localhost:5432' install-plugin pipeline-stage-view
java -jar $JENKINS_CLI -s 'http://localhost:5432' install-plugin docker-plugin
java -jar $JENKINS_CLI -s 'http://localhost:5432' install-plugin docker-workflow

echo "=> Restart Jenkins"
java -jar $JENKINS_CLI -s 'http://localhost:5432' safe-shutdown
java -jar jenkins.war --httpPort=5432 --ajp13Port=-1
