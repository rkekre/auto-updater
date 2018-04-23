#!/bin/bash
CWD=`pwd`
TMP_DIR="/tmp"
BINARY_DIR="${TMP_DIR}/artifacts"
BINARY_REPO="https://github.com/rkekre/artifacts.git"
if [ -d ${BINARY_DIR} ]; then
    rm -rf ${BINARY_DIR}
fi

cd ${TMP_DIR}
git clone -n ${BINARY_REPO} --depth 1	
cd ${BINARY_DIR}
git checkout HEAD required_version.txt
required_version=`cat required_version.txt`
cd ${CWD}

current_version=`rpm -qa | grep auto-updater`
current_version+=".rpm"
if [[ -z "${current_version// }" ]]; then 
    current_version="null"
fi

echo "Current version: $current_version"
echo "Required version: $required_version"
if [ "$current_version" != "$required_version" ]; then 
    echo "Updating to ${required_version}"
    cd ${BINARY_DIR}
    if [ "$current_version" != "null" ]; then
        sudo yum -y erase ${current_version}
    fi
    git checkout HEAD ${required_version}
    sudo yum -y install ${required_version}
    cd ${CWD}
    rm -rf ${BINARY_DIR}

    sudo rsync -rtv /tmp/auto-updater/src/* /tmp/dummy_service
    sudo systemctl daemon-reload 
    sudo systemctl restart dummy
else
    echo "No update required."
fi 
