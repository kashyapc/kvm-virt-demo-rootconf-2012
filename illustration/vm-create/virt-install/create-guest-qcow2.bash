#!/bin/bash

# check if Bridged Networking is configured
show_bridge=`brctl show | awk 'NR==2 {print $1}'`
if [ $? -ne 0 ] ; then
    echo "Bridged Networking is not configured, please do so to get an IP similar to your host."
    exit 255
fi


#Check if no. of arguments and throw usage
if [ "$#" != 3 ]; then
    echo " Please provide the args according to usage"
    echo ""
    echo " usage: "$0 domname distro arch" "
    echo ""
        echo "     where 'domname'= f16qtest1 [OR] f16qtest2"
        echo "     where 'distro' = f16 []or f17"
        echo "     where 'arch'   = x86_64 [OR] i386"
    echo ""
    exit 255
fi


#Define the positional parameters
domname=$1
distro=$2
arch=$3


location1=http://dl.fedoraproject.org/pub/fedora/linux/releases/16/Fedora/x86_64/os/
location2=http://dl.fedoraproject.org/pub/fedora/linux/development/17/$arch/os/

#Disk image location
diskimage=/var/lib/libvirt/images/$domname.qcow2 

# Let's create a qcow2 disk image
qemu-img create -f qcow2 -o preallocation=metadata $diskimage 7G

## NOTE: Further performance Optimization: (This will allocate the full disk size) You ##
## could uncomment the below line : ##

# $fallocate -l `ls -al $diskimage | awk '{print$5}'` $diskimage 



echo "Creating QCOW2 disk image..."


if [ "$distro" = f16 ]; then

echo "Location of the OS sources: $location1"

virt-install --connect=qemu:///system \
    --network=bridge:virbr0 \
    --initrd-inject=./fed-minimal.ks \
    --extra-args="ks=file:/fed-minimal.ks console=tty0 console=ttyS0,115200 " \
    --name=$domname \
    --disk path=$diskimage,format=qcow2,cache=none \
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
    --disk path=$diskimage,format=qcow2,cache=none \
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

