- Generate certificates using below command:
```
mkdir $HOME/certs
cd certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=192.168.0.48"

or

update in openssl.conf file
++
[ req ]
distinguished_name = req_distinguished_name
x509_extensions     = req_ext
default_md         = sha256
prompt             = no
encrypt_key        = no

[ req_distinguished_name ]
countryName            = "IN"
localityName           = "Hyderabad"
organizationName       = "Docker Demo"
organizationalUnitName = "Sudheer"
commonName             = "<Docker Server IP>"
emailAddress           = "dubareddy.383@gmail.com"

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS = "<Docker Server IP>"
++

Note: key pairs should be generated with 2048 bit size, because if it is more than that like 4096 it will create a load on the server for SSL handshake.

openssl req  -x509 -newkey rsa:4096 -days 365 -config openssl.conf  -keyout tls.key -out tls.crt

Command to verify certs genrated above:

openssl x509 -in certs/tls.crt -text -noout
```

- update daemon.json file to accept domain and IP address
```
root@ubuntuserver:~/certs# cat /etc/docker/daemon.json 
{
  "insecure-registries": ["192.168.1.100:443", "dockerserver:443"]
}
root@ubuntuserver:~/certs#
```

- restart docker using #systemctl restart docker

- Instruct every Docker daemon to trust that certificate. The way to do this depends on your OS.

- Linux: Copy the domain.crt file to cmyregistrydomain.com:5000/ca.crt on every Docker host. You do not need to restart Docker.

- Sample example:
```
root@dockerserver:~# docker push dockerserver:443/nginx:1.19.0 
The push refers to repository [dockerserver:443/nginx]
Get https://dockerserver:443/v2/: x509: certificate signed by unknown authority
root@dockerserver:~# mkdir -p /etc/docker/certs.d/dockerserver:443/
root@dockerserver:~# cp certs/tls.crt /etc/docker/certs.d/dockerserver:443/ca.crt

or

root@dockerserver:~# mkdir -p /etc/docker/certs.d/dockerserver/
root@dockerserver:~# cp certs/tls.crt /etc/docker/certs.d/dockerserver/ca.crt

root@dockerserver:~# docker push dockerserver:443/nginx:1.19.0 
The push refers to repository [dockerserver:443/nginx]
f978b9ed3f26: Pushed 
9040af41bb66: Pushed 
7c7d7f446182: Pushed 
d4cf327d8ef5: Pushed 
13cb14c2acd3: Pushed 
1.19.0: digest: sha256:0efad4d09a419dc6d574c3c3baacb804a530acd61d5eba72cb1f14e1f5ac0c8f size: 1362
root@dockerserver:~# 

root@dockerserver:~# docker pull dockerserver:443/nginx:1.19.0@sha256:0efad4d09a419dc6d574c3c3baacb804a530acd61d5eba72cb1f14e1f5ac0c8f
sha256:0efad4d09a419dc6d574c3c3baacb804a530acd61d5eba72cb1f14e1f5ac0c8f: Pulling from nginx
8559a31e96f4: Pull complete 
8d69e59170f7: Pull complete 
3f9f1ec1d262: Pull complete 
d1f5ff4f210d: Pull complete 
1e22bfa8652e: Pull complete 
Digest: sha256:0efad4d09a419dc6d574c3c3baacb804a530acd61d5eba72cb1f14e1f5ac0c8f
Status: Downloaded newer image for dockerserver:443/nginx@sha256:0efad4d09a419dc6d574c3c3baacb804a530acd61d5eba72cb1f14e1f5ac0c8f
dockerserver:443/nginx:1.19.0@sha256:0efad4d09a419dc6d574c3c3baacb804a530acd61d5eba72cb1f14e1f5ac0c8f
root@dockerserver:~# docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
registry                 2                   2d4f4b5309b1        4 weeks ago         26.2MB
dockerserver:443/nginx   <none>              2622e6cca7eb        5 weeks ago         132MB
root@dockerserver:~# 
```

- Create local registry using Docker Engine:
```
docker run -d \
  --restart=always \
  --name registry \
  -v "$(pwd)"/certs:/certs \
  -v docker_registry:/var/lib/registry \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/tls.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/tls.key \
  -p 443:443 \
  registry:2
```

- Docker compose method:
```
version: '3.0'

services:

  registry:
    container_name: docker-registry
    restart: always
    image: registry:2
    environment:
      REGISTRY_HTTP_ADDR=0.0.0.0:443
      REGISTRY_HTTP_TLS_CERTIFICATE: /certs/tls.crt
      REGISTRY_HTTP_TLS_KEY: /certs/tls.key
    ports:
      - 5000:5000
      - 443:443
    volumes:
      - docker-registry:/var/lib/registry
      - ./certs:/certs

volumes:
  docker-registry-data: {}
```

- Docker htpasswd authetication from CLI:
  - Create a password file with one entry for the user testuser, with password testpassword:
```
$ mkdir auth
$ docker run \
  --entrypoint htpasswd \
  registry:2 -Bbn testuser testpassword > auth/htpasswd
Stop the registry.

$ docker container stop registry
Start the registry with basic authentication.

$ docker run -d \
  -p 5000:5000 \
  -p 443:443 \
  --restart=always \
  --name registry \
  -v /auth:/auth \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/tls.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/tls.key \
  registry:2
```
- Try to pull an image from the registry, or push an image to the registry. These commands fail.

- Log in to the registry.
```
$ docker login myregistrydomain.com:5000
Provide the username and password from the first step.
```

- Docker compose file with htpasswd authentication:
```
version: '3.0'

services:

  registry:
    container_name: docker-registry
    restart: always
    image: registry:2
    environment:
      REGISTRY_HTTP_TLS_CERTIFICATE: /certs/tls.crt
      REGISTRY_HTTP_TLS_KEY: /certs/tls.key
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
      REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
    ports:
      - 5000:5000
      - 433:443
    volumes:
      - docker-registry:/var/lib/registry
      - ./certs:/certs
      - ./auth:/auth

volumes:
  docker-registry-data: {}
```

- sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" Container_Name
```
docker run -d --restart=always --name registry -v "$(pwd)"/certs:/certs -v docker-registry:/var/lib/registry -e REGISTRY_HTTP_ADDR=0.0.0.0:443 -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/tls.crt -e REGISTRY_HTTP_TLS_KEY=/certs/tls.key -p 443:443 registry:2
```

- Some of environment variables of docker local registry:
```
REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/somewhere
 -v `pwd`/config.yml:/etc/docker/registry/config.yml
```

## How to use authentication and secure communication to local registry
```
root@ubuntuserverdocker:~# cat /etc/docker/daemon.json
{
  "insecure-registries": ["192.168.1.50:443", "ubuntuserverdocker:443"]
}
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# mkdir auth
root@ubuntuserverdocker:~# docker run --entrypoint htpasswd httpd:2 -Bbn sudheer test1234 > auth/htpasswd
root@ubuntuserverdocker:~# cat auth/htpasswd
sudheer:$2y$05$.btBjF1LwN1DPSyX6AxDYOR8mfEa8Nf8Bpt6PtXNCUTm0EDuCfb4a

root@ubuntuserverdocker:~# ls -l certs/
total 8
-rw-r--r-- 1 root root 1139 Aug 27 11:38 tls.crt
-rw------- 1 root root 1704 Aug 27 11:38 tls.key
root@ubuntuserverdocker:~# docker run -d -p 443:443 --restart=always --name registry -v "$(pwd)"/auth:/auth -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v "$(pwd)"/certs:/certs -e REGISTRY_HTTP_ADDR=0.0.0.0:443 -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/tls.crt -e REGISTRY_HTTP_TLS_KEY=/certs/tls.key registry:2
167cee70b61c2ef06191342b026ee6c50aff3ba62d11f34c308875b34ce4b70e
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS         PORTS                                             NAMES
167cee70b61c   registry:2   "/entrypoint.sh /etc…"   4 seconds ago   Up 2 seconds   0.0.0.0:443->443/tcp, :::443->443/tcp, 5000/tcp   registry
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker image ls
REPOSITORY                              TAG       IMAGE ID       CREATED        SIZE
httpd                                   2         c8ca530172a8   10 days ago    138MB
registry                                2         1fd8e1b0bb7e   4 months ago   26.2MB
localhost:5000/jenkins-local            lts       1fd8e1b0bb7e   4 months ago   26.2MB
ubuntuserverdocker:5000/jenkins-local   lts       1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~# docker image tag localhost:5000/jenkins-local:lts ubuntuserverdocker:443/jenkins-local:latest
root@ubuntuserverdocker:~# docker image ls
REPOSITORY                              TAG       IMAGE ID       CREATED        SIZE
httpd                                   2         c8ca530172a8   10 days ago    138MB
registry                                2         1fd8e1b0bb7e   4 months ago   26.2MB
localhost:5000/jenkins-local            lts       1fd8e1b0bb7e   4 months ago   26.2MB
ubuntuserverdocker:443/jenkins-local    latest    1fd8e1b0bb7e   4 months ago   26.2MB
ubuntuserverdocker:5000/jenkins-local   lts       1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker login ubuntuserverdocker:443
Username: sudheer
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@ubuntuserverdocker:~# cat .docker/config.json
{
        "auths": {
                "ubuntuserverdocker:443": {
                        "auth": "c3VkaGVlcjp0ZXN0MTIzNA=="
                }
        }
}root@ubuntuserverdocker:~# docker push ubuntuserverdocker:443/jenkins-local:latest
The push refers to repository [ubuntuserverdocker:443/jenkins-local]
7b9a3910f3c3: Pushed
3764c3e89288: Pushed
b4592cba0628: Pushed
de9819405bcf: Pushed
9a5d14f9f550: Pushed
latest: digest: sha256:42043edfae481178f07aa077fa872fcc242e276d302f4ac2026d9d2eb65b955f size: 1363
root@ubuntuserverdocker:~#

#Now lets logout and check if we can push the image to secure repository
root@ubuntuserverdocker:~# cat .docker/config.json
{
        "auths": {
                "ubuntuserverdocker:443": {
                        "auth": "c3VkaGVlcjp0ZXN0MTIzNA=="
                }
        }
}root@ubuntuserverdocker:~# dockerlogout ubuntuserverdocker:443
Removing login credentials for ubuntuserverdocker:443
root@ubuntuserverdocker:~# cat .docker/config.json
{
        "auths": {}
}root@ubuntuserverdocker:~#docker push ubuntuserverdocker:443/jenkins-local:latest
The push refers to repository [ubuntuserverdocker:443/jenkins-local]
7b9a3910f3c3: Preparing
3764c3e89288: Preparing
b4592cba0628: Preparing
de9819405bcf: Preparing
9a5d14f9f550: Preparing
no basic auth credentials
root@ubuntuserverdocker:~#
```

### Reference:
- https://docs.docker.com/registry/insecure/
- [certs](https://www.sslshopper.com/article-most-common-openssl-commands.html)
- [Docker mirror registry](https://github.com/moby/moby/blob/v1.6.2/docs/sources/articles/registry_mirror.md)
- [openssl](https://phoenixnap.com/kb/openssl-tutorial-ssl-certificates-private-keys-csrs)