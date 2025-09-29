#!/bin/bash

# TODO: ADD the logic for ubuntu vs other
apt-get update

systemctl stop firewalld && systemctl disable firewalld

echo 'net.ipv4.ip_forward=1' | tee -a /etc/sysctl.conf

sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab && swapoff -a

echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid

systemctl stop firewalld || true

systemctl disable firewalld || true

systemctl stop nm-cloud-setup || true

systemctl disable nm-cloud-setup || true

systemctl stop nm-cloud-setup.timer || true

systemctl disable nm-cloud-setup.timer || true
