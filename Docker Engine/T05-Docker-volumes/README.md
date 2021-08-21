# Docker Volumes
- In general data stored in containers on a writable layer which are ephemeral, which means as long as container runs data stored in container filesystem will avaliable.
- The data doesn’t persist when that container no longer exists, and it can be difficult to get the data out of the container if another process needs it.
- A container’s writable layer is tightly coupled to the host machine where the container is running. You can’t easily move the data somewhere else.
- Docker has two options for containers to store files in the host machine, so that the files are persisted even after the container stops: **volumes, and bind mounts**.

# Mount Types in Docker:
- volume mount
- bind mount
- tmpfs mount

### Note:
- If you’re running Docker on Linux you can also use a tmpfs mount. If you’re running Docker on Windows you can also use a named pipe.