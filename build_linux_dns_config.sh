#!/bin/sh

set -o errexit
set -o nounset

# RHEL and Ubuntu script configure the DNS
#    Designed for use with Azure Linux Custom Script Extension
#    NOTE: This concatenates the DNS IP (Ubuntu) and applies to ipv4 (RHEL)

DNS_IP="SET__DNS_IP_ADDRESS"

if grep "Ubuntu" /etc/os-release
then
    echo "DNS=$DNS_IP" >> /etc/systemd/resolved.conf
    ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
    systemctl restart systemd-resolved.service
elif grep "rhel" /etc/os-release 
then
    nmcli connection modify "System eth0" ipv4.dns "$DNS_IP"
    nmcli connection reload
else
    echo "The system is neither Ubuntu or RedHat"
    echo ..
fi
