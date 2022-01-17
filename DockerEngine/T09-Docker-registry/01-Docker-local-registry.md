# Docker Registry
**In general, Users looking for a zero maintenance, ready-to-go solution are encouraged to head-over to the Docker Hub, which provides a free-to-use, hosted Registry, plus additional features (organization accounts, automated builds, and more).**

## Why to go for registry?
- tightly control where your images are being stored
- fully own your images distribution pipeline
- integrate image storage and distribution tightly into your in-house development workflow

### Note:
- The Registry is compatible with Docker engine version 1.6.0 or higher.

## Basic commands to start with local registry:
```
root@ubuntuserverdocker:~# docker container run -d --name local-registry -v local-registry:/var/lib/registry -p 5000:5000 --restart always registry:2
Unable to find image 'registry:2' locally
2: Pulling from library/registry
ddad3d7c1e96: Pull complete
6eda6749503f: Pull complete
363ab70c2143: Pull complete
5b94580856e6: Pull complete
12008541203a: Pull complete
Digest: sha256:121baf25069a56749f249819e36b386d655ba67116d9c1c6c8594061852de4da
Status: Downloaded newer image for registry:2
e585d6b003971890b89bf13d841430cb877a67706a76ea2302fa7bcbd41a6967
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS          PORTS                                       NAMES
e585d6b00397   registry:2   "/entrypoint.sh /etc…"   17 seconds ago   Up 16 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   local-registry
root@ubuntuserverdocker:~#

#Now lets try to push the simple image to the local registry container which is reachable on Docker Host localhost and port 5000 binded
root@ubuntuserverdocker:~# docker image ls
REPOSITORY               TAG         IMAGE ID       CREATED         SIZE
jenkins/jenkins          lts         619aabbe0502   47 hours ago    441MB
jenkins/jenkins          lts-jdk11   619aabbe0502   47 hours ago    441MB
portainer/portainer-ce   latest      dfac2df13044   4 weeks ago     210MB
registry                 2           1fd8e1b0bb7e   4 months ago    26.2MB
nginx                    1.19.0      2622e6cca7eb   14 months ago   132MB
root@ubuntuserverdocker:~# docker image tag jenkins/jenkins:lts localhost:5000/jenkins-local:lts
root@ubuntuserverdocker:~# docker image ls
REPOSITORY                     TAG         IMAGE ID       CREATED         SIZE
jenkins/jenkins                lts         619aabbe0502   47 hours ago    441MB
jenkins/jenkins                lts-jdk11   619aabbe0502   47 hours ago    441MB
localhost:5000/jenkins-local   lts         619aabbe0502   47 hours ago    441MB
portainer/portainer-ce         latest      dfac2df13044   4 weeks ago     210MB
registry                       2           1fd8e1b0bb7e   4 months ago    26.2MB
nginx                          1.19.0      2622e6cca7eb   14 months ago   132MB

root@ubuntuserverdocker:~# docker push localhost:5000/jenkins-local:lts
The push refers to repository [localhost:5000/jenkins-local]
b2179b93aaec: Pushed
6fec182d902c: Pushed
ccc4007d5735: Pushed
d94bb998ce87: Pushed
b8f175ca8ee7: Pushed
b12aad10aa29: Pushed
539829c9110c: Pushed
add592c117c3: Pushed
f33e775528e6: Pushed
366f56b13eb8: Pushed
3f4e9f271b33: Pushed
d491e7a64665: Pushed
35faf640757e: Pushed
af999d31c9d5: Pushed
d7d3d21a9907: Pushed
2a129856dca6: Pushed
a881cfa23a78: Pushed
lts: digest: sha256:c6c5474940690d8ca872fa300524bf194b1b3c8743482bc439dfc835c11c9ddf size: 3876
root@ubuntuserverdocker:~#

# Now lets verify by pulling image from local registry. Before that lets cleanup image pesent in Docker host.
root@ubuntuserverdocker:~# docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
registry     2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#

#lets download the image jenkins-local:lts image from local-registry
root@ubuntuserverdocker:~# docker pull localhost:5000/jenkins-local:lts
lts: Pulling from jenkins-local
4c25b3090c26: Pull complete
750d566fdd60: Pull complete
2718cc36ca02: Pull complete
5678b027ee14: Pull complete
c839cd2df78d: Pull complete
50861a5addda: Pull complete
ff2b028e5cf5: Pull complete
ee710b58f452: Pull complete
2625c929bb0e: Pull complete
6a6bf9181c04: Pull complete
bee5e6792ac4: Pull complete
6cc5edd2133e: Pull complete
c07b16426ded: Pull complete
e9ac42647ae3: Pull complete
fa925738a490: Pull complete
4a08c3886279: Pull complete
2d43fec22b7e: Pull complete
Digest: sha256:c6c5474940690d8ca872fa300524bf194b1b3c8743482bc439dfc835c11c9ddf
Status: Downloaded newer image for localhost:5000/jenkins-local:lts
localhost:5000/jenkins-local:lts
root@ubuntuserverdocker:~# docker image ls
REPOSITORY                     TAG       IMAGE ID       CREATED        SIZE
localhost:5000/jenkins-local   lts       619aabbe0502   47 hours ago   441MB
registry                       2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#
```

## Dashboard (UI) to manage local docker registries
```
root@ubuntudockerserver:~/compose/jenkins# docker container run -d -e ENV_DOCKER_REGISTRY_HOST=10.0.2.15 -e ENV_DOCKER_REGISTRY_PORT=5000 -p 8080:80 konradkleine/docker-registry-frontend:v2
Unable to find image 'konradkleine/docker-registry-frontend:v2' locally
v2: Pulling from konradkleine/docker-registry-frontend
85b1f47fba49: Pull complete
e3c64813de17: Pull complete
6e61107884ac: Pull complete
411f14e0e0fd: Pull complete
987d1071cd71: Pull complete
95913db6ef30: Pull complete
1eb7ee3fbde2: Pull complete
9b6f26b1b1a1: Pull complete
daa6941a3108: Pull complete
86cc842193a6: Pull complete
024ab6890532: Pull complete
af9b7d0cb338: Pull complete
02f33fb0dcad: Pull complete
e8275670ee05: Pull complete
1c1a56903b01: Pull complete
afc4e94602b9: Pull complete
df1a95efa681: Pull complete
d8bcb7be9e08: Pull complete
d9c69b7bcc4f: Pull complete
2a14b209069e: Pull complete
e7c2bcdf63d5: Pull complete
efc16e6bbbea: Pull complete
552460069ca8: Pull complete
e6b075740da3: Pull complete
9976bc800046: Pull complete
Digest: sha256:181aad54ee64312a57f8ccba5247c67358de18886d5e2f383b8c4b80a7a5edf6
Status: Downloaded newer image for konradkleine/docker-registry-frontend:v2
deec32b88789c65ec1dac4c311adda9c53003322fe9ec47c313adef7d29676df
root@ubuntudockerserver:~/compose/jenkins# docker ps
CONTAINER ID   IMAGE                                      COMMAND                  CREATED          STATUS          PORTS                                            NAMES
deec32b88789   konradkleine/docker-registry-frontend:v2   "/bin/sh -c $START_S…"   49 seconds ago   Up 47 seconds   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp   recursing_leavitt
86ce522c6aa6   registry:2                                 "/entrypoint.sh /etc…"   12 minutes ago   Up 12 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp        registry
root@ubuntudockerserver:~/compose/jenkins#
```

### References
- [Docker Registry](https://docs.docker.com/registry/)