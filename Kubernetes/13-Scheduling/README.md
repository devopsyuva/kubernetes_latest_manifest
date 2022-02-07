# Kubernetes Scheduling Control
**Pods/Worklods will be launched by default on any fesiable nodes based on default scheduler like "kube-scheculer" based on resource calculation and other algorithem.**
- In order to control the Pods/Workloads to get launched on sepcific compute nodes, we use different schduler control options as discussed below.
- Use cases of Manual Pod-to-Node Scheduling:
  - **Running pods on nodes with dedicated hardware:** Some Kubernetes apps may have specific hardware requirements. For example, pods running ML jobs require performant GPUs instead of CPUs, while Elasticsearch pods would be more efficient on SSDs than HDDs. Thus, the best practice for any resource-aware K8s cluster management is to assign pods to the nodes with the right hardware.
  - **Pods colocation and codependency:** In a microservices setting or a tightly coupled application stack, certain pods should be collocated on the same machine to improve performance, avoid network latency issues, and connection failures. For example, it’s a good practice to run a web server on the same machine as an in-memory cache service or database.
  - **Data Locality:** The data locality requirement of data-intensive applications is similar to the previous use case. To ensure faster reads and better write throughput, these applications may require the databases to be deployed on the same machine where the customer-facing application runs.
  - **High Availability and Fault Tolerance:** To make application deployments highly available and fault-tolerant, it’s a good practice to run pods on nodes deployed in separate availability zones.
- Types of Scheduling Options:
  - nodeName
  - nodeSelector
  - nodeAffinity
  - Pod Affinity/Anti-Affinity
  - Taints and Tolerations

- affinity/anti-affinity key enhancements:
1. the language is more expressive (not just “AND of exact match”)
2. you can indicate that the rule is “soft”/“preference” rather than a hard requirement, so if the scheduler can’t satisfy it, the pod will still be scheduled
3. you can constrain against labels on other pods running on the node (or other topological domain), rather than against labels on the node itself, which allows rules about which pods can and cannot be co-located

- Node affinity is like the existing nodeSelector. it allows you to constrain which nodes your pod is eligible to be scheduled on, based on labels on the node.

- There are currently two types rules of node affinity, called
1. requiredDuringSchedulingIgnoredDuringExecution (hard)
2. preferredDuringSchedulingIgnoredDuringExecution (soft)

- “IgnoredDuringExecution” part of the names means that, similar to how nodeSelector works, if labels on a node change at runtime such that the affinity rules on a pod are no longer met, the pod will still continue to run on the node.
  - Note: If you specify both nodeSelector and nodeAffinity, both must be satisfied for the pod to be scheduled onto a candidate node.
- Inter-pod affinity/anti-affinity constrains against pod labels rather than node labels.
- For example, using pod affinity rules, you could spread or pack pods within a service or relative to pods in other services. Anti-affinity rules allow you to prevent pods of a particular service from scheduling on the same nodes as pods of another service that are known to interfere with the performance of the pods of the first service. Or, you could spread the pods of a service across nodes or availability zones to reduce correlated failures.
- You can see the operator In being used in the example. The new node affinity syntax supports the following operators: In, NotIn, Exists, DoesNotExist, Gt, Lt.
- You can use NotIn and DoesNotExist to achieve node anti-affinity behavior, or use node taints to repel pods from specific nodes.
- Note:
1. If you specify both nodeSelector and nodeAffinity, both must be satisfied for the pod to be scheduled onto a candidate node.
2. If you specify multiple nodeSelectorTerms associated with nodeAffinity types, then the pod can be scheduled onto a node if one of the nodeSelectorTerms is satisfied.
3. If you specify multiple matchExpressions associated with nodeSelectorTerms, then the pod can be scheduled onto a node only if all matchExpressions can be satisfied.
4. If you remove or change the label of the node where the pod is scheduled, the pod won’t be removed. In other words, the affinity selection works only at the time of scheduling the pod.

### Reference:
- [Scheduling]https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
- [CNCF Blog](https://www.cncf.io/blog/2021/07/27/advanced-kubernetes-pod-to-node-scheduling/)