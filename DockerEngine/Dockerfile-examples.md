# Dockerfile parameters
**A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Using docker build users can create an automated build that executes several command-line instructions in succession.**
```
FROM --> Specify parent image that to be used to build custom image
MAINTAINER --> Optional, to specify Name and email of the auther (deprecated)
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
STOPSIGNAL --> if we want stop some process garceful or forceful ("STOPSIGNAL SIGQUIT")
HEALTHCHECK --> Syntax looks like below:

HEALTHCHECK [OPTIONS] CMD command

Example:

HEALTHCHECK CMD curl --fail http://localhost:80/ || exit 1

The options that can appear before CMD are:

--interval=DURATION (default: 30s)
--timeout=DURATION (default: 30s)
--start-period=DURATION (default: 0s)
--retries=N (default: 3)
```
SHELL --> specify option to pass which shell need to be used to execute some commands
```
- [Reference](https://docs.docker.com/engine/reference/builder/#volume)
- Different scenarios to use Dockerfile for custom images:

```
FROM ubuntu:20.04
MAINTAINER SUDHEER REDDY DUBA "https://github.com/dubareddy"
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:${passwd}' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```
```
FROM ubuntu:20.04
MAINTAINER sudhams reddy duba<dubareddy.383@gmail.com>
ENV DEBAIN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y iproute2 nginx curl
COPY index.html /usr/share/nginx/html/
VOLUME /usr/share/nginx/html
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
HEALTHCHECK CMD curl --fail http://localhost:80/ || exit 1
```
```
FROM nginx:1.19.0 AS builder
MAINTAINER sudhams reddy duba<dubareddy.383@gmail.com>
COPY index.html /var/www/html/

FROM ubuntu:18.04
COPY --from=builder /var/www/html/index.html /usr/share/nginx/html/
CMD ["cat", "/usr/share/nginx/html/index.html"]
```
```
FROM jenkins/jenkins:lts
MAINTAINER sudhams reddy duba "dubareddy.383@gmail.com"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY  plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
USER jenkins
```
- update/create plugins.txt with list to plugins that you want to install
```
docker
kubernetes
```
- Optional:
```
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk
ENV JENKINS_SLAVE_AGENT_PORT 50001

File "executers.groovy"

++
import jenkins.model.*
Jenkins.instance.setNumExecutors(5)
++

FROM jenkins/jenkins:lts
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
```
- How to get list of plugins from existing server:
```
JENKINS_HOST=username:password@myhost.com:port
curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'

Sample output for Jenkins verion 2.289.1 LTS
++
sshd:3.0.3
cloudbees-folder:6.15
trilead-api:1.0.13
antisamy-markup-formatter:2.1
structs:1.23
workflow-step-api:2.23
token-macro:2.15
build-timeout:1.20
jaxb:2.3.0.1
credentials:2.5
plain-credentials:1.7
ssh-credentials:1.19
credentials-binding:1.25
scm-api:2.6.4
workflow-api:2.44
timestamper:1.13
caffeine-api:2.9.1-23.v51c4e2c879c8
script-security:1.77
plugin-util-api:2.3.0
font-awesome-api:5.15.3-3
popper-api:1.16.1-2
jquery3-api:3.6.0-1
bootstrap4-api:4.6.0-3
snakeyaml-api:1.29.1
jackson2-api:2.12.3
popper2-api:2.5.4-2
bootstrap5-api:5.0.1-2
echarts-api:5.1.2-2
display-url-api:2.3.5
workflow-support:3.8
checks-api:1.7.0
junit:1.50
matrix-project:1.19
resource-disposer:0.16
ws-cleanup:0.39
ant:1.11
durable-task:1.37
workflow-durable-task-step:2.39
command-launcher:1.6
jdk-tool:1.5
bouncycastle-api:2.20
ace-editor:1.1
workflow-scm-step:2.12
workflow-cps:2.92
workflow-job:2.41
apache-httpcomponents-client-4-api:4.5.13-1.0
mailer:1.34
workflow-basic-steps:2.23
gradle:1.36
pipeline-milestone-step:1.3.2
pipeline-input-step:2.12
pipeline-stage-step:2.5
pipeline-graph-analysis:1.11
pipeline-rest-api:2.19
handlebars:3.0.8
momentjs:1.1.1
pipeline-stage-view:2.19
pipeline-build-step:2.13
pipeline-model-api:1.8.5
pipeline-model-extensions:1.8.5
jsch:0.1.55.2
git-client:3.7.2
git-server:1.9
workflow-cps-global-lib:2.19
branch-api:2.6.4
workflow-multibranch:2.24
pipeline-stage-tags-metadata:1.8.5
pipeline-model-definition:1.8.5
lockable-resources:2.11
workflow-aggregator:2.6
jjwt-api:0.11.2-9.c8b45b8bb173
okhttp-api:3.14.9
github-api:1.123
git:4.7.2
github:1.33.1
github-branch-source:2.11.1
pipeline-github-lib:1.0
ssh-slaves:1.32.0
matrix-auth:2.6.7
pam-auth:1.6
ldap:2.7
email-ext:2.83
```
