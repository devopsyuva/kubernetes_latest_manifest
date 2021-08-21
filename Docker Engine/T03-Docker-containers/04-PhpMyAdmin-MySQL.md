# Running PhpMyAdmin container with MySQL access
```
root@ubuntuserverdocker:~# docker container run -d --name mysql --hostname mysqldbserver -e MYSQL_ROOT_PASSWORD=test1234 -e MYSQL_ROOT_HOST=% mysql:5.7
865234c0b935c63c1629d057bb96985d6bfe0d7cecd58350440abf03b3f9e3f0
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                 NAMES
865234c0b935   mysql:5.7   "docker-entrypoint.s…"   5 seconds ago   Up 3 seconds   3306/tcp, 33060/tcp   mysql
root@ubuntuserverdocker:~# mysql -h 172.17.0.2 -u root -p
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
4 rows in set (0.00 sec)

mysql> exit
Bye
root@ubuntuserverdocker:~#

#Now we are establishing a connection to mysql container for phpmyadmin container to access
root@ubuntuserverdocker:~# docker run --name myadmin -d --link mysql:db -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin
2166ba5e8d54c52dffc113bb8995b818de5355c94758980bb41b95d85c8af87f
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS          PORTS                                   NAMES
2166ba5e8d54   phpmyadmin   "/docker-entrypoint.…"   3 seconds ago    Up 2 seconds    0.0.0.0:8080->80/tcp, :::8080->80/tcp   myadmin
865234c0b935   mysql:5.7    "docker-entrypoint.s…"   35 minutes ago   Up 35 minutes   3306/tcp, 33060/tcp                     mysql
root@ubuntuserverdocker:~#

#Now lets access the phpmyadmin container using http://<Docker-Host-IP>:8080
#Update host, username and password of mysql container to get access.
```

## References
- [phpmyadmin image](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)