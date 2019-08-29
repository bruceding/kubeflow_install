#! /bin/bash

DIR=`pwd`
echo $DIR
tar zxvf $DIR/kubeflow/kfctl_v0.6.1_linux.tar.gz 
export PATH=$DIR:$PATH
export KFAPP=$DIR/kubeflow
export CONFIG="https://raw.githubusercontent.com/kubeflow/kubeflow/v0.6.1/bootstrap/config/kfctl_k8s_istio.yaml"

kfctl init ${KFAPP} --config=${CONFIG} -V
cd ${KFAPP}
kfctl apply k8s -V
