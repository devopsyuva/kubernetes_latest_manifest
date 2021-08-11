# How to ensure my containers start at docker host boot time?
- Check below containers are stopped with Exitcode 0 after docker host was rebooted.
- Exit code 0 states that containers applications doesn't have any issue.
- **docker ps** command shows only running containers, to list all **docker ps -a**.
```
root@ubuntuserverdocker:~# docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED        STATUS                    PORTS     NAMES
59e642e725d9   ubuntu:20.04   "bash"                   12 hours ago   Exited (0) 12 hours ago             ubuntuserver
4a4d4c2d3820   nginx:latest   "/docker-entrypoint.…"   12 hours ago   Exited (0) 12 hours ago             nginxserver
root@ubuntuserverdocker:~#
```
- Now lets create a container with a parameter called **--restart** policy values as **always,never,on-failure**.
- **always** will ensure containers are started by docker for any sort of failure or after node was started.
- **never** it will not attempt to start container if container stopped due to node down or failure.
- **on-failure** if any containers was exited with code >0 docker will attempt to start the container.
```
#Lets create a container will always restart policy
root@ubuntuserverdocker:~# docker container run -d --name nginx --hostname webservernginx -p8090:80 --restart=always nginx:latest
e89877660d6eed3769160a3f697765bbddebf97e108fe50379ffaa70ab217f46
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
e89877660d6e   nginx:latest   "/docker-entrypoint.…"   5 seconds ago   Up 4 seconds   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx
root@ubuntuserverdocker:~#
```

## How can we add restart policy to a existing container, not new one?
- Yes, we can add few changes to existing containers like CPU, Memory, blkio and restart policy as well.
- We can not add like port farwarding etc., once the conatiners are created.
- We have to delete and recreate them with proper parameters.
```
root@ubuntuserverdocker:~# docker container run -d --name nginx --hostname webservernginx -p8090:80 nginx:latest    22ea673ad8a45f51855bac5683c43a7d65ad9078ed16a6ff5ef4666e3fc7270b
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
22ea673ad8a4   nginx:latest   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx
root@ubuntuserverdocker:~# docker container update nginx --restart always
nginx
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                   NAMES
22ea673ad8a4   nginx:latest   "/docker-entrypoint.…"   29 seconds ago   Up 28 seconds   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx
root@ubuntuserverdocker:~#
```

## How to cleanup all container in proper way by using loop?
```
root@ubuntuserverdocker:~# docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                    PORTS     NAMES
c1e3984ad65f   nginx:latest   "/docker-entrypoint.…"   7 minutes ago   Up About a minute         80/tcp    nginx
59e642e725d9   ubuntu:20.04   "bash"                   24 hours ago    Up About a minute                   ubuntuserver
4a4d4c2d3820   nginx:latest   "/docker-entrypoint.…"   24 hours ago    Exited (0) 23 hours ago             nginxserver
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker container ps -aq
c1e3984ad65f
59e642e725d9
4a4d4c2d3820
root@ubuntuserverdocker:~# for i in `docker container ps -aq`;do docker container stop $i;docker container rm $i;done
c1e3984ad65f
c1e3984ad65f
59e642e725d9
59e642e725d9
```