#!/bin/bash

CODE_DIR="/home/vagrant/code"

HUBOT_DIR="${CODE_DIR}/myhubot"

STACKATON_DIR="${CODE_DIR}/stackaton"

if [ ! -d "${STACKATON_DIR}" ]; then
    echo "error: Please clone the stackaton repository before running this script"
    exit 1
fi

if [ ! -d "${CODE_DIR}" ]; then
    mkdir -p ${CODE_DIR}
fi

if [ -d "${HUBOT_DIR}" ]; then
    echo "error: ${HUBOT_DIR} directory already exists"
    exit 1
fi

cd ${CODE_DIR}
hubot --create `basename ${HUBOT_DIR}`
cd ${HUBOT_DIR}

rm package.json
ln -s ${STACKATON_DIR}/hubot/package.json .
ln -s ${STACKATON_DIR}/hubot/hubot-hipchat.sh .
ln -s ${STACKATON_DIR}/hubot/scripts/* scripts/
