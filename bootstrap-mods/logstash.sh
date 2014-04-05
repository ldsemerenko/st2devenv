#!/usr/bin/env bash

# PREREQUISITES
yum install -y java-1.7.0-openjdk

BASEDIR=/usr/local/share

# GET LOGSTASH & ELASTICSEARCH
#
cd $BASEDIR
# Install logstash
curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz | tar -xzf -
chown -hR vagrant logstash-1.4.0

# Install elasticsearch 
# problem: should know what sudo and what not...
# TODO: put it somewhere, copy over 
curl https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz | tar -xzf -
chown -hR vagrant elasticsearch-1.0.1

# Install kopf plugin, then access it as
# http://localhost:9200/_plugin/kopf/
$BASEDIR/elasticsearch-1.0.1/bin/plugin -install lmenezes/elasticsearch-kopf

# RUNNING
# 
# Run Elasticsearch as a daemon (port 9200)
# TODO(dzimine): configure to run as a service
#$BASEDIR/elasticsearch-1.0.1/bin/elasticsearch -d

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
