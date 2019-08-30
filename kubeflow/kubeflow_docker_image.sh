#! /bin/bash

for image in `cat kubeflow_images.list`
do 
  echo $image
  sh image_install.sh $image 
done
