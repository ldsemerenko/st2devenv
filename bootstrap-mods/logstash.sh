#!/usr/bin/env bash

#
LOGSTASH_DIR=/opt

# PREREQUISITES

# Install Java JDK
yum install -y java-1.7.0-openjdk

# SETUP ElasticSearch and Logstash:
# configure RPM repo, get the package, register as a servcie
rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-1.0]
name=Elasticsearch repository for 1.0.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.0/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1

[logstash-1.4]
name=logstash repository for 1.4.x packages
baseurl=http://packages.elasticsearch.org/logstash/1.4/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
EOF

mkdir /var/run/logstash-web
yum -y install logstash elasticsearch logstash-contrib.noarch 
chkconfig --add elasticsearch
chkconfig elasticsearch on
service elasticsearch start

# Link stackaton config file 
ln -s /vagrant/logstash/stackaton.conf /etc/logstash/conf.d/

chkconfig --add logstash
service logstash start

# Logstash web app (port 9292, and needs browser access to 9200)
chkconfig --add logstash-web
service logstash-web start
