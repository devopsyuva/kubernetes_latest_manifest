**This Page will guide and show how to understand about POD and each topic with different examples**

## How to create a POD using CLI (imperative)
```
root@controlplane:~# kubectl run nginx --image=nginx:1.19.0 --restart=Always --labels="app=nginx,environment=dev" --port=80 --dry-run=client -o yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    app: nginx
    environment: dev
  name: nginx
spec:
  containers:
  - image: nginx:1.19.0
    name: nginx
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
root@controlplane:~#
---
# Now lets create it
kubectl run nginx --image=nginx:1.19.0 --restart=Always --labels="app=nginx,environment=dev" --port=80

# check status of POD and test using curl command
root@controlplane:~# kubectl get pod -o wide
NAME    READY   STATUS    RESTARTS   AGE    IP                NODE              NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          116s   192.168.101.125   computeplaneone   <none>           <none>
root@controlplane:~# curl 192.168.101.125
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@controlplane:~# 
```

## How to create a POD using YAML (declarative)
- Now lets see how we can define out desired state of the POD by defining YAML and create it.
- Refer topic "01-sample-nginx.yaml" file for more examples
```
#YAML file to create POD with single container
root@controlplane:~# cat pods/nginx.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: nginx-server
spec:
  containers:
  - name: nginx
    image: nginx:1.19.0
    ports:
    - name: http
      containerPort: 80
      hostPort: 8090
root@controlplane:~# 
---
root@controlplane:~# kubectl create -f pods/nginx.yaml 
pod/nginx-server created
root@controlplane:~# kubectl get po -o wide
NAME           READY   STATUS    RESTARTS   AGE   IP                NODE              NOMINATED NODE   READINESS GATES
nginx-server   1/1     Running   0          7s    192.168.101.126   computeplaneone   <none>           <none>
root@controlplane:~# curl -I 192.168.101.126
HTTP/1.1 200 OK
Server: nginx/1.19.0
Date: Tue, 07 Sep 2021 05:43:44 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 26 May 2020 15:00:20 GMT
Connection: keep-alive
ETag: "5ecd2f04-264"
Accept-Ranges: bytes

root@controlplane:~#
```

## How to cleanup objects created on the cluster like POD
```
# To remove specific POD with name
root@controlplane:~# kubectl delete po nginx
pod "nginx" deleted
root@controlplane:~#

# To remove all PODs
root@controlplane:~# kubectl get pods
NAME           READY   STATUS    RESTARTS   AGE
nginx          1/1     Running   0          5s
nginx-server   1/1     Running   0          116s
root@controlplane:~# kubectl delete po --all
pod "nginx" deleted
pod "nginx-server" deleted
root@controlplane:~# kubectl get pods
No resources found in default namespace.
root@controlplane:~#
```

## How to access application running in POD as container from outside the Cluster using "hostPort"
- hostPort will ensure that port(8090) on the host where POD was assigned is binded to container port(80)
- Inorder to check the application, use node IP address on which POD was running and in the browser give http://\<node-ip\>:8090
```
root@controlplane:~# kubectl run nginx --image=nginx:1.19.0 --restart=Always --labels="app=nginx,environment=dev" --port=80 --hostport=8090
Flag --hostport has been deprecated, has no effect and will be removed in the future.
pod/nginx created
root@controlplane:~#

# Lets verify the same, by get the POD nginx information in yaml format to check hostPort on ports section
root@controlplane:~# kubectl get po nginx -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    cni.projectcalico.org/containerID: e74f349685ceaded74170e0520a433fdf4459ed8781a049352acff0fc52d1e40
    cni.projectcalico.org/podIP: 192.168.101.67/32
    cni.projectcalico.org/podIPs: 192.168.101.67/32
  creationTimestamp: "2021-09-07T05:48:37Z"
  labels:
    app: nginx
    environment: dev
  name: nginx
  namespace: default
  resourceVersion: "116204"
  uid: 4daf3add-65cd-4472-911d-6139a1bf12b2
spec:
  containers:
  - image: nginx:1.19.0
    imagePullPolicy: IfNotPresent
    name: nginx
    ports:
    - containerPort: 80
      hostPort: 8090
      protocol: TCP
..
..

#check connection as mentioned above http://node-ip:8090
```

## For Multi-container POD that needs to work together, please refer "02-multi-container.yaml" file.
- This examples shows how a POD will share storage/volume and uses common network namespace of POD running with multiple containers.
- Both the containers in the example will use only network namespace of a POD, for which containers will communicate on localhost.
- ![multi-container POD](./02-multi-container.yaml)

## How to create initContainers in a POD, refer "03-pod-initContainers.yaml" file
- initContainers helps to initialize tasks that are necessary for main containers to run without any issue.
- ![initContainers](./03-pod-initContainers.yaml)

## For Static POD creation, check "04-static-pod.yaml" file

## For POD volumes, please go through folder "05-pod-volunmes"
- ![emptydir](./05-pod-volumes/01-emptyDir.yaml)
- ![hostpath](./05-pod-volumes/02-hostPath.yaml)
- ![nfs](./05-pod-volumes/03-nfs.yaml)
- ![downwardapi](./05-pod-volumes/04-downwardapi.yaml) etc.,

## To run Jenkins CICD on cluster, check "19-Jenkins.yaml" file which uses NFS as volume.
- Before deploying jenkins, how to install and configure NFS server? please check ![18-NFS-server-configuration.md](./05-pod-volumes/nfs-server-setup.md)
- After successful configuration, install sample application as POD to use NFS volume ![NFS](./05-pod-volumes/03-nfs.yaml).
- Now you can test for Jenkins CICD application, please refer ![Jenkins](./07-jenkins-CICD.yaml)

## To restrict resource consumption by containers in a POD, please refer "08-container-resources.yaml" file