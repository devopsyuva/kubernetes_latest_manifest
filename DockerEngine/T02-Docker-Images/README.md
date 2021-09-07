# Docker Images
**A Docker image contains application code, libraries, tools, dependencies and other files needed to make an application run**

- Images can be pulled **[Docker Hub](https://hub.docker.com/)** from docker public repository and also docker uses this as default repository to download the Images.
- We can also store Images in third party repositories like Cloud and third-party repositories (ECR, ACR, GCR, Gitlab, Jfrog artifactory etc.,) both as public and private.
- Private images which are store needs authentication to download the image to local docker host machine.
- Custom images can be build using Dockerfile to run custom application as per requirement.
```
root@ubuntuserverdocker:~# docker images
```
- Each image is build with layers which are read-only filesystem.
- Containers can't do any modification on Image layers, instead it uses COW(Copy-On-Write) strategy as they will copy the file to container layer and do the necessary modification to avoid conflict for other containers using same image.
- Image layers are thin layers
```
Below sample example Image layers for Ubuntu 20.04 base:
root@ubuntuserverdocker:~# docker image history ubuntu:20.04
IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
1318b700e415   11 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      11 days ago   /bin/sh -c #(nop) ADD file:524e8d93ad65f08a0…   72.8MB
root@ubuntuserverdocker:~#
```

## References:
* [Docker Images](https://docs.docker.com/engine/reference/commandline/images/)
* [Docker Image CLI](https://docs.docker.com/engine/reference/commandline/image/)