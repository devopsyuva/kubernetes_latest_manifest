A ReplicationController ensures that a specified number of pod replicas
are running at any one time.

For example:
  If there are too many pods, the ReplicationController terminates the
  extra pods. If there are too few, the ReplicationController starts
  more pods. Unlike manually created pods, the pods maintained by a
  ReplicationController are automatically replaced if they fail, are
  deleted, or are terminated.

To fetch all the pods of RC:
pods=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name})
echo $pods

How to scale your RC:
kubectl scale --replicas=3 rc/nginx

RS:
Difference of rc and rs in yaml file
...
spec:
   replicas: 3
   selector:
     matchExpressions:
      - {key: app, operator: In, values: [soaktestrs, soaktestrs, soaktest]}
      - {key: teir, operator: NotIn, values: [production]}
  template:
     metadata:
...

Need to address this:
https://www.mirantis.com/blog/kubernetes-replication-controller-replica-set-and-deployments-understanding-replication-options/
