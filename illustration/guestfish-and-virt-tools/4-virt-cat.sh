#!/bin/bash

virt-cat -d f17test /var/log/messages | grep 'dhclient.*bound to'
