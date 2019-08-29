#!/bin/bash

#pull docker image
docker pull  mirrorgooglecontainers/kubernetes-dashboard-amd64:v1.10.1
docker tag  mirrorgooglecontainers/kubernetes-dashboard-amd64:v1.10.1 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1

# create ssl file
mkdir $HOME/certs
cd $HOME/certs
openssl genrsa -out dashboard.key 2048
openssl rsa -in dashboard.key -out dashboard.key
openssl req -sha256 -new -key dashboard.key -out dashboard.csr -subj '/CN=dashboard'
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt

# create secret
kubectl -n kube-system  create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs

#install 
kubectl apply -f kubernetes-dashboard.yaml 
kubectl apply -f dashboard-adminuser.yaml  

#you can open dashbord not use kubectl proxy
#can use kubectl port-forward
#like kubectl port-forward --address='0.0.0.0' -n kube-system svc/kubernetes-dashboard 8001:443 
#open https://localhost:8001/ or https://ip:8001/

# use token login
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

