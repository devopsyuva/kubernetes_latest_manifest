# Docker Containers Backup and Restore as Images
- We can backup container(Running or Stopped) with some application running in it.

## Backup
```
root@ubuntuserverdocker:~# docker container run -d -ti --name nginx-ubuntu --hostname nginxwebserver -p8090:80 ubuntu:20.04
1f5619a23c7fe4faf89fc79b62d4521c7e6f473e8b8b304010aa91576f0ed0e9
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND   CREATED         STATUS         PORTS                                   NAMES
1f5619a23c7f   ubuntu:20.04   "bash"    2 seconds ago   Up 2 seconds   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx-ubuntu
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker exec -ti nginx-ubuntu bash

#Lets install nginx application on ubuntu container before taking backup
root@nginxwebserver:/# apt update && apt install -y nginx iproute2 curl
..
..
Setting up nginx (1.18.0-0ubuntu1.2) ...
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
root@nginxwebserver:/#

# Now start nginx service running in background
root@nginxwebserver:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   4108  3480 pts/0    Ss+  15:04   0:00 bash
root           9  0.0  0.0   4108  3624 pts/1    Ss   15:04   0:00 bash
root         800  0.0  0.0   5896  2988 pts/1    R+   15:06   0:00 ps aux
root@nginxwebserver:/# nginx -g "daemon off;" &
[1] 801
root@nginxwebserver:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   4108  3480 pts/0    Ss+  15:04   0:00 bash
root           9  0.0  0.0   4108  3624 pts/1    Ss   15:04   0:00 bash
root         801  1.0  0.1  55280 11544 pts/1    S    15:06   0:00 nginx: master process nginx -g daemon off;
www-data     802  0.0  0.0  55604  3260 pts/1    S    15:06   0:00 nginx: worker process
root         803  0.0  0.0   5896  3072 pts/1    R+   15:06   0:00 ps aux
root@nginxwebserver:/#
root@nginxwebserver:/# curl -I localhost
HTTP/1.1 200 OK
root@nginxwebserver:/#

#Exit from the container and take backup as mentioned below
root@nginxwebserver:/# exit
exit
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND   CREATED         STATUS         PORTS                                   NAMES
1f5619a23c7f   ubuntu:20.04   "bash"    4 minutes ago   Up 4 minutes   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx-ubuntu
root@ubuntuserverdocker:~# docker container export --help

Usage:  docker container export [OPTIONS] CONTAINER

Export a container's filesystem as a tar archive

Options:
  -o, --output string   Write to a file, instead of STDOUT
root@ubuntuserverdocker:~# docker container export -o ubuntu-nginx.tar.gz nginx-ubuntu
root@ubuntuserverdocker:~# ls -lh ubuntu-nginx.tar.gz
-rw------- 1 root root 169M Aug 28 09:39 ubuntu-nginx.tar.gz
root@ubuntuserverdocker:~#
```

## Restore container backup as Image
- The backup of a container restore doesn't create a container. It creates an Image.
```
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND   CREATED         STATUS         PORTS                                   NAMES
1f5619a23c7f   ubuntu:20.04   "bash"    7 minutes ago   Up 7 minutes   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx-ubuntu
root@ubuntuserverdocker:~# docker image ls
REPOSITORY        TAG         IMAGE ID       CREATED       SIZE
jenkins/jenkins   lts-jdk11   619aabbe0502   2 days ago    441MB
nginx             latest      dd34e67e3371   10 days ago   133MB
mysql             5.7         6c20ffa54f86   10 days ago   448MB
ubuntu            20.04       1318b700e415   4 weeks ago   72.8MB
root@ubuntuserverdocker:~# docker image import --help

Usage:  docker image import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]

Import the contents from a tarball to create a filesystem image

Options:
  -c, --change list       Apply Dockerfile instruction to the created image
  -m, --message string    Set commit message for imported image
      --platform string   Set platform if server is multi-platform capable
root@ubuntuserverdocker:~# docker image import -c 'CMD ["nginx", "-g", "daemon off;"]' -m "Image creation from Container Backup" ubuntu-nginx.tar.gz dubareddy/ubuntu-nginx:latest
sha256:11d44127ba39f018b9e20aa0ddf6a986c62a8fede73e1ab8d1abf6e412e77f28
root@ubuntuserverdocker:~# docker image ls
REPOSITORY               TAG         IMAGE ID       CREATED         SIZE
dubareddy/ubuntu-nginx   latest      11d44127ba39   4 seconds ago   172MB
jenkins/jenkins          lts-jdk11   619aabbe0502   2 days ago      441MB
nginx                    latest      dd34e67e3371   10 days ago     133MB
mysql                    5.7         6c20ffa54f86   10 days ago     448MB
ubuntu                   20.04       1318b700e415   4 weeks ago     72.8MB
root@ubuntuserverdocker:~#
```
- Lets create a container usinge Image "dubareddy/ubuntu-nginx:latest".
```
root@ubuntuserverdocker:~# docker container run -d --name nginx-backup dubareddy/ubuntu-nginx:latest
c98306a168b2fc65aa2796b9c0334e02fe72370e753c471ab22440c17103c471
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                                   NAMES
c98306a168b2   dubareddy/ubuntu-nginx:latest   "nginx -g 'daemon of…"   3 seconds ago    Up 2 seconds                                            nginx-backup
1f5619a23c7f   ubuntu:20.04                    "bash"                   11 minutes ago   Up 11 minutes   0.0.0.0:8090->80/tcp, :::8090->80/tcp   nginx-ubuntu
root@ubuntuserverdocker:~#

#From above we can understand that options which are passing while creating container before taking a backup will not get stored in backup.
#These options are specific to container and can't be stored. So every containers need these options as per application.

root@ubuntuserverdocker:~# curl 172.17.0.3
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```