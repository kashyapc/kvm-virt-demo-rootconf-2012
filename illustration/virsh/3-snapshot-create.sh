#!/bin/bash

sudo virsh shutdown f17test
sleep 3
sudo virsh snapshot-create-as f17test snap2-test "test snapshot-2" 
