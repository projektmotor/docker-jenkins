FROM jenkins/jenkins:latest

USER root

RUN apt-get -y update && \
    apt-get install -y rsync curl && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN curl https://jenkins.intranet.projektmotor.de/jnlpJars/jenkins-cli.jar -o /var/jenkins_home/jenkins-cli.jar

ENV TIME_ZONE=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo ${TIME_ZONE} > /etc/timezone

COPY install-docker.sh /install-docker.sh
RUN /install-docker.sh

USER jenkins
