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

## How to create user specific bridge network with specific CIDR?
- By default docker uses docker0 bridge network when you launch a container.
- If we try to create a bridge network without passing any "--subnet" CIDR value. docker will assign its own CIDR to user defined bridge network as mentioned below.
```
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
e2c88530b754   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
root@ubuntuserverdocker:~# docker network create sudheer
d3b0b997af6c143e80c11e7818feb76f043f71e28619b04200dabe3c4bcbbba3
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
e2c88530b754   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
d3b0b997af6c   sudheer   bridge    local
root@ubuntuserverdocker:~# docker network inspect sudheer --format "{{.IPAM.Config}}"
[{172.18.0.0/16  172.18.0.1 map[]}]
root@ubuntuserverdocker:~#
```
- Lets try to create a user-defined bridge network with CIDR "10.10.0.0/16".
```
root@ubuntuserverdocker:~# docker network create --subnet 10.10.0.0/16 --gateway 10.10.0.1 sudheer
bacdbbb0fe071e4fcce50dc85fb70c5cb39c50945d70466f6a310ab968cdb3e1
root@ubuntuserverdocker:~# docker network inspect sudheer --format "{{.IPAM.Config}}"
[{10.10.0.0/16  10.10.0.1 map[]}]
root@ubuntuserverdocker:~#

Note: Create with same name "sudheer", I have delete the old network before creaing with same name
```

## How to check if containers running on different network can communicate with each other?
- Lets try to launch a container name **source-bridge** using default docker0 bridge network.
```
root@ubuntuserverdocker:~# docker container run -d --name source-bridge nginx:latest
3170487babf7891a3bf2a0bf8b301e551bd30d846b847de05f309c1b1349fc80
root@ubuntuserverdocker:~# docker container inspect source-bridge --format "{{.NetworkSettings.IPAddress}}"
172.17.0.2
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
3170487babf7   nginx:latest   "/docker-entrypoint.…"   36 seconds ago   Up 35 seconds   80/tcp    source-bridge
root@ubuntuserverdocker:~#
```
- Now lets try to launch another container on user defined network.
```
root@ubuntuserverdocker:~# docker network inspect sudheer --format "{{.IPAM.Config}}"
[{10.10.0.0/16  10.10.0.1 map[]}]
root@ubuntuserverdocker:~# docker container run -d --name dest-sudheer --network sudheer nginx:latest
1a6f5627a2753d33bd2f7be1ec44dd18efaf6400f7242e2304a0843879dcef90
root@ubuntuserverdocker:~# docker container inspect dest-sudheer --format "{{.NetworkSettings.Networks.sudheer.IPAddress}}"
10.10.0.2
root@ubuntuserverdocker:~#
```
- Now lets check the connectivity between these containers sitting on different network.
```
# First login to source-bridge and install iproute2 and iputils-ping package using #apt update && apt install -y iproute2 iputils-ping
root@ubuntuserverdocker:~# docker exec -ti source-bridge bash
root@3170487babf7:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
root@3170487babf7:/# ping 10.10.0.2
PING 10.10.0.2 (10.10.0.2) 56(84) bytes of data.
^C
--- 10.10.0.2 ping statistics ---
6 packets transmitted, 0 received, 100% packet loss, time 125ms

root@3170487babf7:/# ping 10.10.0.1
PING 10.10.0.1 (10.10.0.1) 56(84) bytes of data.
64 bytes from 10.10.0.1: icmp_seq=1 ttl=64 time=0.068 ms
64 bytes from 10.10.0.1: icmp_seq=2 ttl=64 time=0.182 ms
64 bytes from 10.10.0.1: icmp_seq=3 ttl=64 time=0.100 ms
^C
--- 10.10.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 43ms
rtt min/avg/max/mdev = 0.068/0.116/0.182/0.049 ms
root@3170487babf7:/#

# we can see that you are able to reach to gateway of sudheer network but not to container IP 10.10.0.2
# Optional: check same by login to dest-sudheer conatiner and run ping 172.17.0.2 container "source-bridge"
```

## How to connect two containers running on different network using "connect" option?
- We can connect "source-bridge" container to network "sudheer" where "dest-sudheer" container was running.
```
root@3170487babf7:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
root@3170487babf7:/# exit
exit
root@ubuntuserverdocker:~# docker network connect sudheer source-bridge
root@ubuntuserverdocker:~# docker exec -ti source-bridge bash
root@3170487babf7:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
11: eth1@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:0a:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.10.0.3/16 brd 10.10.255.255 scope global eth1
       valid_lft forever preferred_lft forever
root@3170487babf7:/# ping 10.10.0.2
PING 10.10.0.2 (10.10.0.2) 56(84) bytes of data.
64 bytes from 10.10.0.2: icmp_seq=1 ttl=64 time=0.139 ms
64 bytes from 10.10.0.2: icmp_seq=2 ttl=64 time=0.179 ms
64 bytes from 10.10.0.2: icmp_seq=3 ttl=64 time=0.126 ms
^C
--- 10.10.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 26ms
rtt min/avg/max/mdev = 0.126/0.148/0.179/0.022 ms
root@3170487babf7:/#
```

## How to diconnect a container from specific network?
- Lets try to disconnect container "source-bridge" from docker0 bridge network.
```
root@ubuntuserverdocker:~# docker exec -ti source-bridge bash
root@3170487babf7:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
11: eth1@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:0a:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.10.0.3/16 brd 10.10.255.255 scope global eth1
       valid_lft forever preferred_lft forever
root@3170487babf7:/# exit
exit
root@ubuntuserverdocker:~# docker network disconnect bridge source-bridge
root@ubuntuserverdocker:~# docker exec -ti source-bridge bash
root@3170487babf7:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
11: eth1@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:0a:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.10.0.3/16 brd 10.10.255.255 scope global eth1
       valid_lft forever preferred_lft forever
root@3170487babf7:/# ping 10.10.0.2
PING 10.10.0.2 (10.10.0.2) 56(84) bytes of data.
64 bytes from 10.10.0.2: icmp_seq=1 ttl=64 time=0.067 ms
64 bytes from 10.10.0.2: icmp_seq=2 ttl=64 time=0.099 ms
64 bytes from 10.10.0.2: icmp_seq=3 ttl=64 time=0.122 ms
^C
--- 10.10.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 33ms
rtt min/avg/max/mdev = 0.067/0.096/0.122/0.022 ms
root@3170487babf7:/#
```

## How to connect containers on different network to communicate without using "docker network connect"?
- Earlier we use to conect two containers on different network using #docker network connect option
- But now without using that, how we can achieve this by manipulating the **iptables**.
```
root@ubuntuserverdocker:~# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
29df8af1adf1   bridge    bridge    local
83779fc34e8c   host      host      local
86213fd0e35f   none      null      local
c714511f2001   sudhams   bridge    local
f77494679518   sudheer   bridge    local
root@ubuntuserverdocker:~# docker container run -d --name sudheer-bridge --network sudheer nginx:latest
81709b74d86cd8866be33291b04dc00897be4be680156676d433ef1a44ab4b20
root@ubuntuserverdocker:~# docker container run -d --name sudhams-bridge --network sudhams nginx:latest
8e26be20c1444ee08065ce092df4061e863be27691c2666f8abca1b7990dbde0
root@ubuntuserverdocker:~# docker exec -ti sudheer-bridge bash
root@81709b74d86c:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
14: eth0@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:0a:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.10.0.2/16 brd 10.10.255.255 scope global eth0
       valid_lft forever preferred_lft forever
root@81709b74d86c:/#
root@81709b74d86c:/# ping 10.20.0.2
PING 10.20.0.2 (10.20.0.2) 56(84) bytes of data.
^C
--- 10.20.0.2 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 35ms

root@81709b74d86c:/# ping 10.20.0.1
PING 10.20.0.1 (10.20.0.1) 56(84) bytes of data.
64 bytes from 10.20.0.1: icmp_seq=1 ttl=64 time=0.058 ms
64 bytes from 10.20.0.1: icmp_seq=2 ttl=64 time=0.147 ms
^C
--- 10.20.0.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 0.058/0.102/0.147/0.045 ms
root@81709b74d86c:/#
```
- Now lets slove the issue to connect containers launched on sudheer network to communicate with sudhams network using **iptabels**.
- First find the interfaces names of sudheer and sudhams.
- sudheer bridge --> br-f77494679518 and sudhams --> br-c714511f2001, check using #ip a command on docker host machine
```
root@ubuntuserverdocker:~# iptables -I DOCKER-USER -i br-f77494679518 -o br-c714511f2001 -s 10.10.0.2 -d 10.20.0.2 -j ACCEPT
root@ubuntuserverdocker:~# iptables -I DOCKER-USER -i br-c714511f2001 -o br-f77494679518 -s 10.20.0.2 -d 10.10.0.2 -j ACCEPT
root@ubuntuserverdocker:~#

# Lets check the connectivity now
root@ubuntuserverdocker:~# docker exec -ti sudheer-bridge bash
root@81709b74d86c:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
14: eth0@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:0a:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.10.0.2/16 brd 10.10.255.255 scope global eth0
       valid_lft forever preferred_lft forever
root@81709b74d86c:/# ping 10.20.0.2
PING 10.20.0.2 (10.20.0.2) 56(84) bytes of data.
64 bytes from 10.20.0.2: icmp_seq=1 ttl=63 time=0.124 ms
64 bytes from 10.20.0.2: icmp_seq=2 ttl=63 time=0.169 ms
^C
--- 10.20.0.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 24ms
rtt min/avg/max/mdev = 0.124/0.146/0.169/0.025 ms
root@81709b74d86c:/# exit
exit
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker exec -ti sudhams-bridge bash
root@8e26be20c144:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
16: eth0@if17: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:14:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.20.0.2/16 brd 10.20.255.255 scope global eth0
       valid_lft forever preferred_lft forever
root@8e26be20c144:/# ping 10.10.0.2
PING 10.10.0.2 (10.10.0.2) 56(84) bytes of data.
64 bytes from 10.10.0.2: icmp_seq=1 ttl=63 time=0.053 ms
64 bytes from 10.10.0.2: icmp_seq=2 ttl=63 time=0.155 ms
64 bytes from 10.10.0.2: icmp_seq=3 ttl=63 time=0.265 ms

--- 10.10.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 6ms
rtt min/avg/max/mdev = 0.053/0.157/0.265/0.087 ms
root@8e26be20c144:/#
```

### Note:
- iptables -t filter -vL -> TODO