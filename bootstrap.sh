#!/usr/bin/env bash

if [ `uname` != "Linux" ]; then
    echo "bootstrap.sh expects to execute on a Linux system"
    exit 1
fi

BASE_TOOLS="rpm-build python-pip npm"
DEV_TOOLS="colordiff diffstat doxygen gcc-c++ git-all htop man man-pages make patch patchutils python-tox python-virtualenv rpm-build subversion vim-enhanced python-tox"
PACKAGES="net-tools"

#EPEL_PACKAGES="python-virtualenv"
EPEL_PACKAGES=""


yum -y install ${BASE_TOOLS}

#Note(dzimine): Temporarily commented out to speed up.
yum -y update

yum -y install ${DEV_TOOLS} ${PACKAGES} ${EPEL_PACKAGES}

yum clean all

# Install bootstrap modules:
BOOTSTRAP_MODS_DIR="/vagrant/bootstrap-mods-active"
if [ -d "$BOOTSTRAP_MODS_DIR" ]; then
    for module in `find ${BOOTSTRAP_MODS_DIR} -type f -o -type l` ; do
        echo "Running ${module}"
        bash ${module}
    done
fi

npm install -g bower
npm install -g gulp
