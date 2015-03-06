#!/bin/bash

# Terminate on error.
set -e

USER="vagrant"
USERHOME="/home/${USER}"

OPT_DIR="/opt/openstack"
CONFIG_DIR="/etc/mistral"

ST2_REPO="StackStorm"
ST2_CODE_DIR="${USERHOME}/code/stackstorm"
ST2_STABLE_BRANCH="st2-0.8.1"

OS_REPO="stackforge"
OS_CODE_DIR="${USERHOME}/code/openstack"

mkdir -p ${OPT_DIR}
mkdir -p ${CONFIG_DIR}
mkdir -p ${ST2_CODE_DIR}
mkdir -p ${OS_CODE_DIR}

GIT_REPOS=(
    "${ST2_CODE_DIR}/mistral"
    "${ST2_CODE_DIR}/python-mistralclient"
    "${ST2_CODE_DIR}/st2mistral"
    "${OS_CODE_DIR}/mistral"
    "${OS_CODE_DIR}/python-mistralclient"
)

for i in "${GIT_REPOS[@]}"
do
    if [[ -d "${i}" ]]; then
        echo "Removing directory ${i}..."
        rm -r ${i}
    fi
done

echo "Cloning StackStorm projects to ${ST2_CODE_DIR}..."
cd ${ST2_CODE_DIR}
git clone https://github.com/${ST2_REPO}/mistral.git
git clone https://github.com/${ST2_REPO}/python-mistralclient.git
git clone https://github.com/${ST2_REPO}/st2mistral.git

echo "Cloning StackForge projects to ${OS_CODE_DIR}..."
cd ${OS_CODE_DIR}
git clone https://github.com/${OS_REPO}/mistral.git
git clone https://github.com/${OS_REPO}/python-mistralclient.git

for i in "${GIT_REPOS[@]}"
do
    if [[ ! -d "${i}" ]]; then
        echo "Unable to clone ${i}..."
        exit 1
    fi
done

chown -R ${USER}:${USER} ${OPT_DIR}
chown -R ${USER}:${USER} ${CONFIG_DIR}
chown -R ${USER}:${USER} ${OS_CODE_DIR}
chown -R ${USER}:${USER} ${ST2_CODE_DIR}


setup_mistral_config()
{
config=${CONFIG_DIR}/mistral.conf
if [ -e "$config" ]; then
    rm $config
fi
touch $config
cat <<mistral_config >$config
[database]
connection=mysql://mistral:StackStorm@localhost/mistral
max_pool_size=100
max_overflow=400
pool_recycle=120

[pecan]
auth_enable=false
mistral_config
}

setup_mistral_log_config()
{
log_config=${CONFIG_DIR}/wf_trace_logging.conf
if [ -e "$log_config" ]; then
    rm $log_config
fi
cp ${OPT_DIR}/mistral/etc/wf_trace_logging.conf.sample $log_config
sed -i "s~tmp~var/log~g" $log_config
}

setup_mistral_upstart()
{
upstart=/etc/init/mistral.conf
if [ -e "$upstart" ]; then
    rm $upstart
fi
touch $upstart
cat <<mistral_upstart >$upstart
description "Mistral Workflow Service"

start on runlevel [2345]
stop on runlevel [016]
respawn

exec ${OPT_DIR}/mistral/.venv/bin/python ${OPT_DIR}/mistral/mistral/cmd/launch.py --config-file ${CONFIG_DIR}/mistral.conf --log-config-append ${CONFIG_DIR}/wf_trace_logging.conf
mistral_upstart
}

setup_mistral_db_reset_script()
{
reset_db=${CONFIG_DIR}/reset_db.sh
if [ -e "$reset_db" ]; then
    rm $reset_db
fi
touch $reset_db
cat << mistral_reset_db > $reset_db
#!/bin/bash
mysql -uroot -pStackStorm -e "DROP DATABASE IF EXISTS mistral"
mysql -uroot -pStackStorm -e "CREATE DATABASE mistral"
mysql -uroot -pStackStorm -e "GRANT ALL PRIVILEGES ON mistral.* TO 'mistral'@'%' IDENTIFIED BY 'StackStorm'"
mysql -uroot -pStackStorm -e "FLUSH PRIVILEGES"

cd ${OPT_DIR}/mistral
${OPT_DIR}/mistral/.venv/bin/python ./tools/sync_db.py --config-file ${CONFIG_DIR}/mistral.conf

sed -i 's/#max_connections        = 100/max_connections        = 500/' /etc/mysql/my.cnf
service mysql restart

mistral_reset_db
chmod +x $reset_db
}

install_prereq() {
    apt-get -y install libssl-dev
    apt-get -y install libyaml-dev
    apt-get -y install libffi-dev
    apt-get -y install libxml2-dev libxslt1-dev python-dev
    apt-get -y install libmysqlclient-dev
}

install_mistral() {
    # Create symlink in the opt directory.
    cd ${OPT_DIR}
    rm -f ${OPT_DIR}/mistral
    ln -s ${ST2_CODE_DIR}/mistral mistral

    # Setup and activate the virtualenv for running mistral.
    cd ${ST2_CODE_DIR}/mistral
    virtualenv --no-site-packages .venv
    . ${ST2_CODE_DIR}/mistral/.venv/bin/activate

    # Install mistral.
    cd ${ST2_CODE_DIR}/mistral
    git remote update
    git checkout -b ${ST2_STABLE_BRANCH} origin/${ST2_STABLE_BRANCH}
    pip install -r requirements.txt
    pip install -q mysql-python
    python setup.py develop

    # Setup plugins for custom actions.
    cd ${ST2_CODE_DIR}/st2mistral
    git remote update
    git checkout -b ${ST2_STABLE_BRANCH} origin/${ST2_STABLE_BRANCH}
    python setup.py develop

    # Create configuration files.
    setup_mistral_config
    setup_mistral_log_config
    setup_mistral_upstart

    # Setup database.
    setup_mistral_db_reset_script
    ${CONFIG_DIR}/reset_db.sh

    # Deactivate virtualenv
    deactivate
}

install_mistral_client() {
    cd ${ST2_CODE_DIR}/python-mistralclient
    git remote update
    git checkout -b ${ST2_STABLE_BRANCH} origin/${ST2_STABLE_BRANCH}
    python setup.py develop
}

install_prereq
install_mistral
install_mistral_client
