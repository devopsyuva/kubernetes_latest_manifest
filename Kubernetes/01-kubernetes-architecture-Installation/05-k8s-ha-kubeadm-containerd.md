# Kubernetes HA setup and configuration using **kubeadm** tool

### k8s Tools used
- kubeadm
- kubectl
- kubelet

### Controlplane loadbalancing using HAproxy
- AWS account (Free trail)
- 3 controlplanes have been used as part of HA setup using AWS EC2 service (Since I have less resource on local machine)

### Computeplane nodes to run Kubernetes workloads like PODs, ReplicationControllers, ReplicaSets, Deployments, DaemonSet, StatefulSet, Jobs, CronJobs and etc.,

### List of nodes used to setup Kubernetes HA
- 1 node for HAproxy
- 3 nodes for Controlplane
- 1 or more nodes for Computeplane (as per our need)

### OS and Pre-requisite
- Ubuntu 22.04 LTS (AMI for EC2)
- Disable swap memory, if enabled. Check with command #free -h
    - Temporary disable #swapoff -a. Permanent disable open #/etc/fstab file and comment swap line
- Min 15GiB Storage, 2 vCPU and 4 GiB RAM

## Common operations on all (except HAproxy node)
- Launch AWS EC2 Instance as private or public as per our need, I this demo we are using public IP address to login to instances and private IP address for cluster and loadbalancer communication
- login to controlplane and computeplane instances 
- update apt index and upgrade all the package on the system to latest version as per ubuntu repo using sudo or root user
    - sudo apt update
    - sudo apt upgrade -y
    - Optional: if kernel got upgraded, reboot the system using #init 6 or reboot command
        - To check kernel got upgraded or not, check if file exists "/var/run/reboot-required" (works only for Debian/Ubuntu OS) and run command to reboot if file exists or else skip

## Setup and configure HAproxy
- Launch AWS EC2 Instance as private or public as per our need, I this demo we are using public IP address to login to instances and private IP address for cluster and loadbalancer communication
- login to EC2 instance used for HAproxy setup and configuration
- update apt index and upgrade all the package on the system to latest version as per ubuntu repo using sudo or root user
    - sudo apt update
    - sudo apt upgrade -y
    - Optional: if kernel got upgraded, reboot the system using #init 6 or reboot command
        - To check kernel got upgraded or not, check if file exists "/var/run/reboot-required" (works only for Debian/Ubuntu OS) and run command to reboot if file exists or else skip
- Install HAproxy package on the system as mentioned below, this command will pull the package from Ubuntu repo
    - sudo apt install -y haproxy
- Now, update haproxy configuration file with frontend and backend server details of controlplane nodes
    - Open /etc/haproxyhaproxy.cfg and update below context, but replace IP address with the controlplane node IP addresses as per your network configuration
```
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

frontend kube-apiserver
        bind *:6443
        mode tcp
        option tcplog
        default_backend kube-apiserver

backend kube-apiserver
        mode tcp
        option tcplog
        option tcp-check
        balance roundrobin
        #default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 20 maxqueue 256 weight 100
        server kube-apiserver-1 172.16.0.4:6443 check
        server kube-apiserver-2 172.16.0.5:6443 check
        server kube-apiserver-3 172.16.0.6:6443 check        
```
- Finally enable and restart haproxy service to apply changes and to start service on boot
    - sudo systemctl enable haproxy
    - sudo systemctl restart haproxy
