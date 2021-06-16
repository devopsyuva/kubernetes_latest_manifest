key points:
===========

liveness probes:

1) kubelet uses liveness probes to know when to restart a container.
2) liveness probes could catch a deadlock, where an application is running, but unable to make progress. So restart a container will fix the issue.

Readiness probes:

1) kubelet uses readiness probes to know when a container is ready to start accepting traffic.
2) A Pod is considered ready when all of its containers are ready. One use of this signal is to control which Pods are used as backends for Services. When a Pod is not ready, it is removed from Service load balancers.

Startup probes:

1) The kubelet uses startup probes to know when a container application has started.
2) Enabling start probe, disables liveness and readiness checks until it succeeds, making sure those probes don't interfere with the application startup.

Pod lifecycle:
==============

The kubelet uses liveness probes to know when to restart a Container.
For example, liveness probes could catch a deadlock, where an application
is running, but unable to make progress. Restarting a Container in such a
state can help to make the application more available despite bugs.

The kubelet uses readiness probes to know when a Container is ready to
start accepting traffic. A Pod is considered ready when all of its Containers
are ready. One use of this signal is to control which Pods are used as backends
for Services. When a Pod is not ready, it is removed from Service load balancers.


Types of Probes supported:
==========================
exec
http
tcp

exec:

We can create a pod with exec (example: liveness-probes.yaml) enabled and it
checks for the action to be performed. In the example, it will execute
command to see if returns 0 exit status. if it is non-zero exit status,
kubelet will kill the container and restarts it.

http:

we use http probes to check the http GET request. For example, kubelet sends
a http GET request to the server that is running in the container and
listening on 8080. If the request returns success code (200 ok/300) then
container is live and healthy. if any other code response is triggered like
40x and 50x is considered as failure and container will be killed and restarted

tcp:

TCP socket probe, this is used to check the ports are listening or not.
kubelet will attempt to open a socket to your container on the specified port.
If it can establish a connection, the container is considered healthy, if it
can’t it is considered a failure.

named port:
ports:
- name: liveness-port
  containerPort: 8080
  hostPort: 8080

livenessProbe:
  httpGet:
    path: /healthz
    port: liveness-port

Startup probes:
===============
we have to deal with legacy applications that might require an additional
startup time on their first initialization. In such cases, it can be tricky
to setup liveness probe parameters without compromising the fast response to
deadlocks that motivated such a probe. The trick is to setup a startup probe
with the same command, HTTP or TCP check, with a failureThreshold * periodSeconds
long enough to cover the worse case startup time.

ports:
- name: liveness-port
  containerPort: 8080
  hostPort: 8080

livenessProbe:
  httpGet:
    path: /healthz
    port: liveness-port
  failureThreshold: 1
  periodSeconds: 10

startupProbe:
  httpGet:
    path: /healthz
    port: liveness-port
  failureThreshold: 30
  periodSeconds: 10

the application will have a maximum of 5 minutes (30 * 10 = 300s) to finish its startup.
Once the startup probe has succeeded once, the liveness probe takes over to provide a fast
response to container deadlocks. If the startup probe never succeeds, the container is killed
after 300s and subject to the pod’s restartPolicy.

Readiness Probes:
================
Sometimes, applications are temporarily unable to serve traffic. For example, an application
might need to load large data or configuration files during startup, or depend on external
services after startup. In such cases, you don’t want to kill the application, but you don’t
want to send it requests either. Kubernetes provides readiness probes to detect and mitigate
these situations. A pod with containers reporting that they are not ready does not receive
traffic through Kubernetes Services

readinessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5

We cause the unhealthy status by executing the below command for senario1:
pod=$(kubectl get pods --selector="name=frontend" --output=jsonpath={.items..metadata.name})
kubectl exec $pod -- /usr/bin/curl -s localhost/unhealthy


key threshold values:

1) initialDelaySeconds:

Number of seconds after the container has started before liveness or readiness probes are initiated. Defaults to 0 seconds. Minimum value is 0.

2) periodSeconds:

How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.

3) timeoutSeconds:

Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1.

4) successThreshold:

Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness. Minimum value is 1.

5) failureThreshold:

When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. Defaults to 3. Minimum value is 1.



References:
https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/


