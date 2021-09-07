## How to check Docker default registy?
```
root@ubuntuserverdocker:~# docker info | grep "Registry"
 Registry: https://index.docker.io/v1/
root@ubuntuserverdocker:~#
```

## How to pull image from Docker Hub repository?
```
root@ubuntuserverdocker:~# docker pull ubuntu:20.04
20.04: Pulling from library/ubuntu
16ec32c2132b: Pull complete
Digest: sha256:82becede498899ec668628e7cb0ad87b6e1c371cb8a1e597d83a47fac21d6af3
Status: Downloaded newer image for ubuntu:20.04
docker.io/library/ubuntu:20.04
root@ubuntuserverdocker:~# docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ubuntu       20.04     1318b700e415   11 days ago   72.8MB
root@ubuntuserverdocker:~#
```

## How to pull/push image from specific repository?
For example:
- we have account created in Docker hub repository and pushed the image to our private repository.

- Lets clone the "ubuntu:20.04" image as "dubareddy/ubuntu:20.04" to push to our specific repository in docker hub.
Note: dubareddy is my docker hub account created which should be added as prefix when we clone to push to that specific repository.

- Before pushing image to our repository, we need to login to the account from CLI and after that push the image by executing below command
```
root@ubuntuserverdocker:~# docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
alpine       latest    021b3423115f   3 days ago    5.6MB
ubuntu       20.04     1318b700e415   2 weeks ago   72.8MB
nginx        latest    08b152afcfae   2 weeks ago   133MB
root@ubuntuserverdocker:~# docker image tag alpine:latest dubareddy/alpine:latest
root@ubuntuserverdocker:~# docker image ls
REPOSITORY         TAG       IMAGE ID       CREATED       SIZE
dubareddy/alpine   latest    021b3423115f   3 days ago    5.6MB
alpine             latest    021b3423115f   3 days ago    5.6MB
ubuntu             20.04     1318b700e415   2 weeks ago   72.8MB
nginx              latest    08b152afcfae   2 weeks ago   133MB

Now lets check, if we try to push image "dubareddy/alpine:latest"
root@ubuntuserverdocker:~# docker push dubareddy/alpine:latest
The push refers to repository [docker.io/dubareddy/alpine]
bc276c40b172: Preparing
denied: requested access to the resource is denied
root@ubuntuserverdocker:~#

So to fix the issue, login to docker hub account "dubareddy in my case" and then push the image.
root@ubuntuserverdocker:~# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: dubareddy
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@ubuntuserverdocker:~# ls -l .docker/config.json
-rw------- 1 root root 99 Aug 10 13:32 .docker/config.json
root@ubuntuserverdocker:~# docker push dubareddy/alpine:latest
The push refers to repository [docker.io/dubareddy/alpine]
bc276c40b172: Mounted from library/alpine
latest: digest: sha256:be9bdc0ef8e96dbc428dc189b31e2e3b05523d96d12ed627c37aa2936653258c size: 528
root@ubuntuserverdocker:~#
```
- Login to docker hub dashboard and check if image is pushed.

- Cleanup the images which we have in local docker host to test
```
#docker image rm ubuntu:20.04 dubareddy/ubuntu:20.04
```
- Now pull the image from our private repository
```
#docker pull dubareddy/ubuntu:20.04
```

## How to check image details?
```
#docker image inspect <Image_Name/Image_ID>
```

## How to check image layers?
```
#Sample example for Image: alpine which is most commonly used
root@ubuntuserverdocker:~# docker pull alpine
Using default tag: latest
latest: Pulling from library/alpine
29291e31a76a: Pull complete
Digest: sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
Status: Downloaded newer image for alpine:latest
docker.io/library/alpine:latest
root@ubuntuserverdocker:~# docker image history alpine:latest
IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
021b3423115f   3 days ago   /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
<missing>      3 days ago   /bin/sh -c #(nop) ADD file:34eb5c40aa0002892…   5.6MB
root@ubuntuserverdocker:~#
```

## How to pull private image?
- To pull private image which are tagged as private in the repository, we have to login from cli and then pull those.
```
root@ubuntuserverdocker:~# docker logout
Removing login credentials for https://index.docker.io/v1/
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker pull dubareddy/ubuntu:20.04
Error response from daemon: pull access denied for dubareddy/ubuntu, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
root@ubuntuserverdocker:~# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: dubareddy
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@ubuntuserverdocker:~# docker pull dubareddy/ubuntu:20.04
20.04: Pulling from dubareddy/ubuntu
e6ca3592b144: Pull complete
534a5505201d: Pull complete
990916bd23bb: Pull complete
Digest: sha256:028d7303257c7f36c721b40099bf5004a41f666a54c0896d5f229f1c0fd99993
Status: Downloaded newer image for dubareddy/ubuntu:20.04
docker.io/dubareddy/ubuntu:20.04
root@ubuntuserverdocker:~# docker image ls dubareddy/ubuntu:20.04
REPOSITORY         TAG       IMAGE ID       CREATED         SIZE
dubareddy/ubuntu   20.04     bb0eaf4eee00   10 months ago   72.9MB
root@ubuntuserverdocker:~#
```

## How to cleanup all images layers which are dangling/intermittent?
- Check image first on the Docker host machine.
```
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED          SIZE
dubareddy/nginx-multistage   latest    eecaf089f0c9   15 minutes ago   133MB
<none>                       <none>    2cf601fb55a4   15 minutes ago   5.6MB
<none>                       <none>    0f0b586ad999   16 minutes ago   133MB
<none>                       <none>    be85ac6ccf4b   16 minutes ago   5.6MB
<none>                       <none>    f68592d14086   18 minutes ago   133MB
<none>                       <none>    fc8164a0514c   18 minutes ago   5.6MB
<none>                       <none>    a302fc8cf39d   23 minutes ago   72.8MB
nginx                        latest    dd34e67e3371   7 days ago       133MB
mysql                        5.7       6c20ffa54f86   7 days ago       448MB
alpine                       latest    021b3423115f   2 weeks ago      5.6MB
portainer/portainer-ce       latest    dfac2df13044   3 weeks ago      210MB
jenkins/jenkins              lts       3b4ec91827f2   3 weeks ago      568MB
ubuntu                       20.04     1318b700e415   4 weeks ago      72.8MB
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage#
```
- Now clean them using prune option.
```
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
...
...
Total reclaimed space: 5.693kB
```
- Lets check the image list now.
```
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED          SIZE
dubareddy/nginx-multistage   latest    eecaf089f0c9   16 minutes ago   133MB
nginx                        latest    dd34e67e3371   7 days ago       133MB
mysql                        5.7       6c20ffa54f86   7 days ago       448MB
alpine                       latest    021b3423115f   2 weeks ago      5.6MB
portainer/portainer-ce       latest    dfac2df13044   3 weeks ago      210MB
jenkins/jenkins              lts       3b4ec91827f2   3 weeks ago      568MB
ubuntu                       20.04     1318b700e415   4 weeks ago      72.8MB
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage#
```

## How to remove all unused images?
```
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker ps
CONTAINER ID   IMAGE                    COMMAND        CREATED        STATUS             PORTS                                                                                  NAMES
d00d8bda5c37   portainer/portainer-ce   "/portainer"   25 hours ago   Up About an hour   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp, 0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   portainer
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage#
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED          SIZE
dubareddy/nginx-multistage   latest    eecaf089f0c9   20 minutes ago   133MB
nginx                        latest    dd34e67e3371   7 days ago       133MB
mysql                        5.7       6c20ffa54f86   7 days ago       448MB
alpine                       latest    021b3423115f   2 weeks ago      5.6MB
portainer/portainer-ce       latest    dfac2df13044   3 weeks ago      210MB
jenkins/jenkins              lts       3b4ec91827f2   3 weeks ago      568MB
ubuntu                       20.04     1318b700e415   4 weeks ago      72.8MB
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage#
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image prune -a [-f --> Do not prompt for confirmation]
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
...
...
Total reclaimed space: 1.159GB

#Now lets the list of images avaiables and which are used by containers running like portainer example.
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image ls
REPOSITORY               TAG       IMAGE ID       CREATED       SIZE
portainer/portainer-ce   latest    dfac2df13044   3 weeks ago   210MB
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage#
```