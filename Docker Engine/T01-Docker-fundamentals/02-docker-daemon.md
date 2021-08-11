1) Run below command to check the status of docker server
```
#systemctl status docker
```

2) Run below command to stop/start docker service and check few docker CLI operations
```
#systemctl stop/start docker
#systemctl status docker
#docker ps
```

3) Default location for docker daemon service configration file
```
#vi /lib/systemd/system/docker.service
check for all parameters to make a note, go through the key-value under [Service] section
```

4) To verify the process that was listening for dockerd, execute below command
```
#ps aux | grep dockerd
```

5) To check binary location of dockerd, execute below command
```
root@ubuntuserverdocker:~# which dockerd
/usr/bin/dockerd
root@ubuntuserverdocker:~#
```

6) To verify the actual command, for which docker service will be running in the background
```
#/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```