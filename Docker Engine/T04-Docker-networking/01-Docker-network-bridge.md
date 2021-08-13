# Docker Bridge Network
- By default, when docker engine was installed docker0 default network will be created.
- Docker created below list network types, which doesn't allow to delete.
```
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
804dbb1cb0fe   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
root@ubuntuserverdocker:~#
```

## What will be default network assigned by docker?
- docker0 was default bridge network which will be used by docker if no options are passed related to network.
```
root@ubuntuserverdocker:~# docker container run -d --name jenkins --hostname cicdserverjenkins -p8090:8080 jenkins/jenkins:lts

#Now check the IP address assigned to jenkins container
root@ubuntuserverdocker:~# docker container inspect jenkins --format "{{.NetworkSettings.IPAddress}}"
172.17.0.2
root@ubuntuserverdocker:~#
```
- From above output, we could see that IP address "172.17.0.2" was assigned from default bridge network **docker0**.
- Let check subnet allocated for **docker0** bridge:
```
root@ubuntuserverdocker:~# docker network inspect bridge --format "{{.IPAM.Config}}"
[{172.17.0.0/16  172.17.0.1 map[]}]
root@ubuntuserverdocker:~#
```
- We can also see this CIDR of docker0 interface on docker host machine as well.
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
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:6f:0c:f5:dc brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:6fff:fe0c:f5dc/64 scope link
       valid_lft forever preferred_lft forever
```

## How create a user-defined bridge network with a CIDR "10.10.0.0/16"?
- We can create a user-defined bridge network without subnet as well.
- By default docker will use a CIDR series as "172.18.0.0/16, 172.19.0.0/16 etc.,"
- But we are creating a bridge with our own CIDR value "10.10.0.0/16".
```
root@ubuntuserverdocker:~# docker network create --subnet 10.10.0.0/16 --gateway 10.10.0.1 sudheer
56079a923e63c7f7ea02dded758cd0d17422c7d0403af8b8546a47ca7ed03e9c
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
804dbb1cb0fe   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
56079a923e63   sudheer   bridge    local
root@ubuntuserverdocker:~# docker network inspect sudheer --format "{{.IPAM.Config}}"
[{10.10.0.0/16  10.10.0.1 map[]}]

#we can check on docker host machine as well
root@ubuntuserverdocker:~# ip addr show br-56079a923e63
6: br-56079a923e63: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:c7:7e:d0:94 brd ff:ff:ff:ff:ff:ff
    inet 10.10.0.1/16 brd 10.10.255.255 scope global br-56079a923e63
       valid_lft forever preferred_lft forever
root@ubuntuserverdocker:~#
```