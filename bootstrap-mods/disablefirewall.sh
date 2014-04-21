#!/bin/sh

# Stop the firewall so grease host-guest access
systemctl stop firewalld.service
systemctl disable firewalld.service
