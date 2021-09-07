# Docker Multi-Stage Image Build
- Multi-stage builds are a method of organizing a Dockerfile to minimize the size of the final container, improve run time performance, allow for better organization of Docker commands and files, and provide a standardized method of running build actions.
- As One of the most challenging things about building images is keeping the image size down.
- Each instruction in the Dockerfile adds a layer to the image, and you need to remember to clean up any artifacts you don’t need before moving on to the next layer.
- A multi-stage build is done by creating different sections of a Dockerfile, each referencing a different base image.
- This allows a multi-stage build to fulfill a function previously filled by using multiple docker files, copying files between containers, or running different pipelines.

### Note:
- Multistage build syntax was introduced in Docker Engine 17.05.

## Points to Note:
- With multi-stage builds, you use multiple FROM statements in your Dockerfile.
- Each FROM instruction can use a different base, and each of them begins a new stage of the build.
- You can selectively copy artifacts from one stage to another, leaving behind everything you don’t want in the final image.

## Scenario 1 (using Ubuntu Image)
```
FROM ubuntu:20.04
MAINTAINER "sudhams reddy duba<dubareddy.383@gmail.com>"
ENV DEBIAN_FRONTEND=noninteractive
#RUN apt update && apt install -y \
#    nginx iproute2 iputils-ping
RUN mkdir -p /var/website
RUN echo "Welcome to Multi-Stage Build" >> /var/website/index.html
COPY default.conf /var/website

FROM nginx:latest
COPY --from=0 /var/website /usr/share/nginx/html
COPY --from=0 /var/website/default.conf /etc/nginx/conf.d
EXPOSE 8080
```

## Scenario 2 (using alpine image)
```
FROM alpine
MAINTAINER "sudhams reddy duba<dubareddy.383@gmail.com>"
RUN mkdir -p /var/website
RUN echo "Welcome to Multi-Stage Build Demo from Visualpath" > /var/website/index.html
COPY default.conf /var/website

FROM nginx:latest
COPY --from=0 /var/website/index.html /usr/share/nginx/html
COPY --from=0 /var/website/default.conf /etc/nginx/conf.d
EXPOSE 8080
```

## Scenario 3 (advanced and complex)
```
# syntax=docker/dockerfile:1
FROM golang:1.16
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/alexellis/href-counter/app ./
CMD ["./app"]

#Reference: https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
```
### Notes
- When using multi-stage builds, you are not limited to copying from stages you created earlier in your Dockerfile.
- You can use the COPY --from instruction to copy from a separate image, either using the local image name, a tag available locally or on a Docker registry, or a tag ID.
- The Docker client pulls the image if necessary and copies the artifact from there.
```
COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf
```

#### **Check below output which, we have disabled cache while building image and Ubuntu image layers are not shown in history of "test/sudheer-nginx:latest" image layers**
```
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image build --no-cache -t test/sudheer-nginx:latest .
Sending build context to Docker daemon  4.096kB
Step 1/10 : FROM ubuntu:20.04
 ---> 1318b700e415
Step 2/10 : MAINTAINER "sudhams reddy duba<dubareddy.383@gmail.com>"
 ---> Running in 070683e9003c
Removing intermediate container 070683e9003c
 ---> 70096f6f15cb
Step 3/10 : ENV DEBIAN_FRONTEND=noninteractive
 ---> Running in 333c6614e265
Removing intermediate container 333c6614e265
 ---> d7e84845086a
Step 4/10 : RUN mkdir -p /var/website
 ---> Running in 1fe733f22c97
Removing intermediate container 1fe733f22c97
 ---> bb86fbc73081
Step 5/10 : RUN echo "Welcome to Multi-Stage Build" >> /var/website/index.html
 ---> Running in bf079d3b842d
Removing intermediate container bf079d3b842d
 ---> 831acb2b0a07
Step 6/10 : COPY default.conf /var/website
 ---> ef6230009761
Step 7/10 : FROM nginx:latest
 ---> dd34e67e3371
Step 8/10 : COPY --from=0 /var/website /usr/share/nginx/html
 ---> ee0cc4c38623
Step 9/10 : COPY --from=0 /var/website/default.conf /etc/nginx/conf.d
 ---> d44f16d269cb
Step 10/10 : EXPOSE 8080
 ---> Running in 4b4148a57379
Removing intermediate container 4b4148a57379
 ---> 25e6e9cf1194
Successfully built 25e6e9cf1194
Successfully tagged test/sudheer-nginx:latest
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage# docker image history test/sudheer-nginx:latest
IMAGE          CREATED              CREATED BY                                      SIZE      COMMENT
25e6e9cf1194   About a minute ago   /bin/sh -c #(nop)  EXPOSE 8080                  0B
d44f16d269cb   About a minute ago   /bin/sh -c #(nop) COPY file:213bf5b1bbf59892…   1.1kB
ee0cc4c38623   About a minute ago   /bin/sh -c #(nop) COPY dir:4b8b04f08b0374e5f…   1.13kB
dd34e67e3371   7 days ago           /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>      7 days ago           /bin/sh -c #(nop)  STOPSIGNAL SIGQUIT           0B
<missing>      7 days ago           /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>      7 days ago           /bin/sh -c #(nop)  ENTRYPOINT ["/docker-entr…   0B
<missing>      7 days ago           /bin/sh -c #(nop) COPY file:09a214a3e07c919a…   4.61kB
<missing>      7 days ago           /bin/sh -c #(nop) COPY file:0fd5fca330dcd6a7…   1.04kB
<missing>      7 days ago           /bin/sh -c #(nop) COPY file:0b866ff3fc1ef5b0…   1.96kB
<missing>      7 days ago           /bin/sh -c #(nop) COPY file:65504f71f5855ca0…   1.2kB
<missing>      7 days ago           /bin/sh -c set -x     && addgroup --system -…   63.9MB
<missing>      7 days ago           /bin/sh -c #(nop)  ENV PKG_RELEASE=1~buster     0B
<missing>      7 days ago           /bin/sh -c #(nop)  ENV NJS_VERSION=0.6.1        0B
<missing>      7 days ago           /bin/sh -c #(nop)  ENV NGINX_VERSION=1.21.1     0B
<missing>      7 days ago           /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
<missing>      7 days ago           /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      7 days ago           /bin/sh -c #(nop) ADD file:87b4e60fe3af680c6…   69.3MB
root@ubuntuserverdocker:~/image-dockerfiles/multi-stage#
```