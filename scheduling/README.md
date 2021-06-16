afinity/anti-affinity key enhancements:

1)the language is more expressive (not just “AND of exact match”)
2)you can indicate that the rule is “soft”/“preference” rather than a hard
requirement, so if the scheduler can’t satisfy it, the pod will still be scheduled
3)you can constrain against labels on other pods running on the node (or
other topological domain), rather than against labels on the node itself,
which allows rules about which pods can and cannot be co-located

Node affinity is like the existing nodeSelector. it allows you to constrain which
nodes your pod is eligible to be scheduled on, based on labels on the node.

There are currently two types of node affinity, called
1)requiredDuringSchedulingIgnoredDuringExecution (hard)
2)preferredDuringSchedulingIgnoredDuringExecution (soft)

“IgnoredDuringExecution” part of the names means that, similar to how nodeSelector
works, if labels on a node change at runtime such that the affinity rules on a pod
are no longer met, the pod will still continue to run on the node.

Note: If you specify both nodeSelector and nodeAffinity, both must be satisfied
for the pod to be scheduled onto a candidate node.

Inter-pod affinity/anti-affinity constrains against pod labels rather than
node labels.

For example, using pod affinity rules, you could spread or pack pods within a
service or relative to pods in other services. Anti-affinity rules allow you to prevent
pods of a particular service from scheduling on the same nodes as pods of another
service that are known to interfere with the performance of the pods of the first
service. Or, you could spread the pods of a service across nodes or availability
zones to reduce correlated failures.

You can see the operator In being used in the example. The new node affinity
syntax supports the following operators: In, NotIn, Exists, DoesNotExist, Gt,
Lt. You can use NotIn and DoesNotExist to achieve node anti-affinity behavior,
or use node taints to repel pods from specific nodes.

Note:
1)If you specify both nodeSelector and nodeAffinity, both must be satisfied
for the pod to be scheduled onto a candidate node.

2)If you specify multiple nodeSelectorTerms associated with nodeAffinity
types, then the pod can be scheduled onto a node if one of the nodeSelectorTerms
is satisfied.

3)If you specify multiple matchExpressions associated with nodeSelectorTerms,
then the pod can be scheduled onto a node only if all matchExpressions can be
satisfied.

4)If you remove or change the label of the node where the pod is scheduled,
the pod won’t be removed. In other words, the affinity selection works only at the
time of scheduling the pod.

Reference: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/