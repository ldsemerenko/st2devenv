devenv
======

StackStorm development environment

physical_host$ vagrant box add --name fedora20-dev-x86_64 gdrive:StackStorm/Demo/stackaton_environment/fedora20-dev-x86_64.box


physical_host$ git clone https://github.com/StackStorm/devenv.git


physical_host$ cd devenv


physical_host$ vagrant up


physical_host$ vagrant ssh


guest$ cd /home/vagrant/code


guest$ git clone https://github.com/StackStorm/stackaton.git

OR (with SSH)

guest$ git clone git@github.com:StackStorm/stackaton.git
