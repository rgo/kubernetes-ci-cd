#!/usr/bin/env bash

echo "NOTE: Don't forget to set up RBAC[https://github.com/coreos/etcd-operator/blob/master/doc/user/install_guide.md]"
read -p 'Press [Enter] key to continue...'

echo "installing etcd operator"

kubectl create -f https://raw.githubusercontent.com/coreos/etcd-operator/master/example/deployment.yaml
kubectl rollout status -f https://raw.githubusercontent.com/coreos/etcd-operator/master/example/deployment.yaml

until kubectl get customresourcedefinitions
do
     echo "waiting for operator"
     sleep 2
done

echo "pausing for 10 seconds for operator to settle"
sleep 10

kubectl create -f https://raw.githubusercontent.com/coreos/etcd-operator/master/example/example-etcd-cluster.yaml

echo "installing etcd cluster service"
kubectl create -f https://raw.githubusercontent.com/coreos/etcd-operator/master/example/example-etcd-cluster-nodeport-service.json

echo "waiting for etcd cluster to turnup"

until kubectl  get pod example-etcd-cluster-0002
do
    echo "waiting for etcd cluster to turnup"
    sleep 2
done
