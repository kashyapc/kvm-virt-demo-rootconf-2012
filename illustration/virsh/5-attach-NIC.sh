#!/bin/bash

sudo virsh attach-interface --domain f17test --type bridge --source virbr0 --model virtio --mac 52:54:00:4b:75:6f

sudo virsh domiflist f17test
