# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "fedora20-dev-x86_64"
  
    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
      config.vm.box_url = "https://s3-us-west-1.amazonaws.com/stackstorm.com/images/fedora20-dev-x86_64.box"

    # Configure a private network 
    config.vm.network "private_network", ip: "172.168.50.50"

    # Forward stackaton REST API port
    # config.vm.network "forwarded_port", guest: 9090, host: 9090, auto_correct: true
  
    # Forward ElasticSearch port
    # config.vm.network "forwarded_port", guest: 9200, host: 9200, auto_correct: true
  
    # Forward Kibana port
    # config.vm.network "forwarded_port", guest: 9292, host: 9292, auto_correct: true

    # Start shell provisioning
    config.vm.provision :shell, :path => "bootstrap.sh"
end
