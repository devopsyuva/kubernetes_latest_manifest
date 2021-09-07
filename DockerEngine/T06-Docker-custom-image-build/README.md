# Docker Custom Image Build
## Dockerfile
- Fundamentals of custom images
  - Create Dockerfile
  - Build image using Dockerfile
  - Push image to Repository

## Goals for Container Image Build
- Esay to understand and maintain
- Reduce number of layers
- It works as expected
- Keeping image size as small as possible

### Note
- Sometimes keeping image size reduces the attack vector.
- Always make use of .dockerignore to skip/ignore the files or directories from the Dockerfile build location/path.

## Production ready secured Image
- Images that are scanned, tested, reviewed, and verified.
  - Images: Build code with Jenkins(CICD).
  - Scanned: Scan images for Vulnerabilities check.
  - tested: Run unit and intigration tests with Jenkins.
  - reviewed: Digitally sign images.
  - verified: Ensure only signed images can run.

### TODO
- https://ahmet.im/blog/minimal-init-process-for-containers/
