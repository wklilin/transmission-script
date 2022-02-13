#!/bin/bash
# centos7 Transmission

yum -y install epel-release
yum -y update
yum -y install transmission-cli transmission-common transmission-daemon

systemctl start transmission-daemon.service
sleep 2
systemctl stop transmission-daemon.service

systemctl start firewalld
firewall-cmd --add-service=transmission-client --permanent
firewall-cmd --zone=public --add-port=9091/tcp --permanent
firewall-cmd --zone=public --add-port=9091/udp --permanent
firewall-cmd --zone=public --add-port=51413/tcp --permanent
firewall-cmd --zone=public --add-port=51413/udp --permanent
firewall-cmd --reload

firewall-cmd --zone=public --list-ports

read -p "input username:" username
read -p "input password:" password

sed -i 's/"rpc-authentication-required": false,/"rpc-authentication-required": true,/' /var/lib/transmission/.config/transmission-daemon/settings.json
sed -i 's/"rpc-enabled": false,/"rpc-enabled": true,/' /var/lib/transmission/.config/transmission-daemon/settings.json
sed -i "s/\"rpc-username\": \".*\",/\"rpc-username\": \"${username}\",/" /var/lib/transmission/.config/transmission-daemon/settings.json
sed -i "s/\"rpc-password\": \".*\",/\"rpc-password\": \"${password}\",/" /var/lib/transmission/.config/transmission-daemon/settings.json
sed -i 's/"rpc-whitelist-enabled": true,/"rpc-whitelist-enabled": false,/' /var/lib/transmission/.config/transmission-daemon/settings.json

echo "start transmission-daemon.service"
systemctl start transmission-daemon.service
echo "auto run:"
systemctl enable transmission-daemon.service

#/var/lib/transmission/.config/transmission-daemon/settings.json
#"rpc-authentication-required": true,
#"rpc-enabled": true,
#"rpc-password": "mypassword",
#"rpc-username": "mysuperlogin",
#"rpc-whitelist-enabled": false,

echo "over"

#yum -y install epel-release
#yum -y install nginx
#systemctl start nginx
#systemctl enable nginx
#systemctl start firewalld
#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https
#firewall-cmd --reload
