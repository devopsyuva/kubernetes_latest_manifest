# Docker Components
- Docker Server
- Docker CLI
- Docker Regitry
- containerd (runc)
- Docker Objects
  - Images
  - Containers
  - Volumes
    - volume mount
    - bind mount
    - tmpfs mount
  - Network
    - bridge
    - host
    - none
    - overlay
    - macvlan

## Docker Server
**Docker server/daemon** is a service that runs in the background to handle the request from CLI/API to create a object for application deployment.
```
Login to Docker host machines (Docker host/machine is nothing but server(Virtual Machine or Baremetal) where docker was installed)
#systemctl status docker
#ps aux | grep dockerd
```

## Docker CLI
**Docker CLI** utility is used to create objects and to intract with docker daemon.
we can also run API calls to create objects as well.
```
Few CLI commands example:
#docker image ls
#docker info
#docker ps
```

## Docker Registry
**Docker Registry** is used to pull public/private images to local docker host machine for running specific applications.
```
Examples:
1) Docker Hub
2) Gilab Registry
3) Local registry to store images in container level on Docker host (Image: registry:2)
4) AWS ECR(Elastic Container Registry) and few more etc.,
References: https://docs.docker.com/registry/
```

## Containerd runtime
**containerd** was used for Docker as a backend component to create/run applications.
containerd is available as a daemon for Linux and Windows. It manages the complete container lifecycle of its host system, from image transfer and storage to container execution and supervision to low-level storage to network attachments

## Docker objects
### Images:
- Images are used to create containers, which is bundled as layers with OS/Application specific libraries and binaries.
- Images Doesn't has kernel for which size of image will be too small, which helps to expose less vulnerabilities.
- Images can be downloaded from official public **Docker Hub repository** or private repository by authentication.
- we can build custom images with the help of **Dockerfile**.
- Image layers are read-only which helps to share images with multiple containers.
- containers uses COW(Copy-On-Write) strategy to modify the filesystem data on container layer.

### Containers:
- Containers are the actual layer where your applications will be running.
- Containers running on the Docker Host are isolated with each otrher using Linux kernel features like namespaces and cgroups.
- Containers created with help of images which do not have any kernel.
- Creation/destroy of containers happens in fraction of seconds, since its doesn't kernel and other unnecessary service running.