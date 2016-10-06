#!/usr/bin/env bash

# install ansible (http://docs.ansible.com/intro_installation.html) and
# https://www.liquidweb.com/kb/how-to-install-ansible-on-centos-7-via-yum/
rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
yum -y update
# yum -y upgrade
yum -y install ansible

# copy examples into /home/vagrant (from inside the mgmt node)
cp -a /vagrant/ansible/* /home/vagrant
chown -R vagrant:vagrant /home/vagrant

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL

# vagrant environment nodes
10.0.15.10  mgmt
10.0.15.11  zk
10.0.15.21  broker1
10.0.15.22  broker2
10.0.15.23  broker3
10.0.15.24  broker4
10.0.15.25  broker5
10.0.15.26  broker6
10.0.15.27  broker7
10.0.15.28  broker8
10.0.15.29  broker9
EOL
