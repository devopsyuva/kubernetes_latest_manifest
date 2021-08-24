# Dockerfile complete
```
FROM --> Specify parent image that to be used to build custom image
MAINTAINER --> Optional, to specify Name and email of the auther
RUN --> Execute command, how we have used in shell of linux
COPY --> copy files from docker host path to image layer
WORKDIR --> shift to specific path, as we do with cd command in linux
LABEL --> add labels to your image to help organize images by project, like version, medata info etc.,
ENV --> pass environment variable, when we are working with package installation which need some values to be passed
EXPOSE --> open a port in the container for application running to listen
ADD --> Similar action can be performed as COPY, but ADD allows us to some addition functionality like tar download from URL etc., example: ADD http://example.com/big.tar.xz /usr/src/things/
ENTRYPOINT --> pass utility/command as main command in the image
CMD --> arguments for the command can be passed here
VOLUME --> Example: /usr/share/nginx/html
USER --> USER to change to a non-root user
ONBUILD
ARG --> The ARG instruction defines a variable that users can pass at build-time to the builder with the docker build command using the --build-arg <varname>=<value> flag
Example:
ARG VERSION=1.0
RUN mkdir /test/file-${VERSRION}
COPY . /test/file-${VERSION}

STOPSIGNAL
HEALTHCHECK --> Syntax looks like below:

HEALTHCHECK [OPTIONS] CMD command

Example:
HEALTHCHECK CMD curl --fail http://localhost:80/ || exit 1

The options that can appear before CMD are:

--interval=DURATION (default: 30s)
--timeout=DURATION (default: 30s)
--start-period=DURATION (default: 0s)
--retries=N (default: 3)

SHELL --> specify option to pass which shell need to be used to execute some commands
```

## Image build flow
- Creates a temporary container from the previous image layer (or the base FROM image for the first command.
- Run the Dockerfile instruction in the temporary "intermediate" container.
- Save the temporary container as a new image layer.