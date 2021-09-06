## User Degined Certificate
**By default, kubeadm generates all the certificates needed for a cluster to run. You can override this behavior by providing your own certificates.

To do so, you must place them in whatever directory is specified by the --cert-dir flag or the certificatesDir field of kubeadm's ClusterConfiguration. By default this is /etc/kubernetes/pki.

If a given certificate and private key pair exists before running kubeadm init, kubeadm does not overwrite them. This means you can, for example, copy an existing CA into /etc/kubernetes/pki/ca.crt and /etc/kubernetes/pki/ca.key, and kubeadm will use this CA for signing the rest of the certificates.**

```
root@controlplane:~# kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Aug 31, 2022 02:04 UTC   358d                                    no      
apiserver                  Aug 31, 2022 02:04 UTC   358d            ca                      no      
apiserver-etcd-client      Aug 31, 2022 02:04 UTC   358d            etcd-ca                 no      
apiserver-kubelet-client   Aug 31, 2022 02:04 UTC   358d            ca                      no      
controller-manager.conf    Aug 31, 2022 02:04 UTC   358d                                    no      
etcd-healthcheck-client    Aug 31, 2022 02:04 UTC   358d            etcd-ca                 no      
etcd-peer                  Aug 31, 2022 02:04 UTC   358d            etcd-ca                 no      
etcd-server                Aug 31, 2022 02:04 UTC   358d            etcd-ca                 no      
front-proxy-client         Aug 31, 2022 02:04 UTC   358d            front-proxy-ca          no      
scheduler.conf             Aug 31, 2022 02:04 UTC   358d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Aug 29, 2031 02:04 UTC   9y              no      
etcd-ca                 Aug 29, 2031 02:04 UTC   9y              no      
front-proxy-ca          Aug 29, 2031 02:04 UTC   9y              no      
root@controlplane:~#
```

```
root@controlplane:~# kubectl -n kube-system get cm kubeadm-config -o yaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controllerManager: {}
    dns:
      type: CoreDNS
    etcd:
      local:
        dataDir: /var/lib/etcd
    imageRepository: k8s.gcr.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.21.4
    networking:
      dnsDomain: cluster.local
      podSubnet: 192.168.0.0/16
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
  ClusterStatus: |
    apiEndpoints:
      controlplane:
        advertiseAddress: 10.128.0.22
        bindPort: 6443
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterStatus
kind: ConfigMap
metadata:
  creationTimestamp: "2021-08-31T02:04:45Z"
  name: kubeadm-config
  namespace: kube-system
  resourceVersion: "208"
  uid: bdfa8d64-c897-4b0b-aa8c-3e9b69c80ffa
root@controlplane:~# 
```
### References:
- [Certificate Management](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)
- [PKI Certificates](https://kubernetes.io/docs/setup/best-practices/certificates/)