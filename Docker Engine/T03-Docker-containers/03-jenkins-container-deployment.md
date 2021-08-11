## How to run jenkins CICD on container level in docker?
- Jenkins was one of most popular OpenSource CICD tools.
- Jenkins runs on Java, hudson was actual initiator of CICD and later it was named as Jenkins.
- Jenkins listens on Port 8080 by defaut and root directory location inside containers are /var/jenkins_home.
- Image preferred to use was **jenkins/jenkins:lts**.
```
#docker container run -d --name jenkins -p8090:8080 jenkins/jenkins:lts
#docker ps --> enusre it was running
```
- Once jenkins container was created, we need to configure the dashboard by accessing http://host-ip:8090.
```
# Go to brower and access URL: http://host-ip:8090
# Now get the initialAdminPassword from jenkins containers log by executing below command
docker container logs jenkins
or
# Login to jenkins container and get password from location "/var/jenkins_home/secrets/initialadminpassword" --> This file is temporary, utile we create admin user from setup wizard.
# Now select "Install suggested plugins", wait untile its done.
# After that, it will ask to create admin user. Pass necessary values and click on save and continue.
# Access jenkins with username/password as created above.
```