#!/bin/bash

echo "Stop Services."              
      /etc/init.d/postfix stop
      /etc/init.d/sshd stop 
      
echo "Install PostgreSQL."
      /usr/bin/yum -y install postgresql postgresql-contrib
      chkconfig postgresql on                   
      /etc/init.d/postgresql initdb
      /etc/init.d/postgresql start  
      
echo "Setting Firewall."
      
      /sbin/iptables -P INPUT DROP
      /sbin/iptables -P OUTPUT ACCEPT
      /sbin/iptables -P FORWARD DROP

      /sbin/iptables -F INPUT
      /sbin/iptables -F OUTPUT
      /sbin/iptables -F FORWARD
      /sbin/iptables -F -t nat

      /sbin/iptables -A INPUT -i lo -p tcp -j ACCEPT

      # Allowed Service for World
      # --- none ---

      /sbin/iptables -A INPUT -p tcp -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT                                                                                       
      /sbin/iptables -A OUTPUT -p tcp -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT                                                                                  
      /sbin/iptables -A INPUT -p udp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT                                                                                       
      /sbin/iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT                                                                                      
      /sbin/iptables -A INPUT -p icmp -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT                                                                                     
      /sbin/iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      
      # Reject spoofed packets
      /sbin/iptables -A INPUT -s 10.0.0.0/8 -j DROP
      /sbin/iptables -A INPUT -s 169.254.0.0/16 -j DROP
      /sbin/iptables -A INPUT -s 172.16.0.0/12 -j DROP
      /sbin/iptables -A INPUT -s 127.0.0.0/8 -j DROP

      /sbin/iptables -A INPUT -s 224.0.0.0/4 -j DROP
      /sbin/iptables -A INPUT -d 224.0.0.0/4 -j DROP
      /sbin/iptables -A INPUT -s 240.0.0.0/5 -j DROP
      /sbin/iptables -A INPUT -d 240.0.0.0/5 -j DROP
      /sbin/iptables -A INPUT -s 0.0.0.0/8 -j DROP
      /sbin/iptables -A INPUT -d 0.0.0.0/8 -j DROP
      /sbin/iptables -A INPUT -d 239.255.255.0/24 -j DROP
      /sbin/iptables -A INPUT -d 255.255.255.255 -j DROP

# Stop smurf attacks
      /sbin/iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
      /sbin/iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
      /sbin/iptables -A INPUT -p icmp -m icmp -j DROP

# Drop all invalid packets
      /sbin/iptables -A INPUT -m state --state INVALID -j DROP
      /sbin/iptables -A FORWARD -m state --state INVALID -j DROP
      /sbin/iptables -A OUTPUT -m state --state INVALID -j DROP

# Drop excessive RST packets to avoid smurf attacks
      /sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# Attempt to block portscans
# Anyone who tried to portscan us is locked out for an entire day.
      /sbin/iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP
      /sbin/iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP

# Once the day has passed, remove them from the portscan list
      /sbin/iptables -A INPUT   -m recent --name portscan --remove
      /sbin/iptables -A FORWARD -m recent --name portscan --remove

# These rules add scanners to the portscan list, and log the attempt.
      /sbin/iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
      /sbin/iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

      /sbin/iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
      /sbin/iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP                              
