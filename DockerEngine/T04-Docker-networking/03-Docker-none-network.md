# Docker None Network
- For this container, disable all networking. Usually used in conjunction with a custom network driver. none is not available for swarm services.
- In this kind of network, containers are not attached to any network and do not have any access to the external network or other containers.
- This network is used when you want to completely disable the networking stack on a container and, only create a loopback device.
- ![None Network](https://i0.wp.com/monkelite.com/wp-content/uploads/2020/05/NoneNetwork.png?fit=836%2C507&ssl=1)

## How to create a container using none network?
```
root@ubuntuserverdocker:~# docker container run -d --name nginx-none --hostname nginxwebserver --network none nginx:latest
4fa6706f45811762217107014ad6f5f24b1c19aed6b856b8aea738594f9249b5
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
4fa6706f4581   nginx:latest   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds             nginx-none
root@ubuntuserverdocker:~#

#check IP address for container created above, we could see only localhost IP address 127.0.0.1
 "Networks": {
                "none": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "86213fd0e35f6f52ad4e3861beb7d0fe466e54933bb64b83682b21175fbf4cc9",
                    "EndpointID": "a3ff2fd26773bdf3061c11111e64dc3afc76acc156db9fa89ea1107d8a5fd8ce",
                    "Gateway": "",
                    "IPAddress": "",
                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "",
                    "DriverOpts": null
                }
            }

#Lets login to container and check the details more if we can connect to external network or not
root@ubuntuserverdocker:~# docker exec -ti nginx-none bash
root@nginxwebserver:/# cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
root@nginxwebserver:/# ping google.com
bash: ping: command not found
root@nginxwebserver:/# apt update
Err:1 http://security.debian.org/debian-security buster/updates InRelease
  Temporary failure resolving 'security.debian.org'
Err:2 http://deb.debian.org/debian buster InRelease
  Temporary failure resolving 'deb.debian.org'
Err:3 http://deb.debian.org/debian buster-updates InRelease
  Temporary failure resolving 'deb.debian.org'
Reading package lists... Done
Building dependency tree
Reading state information... Done
All packages are up to date.
W: Failed to fetch http://deb.debian.org/debian/dists/buster/InRelease  Temporary failure resolving 'deb.debian.org'
W: Failed to fetch http://security.debian.org/debian-security/dists/buster/updates/InRelease  Temporary failure resolving 'security.debian.org'
W: Failed to fetch http://deb.debian.org/debian/dists/buster-updates/InRelease  Temporary failure resolving 'deb.debian.org'
W: Some index files failed to download. They have been ignored, or old ones used instead.
root@nginxwebserver:/#
```

## Can we attach none network container to any bridge network in parallel?
```
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
4fa6706f4581   nginx:latest   "/docker-entrypoint.…"   4 minutes ago   Up 4 minutes             nginx-none
root@ubuntuserverdocker:~# docker network connect bridge nginx-none
Error response from daemon: container cannot be connected to multiple networks with one of the networks in private (none) mode
root@ubuntuserverdocker:~#
```
- It clearly state that containers launched on none network can't attach to another network instance in parallel.
- To solve the above issue, we have to detach from none network and attach to any bridge or host network as per our need.
```
root@ubuntuserverdocker:~# docker network disconnect none nginx-none
root@ubuntuserverdocker:~# docker network connect bridge nginx-none
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
4fa6706f4581   nginx:latest   "/docker-entrypoint.…"   7 minutes ago   Up 7 minutes   80/tcp    nginx-none
root@ubuntuserverdocker:~# docker container inspect nginx-none --format "{{.NetworkSettings.IPAddress}}"
172.17.0.2
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker exec -ti nginx-none bash
root@nginxwebserver:/# apt update
Get:1 http://security.debian.org/debian-security buster/updates InRelease [65.4 kB]
Get:2 http://deb.debian.org/debian buster InRelease [122 kB]
Get:3 http://deb.debian.org/debian buster-updates InRelease [51.9 kB]
Get:4 http://security.debian.org/debian-security buster/updates/main amd64 Packages [301 kB]
Get:5 http://deb.debian.org/debian buster/main amd64 Packages [7907 kB]
Get:6 http://deb.debian.org/debian buster-updates/main amd64 Packages [15.2 kB]
Fetched 8463 kB in 3s (2707 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
4 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@nginxwebserver:/# cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2      nginxwebserver
root@nginxwebserver:/#
```