# Volume Mount
- Volumes are stored in a part of the host filesystem which is managed by Docker (/var/lib/docker/volumes/ on Linux). Non-Docker processes should not modify this part of the filesystem. Volumes are the best way to persist data in Docker.
  - Volumes are easier to back up or migrate than bind mounts.
  - You can manage volumes using Docker CLI commands or the Docker API.
  - Volumes work on both Linux and Windows containers.
  - Volumes can be more safely shared among multiple containers.
  - Volume drivers let you store volumes on remote hosts or cloud providers, to encrypt the contents of volumes, or to add other functionality.
  - New volumes can have their content pre-populated by a container.
  - Volumes on Docker Desktop have much higher performance than bind mounts from Mac and Windows hosts.

### Note:
- Volume mount can be used using -v or --mount option
- When using volumes with services, only --mount is supported.

## Scenario 1: How to create a container for mysql to store data using volume mount
- Lets create a volume first using **docker volume create** with name mysql-backup.
- Now lets use that volume "mysql-backup" to the container using -v option.
```
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
root@ubuntuserverdocker:~# docker volume create mysql-backup
mysql-backup
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     mysql-backup
root@ubuntuserverdocker:~# ls -l /var/lib/docker/volumes/mysql-backup/_data/
total 0
root@ubuntuserverdocker:~# docker container run -d --name mysql --hostname mysqldbserver -v mysql-backup:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=test1234 -e MYSQL_ROOT_HOST=% mysql:5.7
3f20fb17df7eb4e3db1bd06143035c92838f000b024c9b4b3567de4d4589fa03
root@ubuntuserverdocker:~# ls -l /var/lib/docker/volumes/mysql-backup/_data/
total 188476
-rw-r----- 1 systemd-coredump systemd-coredump       56 Aug 21 12:45 auto.cnf
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 ca-key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1112 Aug 21 12:45 ca.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1112 Aug 21 12:45 client-cert.pem
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 client-key.pem
-rw-r----- 1 systemd-coredump systemd-coredump     1359 Aug 21 12:46 ib_buffer_pool
-rw-r----- 1 systemd-coredump systemd-coredump 79691776 Aug 21 12:46 ibdata1
-rw-r----- 1 systemd-coredump systemd-coredump 50331648 Aug 21 12:46 ib_logfile0
-rw-r----- 1 systemd-coredump systemd-coredump 50331648 Aug 21 12:45 ib_logfile1
-rw-r----- 1 systemd-coredump systemd-coredump 12582912 Aug 21 12:46 ibtmp1
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug 21 12:45 mysql
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug 21 12:45 performance_schema
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 private_key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump      452 Aug 21 12:45 public_key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1112 Aug 21 12:45 server-cert.pem
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 server-key.pem
drwxr-x--- 2 systemd-coredump systemd-coredump    12288 Aug 21 12:45 sys
root@ubuntuserverdocker:~# mysql -h 172.17.0.2 -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.35 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)

mysql> exit
Bye
root@ubuntuserverdocker:~#

# For testing purpose, let create some sample databases to see if data exists even after container deletion.
root@ubuntuserverdocker:~# mysql -h 172.17.0.2 -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.35 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

mysql> create database sudheer;
Query OK, 1 row affected (0.00 sec)

mysql> create database teja;
Query OK, 1 row affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sudheer            |
| sys                |
| teja               |
+--------------------+
6 rows in set (0.00 sec)

mysql> exit
Bye
root@ubuntuserverdocker:~#
```

## Scenario 2: Lets reuse volume to new container to check two things as mentioned below
- reuse volume "mysql-backup" to new container and see if volume are sharable.
- delete existing container "mysql" and see if data exists in volume.
```
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                 NAMES
3f20fb17df7e   mysql:5.7   "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   3306/tcp, 33060/tcp   mysql
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     mysql-backup
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                 NAMES
3f20fb17df7e   mysql:5.7   "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes   3306/tcp, 33060/tcp   mysql
root@ubuntuserverdocker:~# docker container stop mysql
mysql
root@ubuntuserverdocker:~# docker container rm mysql
mysql
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     mysql-backup
root@ubuntuserverdocker:~# ls -l /var/lib/docker/volumes/mysql-backup/_data/
total 176196
-rw-r----- 1 systemd-coredump systemd-coredump       56 Aug 21 12:45 auto.cnf
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 ca-key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1112 Aug 21 12:45 ca.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1112 Aug 21 12:45 client-cert.pem
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 client-key.pem
-rw-r----- 1 systemd-coredump systemd-coredump      672 Aug 21 12:55 ib_buffer_pool
-rw-r----- 1 systemd-coredump systemd-coredump 79691776 Aug 21 12:55 ibdata1
-rw-r----- 1 systemd-coredump systemd-coredump 50331648 Aug 21 12:55 ib_logfile0
-rw-r----- 1 systemd-coredump systemd-coredump 50331648 Aug 21 12:45 ib_logfile1
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug 21 12:45 mysql
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug 21 12:45 performance_schema
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 private_key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump      452 Aug 21 12:45 public_key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1112 Aug 21 12:45 server-cert.pem
-rw------- 1 systemd-coredump systemd-coredump     1676 Aug 21 12:45 server-key.pem
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug 21 12:48 sudheer
drwxr-x--- 2 systemd-coredump systemd-coredump    12288 Aug 21 12:45 sys
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug 21 12:48 teja
root@ubuntuserverdocker:~#

#Now lets use same volume to new container
root@ubuntuserverdocker:~# docker container stop mysql
mysql
root@ubuntuserverdocker:~# docker container rm mysql
mysql
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     mysql-backup
root@ubuntuserverdocker:~# docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker container run -d --name mysql-demo  -v mysql-backup:/var/lib/mysql mysql:5.7
eb869c90f9683685847a5da4565fb0a991a07fb7435179996dd8898b0382270b
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                 NAMES
eb869c90f968   mysql:5.7   "docker-entrypoint.s…"   2 seconds ago   Up 2 seconds   3306/tcp, 33060/tcp   mysql-demo
root@ubuntuserverdocker:~# mysql -h 172.17.0.2 -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.35 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> exit
Bye
root@ubuntuserverdocker:~#
```

## Scenario 3: Let see if a volume can be shared for multiple containers using nginx webapp
- Lets create a common volume name "nginx-backup".
- Now create two containers name "nginx-1" and "nginx-2" to use same volume "nginx-backup".
```
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
root@ubuntuserverdocker:~# docker volume create nginx-backup
nginx-backup
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     nginx-backup
root@ubuntuserverdocker:~# docker container run -d --name nginx-1 -v nginx-backup:/usr/share/nginx/html nginx:latest
fa11d6cf203737ee4249b9c132dfae33bbfc5a38db2bcf475fa59efbb3301c0c
root@ubuntuserverdocker:~# docker container run -d --name nginx-2 -v nginx-backup:/usr/share/nginx/html nginx:latest
1b3e4e26da29765ce2b34caa2216be85bce301d97f6c37e16efd11a14bc307ae
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS         PORTS     NAMES
1b3e4e26da29   nginx:latest   "/docker-entrypoint.…"   3 seconds ago    Up 2 seconds   80/tcp    nginx-2
fa11d6cf2037   nginx:latest   "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds   80/tcp    nginx-1
root@ubuntuserverdocker:~# echo "welcome to Docker volume common share storage" > /var/lib/docker/volumes/nginx-backup/_data/index.html
root@ubuntuserverdocker:~# curl 172.17.0.2
welcome to Docker volume common share storage
root@ubuntuserverdocker:~# curl 172.17.0.3
welcome to Docker volume common share storage
root@ubuntuserverdocker:~#
```

## Scenario 4: We will not create a volume as a prerequest for a container
- Lets create a container name "nginx-test" with volume name "nginx-demo".
- Volume "nginx-demo" will not be created in this as a prerequest.
- Volume name will be passed while creating a container.
```
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
root@ubuntuserverdocker:~# docker container run -d --name nginx-test -v nginx-demo:/usr/share/nginx/html nginx:latest
3bb9dc718e3d933f399de5262b4f7598ef8461fe8e4701748433d2d58737799f
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     nginx-demo
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
3bb9dc718e3d   nginx:latest   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds   80/tcp    nginx-test
root@ubuntuserverdocker:~# curl 172.17.0.2
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
## Scenario 5: Lets mount shared volume as read-only to the containers.
- Benefit of sharing volume mount as read-only to multiple containers is applications/users can't modify the context of mounted path to volume.
- These helps admin to maintain common data/context to be shared among containers.
```
root@ubuntuserverdocker:~# docker container run -d --name nginx-1 -v nginx-backup:/usr/share/nginx/html:ro nginx:latest
cb02250d233dc940b4ac1d5e3a7213248e3aede9416f94142ec22cb8285f2c3f
root@ubuntuserverdocker
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     nginx-backup
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
cb02250d233d   nginx:latest   "/docker-entrypoint.…"   20 seconds ago   Up 19 seconds   80/tcp    nginx-1
root@ubuntuserverdocker:~# docker container run -d --name nginx-2 -v nginx-backup:/usr/share/nginx/html:ro nginx:latest
c9863da8eee127243d8cc5f34abe44d8ec84d3a318f4cab47c759a6b417bb6c3
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# echo "welcome to nginx shared volume as read-only" > /var/lib/docker/volumes/nginx-backup/_data/index.html
root@ubuntuserverdocker:~# docker exec -ti nginx-1 bash
root@cb02250d233d:/# echo "Test from nginx-1" > /usr/share/nginx/html/index.html
bash: /usr/share/nginx/html/index.html: Read-only file system
root@cb02250d233d:/# exit
exit
root@ubuntuserverdocker:~# docker exec -ti nginx-2 bash
root@c9863da8eee1:/#  echo "Test from nginx-2" > /usr/share/nginx/html/index.html
bash: /usr/share/nginx/html/index.html: Read-only file system
root@c9863da8eee1:/# exit
exit
root@ubuntuserverdocker:~#
```

## Scenario 6: Lets use --mount for above one of the example to see the options
- Option --mount can also be used for using volume mount for containers.
- This option is mostly preffered and suggested for **Docker Swarm**, since service support only --mount option.
```
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
root@ubuntuserverdocker:~# docker container run -d --name nginx --hostname nginxwebserver --mount type=volume,src=nginx-backup,dst=/usr/share/nginx/html nginx:latest
3e6bfb51a41eda2f5fea65d8ef258a6038b5090d3ca68c48a3099bc2f210c2ca
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
3e6bfb51a41e   nginx:latest   "/docker-entrypoint.…"   5 seconds ago   Up 3 seconds   80/tcp    nginx
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker volume ls
DRIVER    VOLUME NAME
local     nginx-backup
root@ubuntuserverdocker:~#
```

### References
- [Docker Volume Mount](https://docs.docker.com/storage/volumes/)