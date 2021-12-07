# RBAC using user certificates:
```
kubectl create namespace sudheer
openssl genrsa -out employee.key 2048
openssl req -new -key employee.key -out employee.csr -subj "/CN=employee/O=sudheer"
openssl x509 -req -in employee.csr -CA CA_LOCATION/ca.crt -CAkey CA_LOCATION/ca.key -CAcreateserial -out employee.crt -days 500
kubectl config set-credentials employee --client-certificate=employee.crt --client-key=employee.key
kubectl config set-context employee-context --cluster=kubernetes --namespace=sudheer --user=employee
kubectl --context=employee-context get pods
```

# RBAC using ServiceAccount:
```
kubectl get secret default-token-hjcdh -n default -o "jsonpath={.data.token}" | base64 --decode
kubectl get secret default-token-hjcdh -n default -o "jsonpath={.data['ca\.crt']}"
```
- Update the above entries as mentioned below:
```
kubectl config set-credentials sudheer --token=<token>
kubectl config set-context sudheer-context --cluster=kubernetes --namespace=default --user=sudheer
```
- Update the client-key-date as well in the config file under (~/.kube/config --> default path)
```
apiVersion: v1
kind: Config
preferences: {}

# Define the cluster
clusters:
- cluster:
    certificate-authority-data: PLACE CERTIFICATE HERE
    # You'll need the API endpoint of your Cluster here:
    server: https://YOUR_KUBERNETES_API_ENDPOINT
  name: my-cluster

# Define the user
users:
- name: mynamespace-user
  user:
    as-user-extra: {}
    client-key-data: PLACE CERTIFICATE HERE
    token: PLACE USER TOKEN HERE

# Define the context: linking a user to a cluster
contexts:
- context:
    cluster: my-cluster
    namespace: mynamespace
    user: mynamespace-user
  name: mynamespace

# Define current context
current-context: mynamespace
```
- Set new contexts to your kubectl to communicate with as mentioned below.
```
root@kubernetesmaster:~# kubectl config set-context sudhams-context
Context "sudhams-context" modified.
root@kubernetesmaster:~#

or

kubectl config set-context $(kubectl config current-context) --namespace=mynamespace
```

# RBAC using username and password:
```
root@kubernetesmaster:~# kubectl config set-credentials cluster-admin --username=admin --password=dGVzdDEyMwo=
User "cluster-admin" set.
root@kubernetesmaster:~# kubectl config set-context sudhams-context --cluster=scratch --namespace=default --user=admin
Context "usersudhams-context" created.
root@kubernetesmaster:~#
```

## Reference:
- https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#define-clusters-users-and-contexts