In order to schedule the pods on master nodes whch is disabled by default:
kubectl taint nodes --all node-role.kubernetes.io/master-


Certificates renewal:
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/