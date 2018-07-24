FROM jenkins/jenkins

USER root

COPY install-docker.sh /install-docker.sh
RUN /install-docker.sh

USER jenkins
