## How to create a sample nginx webapp containers?
- we will use existing image available in **Docker Hub** repository.
```
#Container was created wuth name "nginx" and hostname was set to "webservernginx" with image "nginx:latest"
root@ubuntuserverdocker:~# docker container run -d --name nginx --hostname webservernginx nginx:latest
70fc126266bf509eebfb2cdddd4bb946951f8ce7dcd5a867d6216b2f70341be0
root@ubuntuserverdocker:~#

#check running containers
root@ubuntuserverdocker:~# docker container ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
70fc126266bf   nginx:latest   "/docker-entrypoint.…"   18 seconds ago   Up 13 seconds   80/tcp    nginx
root@ubuntuserverdocker:~#

Note: By default "latest" tag will be added if you do not specify it
```

## How to access application nginx created above to ensure its working?
- Check the IP address applocated to container using below shortcut command or **docker container inspect nginx**
```
root@ubuntuserverdocker:~# docker container inspect nginx --format "{{.NetworkSettings.IPAddress}}"
172.17.0.2
root@ubuntuserverdocker:~#

or 

root@ubuntuserverdocker:~# docker container inspect nginx
[
    {
        "Id": "70fc126266bf509eebfb2cdddd4bb946951f8ce7dcd5a867d6216b2f70341be0",
        "Created": "2021-08-10T13:47:37.976069828Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
...
...
```

## How to expose a container outside docker host machine or with docker host IP address?
- All containers by default will be getting a Private IP address.
- Containers will get IP address from docker0 bridge network as default.
- Default CIDR for docker0 interface is "172.17.0.1/16"
- We need to bind/portfarwarding on docker host machine to container port (-p8090:80).
- From above "8090" port will be opened on docker host and 80 port inside container.
```
root@ubuntuserverdocker:~# ip addr show docker0
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:93:1d:96:d2 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:93ff:fe1d:96d2/64 scope link
       valid_lft forever preferred_lft forever
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker container stop nginx
nginx
root@ubuntuserverdocker:~# docker container rm nginx
nginx
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker container run -d --name nginx --hostname webservernginx -p8090:80 nginx:latest
4f1ce1199ec6d1026fd78bcb5d5f88bc6427ad35876cc4289963e06ec91a81f0
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
4f1ce1199ec6   nginx:latest   "/docker-entrypoint.…"   6 seconds ago   Up 4 seconds   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx
root@ubuntuserverdocker:~#
```

## How to access container application after port farwarding?
- Check docker host IP address.
- Go to browser and access Example http://192.168.0.50:8090
```
root@ubuntuserverdocker:~# ip addr show enp0s3
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:27:1c:42 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.50/24 brd 192.168.0.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe27:1c42/64 scope link
       valid_lft forever preferred_lft forever
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# curl -I 192.168.0.50:8090
HTTP/1.1 200 OK
Server: nginx/1.21.1
Date: Tue, 10 Aug 2021 14:01:29 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 06 Jul 2021 14:59:17 GMT
Connection: keep-alive
ETag: "60e46fc5-264"
Accept-Ranges: bytes

root@ubuntuserverdocker:~#

We can see nginx default page as mentioned below
root@ubuntuserverdocker:~# curl 192.168.0.50:8090
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
root@ubuntuserverdocker:~#
```

## How to cleanup running containers in proper way?
- stop the running container and then remove it.
- we can remove running containers forefully, but **not recommended as best practice**.
```
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
4f1ce1199ec6   nginx:latest   "/docker-entrypoint.…"   5 minutes ago   Up 5 minutes   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx
root@ubuntuserverdocker:~# docker container stop nginx
nginx
root@ubuntuserverdocker:~# docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                     PORTS     NAMES
4f1ce1199ec6   nginx:latest   "/docker-entrypoint.…"   5 minutes ago   Exited (0) 2 seconds ago             nginx
59e642e725d9   ubuntu:20.04   "bash"                   12 hours ago    Exited (0) 12 hours ago              ubuntuserver
4a4d4c2d3820   nginx:latest   "/docker-entrypoint.…"   12 hours ago    Exited (0) 12 hours ago              nginxserver
root@ubuntuserverdocker:~# docker container rm nginx
nginx
root@ubuntuserverdocker:~# docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED        STATUS                    PORTS     NAMES
59e642e725d9   ubuntu:20.04   "bash"                   12 hours ago   Exited (0) 12 hours ago             ubuntuserver
4a4d4c2d3820   nginx:latest   "/docker-entrypoint.…"   12 hours ago   Exited (0) 12 hours ago             nginxserver
root@ubuntuserverdocker:~#
```