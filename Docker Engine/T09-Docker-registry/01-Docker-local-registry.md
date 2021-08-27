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

### References
- [Docker Registry](https://docs.docker.com/registry/)