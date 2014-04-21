devenv
======

StackStorm development environment
----------------------------------

The StackStorm development environment is packaged in a vagrant-managed VM. To
setup the VM, copy the vagrant box image from Google Drive then checkout the
devenv setup from github.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
physical_host$ vagrant box add --name fedora20-dev-x86_64 gdrive:StackStorm/Demo/stackaton_environment/fedora20-dev-x86_64.box

physical_host$ git clone https://github.com/StackStorm/devenv.git

physical_host$ cd devenv

physical_host$ vagrant up

physical_host$ vagrant ssh

guest$ cd /home/vagrant/code
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



Now, inside the guest, clone the codebase from github, and run `tox` to install all the dependencies. It'll take couple of minutes, get yourself a coffee :). 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
guest$ git clone https://github.com/StackStorm/stackaton.git
guest$ cd stackaton
guest$ tox
guest$ cd /vagrant
guest$ ./create_hubot.sh
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
