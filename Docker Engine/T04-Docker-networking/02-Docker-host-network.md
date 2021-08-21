# Docker host network
- Docker container’s network stack is not isolated from the Docker host (the container shares the host’s networking namespace), and the container does not get its own IP-address allocated.
- If containers needs to be exposed using network namespace what docker host will be using, then containers can be launched using host network.
- In general, containers will have separate namespace for network as well by default for bridge.
- We have to ensure, why we need to give containers a host network before creating it.
- Not all application in a containers need host network namespace.
- Some application might open dynamic port numbers which needs external access to clients. Those application can't use port forwarding.
- Port farwarding works well for static ports not for dynamic ports.
- Host mode networking can be useful to optimize performance, and in situations where a container needs to handle a large range of ports, as it does not require network address translation (NAT), and no “userland-proxy” is created for each port.

### Note
- The host networking driver only works on Linux hosts, and is not supported on Docker Desktop for Mac, Docker Desktop for Windows, or Docker EE for Windows Server.

## How to create a containers with host network?
- Host network is created by default when docker installed.
```
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
e2c88530b754   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
root@ubuntuserverdocker:~# docker container run -d --name nginx-host --network host nginx:latest
e3b7afebd41d779e72cb9870beab395e6e5a4d14f8153fcabe11b3bc0e97589e

#Now lets login to container and check network interfaces details and hostname which looks as docker host machine. For that we have to install #iproute2 and iputils-ping package.
root@ubuntuserverdocker:~# docker exec -ti nginx-host bash
root@ubuntuserverdocker:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:27:1c:42 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.50/24 brd 192.168.1.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe27:1c42/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:1e:ff:2b:ce brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:1eff:feff:2bce/64 scope link
       valid_lft forever preferred_lft forever
root@ubuntuserverdocker:/#

#check same on your docker host machine and access nginx application running inside container "nginx-host" in browser http://docker-host-ip
root@ubuntuserverdocker:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:27:1c:42 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.50/24 brd 192.168.1.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe27:1c42/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:1e:ff:2b:ce brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:1eff:feff:2bce/64 scope link
       valid_lft forever preferred_lft forever
root@ubuntuserverdocker:~# curl -I 192.168.1.50
HTTP/1.1 200 OK
Server: nginx/1.21.1
Date: Mon, 16 Aug 2021 09:49:39 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 06 Jul 2021 14:59:17 GMT
Connection: keep-alive
ETag: "60e46fc5-264"
Accept-Ranges: bytes

#it works and no need to do any port forwarding.
```

## Can we create additional host network on Docker apart from default "host" network?
- By Default docker creates a host network stack which is used by default while creating container **--network host**.
- Docker doesn't allow to create additional host network stack as mentioned below.
```
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
a491b8f52b67   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
root@ubuntuserverdocker:~# docker network create -d host sudheer
Error response from daemon: only one instance of "host" network is allowed
root@ubuntuserverdocker:~#
```

### References
- [Host Network](https://docs.docker.com/network/host/)