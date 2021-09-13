# NFS server setup for Kubernetes Volume Backup Storage

## Manual
```
NFS server configuration:

Lets say my NFS server IP address: 192.168.0.50
Client: 192.168.0.51

Setup NFS server:
#apt-get update
#apt-get install -y nfs-kernel-server

Lets create shared directory on NFS server to clients:
#mkdir -p /var/nfs/data
#chown nobody:nogroup /var/nfs/data

Note: NFS will translate any root operations on the client to the nobody:nogroup
credentials as a security measure. Therefore, we need to change the directory
ownership to match those credentials.

Now export created shared directory:
#vi/nano /etc/exports
add below entries based on your configuration
++
/var/nfs/data    192.168.0.51(rw,sync,no_subtree_check)
/home       192.168.0.51(rw,sync,no_root_squash,no_subtree_check) --> optional
++

save and exit

rw: This option gives the client computer both read and write access to the volume.
sync: This option forces NFS to write changes to disk before replying. This
results in a more stable and consistent environment since the reply reflects the
actual state of the remote volume. However, it also reduces the speed of file operations.
no_subtree_check: This option prevents subtree checking, which is a process
where the host must check whether the file is actually still available in the
exported tree for every request. This can cause many problems when a file is
renamed while the client has it opened. In almost all cases, it is better to
disable subtree checking.
no_root_squash: By default, NFS translates requests from a root user remotely
into a non-privileged user on the server. This was intended as security feature
to prevent a root account on the client from using the file system of the host
as root. no_root_squash disables this behavior for certain shares.

Now restart nfs service as mentioned below:
#systemctl restart nfs-kernel-server

Setup on Client side:
#apt update
#apt-get install -y nfs-common

Now create on directory to moun the NFS path or we can use /mnt directory to
mount:
#mkdir -p /nfs/general
#mount 192.168.0.50:/var/nfs/data /nfs/general

verify the mounted path to client with below command:
#df -h

Note: After next reboot mount path will be removed, so in-order to make it
permanent add the mount entries of NFS server to the client server in fstab
file.

#vi /etc/fstab
++
192.168.0.50:/var/nfs/data    /nfs/general   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
192.168.0.50:/home       /nfs/home      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
++
Save and exit

TroubleShooting:
================
Disabling ID mapping on NFSv4

On both the NFS client and server, run:

# echo 'Y' > /sys/module/nfsd/parameters/nfs4_disable_idmapping
```

## Shell Script to Automate
```
#!/bin/bash

# This script should be executed on Linux Ubuntu Virtual Machine

EXPORT_DIRECTORY=${1:-/export/data}
DATA_DIRECTORY=${2:-/data}
AKS_SUBNET=${3:-*}

echo "Updating packages"
apt-get -y update

echo "Installing NFS kernel server"

apt-get -y install nfs-kernel-server

echo "Making data directory ${DATA_DIRECTORY}"
mkdir -p ${DATA_DIRECTORY}

echo "Making new directory to be exported and linked to data directory: ${EXPORT_DIRECTORY}"
mkdir -p ${EXPORT_DIRECTORY}

echo "Mount binding ${DATA_DIRECTORY} to ${EXPORT_DIRECTORY}"
mount --bind ${DATA_DIRECTORY} ${EXPORT_DIRECTORY}

echo "Giving 777 permissions to ${EXPORT_DIRECTORY} directory"
chmod 777 ${EXPORT_DIRECTORY}

parentdir="$(dirname "$EXPORT_DIRECTORY")"
echo "Giving 777 permissions to parent: ${parentdir} directory"
chmod 777 $parentdir

echo "Appending bound directories into fstab"
echo "${DATA_DIRECTORY}    ${EXPORT_DIRECTORY}   none    bind  0  0" >> /etc/fstab

echo "Appending localhost and Kubernetes subnet address ${AKS_SUBNET} to exports configuration file"
echo "/export        ${AKS_SUBNET}(rw,async,insecure,fsid=0,crossmnt,no_subtree_check)" >> /etc/exports
echo "/export        localhost(rw,async,insecure,fsid=0,crossmnt,no_subtree_check)" >> /etc/exports

nohup service nfs-kernel-server restart
```