## Issue related to br_netfilter module missing
```
Issue:
======
root@controlplanenode:~# kubeadm init --apiserver-advertise-address=192.168.1.90 --pod-network-cidr=10.244.0.0/16
[init] Using Kubernetes version: v1.22.1
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher


Solution:
=========
root@controlplanenode:~# modprobe br_netfilter
root@controlplanenode:~# sysctl -p /etc/sysctl.conf
net.bridge.bridge-nf-call-iptables = 1
root@controlplanenode:~# kubeadm init --apiserver-advertise-address=192.168.1.90 --pod-network-cidr=10.244.0.0/16
[init] Using Kubernetes version: v1.22.1
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
..
..
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.90:6443 --token j1k7qd.3amsprf4br85e0nt \
        --discovery-token-ca-cert-hash sha256:24a0a5564c564dbfd35181394bbf43f52252b0f9e7c9b3af17ab867599b40886
```

## Issue on compute plane
```
Issue:
======
root@computeplaneone:~# kubeadm join 192.168.1.90:6443 --token j1k7qd.3amsprf4br85e0nt \
>         --discovery-token-ca-cert-hash sha256:24a0a5564c564dbfd35181394bbf43f52252b0f9e7c9b3af17ab867599b40886
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher

Solution:
=========
root@computeplaneone:~# echo 1 > /proc/sys/net/ipv4/ip_forward
root@computeplaneone:~# kubeadm join 192.168.1.90:6443 --token j1k7qd.3amsprf4br85e0nt         --discovery-token-ca-cert-hash sha256:24a0a5564c564dbfd35181394bbf43f52252b0f9e7c9b3af17ab867599b40886
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
[kubelet-check] Initial timeout of 40s passed.

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

root@computeplaneone:~#
```

```
root@controlplane:~# kubeadm init --apiserver-advertise-address=10.244.0.2 --pod-network-cidr=192.168.0.0/16
[init] Using Kubernetes version: v1.22.2
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
root@controlplane:~# echo 1 > /proc/sys/net/ipv4/ip_forward
root@controlplane:~#
```