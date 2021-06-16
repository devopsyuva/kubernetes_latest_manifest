When you (a human) access the cluster (for example, using kubectl), you are
authenticated by the apiserver as a particular User Account (currently this is
usually admin, unless your cluster administrator has customized your cluster).
Processes in containers inside pods can also contact the apiserver. When they
do, they are authenticated as a particular Service Account (for example, default).

Note: when we try to create a POD it will use default serviceaccount on pod
specific namespace.

#kubectl get pod -n <namespace> -o yaml
#kubectl get serviceaccount -n <namespace> or kubectl describe serviceaccount <name> -n <namespace>
#kubectl get secrets <default-token> -n <namespace>

Sample serviceaccount creation, which also generates a token for that
serviceaccount with ca.crt reference:

++
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sample-test
  namespace: <saome_namespace>
++

We can also disable the token creation for serviceaccount as mentioned below:

++
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sample-test
automountServiceAccountToken: false
++

Sample can be applied to POD spec level as mentioned below:

++
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: build-robot
  automountServiceAccountToken: false
...
...
++


