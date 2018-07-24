FROM jenkins/jenkins:latest

USER root

COPY install-docker.sh /install-docker.sh
RUN /install-docker.sh

USER jenkins

# oMo
