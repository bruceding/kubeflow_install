#! /bin/bash
echo "add aliyun k8s repo"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

echo "add sysctl config"
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

setenforce 0

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo "install kubelet kubeadm kubectl"
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet
systemctl daemon-reload

echo "start kubelet"
systemctl restart kubelet

echo "create kubeadm.yaml file"

cat <<EOF > kubeadm.yaml
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
controllerManager:
    extraArgs:
        horizontal-pod-autoscaler-use-rest-clients: "true"
        horizontal-pod-autoscaler-sync-period: "10s"
        node-monitor-grace-period: "10s"
apiServer:
    extraArgs:
        runtime-config: "api/all=true"
kubernetesVersion: "v1.15.2"
networking:
    podSubnet: "10.244.0.0/16"
EOF

echo "k8s.gcr.io repo can not pull in china, use mirrorgooglecontainers"
docker pull  mirrorgooglecontainers/kube-apiserver:v1.15.2
docker tag mirrorgooglecontainers/kube-apiserver:v1.15.2 k8s.gcr.io/kube-apiserver:v1.15.2

docker pull mirrorgooglecontainers/kube-controller-manager-amd64:v1.15.2
docker tag mirrorgooglecontainers/kube-controller-manager-amd64:v1.15.2 k8s.gcr.io/kube-controller-manager:v1.15.2

docker pull mirrorgooglecontainers/kube-scheduler-amd64:v1.15.2 
docker tag mirrorgooglecontainers/kube-scheduler-amd64:v1.15.2 k8s.gcr.io/kube-scheduler:v1.15.2

docker pull mirrorgooglecontainers/kube-proxy:v1.15.2
docker tag mirrorgooglecontainers/kube-proxy:v1.15.2 k8s.gcr.io/kube-proxy:v1.15.2

docker pull coredns/coredns:1.3.1 
docker tag coredns/coredns:1.3.1 k8s.gcr.io/coredns:1.3.1

docker pull mirrorgooglecontainers/pause:3.1
docker tag mirrorgooglecontainers/pause:3.1 k8s.gcr.io/pause:3.1

docker pull mirrorgooglecontainers/etcd:3.3.10
docker tag mirrorgooglecontainers/etcd:3.3.10 k8s.gcr.io/etcd:3.3.10

swapoff -a
echo "kubeadm init"
kubeadm init --config kubeadm.yaml

# after install
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
#if master node run pod , remove taints
#kubectl  taint nodes master_node node-role.kubernetes.io/master-
