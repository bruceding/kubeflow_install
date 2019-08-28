#! /bin/bash

systemctl stop kubelet
kubeadm reset
rm -rf  /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/

ifconfig cni0 down
ifconfig flannel.1 down 

ip link delete cni0
ip link delete flannel.1 


