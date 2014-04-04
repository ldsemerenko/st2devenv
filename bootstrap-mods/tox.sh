install_tox() {
    test -e /etc/redhat-release && grep 'Fedora release 20 (Heisenbug)' /etc/redhat-release
    if  [ "${?}" = "0" ]; then
        # Running under Fedora 20 so manually upgrade tox
        echo "Require tox >= 1.6 but no Fedora package exists. Manually updating..."
        pip install -U tox
    fi
}

install_tox
