# Add npm modules that need to be installed to this list.
NPM_MODULES="bower gulp"

install_npm_modules() {
    # Install npm modules.
    npm install -g ${NPM_MODULES}
}

install_npm_modules
