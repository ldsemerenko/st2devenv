install_mongodb() {
    # Install mongodb
    yum -y install mongodb
    # Make mongodb start on reboot
    chkconfig mongod on
    # Make mongodb start now
    service mongod start
}

yum -y install mongodb

install_mongodb
