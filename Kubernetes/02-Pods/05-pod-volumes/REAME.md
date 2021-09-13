# Volumes
On-disk files in a Container are ephemeral, which presents some problems for non-trivial applications when running in Containers. First, when a Container crashes, kubelet will restart it, but the files will be lost - the Container starts with a clean state. Second, when running Containers together in a Pod it is often necessary to share files between those Containers. The Kubernetes Volume abstraction solves both of these problems.

## Why Volumes?
- When multiple pods are launched they might need to share same data volumes.
- Reattach data volume if the Pod is resceduled on a different node.

## Types of Volumes
- emptyDir
- hostPath
- NFS
- configmap
- secrets
- downwardapi
- AWS EBS
- Azure Disk
- Azure File
- CephFS
- Cinder
- iSCSI
- local etc.,

### References
- [volumes](https://kubernetes.io/docs/concepts/storage/volumes/)