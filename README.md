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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


## Running

1. Start stackaton service:
	
		guest$ cd /vagrant/home/code/stackaton
	 	guest$ . .tox/py27/bin/activate
	 	guest$ stackstorm/cmd/api.py --config-file etc/stackaton.conf &> /dev/null &
	 	guest$ curl http://localhost:9090/v1/stactions/
1. Run Hubot locally: 
		
		guest$ cd /home/vagrant/bot
		guest$ bin/hubot
		Hubot> hubot help staction
		Hubot> hubot die
		
1. Launch hubot with Hipchat (yes you need to `cd` to directory or node won't pick up the right packages):
		
		guest$ cd /home/vagrant/bot/ 
		$guest hubot-hipchat.sh &> /tmp/hubot.log &

## Audit with Logstash
We experiment with using Logstash to slice and dice Audit logs. 


Connect to Kibana (aka Logstash web) at [http://172.168.50.50:9292/index.html#/dashboard/file/logstash.json](http://172.168.50.50:9292/index.html#/dashboard/file/logstash.json). Check the log messages.


Wiring and configuring Logstash for Stackaton logs is in `/vagrant/logstash/stackaton.conf`. 
Normally, no need to connect to ElasticSearch but for the off case: 

* 172.168.50.50:9200/_search?pretty - REST endpoint
* 172.168.50.50:9200/_plugin/kopf - UI plugin

For working with logstash, see [QuickStart](http://logstash.net/docs/1.4.0/tutorials/getting-started-with-logstash) and [this blog](http://www.chriscowley.me.uk/blog/2014/03/21/logstash-on-centos-6/) 

[Grok Debugger](http://grokdebug.herokuapp.com/) is a good tool to help build filters. 


### To clean up logstash from old data:

1. Swipe elasticsearch index

		curl -XDELETE 'http://172.168.50.50:9200/_all'
* Remove a file marker to force parse the log from the beginning

		rm /vagrant/logstash/sincedb-test
