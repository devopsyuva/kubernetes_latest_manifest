# Kubernetes Setup using minikube for standalone

## System Requirements
- OS: Ubuntu 20.04 LTS server
- RAM: 4GB or more
- Network: Nat and host-only for internal purpose, and Bridge/Public IP address external access
- Disk: 30GB or more
- Swap memory: disable (Important)

## Pre-request
- on new machine created, just run
```
#apt update && apt dist-upgrade
#init 6 --> execute this command if kernel was upgraded while "dis-upgrade", better to reboot
```
- Disable swap memeory permanentry and temporarly
```
#swapoff -a (temporary)
# vi /etc/fstab --> comment the line which shows swap details and :x or :wq! to save and exit
```

## Install minikube
- First download utility and place it in proper executable binary default location
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

mv minikube /usr/local/bin/

Note
When we are using --driver=none, just install below package on ubuntu:

apt install conntrack
```

- Now run below command to start/initiate minikube
```
minikube start --driver=none --kubernetes-version=1.18.4

Note:
--driver=none, which means that I am setting up local k8s cluster.
```

- Install kubectl client package to interaction with k8s cluster:
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.4/bin/linux/amd64/kubectl && chmod +x kubectl 

mv kubectl /usr/local/bin/kubectl

Note: Since I am using v1.18.4 k8s, I have downloaded kubectl package with same version.
```

### Reference:
- [minikube]https://kubernetes.io/docs/tasks/tools/install-minikube/