FROM jenkins/jenkins:2.134

USER root

COPY install-docker.sh /install-docker.sh
RUN /install-docker.sh

USER jenkins

# oMo
