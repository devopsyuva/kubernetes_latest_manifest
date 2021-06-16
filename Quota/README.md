List of resources you can limit via object count quota:
count/persistentvolumeclaims
count/services
count/secrets
count/configmaps
count/replicationcontrollers
count/deployments.apps
count/replicasets.apps
count/statefulsets.apps
count/jobs.batch
count/cronjobs.batch
count/deployments.extensions


CLI command to apply resourcequota:
kubectl create quota test --hard=count/deployments.extensions=2,count/replicasets.extensions=4,count/pods=3,count/secrets=4 --namespace=visualpath


Reference:
https://medium.com/@Alibaba_Cloud/kubernetes-resource-quotas-f2161607444e
https://kubernetes.io/docs/concepts/policy/resource-quotas/?spm=a2c41.13112061.0.0


https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-constraint-namespace/
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-constraint-namespace/
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/quota-memory-cpu-namespace/
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/quota-pod-namespace/