# kubeflow_install
toolkits for kubeflow install, use centos7.6 system

### install docker with root permission

```
sh docker_install.sh
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
### install k8s worker node use kubeadm
```
sh kubeadm_install_worker.sh
```
After install, use this join the master 
```
kubeadm join 172.17.35.1:6443 --token o4y74e.s2agv2jo7flp9bfy \
    --discovery-token-ca-cert-hash sha256:cb8fef596369604ca08634df74836fd1d51f79faadb58896b1efc6d02f6aeb08
```
Check token from `kubeadm token list`, if the token is invalid, you can use  `kubeadm token create`. 

### install k8s dashborad
```
sh kubernetes_dashbord_install.sh 
```

### install kubeflow
```
sh kubeflow_install.sh
```
If you create local storage
Change kubeflow/\*pv.yaml as your local environment 
```
nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - k8smaster # change this
```
install like this
```
cd kubeflow
kubectl apply -f katib-pv.yaml 
kubectl apply -f metadata-mysql-pv.yaml  
kubectl apply -f minio-pv.yaml   
kubectl apply -f mysql-pv.yaml    
```
Check `kubectl get pods -n kubeflow`, if you can not pull the docker image, you can run
```
sh kubeflow_docker_image.sh
```
You can use `istio-ingressgateway` NodePort like `80:31380/TCP`, use http://${master_ip}:31380 login kubeflow dashborad.
