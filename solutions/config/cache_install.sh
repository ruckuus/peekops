#!/bin/bash

echo "mulai Provisioning"
echo "software source dan repository"
cp /vagrant/config/sources.list /etc/apt/sources.list
cp /vagrant/config/environment /etc/environment

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

echo "Instalasi nginx"
apt-get install redis-server -y
mv /etc/redis/redis.conf /etc/redis/redis.conf.old
echo "bind 0.0.0.0" | sudo tee /etc/redis/redis.conf
cat /etc/redis/redis.conf.old | grep -v bind | sudo tee -a /etc/redis/redis.conf
service redis-server restart
# date > /etc/vagrant_provisioned_at


echo '# Flushing all rules'
iptables -F
iptables -X

echo '# Setting default filter policy'
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

echo '# Allow unlimited traffic on loopback'
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -o eth0 -j ACCEPT
iptables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o eth1 -j ACCEPT
iptables -A INPUT -i eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --dport 6379 -j ACCEPT
iptables -A INPUT -p icmp -s 0/0 -j ACCEPT