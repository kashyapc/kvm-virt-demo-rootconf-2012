#!/bin/bash

sudo virsh start f17test

#Ensure f17test is the only guest up. Result: The SELinux security context should match.
ps -eZ | grep qemu-kvm
sudo ls -lZ /var/lib/libvirt/images/f17test.qcow2

