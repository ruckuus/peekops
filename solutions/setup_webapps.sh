#!/bin/bash

echo "Update Centos ........ "
      yum -y update
      

echo "Install Group Development Tools"
      yum -y groupinstall "Development Tools"
      yum -y install screen
      
      cd  /usr/src/
      wget http://nodejs.org/dist/v0.10.4/node-v0.10.4.tar.gz
      
      tar zxf node-v0.10.4.tar.gz
      cd node-v0.10.4
      ./configure
      make
      make install
      
      
      npm -g install express express-generator supervisor
      
echo "Setting Firewall"
      
      echo "/sbin/iptables -P INPUT DROP" > /etc/rc.d/rc.firewall
      echo "/sbin/iptables -P OUTPUT ACCEPT" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -P FORWARD DROP" >> /etc/rc.d/rc.firewall

      echo "/sbin/iptables -F INPUT" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -F OUTPUT" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -F FORWARD" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -F -t nat" >> /etc/rc.d/rc.firewall

      echo "/sbin/iptables -A INPUT -i lo -p tcp -j ACCEPT" >> /etc/rc.d/rc.firewall

      echo "# Allowed Service for World" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -p tcp --dport 22 -j ACCEPT" >> /etc/rc.d/rc.firewall

      echo "/sbin/iptables -A INPUT -p tcp -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT" >> /etc/rc.d/rc.firewall                                                                                       
      echo "/sbin/iptables -A OUTPUT -p tcp -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT" >> /etc/rc.d/rc.firewall                                                                                  
      echo "/sbin/iptables -A INPUT -p udp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT" >> /etc/rc.d/rc.firewall                                                                                       
      echo "/sbin/iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT" >> /etc/rc.d/rc.firewall                                                                                      
      echo "/sbin/iptables -A INPUT -p icmp -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT" >> /etc/rc.d/rc.firewall                                                                                     
      echo "/sbin/iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT" >> /etc/rc.d/rc.firewall  
      
      echo "# Stop smurf attacks" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -p icmp -m icmp -j DROP" >> /etc/rc.d/rc.firewall

      echo "# Drop all invalid packets" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -m state --state INVALID -j DROP" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A FORWARD -m state --state INVALID -j DROP" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A OUTPUT -m state --state INVALID -j DROP" >> /etc/rc.d/rc.firewall

      echo "# Drop excessive RST packets to avoid smurf attacks" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT" >> /etc/rc.d/rc.firewall

      echo "# Attempt to block portscans" >> /etc/rc.d/rc.firewall
      echo "# Anyone who tried to portscan us is locked out for an entire day." >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP" >> /etc/rc.d/rc.firewall

      echo # Once the day has passed, remove them from the portscan list" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT   -m recent --name portscan --remove" >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A FORWARD -m recent --name portscan --remove" >> /etc/rc.d/rc.firewall

      echo "# These rules add scanners to the portscan list, and log the attempt." >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:" " >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP" >> /etc/rc.d/rc.firewall

      echo "/sbin/iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"  " >> /etc/rc.d/rc.firewall
      echo "/sbin/iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP " >> /etc/rc.d/rc.firewall      
      
      bash /etc/rc.d/rc.firewall           
      
echo "Stop Services"              
      /etc/init.d/postfix stop    
      
echo "NPM things "
      su - vagrant
      npm init
      npm install
      npm instlal node-env-file
      npm install dotenv --save
      npm install procfile
      npm install foobar --save --save-exact
      npm config set save=true
      npm config set save-exact=true
      npm install --save --save-exact foreman
      sudo yum -y install git-all
      echo "WEB_TARGET_MACHINE=192.168.99.101" > /home/vartrand/.env
      echo "APPLICATION_TARGET_MACHINE=192.168.99.102" >> /home/vartrand/.env
      echo "CACHE_TARGET_MACHINE=192.168.99.103" >> /home/vartrand/.env
      echo "DATABASE_TARGET_MACHINE=192.168.99.104" >> /home/vartrand/.env
      
