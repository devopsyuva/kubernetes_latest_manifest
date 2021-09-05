https://github.com/kubernetes-sigs/metrics-server

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml

Release: https://github.com/kubernetes-sigs/metrics-server/releases

Depending on your cluster configuration, you may also need to change flags passed to the Metrics Server container. Most useful flags:

--kubelet-preferred-address-types - The priority of node address types used when determining an address for connecting to a particular node (default [Hostname,InternalDNS,InternalIP,ExternalDNS,ExternalIP])
--kubelet-insecure-tls - Do not verify the CA of serving certificates presented by Kubelets. For testing purposes only.
--requestheader-client-ca-file - Specify a root certificate bundle for verifying client certificates on incoming requests before trusting usernames in headers specified by --requestheader-username-headers.
WARNING: Do not depend on prior authorization for incoming requests.


Testing load on HPA:

kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
kubectl run -it --rm load-generator --image=busybox /bin/sh
while true; do wget -q -O- http://php-apache; done