#! /bin/bash

echo "add requeire package"
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

echo "add repo"
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

echo "disable docker-ce-nightly"
yum-config-manager --disable docker-ce-nightly

echo "install docker "
yum install -y  docker-ce-18.09.8-3.el7 docker-ce-cli-18.09.8-3.el7  containerd.io

systemctl start docker
systemctl stop docker

echo "add config "
echo "-- data-root  set docker image location"
echo "-- change cgroupdriver type"

touch /etc/docker/daemon.json

rm -rf /home/bruceding/data/docker/*
cat <<EOF > /etc/docker/daemon.json
{
  "data-root": "/home/bruceding/data/docker",
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "start docker "
systemctl start docker

