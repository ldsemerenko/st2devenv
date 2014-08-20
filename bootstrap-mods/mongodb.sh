install_mongodb() {
    # Install mongodb
    apt-get -y install mongodb mongodb-server
    # Set up oplog
    echo "replSet = rs0" >> /etc/mongodb.conf
    echo "oplogSize = 100" >> /etc/mongodb.conf
    # Make mongodb start now
    service mongodb start
    # Add hostname to /etc/hosts
    echo -e '127.0.0.1'\\t`hostname` >> /etc/hosts
    # Wait for mongo to spin up
    sleep 10
    # Initiate replication set
    mongo --eval "rs.initiate()"
}

install_mongodb
