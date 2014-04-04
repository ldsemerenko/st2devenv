install_epel() {
    # Install EPEL repo
    rpm -q epel-release
    if [ "${?}" != "0"  ]; then
        echo "log: install EPEL" 
        EPEL_URL="http://linux.mirrors.es.net/fedora-epel/6/i386/epel-release-6-8.noarch.rpm"
        ( cd /tmp ; curl -O ${EPEL_URL}; rpm -i --hash -v `basename ${EPEL_URL}` )
    fi
}

#install_epel
