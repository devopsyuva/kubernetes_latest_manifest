## Docker root directory location
```
root@ubuntuserverdocker:~# docker info | grep "Docker Root Dir"
 Docker Root Dir: /var/lib/docker
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# ls -l /var/lib/docker/
total 44
drwx--x--x 4 root root 4096 Aug  3 01:52 buildkit
drwx-----x 2 root root 4096 Aug  3 01:52 containers
drwx------ 3 root root 4096 Aug  3 01:52 image
drwxr-x--- 3 root root 4096 Aug  3 01:52 network
drwx-----x 3 root root 4096 Aug  6 12:03 overlay2
drwx------ 4 root root 4096 Aug  3 01:52 plugins
drwx------ 2 root root 4096 Aug  6 12:03 runtimes
drwx------ 2 root root 4096 Aug  3 01:52 swarm
drwx------ 2 root root 4096 Aug  6 12:03 tmp
drwx------ 2 root root 4096 Aug  3 01:52 trust
drwx-----x 2 root root 4096 Aug  6 12:03 volumes
root@ubuntuserverdocker:~#
```

## How to check docker information like total images, no of containers Running,Stopped etc.,
```
root@ubuntuserverdocker:~# docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Build with BuildKit (Docker Inc., v0.5.1-docker)
  scan: Docker Scan (Docker Inc., v0.8.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.7
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: e25210fe30a0a703442421b0f60afac609f950a3
 runc version: v1.0.1-0-g4144b63
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: default
 Kernel Version: 5.4.0-80-generic
 Operating System: Ubuntu 20.04.2 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 1
 Total Memory: 5.843GiB
 Name: ubuntuserverdocker
 ID: FKIJ:6C6T:K73D:UP24:FBNS:QZGY:YYJB:4Q23:IIVX:GTCK:ISKX:LRZ5
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false

WARNING: No swap limit support
root@ubuntuserverdocker:~#
```

## Docker default networks
```
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
610426a38d7d   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
root@ubuntuserverdocker:~#
```

## Below command shows that "docker0" was default bridge network used by containers launched on docker host:
```
root@ubuntuserverdocker:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:27:1c:42 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.50/24 brd 192.168.0.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe27:1c42/64 scope link
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:ac:69:1d:f3 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
root@ubuntuserverdocker:~#
```

## Docker default "Storage Driver" on Linux machines:
```
root@ubuntuserverdocker:~# docker info | grep "Storage Driver"
 Storage Driver: overlay2
root@ubuntuserverdocker:~#
```