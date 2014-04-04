install_mongodb() {
    # Install mongodb
    yum -y install mongodb mongodb-server
    # Make mongodb start on reboot
    systemctl enable mongod.service
    # Make mongodb start now
    systemctl start mongod.service
}

install_mongodb
