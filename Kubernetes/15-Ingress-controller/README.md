# Ingress Controller

**Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.**

- When you create a Service Type: LoadBalancer, you also create an underlying Bare-metal/Azure/AWS/GCP load balancer resource. The load balancer is configured to distribute traffic to the pods in your Service on a given port.
- The LoadBalancer only works at layer 4. At layer 4, the Service is unaware of the actual applications, and can't make any more routing considerations.
- Ingress controllers work at layer 7, and can use more intelligent rules to distribute application traffic. Ingress controllers typically route HTTP traffic to different applications based on the inbound URL.

- [k8s-ingress](../src/images/k8s-ingress.png)
- [Ingress-controller](../src/images/Ingress-Controller-k8s.png)

## Ingress rules:
- host:
  - If no host is specified, so the rule applies to all inbound HTTP traffic through he IP address specified.
  - If host is specified, the rules apply to that host.
- paths:
  - /app1 for example, both host and path must match the content of an incomming request before the load balancer traffic to the referenced service.
- backend:
  - A backend is a combination of Service and port names as described in the Service doc or a custom resource backend by way of a CRD.
  - HTTP (and HTTPS) requests to the Ingress that matches the host and path of the rule are sent to the listed backend.

## Types of Ingress
- Ingress backend by a single service
- Multi-Services access with single IP address(Path Based Routing)
- Name based virtual hosting
- TLS

### References:
- [Ingress Nginx](https://kubernetes.github.io/ingress-nginx/deploy/)
- [TLS ingress](https://kubernetes.github.io/ingress-nginx/user-guide/tls/)
- [Client Cert Auth](https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/)
- [Azure Example](https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls)

```
#TLS certs creation and manual verification
#Copy
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out app1-ingress-tls.crt -keyout app1-ingress-tls.key -subj "/CN=app1.sudheerdevops.com/O=SudheerDevops"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out app2-ingress-tls.crt -keyout app2-ingress-tls.key -subj "/CN=app2.sudheerdevops.com/O=SudheerDevops"

or
openssl req -nodes -newkey rsa:2048 -keyout app1-ingress.key -out app1-ingress.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=app1.sudheerdevops.tld"
Field   Meaning	              Example
=====================================
/C=	    Country	              IN
/ST=	  State	                Telangana
/L=	    Location	            Hyderabad
/O=	    Organization	        Global Security
/OU=	  Organizational Unit   IT Department
/CN=	  Common Name           app1.sudheerdevops.com

kubectl create secret tls app1-ingress-tls --key app1-ingress-tls.key --cert app1-ingress-tls.crt
kubectl create secret tls app2-ingress-tls --key app2-ingress-tls.key --cert app2-ingress-tls.crt

#Curl example:
curl -v -k --resolve app1.sudheerdevops.tld:30443:192.168.1.91 https://app1.sudheerdevops.tld/app1
```

```
root@controlplanenode:~# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/baremetal/deploy.yaml
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
configmap/ingress-nginx-controller created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
service/ingress-nginx-controller-admission created
service/ingress-nginx-controller created
deployment.apps/ingress-nginx-controller created
ingressclass.networking.k8s.io/nginx created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
serviceaccount/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
root@controlplanenode:~#

root@controlplanenode:~# kubectl get all -n ingress-nginx -o wide
NAME                                           READY   STATUS      RESTARTS   AGE     IP              NODE              NOMINATED NODE   READINESS GATES
pod/ingress-nginx-admission-create--1-c96d7    0/1     Completed   0          2m54s   10.244.101.69   computeplaneone   <none>           <none>
pod/ingress-nginx-admission-patch--1-r2rzs     0/1     Completed   0          2m54s   10.244.101.70   computeplaneone   <none>           <none>
pod/ingress-nginx-controller-8cf5559f8-zrhdh   1/1     Running     0          2m54s   10.244.101.71   computeplaneone   <none>           <none>

NAME                                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE     SELECTOR
service/ingress-nginx-controller             NodePort    10.111.12.191   <none>        80:30544/TCP,443:32350/TCP   2m54s   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
service/ingress-nginx-controller-admission   ClusterIP   10.98.156.214   <none>        443/TCP                      2m54s   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                                                                                                               SELECTOR
deployment.apps/ingress-nginx-controller   1/1     1            1           2m54s   controller   k8s.gcr.io/ingress-nginx/controller:v1.0.0@sha256:0851b34f69f69352bf168e6ccf30e1e20714a264ab1ecd1933e4d8c0fc3215c6   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx

NAME                                                 DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES                                                                                                               SELECTOR
replicaset.apps/ingress-nginx-controller-8cf5559f8   1         1         1       2m54s   controller   k8s.gcr.io/ingress-nginx/controller:v1.0.0@sha256:0851b34f69f69352bf168e6ccf30e1e20714a264ab1ecd1933e4d8c0fc3215c6   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx,pod-template-hash=8cf5559f8

NAME                                       COMPLETIONS   DURATION   AGE     CONTAINERS   IMAGES                                                                                                                       SELECTOR
job.batch/ingress-nginx-admission-create   1/1           14s        2m54s   create       k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0@sha256:f3b6b39a6062328c095337b4cadcefd1612348fdd5190b1dcbcb9b9e90bd8068   controller-uid=d6f32e19-c5b0-4e76-832d-4e364d1b6f67
job.batch/ingress-nginx-admission-patch    1/1           15s        2m54s   patch        k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0@sha256:f3b6b39a6062328c095337b4cadcefd1612348fdd5190b1dcbcb9b9e90bd8068   controller-uid=de1e06c7-e7b1-427d-ae34-d11a62108db9

root@controlplanenode:~# curl 10.244.101.71
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
root@controlplanenode:~#
```


```
root@controlplanenode:~/ingress# kubectl get all -o wide
NAME                                     READY   STATUS    RESTARTS   AGE    IP              NODE              NOMINATED NODE   READINESS GATES
pod/app1-nginx-deploy-68f6b4f6dc-hpr59   1/1     Running   0          117s   10.244.101.73   computeplaneone   <none>           <none>
pod/app2-nginx-deploy-bb6b979c6-9vpf7    1/1     Running   0          117s   10.244.101.72   computeplaneone   <none>           <none>

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/app1-nginx   ClusterIP   10.104.202.13   <none>        80/TCP    77s   app=nginx-app1
service/app2-nginx   ClusterIP   10.99.177.186   <none>        80/TCP    77s   app=nginx-app2
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP   27m   <none>

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES   SELECTOR
deployment.apps/app1-nginx-deploy   1/1     1            1           117s   nginx        nginx    app=nginx-app1
deployment.apps/app2-nginx-deploy   1/1     1            1           117s   nginx        nginx    app=nginx-app2

NAME                                           DESIRED   CURRENT   READY   AGE    CONTAINERS   IMAGES   SELECTOR
replicaset.apps/app1-nginx-deploy-68f6b4f6dc   1         1         1       117s   nginx        nginx    app=nginx-app1,pod-template-hash=68f6b4f6dc
replicaset.apps/app2-nginx-deploy-bb6b979c6    1         1         1       117s   nginx        nginx    app=nginx-app2,pod-template-hash=bb6b979c6
root@controlplanenode:~/ingress#

root@controlplanenode:~/ingress# curl 10.104.202.13
<h1>Welcome to Sudheer Devops <font color=green>APP1</font></h1>
root@controlplanenode:~/ingress# curl 10.99.177.186
<h1>Welcome to Sudheer Devops <font color=blue>APP2</font></h1>
root@controlplanenode:~/ingress#

root@controlplanenode:~/ingress# kubectl get ing
NAME                    CLASS    HOSTS                                           ADDRESS   PORTS   AGE
sudheerdevops-ingress   <none>   app1.sudheerdevops.tld,app2.sudheerdevops.tld             80      58s
root@controlplanenode:~/ingress# kubectl describe ing sudheerdevops-ingress
Name:             sudheerdevops-ingress
Namespace:        default
Address:
Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)
Rules:
  Host                    Path  Backends
  ----                    ----  --------
  app1.sudheerdevops.tld
                          /   app1-nginx:80 (10.244.101.73:80)
  app2.sudheerdevops.tld
                          /   app2-nginx:80 (10.244.101.72:80)
Annotations:              <none>
Events:                   <none>
```


### Issues:
```
Error 1: Unable to reach domains through ingress controller, logs shows below errors in ingress-controller pod:
===
I0913 12:49:09.947910       9 event.go:282] Event(v1.ObjectReference{Kind:"Pod", Namespace:"ingress-nginx", Name:"ingress-nginx-controller-8cf5559f8-zrhdh", UID:"413cebfd-2fa4-4c9b-8b86-615992e74e82", APIVersion:"v1", ResourceVersion:"2212", FieldPath:""}): type: 'Normal' reason: 'RELOAD' NGINX reload triggered due to a change in configuration
I0913 13:03:09.589624       9 main.go:101] "successfully validated configuration, accepting" ingress="sudheerdevops-ingress/default"
**I0913 13:03:09.603754       9 store.go:361] "Ignoring ingress because of error while validating ingress class" ingress="default/sudheerdevops-ingress" error="ingress does not contain a valid IngressClass"**
I0913 13:40:56.671108       9 store.go:336] "Ignoring ingress because of error while validating ingress class" ingress="default/sudheerdevops-ingress" error="ingress does not contain a valid IngressClass"
I0913 13:40:56.828181       9 main.go:101] "successfully validated configuration, accepting" ingress="sudheerdevops-ingress/default"
I0913 13:40:56.863157       9 store.go:361] "Ignoring ingress because of error while validating ingress class" ingress="default/sudheerdevops-ingress" error="ingress does not contain a valid IngressClass"
===
Fix
===
apiVersion: networking.k8s.io/v1 #extensions/v1beta1
kind: Ingress
metadata:
  name: sudheerdevops-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /
===
root@controlplanenode:~/ingress# curl -k https://192.168.1.91:32350/app1
<h1>Welcome to Sudheer Devops <font color=green>APP1</font></h1>
root@controlplanenode:~/ingress# curl -k https://192.168.1.91:32350/app2
<h1>Welcome to Sudheer Devops <font color=blue>APP2</font></h1>
===
root@controlplanenode:~/ingress# kubectl describe ing
Name:             sudheerdevops-ingress
Namespace:        default
Address:          192.168.1.91
Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)
Rules:
  Host        Path  Backends
  ----        ----  --------
  *
              /app1   app1-nginx:80 (10.244.101.73:80)
              /app2   app2-nginx:80 (10.244.101.72:80)
Annotations:  kubernetes.io/ingress.class: nginx
              nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age                   From                      Message
  ----    ------  ----                  ----                      -------
  Normal  Sync    4m2s (x2 over 4m24s)  nginx-ingress-controller  Scheduled for sync
root@controlplanenode:~/ingress# kubectl get ing
NAME                    CLASS    HOSTS   ADDRESS        PORTS   AGE
sudheerdevops-ingress   <none>   *       192.168.1.91   80      4m35s
root@controlplanenode:~/ingress#

root@computeplaneone:~# curl -k --resolve app2.sudheerdevops.tld:32350:192.168.1.91 https://app2.sudheerdevops.tld:32350/app2
<h1>Welcome to Sudheer Devops <font color=blue>APP2</font></h1>
root@computeplaneone:~# curl -k --resolve app1.sudheerdevops.tld:32350:192.168.1.91 https://app1.sudheerdevops.tld:32350/app1
<h1>Welcome to Sudheer Devops <font color=green>APP1</font></h1>
root@computeplaneone:~#
```