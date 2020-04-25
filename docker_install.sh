#! /bin/bash

echo "add requeire package"
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

echo "add repo"
yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

echo "disable docker-ce-nightly"
yum-config-manager --disable docker-ce-nightly

echo "install docker "
yum install -y  docker-ce-18.09.8-3.el7 docker-ce-cli-18.09.8-3.el7  containerd.io

systemctl enable docker.service
systemctl start docker
systemctl stop docker

echo "add config "
echo "-- data-root  set docker image location"
echo "-- change cgroupdriver type"

touch /etc/docker/daemon.json

if [ ! -d "/opt/docker" ]; then
    mkdir -p /opt/docker
    chmod 777 /opt/docker
fi

cat <<EOF > /etc/docker/daemon.json
{
  "data-root": "/opt/docker",
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "start docker "
systemctl start docker

