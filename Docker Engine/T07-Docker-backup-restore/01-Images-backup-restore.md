# Docker Image Backup and Restore
- There could be a change where users/client/developer needs to backup images in centralized location.
- Restore those backup as needed, instead of building from scratch.

## Backup Images
```
# These are following Images present on Docker Host
root@ubuntuserverdocker:~# docker image ls
REPOSITORY        TAG         IMAGE ID       CREATED       SIZE
jenkins/jenkins   lts-jdk11   619aabbe0502   2 days ago    441MB
nginx             latest      dd34e67e3371   10 days ago   133MB
mysql             5.7         6c20ffa54f86   10 days ago   448MB
ubuntu            20.04       1318b700e415   4 weeks ago   72.8MB
root@ubuntuserverdocker:~#

# Lets take a backup of these images and store it was tar.gz which takes couple of minutes depends on size of the images
root@ubuntuserverdocker:~# docker image save --help

Usage:  docker image save [OPTIONS] IMAGE [IMAGE...]

Save one or more images to a tar archive (streamed to STDOUT by default)

Options:
  -o, --output string   Write to a file, instead of STDOUT
root@ubuntuserverdocker:~# docker image save -o images-backup.tar.gz jenkins/jenkins:lts-jdk11 nginx:latest ubuntu:20.04 mysql:5.7
root@ubuntuserverdocker:~# ls -lh images-backup.tar.gz
-rw------- 1 root root 996M Aug 28 09:25 images-backup.tar.gz
root@ubuntuserverdocker:~#
```

## Restore
```
# To esnure that restore works as expected. In the same machine, lets remove all the images and restore the backup
root@ubuntuserverdocker:~# docker image rm -f images-backup.tar.gz jenkins/jenkins:lts-jdk11 nginx:latest ubuntu:20.04 mysql:5.7

root@ubuntuserverdocker:~# docker image ls -a
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
root@ubuntuserverdocker:~# ls -lh images-backup.tar.gz
-rw------- 1 root root 996M Aug 28 09:25 images-backup.tar.gz
root@ubuntuserverdocker:~# docker image load --help

Usage:  docker image load [OPTIONS]

Load an image from a tar archive or STDIN

Options:
  -i, --input string   Read from tar archive file, instead of STDIN
  -q, --quiet          Suppress the load output
root@ubuntuserverdocker:~# docker image load -i images-backup.tar.gz
a881cfa23a78: Loading layer [==================================================>]  5.014MB/129.1MB
...
...
ac622cfb913b: Loading layer [==================================================>]  1.536kB/1.536kB
Loaded image: mysql:5.7
root@ubuntuserverdocker:~#

#Now lets check if images restored
root@ubuntuserverdocker:~# docker image ls
REPOSITORY        TAG         IMAGE ID       CREATED       SIZE
jenkins/jenkins   lts-jdk11   619aabbe0502   2 days ago    441MB
nginx             latest      dd34e67e3371   10 days ago   133MB
mysql             5.7         6c20ffa54f86   10 days ago   448MB
ubuntu            20.04       1318b700e415   4 weeks ago   72.8MB
root@ubuntuserverdocker:~#
```