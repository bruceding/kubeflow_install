# kubeflow_install
toolkits for kubeflow install, use centos7.6 system

### install docker with root permission

```
sh docker_install.sh
```

If you change the docker image location set the data-root

```
rm -rf /home/bruceding/data/docker/*
cat <<EOF > /etc/docker/daemon.json
{
  "data-root": "/home/bruceding/data/docker",
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
```

### install k8s master use kubeadm, use root to run
```
sh kubeadm_install.sh 
```
After install, do this with normal user
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# install flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
```

You must remember like this 
```
kubeadm join 172.17.35.1:6443 --token o4y74e.s2agv2jo7flp9bfy \
    --discovery-token-ca-cert-hash sha256:cb8fef596369604ca08634df74836fd1d51f79faadb58896b1efc6d02f6aeb08

```
### install k8s work use kubeadm
```
sh kubeadm_install_worker.sh
```
