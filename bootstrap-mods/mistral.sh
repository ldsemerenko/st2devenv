config=/etc/mistral/mistral.conf
upstart=/etc/init/mistral.conf

write_config()
{
if [ -e "$config" ]; then
    rm $config
fi
touch $config
cat <<mistral_config >$config
[database]
connection=mysql://mistral:mistral@localhost/mistral

[pecan]
auth_enable=false
mistral_config
}

write_upstart()
{
if [ -e "$upstart" ]; then
    rm $upstart
fi
touch $upstart
cat <<mistral_upstart >$upstart
description "OpenStack Workflow Service"
script
    /opt/openstack/mistral/.venv/bin/python /opt/openstack/mistral/mistral/cmd/launch.py --config-file /etc/mistral/mistral.conf
end script
mistral_upstart
}

setup_mistral_db() {
    mysql -uroot -pStackStorm -e "DROP DATABASE IF EXISTS mistral"
    mysql -uroot -pStackStorm -e "CREATE DATABASE mistral"
    mysql -uroot -pStackStorm -e "GRANT ALL PRIVILEGES ON mistral.* TO 'mistral'@'%' IDENTIFIED BY 'mistral'"
    mysql -uroot -pStackStorm -e "FLUSH PRIVILEGES"
}

install_mistral() {
    # Install prerequisites.
    apt-get -y install libssl-dev
    apt-get -y install libyaml-dev
    apt-get -y install libffi-dev
    apt-get -y install libxml2-dev libxslt1-dev python-dev
    apt-get -y install libmysqlclient-dev

    # Clone mistral from github.
    mkdir -p /opt/openstack
    cd /opt/openstack
    if [ -d "/opt/openstack/mistral" ]; then
        rm -r /opt/openstack/mistral
    fi
    git clone -b st2-0.5.1 https://github.com/StackStorm/mistral.git

    if [ -d "/opt/openstack/mistral" ]; then
        # Setup virtualenv for running mistral.
        cd /opt/openstack/mistral
        virtualenv --no-site-packages .venv
        . /opt/openstack/mistral/.venv/bin/activate
        pip install -r requirements.txt
        pip install -q mysql-python
        python setup.py develop

        # Setup plugins for actions.
        mkdir -p /etc/mistral/actions
        cd /etc/mistral/actions
        git clone -b st2-0.5.1 https://github.com/StackStorm/st2mistral.git
        cd /etc/mistral/actions/st2mistral
        python setup.py develop

        # Create configuration files.
        write_config
        write_upstart

        # Setup database.
        cd /opt/openstack/mistral
        setup_mistral_db
        python ./tools/sync_db.py --config-file /etc/mistral/mistral.conf
    fi
}

install_mistral
