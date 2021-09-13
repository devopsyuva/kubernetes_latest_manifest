```
root@controlplane:~# wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
--2021-09-09 14:49:05--  https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
Resolving get.helm.sh (get.helm.sh)... 152.195.19.97, 2606:2800:11f:1cb7:261b:1f9c:2074:3c
Connecting to get.helm.sh (get.helm.sh)|152.195.19.97|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 13702117 (13M) [application/x-tar]
Saving to: ‘helm-v3.6.3-linux-amd64.tar.gz’

helm-v3.6.3-linux-amd64.tar.gz                        100%[======================================================================================================================>]  13.07M  --.-KB/s    in 0.1s    

2021-09-09 14:49:05 (113 MB/s) - ‘helm-v3.6.3-linux-amd64.tar.gz’ saved [13702117/13702117]

root@controlplane:~# 
root@controlplane:~# 
root@controlplane:~# 
root@controlplane:~# tar -xzvf helm-v3.6.3-linux-amd64.tar.gz 
linux-amd64/
linux-amd64/helm
linux-amd64/LICENSE
linux-amd64/README.md
root@controlplane:~# 
root@controlplane:~# cp linux-amd64/helm /usr/local/bin/

root@controlplane:~# helm version
version.BuildInfo{Version:"v3.6.3", GitCommit:"d506314abfb5d21419df8c7e7e68012379db2354", GitTreeState:"clean", GoVersion:"go1.16.5"}
root@controlplane:~#
```

```
root@controlplane:~# helm repo add stable https://charts.helm.sh/stable
"stable" has been added to your repositories
root@controlplane:~# helm repo ls
NAME    URL                          
stable  https://charts.helm.sh/stable
root@controlplane:~# helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
root@controlplane:~#
```


### Reference:
- [Helm Install](https://github.com/helm/helm/releases)
- [EFK](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/getting-started-with-logging-using-efk-on-kubernetes/ba-p/1333050)