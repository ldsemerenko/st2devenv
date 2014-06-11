#!/bin/bash
BOT_NAME="stormbot"
CODE_DIR="/home/vagrant/code"

HUBOT_DIR="${CODE_DIR}/${BOT_NAME}"

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
hubot --create ${BOT_NAME}
cd ${HUBOT_DIR}

ln -s ${STACKATON_DIR}/hubot/hubot-hipchat.sh .
ln -s ${STACKATON_DIR}/hubot/scripts/* scripts/
