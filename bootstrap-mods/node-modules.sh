# Add npm modules that need to be installed to this list.
NPM_MODULES="bower gulp"

install_node_modules() {
    # Install node, npm, and npm modules.
    yum -y install npm
    npm install -g ${NPM_MODULES}
}

install_node_modules
