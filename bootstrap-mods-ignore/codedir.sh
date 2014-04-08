USERHOME="/home/vagrant"
CODE_DIR="${USERHOME}/code"

if [ ! -d "${CODE_DIR}" ]; then
    mkdir ${CODE_DIR}
    chown vagrant:vagrant ${CODE_DIR}
fi

VAGRANT_CODE="/vagrant/code"
if [ ! -e "${VAGRANT_CODE}" ]; then
    ln -s ${CODE_DIR} ${VAGRANT_CODE}
fi
