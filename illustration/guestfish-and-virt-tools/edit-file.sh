#!/bin/bash
set -e

guestname="$1"

guestfish -d "$guestname" -i <<EOF
    write /etc/motd "welcome to kvm virt session at rootconf 2012"
    cat /etc/motd
EOF
