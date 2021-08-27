# Secure Docker local registry container
- By default, images are pushed and pulled from the local registry container without any authentication.
- To secure the communication, pull and push should happen with authentication mechanisam as provided below.
- If you want to customize the port listening by registry container, use environment variables "-e REGISTRY_HTTP_ADDR=0.0.0.0:5001" while creating container.
```
root@ubuntuserverdocker:~# mkdir $HOME/certs
root@ubuntuserverdocker:~# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs/tls.key -out certs/tls.crt -subj "/CN=ubuntuserverdocker"
Generating a RSA private key
......................................................................................+++++
.............................................+++++
writing new private key to 'certs/tls.key'
-----
root@ubuntuserverdocker:~# ls -l certs/
total 8
-rw-r--r-- 1 root root 1139 Aug 27 11:38 tls.crt
-rw------- 1 root root 1704 Aug 27 11:38 tls.key
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# vi /etc/docker/daemon.json
root@ubuntuserverdocker:~# cat /etc/docker/daemon.json
{
  "insecure-registries": ["192.168.1.50:443", "ubuntuserverdocker:443"]
}
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker run -d \
>   --restart=always \
>   --name registry \
>   -v "$(pwd)"/certs:/certs \
>   -v docker_registry:/var/lib/registry \
>   -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
>   -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/tls.crt \
>   -e REGISTRY_HTTP_TLS_KEY=/certs/tls.key \
>   -p 443:443 \
>   registry:2
3d801f9b03e1a05da37f4e0685e18a2abb66445e18331b86d267e4fe3d23066e
root@ubuntuserverdocker:~# docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS         PORTS                                             NAMES
3d801f9b03e1   registry:2   "/entrypoint.sh /etc…"   3 seconds ago   Up 2 seconds   0.0.0.0:443->443/tcp, :::443->443/tcp, 5000/tcp   registry
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker image ls
REPOSITORY                     TAG       IMAGE ID       CREATED        SIZE
localhost:5000/jenkins-local   lts       619aabbe0502   2 days ago     441MB
registry                       2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker image tag localhost:5000/jenkins-local:lts ubuntuserverdocker:443/jenkins-local:lts
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker image ls
REPOSITORY                             TAG       IMAGE ID       CREATED        SIZE
localhost:5000/jenkins-local           lts       619aabbe0502   2 days ago     441MB
ubuntuserverdocker:443/jenkins-local   lts       619aabbe0502   2 days ago     441MB
registry                               2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker push ubuntuserverdocker:443/jenkins-local:lts
The push refers to repository [ubuntuserverdocker:443/jenkins-local]
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
```

## Lets clean all images and pull from secured docker local registry for image "jenkins-local:lts"
```
root@ubuntuserverdocker:~# docker image ls
REPOSITORY                             TAG       IMAGE ID       CREATED        SIZE
localhost:5000/jenkins-local           lts       619aabbe0502   2 days ago     441MB
ubuntuserverdocker:443/jenkins-local   lts       619aabbe0502   2 days ago     441MB
registry                               2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~# docker image rm ubuntuserverdocker:443/jenkins-local:lts
Untagged: ubuntuserverdocker:443/jenkins-local:lts
Untagged: ubuntuserverdocker:443/jenkins-local@sha256:c6c5474940690d8ca872fa300524bf194b1b3c8743482bc439dfc835c11c9ddf
root@ubuntuserverdocker:~# docker image rm localhost:5000/jenkins-local:lts
Untagged: localhost:5000/jenkins-local:lts
Untagged: localhost:5000/jenkins-local@sha256:c6c5474940690d8ca872fa300524bf194b1b3c8743482bc439dfc835c11c9ddf
Deleted: sha256:619aabbe0502d69b049b7543cda1f374fe381f425d5410680a9003d8620ddd98
Deleted: sha256:5ad9522c89dd18890e769c8cc9ea897211aa2df5bba093f708bbf65a00163a51
Deleted: sha256:da7776582a1e12b8b75d4916c85c21ddaefa1b7503d2f39cdf3f13e251028851
Deleted: sha256:55a9fb8546393ed326496aca5286cf79eb4f552606d5f9c76ba71187736854e5
Deleted: sha256:bdc388e0560a82be90b2feb2245cb979c08f12c00efeae754a8c0ec63d82e6cf
Deleted: sha256:bb0110b26f0f5cf131f7a92deb665488fb1962a9ca3965acbbbda6c0b738b92a
Deleted: sha256:394ee58ccf2fa5708bfd4f4774aada6206eb6895466f86fa393b46f7b3a44cd9
Deleted: sha256:68713763fa690e1fe74aa52a887f8fd9babccdf218d3520975e141b5a2b9b3e0
Deleted: sha256:6b9459ed3369dc2205da1487033fd5548b048e168c4b700da77982f2f1a2c69a
Deleted: sha256:6fa45bfd1ab9089537001fc5809aa9e8dc3b2bd49b2805dd66aecb4aa8593274
Deleted: sha256:78b9ff9dfdab0addd3535504a933bc36c97b552bfb3aeb17e0654251ee988427
Deleted: sha256:3efa8104a3ec96b9ea10aaa39bbddf30f3abc8ee5a23095d60ae2e3224633dcc
Deleted: sha256:e8edcf0252603b3d0ec345757de20de670510398f9361ff38a82dd5cb210a1a9
Deleted: sha256:159440e17ffa3a2a5d49203ee6f196033ca2bfcd2c88f5351a3d05d467a39124
Deleted: sha256:856768534439b02399e888a29bd95e431d891175f4001873a1db34a690f63383
Deleted: sha256:4b60eeee7be1add63308203fbc26ccf27d711cb94e2dadcdd7c799793f478722
Deleted: sha256:aa8e217907805131972007c0598d2434f73ec12d51e83d69f2bb822288fc3af1
Deleted: sha256:a881cfa23a7842d844818a1cb4d8460a7396b94fdc0bc4091f8d79b8f4f81c3e
root@ubuntuserverdocker:~# docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
registry     2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#
root@ubuntuserverdocker:~# docker pull ubuntuserverdocker:443/jenkins-local:lts
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
Status: Downloaded newer image for ubuntuserverdocker:443/jenkins-local:lts
ubuntuserverdocker:443/jenkins-local:lts
root@ubuntuserverdocker:~#

root@ubuntuserverdocker:~# docker image ls
REPOSITORY                             TAG       IMAGE ID       CREATED        SIZE
ubuntuserverdocker:443/jenkins-local   lts       619aabbe0502   2 days ago     441MB
registry                               2         1fd8e1b0bb7e   4 months ago   26.2MB
root@ubuntuserverdocker:~#
```

## Lets check by accessing with any other port and even IP address of the docker host on port 5000 and 433
```
root@ubuntuserverdocker:~# docker pull loaclhost:5000/jenkins-local:lts
Error response from daemon: Get https://loaclhost:5000/v2/: dial tcp: lookup loaclhost: Temporary failure in name resolution
root@ubuntuserverdocker:~# docker pull 192.168.1.50:5000/jenkins-local:lts
Error response from daemon: Get https://192.168.1.50:5000/v2/: dial tcp 192.168.1.50:5000: connect: connection refused
root@ubuntuserverdocker:~# docker pull 192.168.1.50:443/jenkins-local:lts
Error response from daemon: Get https://192.168.1.50:443/v2/: x509: cannot validate certificate for 192.168.1.50 because it doesn't contain any IP SANs
root@ubuntuserverdocker:~#

#Above failure was because, certs are generated only for domain name "ubuntuserverdocker" not for IP address. Add below one while created cert for IP address as well.

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