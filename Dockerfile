FROM jenkins/jenkins:latest

USER root

RUN apt-get -y update && \
    apt-get install -y rsync && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY install-docker.sh /install-docker.sh
RUN /install-docker.sh

USER jenkins
