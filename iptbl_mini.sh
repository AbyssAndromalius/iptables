#!/bin/sh
# My system IP/set ip address of server
SERVER_IP="XXXXXXXXX"
HOME_IP="YYYYYYYY"
WORK_IP="ZZZZZZZZ"

# Flushing all rules
iptables -F
iptables -X

# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow incoming ssh 22 from anywere (protected by public key) 
iptables -A INPUT -p tcp -d $SERVER_IP --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER_IP --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

#Allow DNS Query 
iptables -A OUTPUT -p udp -s $SERVER_IP --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -d $SERVER_IP --sport 53 -m state --state ESTABLISHED -j ACCEPT

#Allow HTTP Work (for updates)
iptables -A OUTPUT -p tcp -s $SERVER_IP --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -d $SERVER_IP --sport 80 -m state --state ESTABLISHED -j ACCEPT

#Allow access to HTTP
iptables -A INPUT -p tcp -d $SERVER_IP --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT   
iptables -A OUTPUT -p tcp -s $SERVER_IP --sport 80 -m state --state ESTABLISHED -j ACCEPT

#Allow access to HTTPS
iptables -A INPUT -p tcp -d $SERVER_IP --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT   
iptables -A OUTPUT -p tcp -s $SERVER_IP --sport 443 -m state --state ESTABLISHED -j ACCEPT

#########ADD CUSTOM RULES HERE######################################



####################################################################

# make sure nothing comes or goes out of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

###################EXEMPLES################


# Allow incoming TCP 9999 from HOME_IP & WORK_IP
#iptables -A INPUT -p tcp -s $Q_HOME_IP,$WORK_IP -d $SERVER_IP --sport 513:65535 --dport 9999 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp -s $SERVER_IP -d $Q_HOME_IP,$WORK_IP --sport 9999 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming TCP 9999 from an IP (1.2.3.4)
#iptables -A INPUT -p tcp -s 1.2.3.4 -d $SERVER_IP --sport 513:65535 --dport 9999 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp -s $SERVER_IP -d 1.2.3.4 --sport 9999 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming ping 
#iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -d $SERVER_IP -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#iptables -A OUTPUT -p icmp --icmp-type 0 -s $SERVER_IP -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT
