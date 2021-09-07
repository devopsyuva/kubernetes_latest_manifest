# Install Docker Engine CE on Ubuntu 20.04 LTS server machine

1) Login to ubuntu machine (virtual or baremetal)

2) Run update and upgrade commands to ensure server was up to date
```
#apt update
#apt dist-upgrade
```

3) Now check if we have any old docker package installed, for new host machine spinned up its not required but its better to check once
```
This command will remove packages if any
#apt-get remove docker docker-engine docker.io containerd runc
Note: I have execute commands as root user, use sudo before command for sudo users

Execute below command to delete docker root directory if any
#rm -rf /var/lib/docker
```

4) Install basic packages which are need to proceed further
```
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

5) Download docker GPG keys as we are using OpenSource package
```
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

6) Create a Docker stable repository on host and run update command before downloading Docker Engine CE packages
```
#echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#apt update
```

7) Now final step to install Docker Engine CE from docker respository created in step 6
```
#apt-get install docker-ce docker-ce-cli containerd.io

After successful execution, check docker version installed
#docker --version
```