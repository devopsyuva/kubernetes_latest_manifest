# Kubernetes Architecture and Components

![kubernetes Architecture](https://www.aquasec.com/wp-content/uploads/2020/11/Kubernetes-101-Architecture-Diagram.jpg)

## Control/Master Node Components:
- kube-apiserver
- etcd
- kube-controller/cloud-controller
- kube-scheduler
- kubelet
- kube-proxy
- CRI(Container Runtime Interface) docker, containerd, cri-o etc.,

## Compute/Worker Node Components:
- kubelet
- kube-proxy
- CRI(Container Runtime Interface) docker(depricated from 1.22), containerd, cri-o etc.,

![containerd](https://kubernetes.io/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/cri-containerd.png)

![kubelet](https://d33wubrfki0l68.cloudfront.net/cbb16af935843386c15e9a7f2c13fd383fea7599/9065d/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/docker-ce.png) 

![containerd](https://kruyt.org/content/images/2021/03/docker_containerd.png)

## Add-on for kubernetes DNS and networking
- CNI(Container Network Interface) like calico, flannel(depricated), wavenet, AWS VPC, Azure VNI etc.,
- CoreDNS for kubernetes internal/cluster DNS service

![calico](https://docs.projectcalico.org/images/architecture-calico.svg)

### References
- [Calico Components](https://docs.projectcalico.org/reference/architecture/overview)