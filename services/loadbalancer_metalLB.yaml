#MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.
#we can follow the instructions specified in the document or else we can
#download the yaml file and modified the parameters based on our requirement.
#https://metallb.universe.tf/installation/
#kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
#After This follow the configurations steps specified: https://metallb.universe.tf/configuration/
#kubectl expose deploy nginx --port 80 --type Loadbalancer

apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true


kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


apiVersion: v1
kind: Service
metadata:
  name: example-service
spec:
  selector:
    app: nginx
  ports:
    - port: 32326
      targetPort: 80
  type: LoadBalancer
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      name: web
    volumeMounts:
    - name: www
      mountPath: /usr/share/nginx/html/index.html
      subPath: index.html
  volumes:
    - name: www
      downwardAPI:
        items:
          - path: "index.html"
            fieldRef:
              fieldPath: metadata.name
---
apiVersion: v1
kind: example-service
metadata:
  name: example-service
spec:
  loadBalancerIP: 192.168.0.241
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
  type: LoadBalancer