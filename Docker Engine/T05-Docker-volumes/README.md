# Docker Volumes
- In general data stored in containers on a writable layer which are ephemeral, which means as long as container runs data stored in container filesystem will avaliable.
- The data doesn’t persist when that container no longer exists, and it can be difficult to get the data out of the container if another process needs it.
- A container’s writable layer is tightly coupled to the host machine where the container is running. You can’t easily move the data somewhere else.
- Docker has two options for containers to store files in the host machine, so that the files are persisted even after the container stops: **volumes, and bind mounts**.

# Mount Types in Docker:
- **volume mount**
  - Bind mounts with arbitrary storage.
  - Plugins exists for alternative storage.
  - Can be attached to multiple containers simultaneously.
  - Excellent performance chracteristics.
  - Great for storing data and/or code.
- **bind mount**
  - Existing filesystem paths made accessiable in different locations.
  - Not Something specific to containers.
  - No performance penalty natively.
  - Implemented using vistual filesystem in Docker Desktop.
    - gRPC-FUSE for MacOS (previously osxfs).
    - 9P on windows (but native via WSL2).
  - Excellent for code you need to edit.
- **tmpfs mount**
  - Standard Linux tempfs filesystems.
  - Good performance.
  - No Persistence
    - Not a good option for code.

### Note:
- If you’re running Docker on Linux you can also use a tmpfs mount. If you’re running Docker on Windows you can also use a named pipe.