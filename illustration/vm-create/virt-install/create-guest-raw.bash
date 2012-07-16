#!/bin/bash

# Script to auto create/install unattended Virtual Machines (with bridging if available)
#
# 1)Note: Bridging should be configured on the host to allow guests to be in the same subnet as hosts
# 2)For creating a bridge, refer this --  http://kashyapc.wordpress.com/2012/05/13/bridged-networking-notes-with-systemctl/
# 3)The kickstart file contains minimal fedora pkgs [only @core] 
# 4)Also adds a serial console


# check if Bridged Networking is configured

show_bridge=`brctl show | awk 'NR==2 {print $1}'`
if [ $? -ne 0 ] ; then
	echo "Bridged Networking is not configured, please do so to get an IP similar to your host."
	exit 1
fi 

#check if no. of arguments are 3
if [ "$#" != 3 ]; then
	echo " Please provide the args according to usage"
	echo ""
	echo " usage: "$0 domname distro arch" "
	echo ""
        echo "     where 'domname'= fed16test1 [OR] fed16test2"
        echo "     where 'distro' = f16 [or] f17"
        echo "     where 'arch'   = x86_64 [OR] i386"
	echo ""
	exit 1
fi


#Define the positional parameters
domname=$1
distro=$2
arch=$3

location1=http://dl.fedoraproject.org/pub/fedora/linux/releases/16/Fedora/x86_64/os/
location2=http://dl.fedoraproject.org/pub/fedora/linux/development/17/$arch/os/



echo "Creating domain $domname..." 
echo "Location of OS sources --  $location1"

if [ "$distro" = f16 ]; then

virt-install --connect=qemu:///system \
    --network=bridge:virbr0 \
    --initrd-inject=./fed-minimal.ks \
    --extra-args="ks=file:/fed-minimal.ks console=tty0 console=ttyS0,115200" \
    --name=$domname \
    --disk /var/lib/libvirt/images/$domname.img,size=6,cache=none \
    --ram 2048 \
    --vcpus=2 \
    --check-cpu \
    --cpuset auto \
    --accelerate \
    --hvm \
    --location=$location1 \
    --os-type linux \
    --os-variant fedora16 \
    --nographics

exit 1

#-------------------------------------------------------------------------------#

elif [ "$distro" = f17 ]; then

echo "Location of the OS sources: $location2"

virt-install --connect=qemu:///system \
    --network=bridge:virbr0 \
    --initrd-inject=./fed-minimal.ks \
    --extra-args="ks=file:/fed-minimal.ks console=tty0 console=ttyS0,115200 " \
    --name=$domname \
    --disk /var/lib/libvirt/images/$domname.img,size=6,cache=none \
    --ram 2048 \
    --vcpus=2 \
    --check-cpu \
    --cpuset auto \
    --accelerate \
    --hvm \
    --location=$location2 \
    --os-type linux \
    --nographics

fi

#-------------------------------------------------------------------------------#
