devenv
======

StackStorm development environment

Usage
-----
The StackStorm development environment is packaged in a vagrant-managed VM. The [vagrant box is on cloudimages-ubuntu](https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box). Checkout the
devenv setup from github.

    $ git clone https://github.com/StackStorm/st2devenv.git
    $ vagrant up
    $ vagrant ssh

You may also need to sync your `code` folders between host and guest for easier development process.

If you are using OSX, you can just install `vagrant-sparseimage` plugin (original version hasn't
been updated since July 2013, so enykeev created [a fork][fork]. It is already configured to work
out-the-box to provide you with case-sensitive environment to work with. BE AWARE: it's SLOW.

Another option is to setup [nfs share][nfswiki].

[fork]: http://guthub.com/enykeev/vagrant-sparseimage
[nfswiki]: https://stackstorm.atlassian.net/wiki/display/STORM/Developing+in+PyCharm
