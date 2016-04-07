#!/bin/bash

echo "Start the Provisioning"
echo "Setup software source dan repository"
cp /vagrant/config/sources.list /etc/apt/sources.list
cp /vagrant/config/environment /etc/environment

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

echo "PostgreSQL Installlation"
apt-get install -y postgresql
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
echo "host   all   all   192.168.99.0/24   trust" >> /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart
# pg_createcluster 9.3 main --star/t  

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
iptables -A INPUT -p tcp -s 0/0 --dport 5432 -j ACCEPT
iptables -A INPUT -p icmp -s 0/0 -j ACCEPT