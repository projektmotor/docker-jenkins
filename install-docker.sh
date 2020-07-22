#!/bin/bash

BASE_URL="https://download.docker.com/linux/static/stable/x86_64/"
DIRECTORY_LISTING=$(curl -s ${BASE_URL} | awk 'BEGIN{ RS="<a *href *= *\""} NR>2 {sub(/".*/,"");print; }')
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/1.26.2/docker-compose-`uname -s`-`uname -m`"
RELEASES=(${DIRECTORY_LISTING// / })
TMP_DIR="$HOME/.tmp-docker-install-files"

MAJOR=0
MINOR=0
PATCH=0

for i in ${RELEASES[*]}
do
        FILTERED_FILENAME=$(echo $i | egrep 'docker\-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.tgz')

        if [[ "${FILTERED_FILENAME}" == "" ]]; then
                continue
        fi

        TMP_MAJOR=$(echo ${FILTERED_FILENAME} |  awk -F'[.-]' '{print $2}')
        TMP_MINOR=$(echo ${FILTERED_FILENAME} |  awk -F'[.-]' '{print $3}')
        TMP_PATCH=$(echo ${FILTERED_FILENAME} |  awk -F'[.-]' '{print $4}')

        if [ ${TMP_MAJOR} -gt ${MAJOR} ]; then
                MAJOR=${TMP_MAJOR}
                MINOR=0
                PATCH=0
        fi

        if [ ${TMP_MINOR} -gt ${MINOR} ]; then
                MINOR=${TMP_MINOR}
                PATCH=0
        fi

        if [ ${TMP_PATCH} -gt ${PATCH} ]; then
                PATCH=${TMP_PATCH}
        fi
done

CURRENT_RELEASE_URL="${BASE_URL}/docker-${MAJOR}.${MINOR}.${PATCH}.tgz"

mkdir ${TMP_DIR}
cd ${TMP_DIR}

echo "Download docker binaries from ... ${CURRENT_RELEASE_URL}"
curl -s ${CURRENT_RELEASE_URL} --output "${TMP_DIR}/${CURRENT_RELEASE}"

echo "Extracting binaries ..."
tar xzf "${TMP_DIR}/${CURRENT_RELEASE}"

echo "Making binaries accessable ..."
rm "${TMP_DIR}/docker/dockerd"
cp "${TMP_DIR}/docker/docker" /usr/local/bin

groupadd -g 999 docker
usermod -a -G docker jenkins

echo "Download docker-compose binary from ... ${DOCKER_COMPOSE_URL}"
curl -s -L ${DOCKER_COMPOSE_URL} -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


echo "Cleaning up ..."
rm -rf ${TMP_DIR}
