#! /bin/bash
usage(){
	echo "Usage: $0 docker image"
	echo "Demo: sh $0 gcr.io/kubeflow-images-public/notebook-controller:v20190603-v0-175-geeca4530-e3b0c4"
	exit 1
}
if [[ $# != 1 ]]
then
  usage
fi
echo $1 > tmp
sed  's/gcr.io/gcr.azk8s.cn/' tmp > tmp1

SRC=`cat tmp`
DST=`cat tmp1`

docker pull $DST
docker tag $DST $SRC
