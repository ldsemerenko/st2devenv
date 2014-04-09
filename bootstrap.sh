#!/usr/bin/env bash

if [ `uname` != "Linux" ]; then
    echo "bootstrap.sh expects to execute on a Linux system"
    exit 1
fi

BASE_TOOLS="rpm-build python-pip"
DEV_TOOLS="colordiff diffstat doxygen gcc-c++ git-all htop icu libicu libicu-devel man man-pages make patch patchutils python-tox python-virtualenv rpm-build subversion vim-enhanced python-tox"
PACKAGES="net-tools"

#EPEL_PACKAGES="python-virtualenv"
EPEL_PACKAGES=""


yum -y install ${BASE_TOOLS}

#Note(dzimine): Temporarily commented out to speed up.
yum -y update

yum -y install ${DEV_TOOLS} ${PACKAGES} ${EPEL_PACKAGES}

yum clean all

# Stop the firewall so grease host-guest access
systemctl stop firewalld.service
systemctl disable firewalld.service

# Install bootstrap modules:
BOOTSTRAP_MODS_DIR="/vagrant/bootstrap-mods"
if [ -d "/vagrant/bootstrap-mods" ]; then
    for module in `find ${BOOTSTRAP_MODS_DIR} -type f` ; do
        echo "Running ${module}"
        bash ${module}
    done
fi
