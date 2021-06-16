curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

mv minikube /usr/local/bin/

When we are using --driver=none, just install below package on ubuntu:

apt install conntrack

minikube start --driver=none --kubernetes-version=1.18.4

Note: --driver=none, which means that I am setting up local k8s cluster.

Install kubectl client package to interaction with k8s cluster:

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.4/bin/linux/amd64/kubectl && chmod +x kubectl 

mv kubectl /usr/local/bin/kubectl

Note: Since I am using v1.18.4 k8s, I have downloaded kubectl package with same version.

Reference: https://kubernetes.io/docs/tasks/tools/install-minikube/