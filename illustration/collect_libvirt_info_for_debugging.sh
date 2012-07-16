#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: collect_libvirt_info.sh <output>"
    exit 1
fi

run_command() {
    echo "# $@"
    eval "$@"
}

(
run_command virsh list --all
echo "#----------------------------------------------------------#"
run_command virsh net-list --all
echo "#----------------------------------------------------------#"
run_command virsh net-dumpxml default
echo "#----------------------------------------------------------#"
run_command cat /proc/sys/net/ipv4/ip_forward
run_command cat /proc/sys/net/bridge/bridge-nf-call-arptables
run_command cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
run_command cat /proc/sys/net/bridge/bridge-nf-call-iptables
echo "#----------------------------------------------------------#"
run_command iptables -t filter -L -v
run_command iptables -t nat -L -v
run_command iptables -t mangle -L -v
echo "#----------------------------------------------------------#"
run_command brctl show
run_command route
run_command ifconfig
echo "#----------------------------------------------------------#"
run_command "chkconfig --list | grep -i network"
run_command "ls /etc/systemd/system/*.wants/ | egrep -i 'network|NetworkManager'"
echo "#----------------------------------------------------------#"
) >& $1
