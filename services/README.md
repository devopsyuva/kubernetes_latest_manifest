Service is way to communicate the backend PODs using Loadbalancer which is
inbuild functionality of kubernetes, insteed of using external loadbalancer

Different values supported for type in service spec:

ClusterIP(default), NodePort, LoadBalancer, EnternalName, ExternalIP, ClusterIP (None)

Supported Protocols:

TCP, UCP, HTTP, SCTP


Service can also be created in two ways:
Headless and Normal(clusterIP)

Default Kubernetes service type is clusterIP, When you create a headless
service by setting clusterIP None, no load-balancing is done and no cluster IP
is allocated for this service. Only DNS is automatically configured. When you
run a DNS query for headless service, you will get the list of the Pods IPs
and usually client dns chooses the first DNS record.

Example:
1)kubectl create deployment nginx --image=nginx
2)kubectl scale --replicas=3 deployment nginx
3)kubectl expose deployment nginx --name nginxheadless --cluster-ip=None
or for clusterIP
kubectl expose deployment nginx --name nginxclusterip --port=80  --target-port=80
4)kubectl run --generator=run-pod/v1 --rm utils -it --image arunvelsriram/utils bash

Service can be created without selector, but we have to manually create the
endpoints for the service as service without selector will not do that for us.

Service without selector:
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376

Endpoint for the above service:
apiVersion: v1
kind: Endpoints
metadata:
  name: my-service #This should match to the service name
subsets:
  - addresses:
      - ip: 192.0.2.42
    ports:
      - port: 9376



ClusterIP --> https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.1/images/networkimages/cluster-ip.png

NodePort
https://i0.wp.com/www.docker.com/blog/wp-content/uploads/2019/09/Kubernetes-NodePort-Service-2.png?resize=1069%2C678&ssl=1 
https://linuxacademy.com/site-content/uploads/2019/05/Screen-Shot-2019-04-17-at-10.58.43-AM-1024x769.png


