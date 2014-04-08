#!/usr/bin/env bash

#
LOGSTASH_BASEDIR=/opt

# PREREQUISITES

# Install Java JDK
yum install -y java-1.7.0-openjdk

# Install ElasticSearch:
# configure RPM repo, get the package, register as a servcie
rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-1.0]
name=Elasticsearch repository for 1.0.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.0/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
EOF

yum -y install elasticsearch

# Install kopf plugin
# To access, http://localhost:9200/_plugin/kopf/
/usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

/sbin/chkconfig --add elasticsearch
service elasticsearch start


# INSTALL LOGSTASH 
#
# Install logstash
curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz | tar -C $BASEDIR -xzf -
chown -hR vagrant $BASEDIR/logstash-1.4.0


# TODO: configure to run as service
# Problem: the scrip is for earlier versions...
# cp /vagrant/logstash/lostash.init.d /etc/init.d/logstash
# /sbin/chkconfig --add logstash
# service logstash start

# RUNNING

# Run Logstash agent 
# TODO(dzimine): configure to run as a service
#$BASEDIR/logstash-1.4.0/bin/logstash agent --config /vagrant/logstash/ls.conf

# Run Logstash web app (port 9292)
# TODO(dzimine): configure to run as a service (or move out of VM all together)
#$BASEDIR/logstash-1.4.0/bin/logstash-web

# CLEANUP LOGSTASH
# 
# Swipe elasticsearch index
#curl -XDELETE 'http://localhost:9200/_all'
# Remove file marker to parse the log from the beginning
#rm /vagrant/sincedb-test
