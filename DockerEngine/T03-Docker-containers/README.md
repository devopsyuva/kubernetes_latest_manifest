# Docker containers
**Docker containers are created using images which has libraries, binaries etc., specific to that OS to run application**
- Docker containers are Thin layers which are created on top of image layers.
- Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.
- Any changes made inside the container are stored in container layer with COW strategy.

![](./sharing-layers.jpg)

- How to check layers of a image?
```
root@ubuntudockerserver:~# docker image ls
REPOSITORY         TAG       IMAGE ID       CREATED         SIZE
nginx              latest    f6987c8d6ed5   8 days ago      141MB
alpine             latest    c059bfaa849c   4 weeks ago     5.59MB
dubareddy/ubuntu   latest    72300a873c2c   22 months ago   64.2MB
root@ubuntudockerserver:~# docker image history nginx
IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
f6987c8d6ed5   8 days ago   /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>      8 days ago   /bin/sh -c #(nop)  STOPSIGNAL SIGQUIT           0B
<missing>      8 days ago   /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>      8 days ago   /bin/sh -c #(nop)  ENTRYPOINT ["/docker-entr…   0B
<missing>      8 days ago   /bin/sh -c #(nop) COPY file:09a214a3e07c919a…   4.61kB
<missing>      8 days ago   /bin/sh -c #(nop) COPY file:0fd5fca330dcd6a7…   1.04kB
<missing>      8 days ago   /bin/sh -c #(nop) COPY file:0b866ff3fc1ef5b0…   1.96kB
<missing>      8 days ago   /bin/sh -c #(nop) COPY file:65504f71f5855ca0…   1.2kB
<missing>      8 days ago   /bin/sh -c set -x     && addgroup --system -…   61.1MB
<missing>      8 days ago   /bin/sh -c #(nop)  ENV PKG_RELEASE=1~bullseye   0B
<missing>      8 days ago   /bin/sh -c #(nop)  ENV NJS_VERSION=0.7.0        0B
<missing>      8 days ago   /bin/sh -c #(nop)  ENV NGINX_VERSION=1.21.4     0B
<missing>      8 days ago   /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
<missing>      8 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      8 days ago   /bin/sh -c #(nop) ADD file:09675d11695f65c55…   80.4MB
root@ubuntudockerserver:~# docker image history alpine:latest
IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
c059bfaa849c   4 weeks ago   /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
<missing>      4 weeks ago   /bin/sh -c #(nop) ADD file:9233f6f2237d79659…   5.59MB
root@ubuntudockerserver:~#
```