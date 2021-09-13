# Nginx web application with MYSQL as backend database storage

```
.
├── default
├── Dockerfile
├── README.md
├── src
│   ├── dbConn.php
│   ├── index.php
│   └── insert.php
└── startup_scripts
    ├── config
    │   └── supervisord.conf
    └── supervisord.conf

3 directories, 8 files
```

- Dockerfile
```
FROM ubuntu:20.04
MAINTAINER sudhams reddy duba<dubareddy.383@gmail.com>
ENV DEBAIN_FRONTEND=noninteractive
ENV TZ=Asia/Calcutta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y iproute2 nginx curl \
    php-fpm php-mysql php-cli supervisor
RUN mkdir -p /var/log/supervisor
COPY src/ /usr/share/nginx/html/
COPY src/ /var/www/html/
COPY default /etc/nginx/sites-available/
COPY startup_scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY startup_scripts/config/supervisord.conf /etc/supervisor/supervisord.conf
VOLUME /usr/share/nginx/html
EXPOSE 80
CMD ["/usr/bin/supervisord", "-n"]
HEALTHCHECK CMD curl --fail http://localhost:80/ || exit 1
```

- default
```
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        # pass PHP scripts to FastCGI server
        #
        location ~ \.php$ {
               include snippets/fastcgi-php.conf;

               # With php-fpm (or other unix sockets):
               fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
               # With php-cgi (or other tcp sockets):
               # fastcgi_pass 127.0.0.1:9000;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #       deny all;
        #}
}
```

- startup_scripts/config/supervisord.conf
```
; supervisor config file

[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
user=0
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

[include]
files = /etc/supervisor/conf.d/*.conf
```

- start_scripts/supervisord.conf
```
[program:php7.4-fpm]
  command=/etc/init.d/php7.4-fpm start
  priotity=2
  startsecs = 0
  startretries=10
  stdout_logfile=/dev/stdout
  stdout_logfile_maxbytes=0
  stderr_logfile=/dev/stderr
  stderr_logfile_maxbytes=0

[program:nginx]
  command=nginx -g "daemon off;"
  priority=1
  stdout_logfile=/dev/stdout
  stdout_logfile_maxbytes=0
  stderr_logfile=/dev/stderr
  stderr_logfile_maxbytes=0
```

- src/index.php
```
<!DOCTYPE html>
<html>
<head>
  <title>Add Records in Database</title>
</head>
<body>

<form action="insert.php" method="POST">
  Full Name : <input type="text" name="fullname" placeholder="Enter Full Name" Required>
  <br/>
  Age : <input type="text" name="age" placeholder="Enter Age" Required>
  <br/>
  <input type="submit" name="submit" value="Submit">
</form>

</body>
</html>
```

- src/dbConn.php
```
<?php
$db_host = $_SERVER["DB_HOST"]
$db_user = $_SERVER["DB_USER"]
$db_passwd = $_SERVER["DB_PASSWD"]
$db_name = $_SERVER["DB_NAME"]
$db = mysqli_connect($db_host,$db_user,$db_passwd,$db_name);

if(!$db)
{
    die("Connection failed: " . mysqli_connect_error());
}

?>
```

- src/insert.php
```
<?php
include "dbConn.php"; // Using database connection file here

if(isset($_POST['submit']))
{
    $fullname = $_POST['fullname'];
    $age = $_POST['age'];

    $insert = mysqli_query($db,"INSERT INTO `team`(`fullname`, `age`) VALUES ('$fullname','$age')");

    if(!$insert)
    {
        echo mysqli_error();
    }
    else
    {
        echo "Records added successfully.";
    }
}

mysqli_close($db); // Close connection
?>
```

```
mysql> create database employees;
Query OK, 1 row affected (0.00 sec)

mysql> CREATE TABLE `team` (`fullname` VARCHAR(150), `age` INT, PRIMARY KEY (`fullname`));
Query OK, 0 rows affected (0.05 sec)

mysql> CREATE USER 'sudheer'@'172.17.0.2' IDENTIFIED BY 'password';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT ALL PRIVILEGES ON *.* TO 'sudheer'@'172.17.0.2' WITH GRANT OPTION;
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> \q
Bye


or

mysql> GRANT ALL PRIVILEGES ON employees.* TO sudheer@'172.17.0.3' IDENTIFIED BY 'password';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)
```