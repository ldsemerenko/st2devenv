#!/usr/bin/env bash

if [ `uname` != "Linux" ]; then
    echo "bootstrap.sh expects to execute on a Linux system"
    exit 1
fi

BASE_TOOLS="python-pip"
DEV_TOOLS="build-essential git htop man manpages make python-virtualenv python-dev screen realpath"
PACKAGES="net-tools"
EPEL_PACKAGES=""

apt-get -y install ${BASE_TOOLS}
apt-get -y update
apt-get -y install ${DEV_TOOLS} ${PACKAGES} ${EPEL_PACKAGES}
apt-get clean all

# Install bootstrap modules:
BOOTSTRAP_MODS_DIR="/vagrant/bootstrap-mods-active"
if [ -d "$BOOTSTRAP_MODS_DIR" ]; then
    for module in `find ${BOOTSTRAP_MODS_DIR} -type f -o -type l` ; do
        echo "Running ${module}"
        bash ${module}
    done
fi
