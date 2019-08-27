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
yum install docker-ce docker-ce-cli containerd.io

systemctl start docker
systemctl stop docker

echo "add config "
echo "-- data-root  set docker image location"
echo "-- change cgroupdriver type"

touch /etc/docker/daemon.json

cat <<EOF > /etc/docker/daemon.json
{
  "data-root": "/mnt/docker_worker01",
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "start docker "
systemctl start docker

