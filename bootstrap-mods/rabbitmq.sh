install_rabbitmq() {
    # Install mongodb
    apt-get install rabbitmq-server 
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
