# Dockerfile to run Nginx, PHP and Memcache services/application in one container
- Dockefile
```
FROM ubuntu:20.04
MAINTAINER sudhams reddy duba<dubareddy.383@gmail.com>
ENV DEBAIN_FRONTEND=noninteractive
ENV TZ=Asia/Calcutta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y iproute2 nginx curl memcached \
    php-fpm php-memcached php-cli supervisor
RUN mkdir -p /var/log/supervisor
COPY src/index.html /usr/share/nginx/html/
COPY src/index.html src/phpinfo.php /var/www/html/
COPY default /etc/nginx/sites-available/
COPY startup_script/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY src/config/supervisord.conf /etc/supervisor/supervisord.conf
VOLUME /usr/share/nginx/html
EXPOSE 80
CMD ["/usr/bin/supervisord", "-n"]
HEALTHCHECK CMD curl --fail http://localhost:80/ || exit 1
```
- supervisord
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

- supervisor startup script
```
[program:php7.4-fpm]
  command=/etc/init.d/php7.4-fpm start
  priotity=3
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

[program:memcached]
  command=/usr/bin/memcached -u root
  priority=2
  stdout_logfile=/dev/stdout
  stdout_logfile_maxbytes=0
  stderr_logfile=/dev/stderr
  stderr_logfile_maxbytes=0
```

- index.html and info.php
```
<html>
<img src="https://upload.wikimedia.org/wikipedia/commons/4/45/A_small_cup_of_coffee.JPG" alt="A Cup Coffee">
</html>
---
<?php
phpinfo();
?>
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

        index index.html index.htm index.nginx-debian.html;

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
