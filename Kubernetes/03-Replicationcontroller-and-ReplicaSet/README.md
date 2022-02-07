# ReplicationController and ReplicaSet
- A ReplicationController ensures that a specified number of pod replicas
are running at any one time.
- For example:
  - If there are too many pods, the ReplicationController terminates the extra pods. If there are too few, the ReplicationController starts more pods. Unlike manually created pods, the pods maintained by a ReplicationController are automatically replaced if they fail, are deleted, or are terminated.
- To fetch all the pods of RC:
```
pods=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name})
echo $pods
```
- How to scale your RC?
```
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
```
## Difference between ReplicationController and ReplicaSet
- ReplicationController:
  - ReplicationController has scalein and scaleout strategy, where replicaset has the same.
  - It has Equality based selectors.
  - It is based on filtering by label keys and values. Matching objects must satisfy all of the specified label constraints.
  ```
  env = prod
  app != database
  ```
- ReplicaSet:
  - It works same as ReplicationController except selectors.
  - It has Set based selectors.
  - It helps to allow filtering keys according to a set of values.
  ```
  env in (production, staging)
  app notin (frontend, backend)
  qa
  ```

### Need to address this:
- https://www.mirantis.com/blog/kubernetes-replication-controller-replica-set-and-deployments-understanding-replication-options/
