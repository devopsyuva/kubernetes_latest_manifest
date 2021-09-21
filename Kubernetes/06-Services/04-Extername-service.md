# Service of type: ExternalName
- Services with type ExternalName work as other regular services, but when you want to access to that service name, instead of returning cluster-ip of this service, it returns CNAME record with value that mentioned in "externalName: "parameter of service.

- As example mentioned in Kubernetes Documentation:
```
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  type: ExternalName
  externalName: sudheerdevops.com
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80

#kubectl run --generator=run-pod/v1 --rm utils -it --image dubareddy/utils bash
```
- When you want to do curl -v http://my-service or curl -v http://my-service.default.svc.cluster.local according your namespace(in this example it is default), it will redirect you at the external DNS name to http://sudheerdevops.com
```
root@controlplanenode:~# kubectl get svc
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP            PORT(S)                          AGE
jenkins-service   NodePort       10.109.116.82   <none>                 8080:31774/TCP,50000:31360/TCP   20d
kubernetes        ClusterIP      10.96.0.1       <none>                 443/TCP                          20d
my-service        ExternalName   <none>          sudheerdevops.com      80/TCP                           4s
root@controlplanenode:~#
root@controlplanenode:~# kubectl run --rm -ti test-utils --image=dubareddy/utils -- bash
If you don't see a command prompt, try pressing enter.
root@test-utils:/# 
root@test-utils:/# nslookup my-service
Server:         10.96.0.10
Address:        10.96.0.10#53
my-service.default.svc.cluster.local    canonical name = sudheerdevops.com.

root@test-utils:/# exit
```