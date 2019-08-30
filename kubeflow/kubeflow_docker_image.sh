#! /bin/bash
docker pull gcr.azk8s.cn/kubeflow-images-public/ingress-setup
docker tag gcr.azk8s.cn/kubeflow-images-public/ingress-setup:latest gcr.io/kubeflow-images-public/ingress-setup:v1.0.0
for image in `cat kubeflow_images.list`
do 
  echo $image
  sh image_install.sh $image 
done
