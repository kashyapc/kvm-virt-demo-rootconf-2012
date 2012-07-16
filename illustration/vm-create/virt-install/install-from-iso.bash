#!/bin/bash
set -x
virt-install --connect=qemu:///system \
--name fedora16-rconf\
--disk /export/vmimgs/fedora16-rconf.img,size=5,cache=none \
--ram 2048 \
--vcpus=2 \
--check-cpu \
--hvm \
--os-type linux \
--cpuset auto \
--cdrom /export/isos/Fedora-17-Beta-x86_64-Live-Desktop.iso
