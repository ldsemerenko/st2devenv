install_mongodb() {
    # Install mongodb
    yum -y install mongodb mongodb-server
    # Make mongodb start on reboot
    systemctl enable mondod.service
#    chkconfig mongod on
    # Make mongodb start now
#    service mongod start
    systemctl start mongod.service
}

yum -y install mongodb

install_mongodb
