## A minimal fedora kickstart file

install
text
lang en_US.UTF-8
keyboard us
rootpw redhat
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc Asia/Kolkata
bootloader --location=mbr --driveorder=sda  --append="rhgb console=tty0 console=ttyS0,115200 rd_NO_PLYMOUTH" 
zerombr
clearpart --all --initlabel
autopart --type=btrfs


%packages
@core
@editors
%end
