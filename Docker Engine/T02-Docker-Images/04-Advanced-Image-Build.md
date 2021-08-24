# Build Image from Scratch
- Execute below command on ubuntu 20.04 LTS sever VM to create a Docker image with ubuntu 20.04 version as mentioned below using debootstrap tool.
```
root@ubuntuserverdocker:~#  apt-get install debootstrap
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  arch-test squid-deb-proxy-client
The following NEW packages will be installed:
  debootstrap
0 upgraded, 1 newly installed, 0 to remove and 17 not upgraded.
Need to get 39.3 kB of archives.
After this operation, 301 kB of additional disk space will be used.
Get:1 http://in.archive.ubuntu.com/ubuntu focal-updates/main amd64 debootstrap all 1.0.118ubuntu1.4 [39.3 kB]
Fetched 39.3 kB in 0s (108 kB/s)
Selecting previously unselected package debootstrap.
(Reading database ... 82108 files and directories currently installed.)
Preparing to unpack .../debootstrap_1.0.118ubuntu1.4_all.deb ...
Unpacking debootstrap (1.0.118ubuntu1.4) ...
Setting up debootstrap (1.0.118ubuntu1.4) ...
Processing triggers for man-db (2.9.1-1) ...
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# sudo debootstrap focal focal > /dev/null
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# ls -lrt
total 1352476
-rw-r--r--  1 root root   32406882 Jul 21 18:49 terraform_1.0.3_linux_amd64.zip
drwxr-xr-x  3 root root       4096 Aug  2 02:05 snap
drwxr-xr-x  7 root root       4096 Aug  8 08:52 aws-terraform
-rw-r--r--  1 root root       1252 Aug 18 02:16 backup-mysql.sql
-rw-------  1 root root 1175425024 Aug 19 01:39 images-backup.tar.gz
-rw-------  1 root root  177077760 Aug 19 02:03 nginx-ubuntu-baqckup.tar.gz
drwxr-xr-x  5 root root       4096 Aug 24 14:21 image-dockerfiles
drwxr-xr-x 17 root root       4096 Aug 24 14:58 focal
root@ubuntuserverdocker:~# ls -lrt focal/
total 60
drwxr-xr-x  2 root root 4096 Apr 15  2020 sys
drwxr-xr-x  2 root root 4096 Apr 15  2020 proc
drwxr-xr-x  2 root root 4096 Apr 15  2020 home
drwxr-xr-x  2 root root 4096 Apr 15  2020 boot
lrwxrwxrwx  1 root root    7 Aug 24 14:55 bin -> usr/bin
lrwxrwxrwx  1 root root    8 Aug 24 14:55 sbin -> usr/sbin
lrwxrwxrwx  1 root root    7 Aug 24 14:55 lib -> usr/lib
lrwxrwxrwx  1 root root    9 Aug 24 14:55 lib32 -> usr/lib32
lrwxrwxrwx  1 root root    9 Aug 24 14:55 lib64 -> usr/lib64
lrwxrwxrwx  1 root root   10 Aug 24 14:55 libx32 -> usr/libx32
drwxr-xr-x  4 root root 4096 Aug 24 14:55 dev
drwx------  2 root root 4096 Aug 24 14:55 root
drwxr-xr-x  2 root root 4096 Aug 24 14:55 mnt
drwxr-xr-x  2 root root 4096 Aug 24 14:55 srv
drwxr-xr-x  2 root root 4096 Aug 24 14:55 opt
drwxr-xr-x  2 root root 4096 Aug 24 14:55 media
drwxr-xr-x 11 root root 4096 Aug 24 14:55 var
drwxr-xr-x 13 root root 4096 Aug 24 14:55 usr
drwxr-xr-x  8 root root 4096 Aug 24 14:58 run
drwxr-xr-x 59 root root 4096 Aug 24 14:58 etc
drwxrwxrwt  2 root root 4096 Aug 24 14:58 tmp

root@ubuntuserverdocker:~# sudo tar -C focal -c . | docker import - focal
sha256:7044c5ad7a5c15a7f1694c748465856f25eeef9d3362bb87350ae525cd1e4955
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker image ls
REPOSITORY               TAG       IMAGE ID       CREATED              SIZE
focal                    latest    7044c5ad7a5c   About a minute ago   322MB

root@ubuntuserverdocker:~# docker run focal cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04 LTS"
root@ubuntuserverdocker:~#
```

## Consider the following best practices when rebuilding an image:
```
 docker build --no-cache -t repo/image:tag
```
- Each container should have only one responsibility.
- Containers should be immutable, lightweight, and fast.
- Don’t store data in your container. Use a shared data store instead.
- Containers should be easy to destroy and rebuild.
- Use a small base image (such as Linux Alpine). Smaller images are easier to distribute.
- Avoid installing unnecessary packages. This keeps the image clean and safe.
- Avoid cache hits when building.
- Auto-scan your image before deploying to avoid pushing vulnerable containers to production.
- Scan your images daily both during development and production for vulnerabilities Based on that, automate the rebuild of images if necessary.

### References:
- [Image Build Scratch](https://docs.docker.com/develop/develop-images/baseimages/)