RABBIT_PUBLIC_KEY="rabbitmq-signing-key-public.asc"

install_rabbitmq() {
    # add rabbitmq APT repo
    echo 'deb http://www.rabbitmq.com/debian/ testing main' >> /etc/apt/sources.list
    # include public key in trusted key list to avoid warnings
    wget http://www.rabbitmq.com/${RABBIT_PUBLIC_KEY}
    sudo apt-key add ${RABBIT_PUBLIC_KEY}
    rm ${RABBIT_PUBLIC_KEY}
    apt-get update
    # Install rabbitmq
    apt-get -y install rabbitmq-server
    # enable rabbitmq-management plugin
    rabbitmq-plugins enable rabbitmq_management
    # Restart rabbitmq
    service rabbitmq-server restart
    # use rabbitmqctl to check status
    rabbitmqctl status
    # rabbitmaadmin is useful to inspect exchanges, queues etc.
    curl http://localhost:15672/cli/rabbitmqadmin >> /usr/bin/rabbitmqadmin
    chmod 755 /usr/bin/rabbitmqadmin
}

install_rabbitmq
