#!/bin/bash

echo "Start the Provisioning"
echo "Setup software source dan repository"
cp /vagrant/config/sources.list /etc/apt/sources.list
cp /vagrant/config/environment /etc/environment

echo "Add nginx Repository"	
add-apt-repository -y ppa:nginx/stable

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

echo "nginx Installation"
apt-get install -y nginx  

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
iptables -A INPUT -p tcp -s 0/0 --dport 80 -j ACCEPT
iptables -A INPUT -p icmp -s 0/0 -j ACCEPT