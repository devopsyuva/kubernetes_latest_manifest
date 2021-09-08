# Kubernetes Setup on GCP inatnces with Docker as CRI(Container Runtime Interface)
- How to create a GCP account free trail?
- [GCP Account Free Trail](https://youtu.be/aOVh4qlx-eU)

## System Specification:
- OS: Ubuntu 20.04 LTS server
- RAM: 4GB or more
- CPU: 2 core or more
- Disk: 30GB+
- GCP Instances: 2 instances, one for control plane node (Hostname: controlplane) and another for compute (Hostname: computeplaneone)
- Swap Memory: Diable

## Common tasks/commands to execute on all nodes
- On both new instances/VMs created, just execute below commands to update the apt db and upgrade all packages to latest version.
```
#apt update
#apt dist-upgrade -y
```

- Now, lets install Docker Engine CE on all nodes used for cluster as CRI for kubernetes.
```
#apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#apt-get update
#apt install -y docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03 15~3-0~ubuntu-focal containerd.io

Conform on all nodes if docker was installed with the expected version and running as daemon
#docker --version
#systemctl status docker
```

- Now lets install kubernetes packages on both the nodes, before that we have to enable network module for iptables and bridges as mentioned below
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo 1 > /proc/sys/net/ipv4/ip_forward

sudo sysctl --system
```

- Lets create a repo for kubernetes and install kubernetes v1.21.4 version for now, since v1.22.x has issues in "kubeadm init bootstrap" command.
```
#apt-get install -y apt-transport-https ca-certificates curl
#curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#apt update
#apt install -y kubeadm=1.21.4-00 kubelet=1.21.4-00 kubectl=1.21.4-00
#apt-mark hold kubelet kubeadm kubectl
```

## On controller node
- Now we are going to bootstrap control plane first in the cluster.
- These node now will be control plane node for the entire cluster.
- We will use "--pod-network-cidr" with subnet that doesn't conflict with my base network.
- Since my instances/VMs are using "10.128.0.0/16" series, I can gohead and use "192.168.0.0/16" which calico will use by default.
- We are using calico network for kubernetes as CNI(Container Network Interface)
- Now lets bootstrap the control plane node using "kubeadm init" command as mentioned below:
```
#kubeadm init --apiserver-advertise-address=10.128.0.28 --pod-network-cidr=192.168.0.0/16
Note:
--apiserver-advertise-address needs update with the Internal IP address of the control plane node.
```
- After successful completion of the command, execute below command as shown in the result as well.
```
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```
- Copy the result at last which has details mentioned below to add compute plane node to the cluster.
```
For example:
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a Pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  /docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

 kubeadm join 10.128.0.28:6443 --token q29jqz.2yufaho07bgox8e1 --discovery-token-ca-cert-hash sha256:5e797edb8b039ba369218357a42139a4d169ad3e96c1bcff35585470f0ecba0f 

Note:
**kubeadm join 10.128.0.28:6443 --token q29jqz.2yufaho07bgox8e1 --discovery-token-ca-cert-hash sha256:5e797edb8b039ba369218357a42139a4d169ad3e96c1bcff35585470f0ecba0f** this is important to join the worker node to the master.
```
- Now execute YAML files for calico to get installed on the cluster for networking.
```
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```

## On Compute
- As per result, we need to execute below command to join the compute/worker node to the cluster.
```
root@computenodeone:~# kubeadm join 10.128.0.28:6443 --token q29jqz.2yufaho07bgox8e1 --discovery-token-ca-cert-hash sha256:5e797edb8b039ba369218357a42139a4d169ad3e96c1bcff35585470f0ecba0f
[preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

root@computenodeone:~#
```

## On Controlplane node
- Execute below command to check all nodes are in "Ready" state.
```
root@controlplane:~# kubectl get nodes
NAME             STATUS     ROLES                  AGE     VERSION
computenodeone   NotReady   <none>                 19s     v1.21.4
controlplane     Ready      control-plane,master   2m44s   v1.21.4

root@controlplane:~# kubectl get pods --all-namespaces
NAMESPACE         NAME                                       READY   STATUS    RESTARTS   AGE
calico-system     calico-kube-controllers-868b656ff4-bmzxb   1/1     Running   0          55s
calico-system     calico-node-5xbvk                          1/1     Running   0          39s
calico-system     calico-node-q4phf                          1/1     Running   0          55s
calico-system     calico-typha-b645f876f-l65zj               1/1     Running   1          38s
calico-system     calico-typha-b645f876f-pzx9x               1/1     Running   0          55s
kube-system       coredns-558bd4d5db-xn4zm                   1/1     Running   0          2m46s
kube-system       coredns-558bd4d5db-zqjqp                   1/1     Running   0          2m46s
kube-system       etcd-controlplane                          1/1     Running   0          3m
kube-system       kube-apiserver-controlplane                1/1     Running   0          3m
kube-system       kube-controller-manager-controlplane       1/1     Running   0          3m
kube-system       kube-proxy-njrl8                           1/1     Running   0          39s
kube-system       kube-proxy-p9ksx                           1/1     Running   0          2m46s
kube-system       kube-scheduler-controlplane                1/1     Running   0          3m
tigera-operator   tigera-operator-6fbb48778f-5vzlh           1/1     Running   0          62s

root@controlplane:~# kubectl get nodes
NAME             STATUS   ROLES                  AGE     VERSION
computenodeone   Ready    <none>                 72s     v1.21.4
controlplane     Ready    control-plane,master   3m37s   v1.21.4
root@controlplane:~# 
```

### References:
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Calico](https://docs.projectcalico.org/getting-started/kubernetes/quickstart)