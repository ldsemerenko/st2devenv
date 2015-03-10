# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "ubuntu-14-10-dev-x86_64"

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box"

    config.vm.define "ubuntu_utopic" do |ubuntu_utopic|
    end
    config.vm.provider :virtualbox do |vb|
      vb.name = "ubuntu-utopic-st2-dev"
      vb.memory = 1024
    end

    # Configure a private network
    config.vm.network "private_network", ip: "172.168.50.50"

    # Forward Action controller port = 9101
    # config.vm.network "forwarded_port", guest: 9101, host: 9101

    # Forward ActionRunner controller port = 9501
    # config.vm.network "forwarded_port", guest: 9501, host: 9501

    # Forward Reactor controller port = 9102
    # config.vm.network "forwarded_port", guest: 9102, host: 9102

    # Forward Datastore controller port = 9103
    # config.vm.network "forwarded_port", guest: 9103, host: 9103

    # Forward stackaton REST API port
    # config.vm.network "forwarded_port", guest: 9090, host: 9090, auto_correct: true

    # Forward ElasticSearch port
    # config.vm.network "forwarded_port", guest: 9200, host: 9200, auto_correct: true

    # Forward Kibana port
    # config.vm.network "forwarded_port", guest: 9292, host: 9292, auto_correct: true

    if Vagrant.has_plugin?("vagrant-sparseimage")
      config.sparseimage.add_image do |image|
        image.image_folder = '.'
        image.volume_name = 'code'
        image.image_type = 'SPARSEIMAGE'
        image.image_fs = 'HFSX'
        image.image_size = 4096
        image.auto_unmount = true
      end
    end

    # Start shell provisioning
    config.vm.provision :shell, :path => "bootstrap.sh"
end
