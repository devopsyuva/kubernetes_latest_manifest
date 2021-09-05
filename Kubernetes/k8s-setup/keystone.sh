#!/usr/bin/env bash
# Before running this script
# - You need to source the openstack admin credential
# - Make sure 'jq' is installed('apt install -y jq')
# - python-openstackclient needs to be installed('pip install python-openstackclient')
# - This script is supposed to run on the api server node

set -ex

# Re-use api server certs for k8s-keystone-service
api_cert_data=$(cat /etc/kubernetes/pki/apiserver.crt | base64 | tr -d '\n')
api_key_data=$(cat /etc/kubernetes/pki/apiserver.key | base64 | tr -d '\n')

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: k8s-auth-policy
  namespace: kube-system
data:
  policies: |
    [
      {
        "resource": {
          "verbs": ["get", "list", "watch"],
          "resources": ["pods"],
          "version": "*",
          "namespace": "default"
        },
        "match": [
          {
            "type": "role",
            "values": ["member"]
          },
          {
            "type": "project",
            "values": ["demo"]
          }
        ]
      }
    ]
---
apiVersion: v1
kind: Secret
metadata:
  name: k8s-keystone-service-certs
  namespace: kube-system
type: Opaque
data:
  cert-file: ${api_cert_data}
  key-file: ${api_key_data}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8s-keystone-service
  namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: k8s-keystone-service
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "watch", "list"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: k8s-keystone-service
subjects:
  - kind: ServiceAccount
    name: k8s-keystone-service
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: k8s-keystone-service
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-keystone-auth
  namespace: kube-system
  labels:
    app: k8s-keystone-auth
spec:
  replicas: 1
  selector:
    matchLabels:
      app: k8s-keystone-auth
  template:
    metadata:
      labels:
        app: k8s-keystone-auth
    spec:
      serviceAccountName: k8s-keystone-service
      containers:
        - name: k8s-keystone-auth
          image: k8scloudprovider/k8s-keystone-auth
          imagePullPolicy: Always
          args:
            - ./bin/k8s-keystone-auth
            - --tls-cert-file
            - /etc/kubernetes/pki/cert-file
            - --tls-private-key-file
            - /etc/kubernetes/pki/key-file
            - --policy-configmap-name
            - k8s-auth-policy
            - --keystone-url
            - ${OS_AUTH_URL}/v3
          volumeMounts:
            - mountPath: /etc/kubernetes/pki
              name: k8s-certs
              readOnly: true
          ports:
            - containerPort: 8443
      volumes:
      - name: k8s-certs
        secret:
          secretName: k8s-keystone-service-certs
---
kind: Service
apiVersion: v1
metadata:
  name: k8s-keystone-service
  namespace: kube-system
spec:
  selector:
    app: k8s-keystone-auth
  ports:
    - protocol: TCP
      port: 8443
      targetPort: 8443
EOF

# Wait for the deployment to be available
end=$(($(date +%s) + 600))
status="False"
while true; do
  status=$(kubectl get deployment k8s-keystone-auth -n kube-system -o json | jq -r '.status.conditions[] | select(.type=="Available") | .status')
  [ "$status" == "True" ] && break || true
  sleep 5
  now=$(date +%s)
  [ $now -gt $end ] && echo "Timeout when waiting for the k8s-keystone-service being available." && exit -1
done

# Test if the service is working
service_ip=$(kubectl get service k8s-keystone-service -n kube-system -o json | jq -r '.spec.clusterIP')
token=$(openstack token issue -f yaml -c id | awk '{print $2}')
cat <<EOF | curl -ks -XPOST -d @- https://${service_ip}:8443/webhook | python -mjson.tool
{
  "apiVersion": "authentication.k8s.io/v1beta1",
  "kind": "TokenReview",
  "metadata": {
    "creationTimestamp": null
  },
  "spec": {
    "token": "$token"
  }
}
EOF
cat <<EOF | curl -ks -XPOST -d @- https://${service_ip}:8443/webhook | python -mjson.tool
{
  "apiVersion": "authorization.k8s.io/v1beta1",
  "kind": "SubjectAccessReview",
  "spec": {
    "resourceAttributes": {
      "namespace": "",
      "verb": "get",
      "group": "",
      "resource": "pods"
    },
    "user": "admin",
    "group": ["00df464927124a34a034e2af2bd0081d"],
    "extra": {
        "alpha.kubernetes.io/identity/project/id": ["00df464927124a34a034e2af2bd0081d"],
        "alpha.kubernetes.io/identity/project/name": ["admin"],
        "alpha.kubernetes.io/identity/roles": ["admin", "member", "anotherrole"]
    }
  }
}
EOF

# Config API server
cat <<EOF > /etc/kubernetes/pki/webhookconfig.yaml
---
apiVersion: v1
kind: Config
preferences: {}
clusters:
  - cluster:
      insecure-skip-tls-verify: true
      server: https://${service_ip}:8443/webhook
    name: webhook
users:
  - name: webhook
contexts:
  - context:
      cluster: webhook
      user: webhook
    name: webhook
current-context: webhook
EOF
sed -i '/image:/ i \ \ \ \ - --authentication-token-webhook-config-file=/etc/kubernetes/pki/webhookconfig.yaml' /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i '/image:/ i \ \ \ \ - --authorization-webhook-config-file=/etc/kubernetes/pki/webhookconfig.yaml' /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i "/authorization-mode/c \ \ \ \ - --authorization-mode=Node,Webhook,RBAC" /etc/kubernetes/manifests/kube-apiserver.yaml
# 恢复
# sed -i "/authorization-mode/c \ \ \ \ - --authorization-mode=Node,RBAC" /etc/kubernetes/manifests/kube-apiserver.yaml
# sed -i '/webhookconfig.yaml/d' /etc/kubernetes/manifests/kube-apiserver.yaml

# Wait for the API server to be running
end=$(($(date +%s) + 60))
status="False"
while true; do
  status=$(kubectl get po -n kube-system | grep kube-apiserver | awk '{print $3}')
  [ "$status" == "Running" ] && break || true
  sleep 2
  now=$(date +%s)
  [ $now -gt $end ] && echo "Timeout when waiting for API server to be running." && exit -1
done

echo "Done!"