A PV will be provisioned by administrator to store the data Persistence,
which means data will be available even after POD deletion.
We can also provision the PV dynamically using Storage Classes.

A PersistentVolumeClaim (PVC) is a request for storage by a user.
It is similar to a pod. Pods consume node resources and PVCs consume
PV resources. Pods can request specific levels of resources (CPU and Memory).
Claims can request specific size and access modes (e.g., can be mounted once
read/write or many times read-only).

As updated earlier, PVs can be provisioned in two ways:

Static and Dynamic

Static PV are provisioned by cluster administrator, which can be managed by
kubernetes api-server

Dynamic PV are created when none of the PV exists created by administrator,
it will provision the dynamic PV in the background.

We have three types of reclaim policies:

Retain, Delete and Recycle

The Retain reclaim policy (manual reclamation) allows for manual reclamation of the resource.
When the PersistentVolumeClaim is deleted, the PersistentVolume still exists
and the volume is considered “released”. But it is not yet available for
another claim because the previous claimant’s data remains on the volume.
An administrator can manually reclaim the volume with the following steps.

1)Delete the PersistentVolume. The associated storage asset in external
infrastructure still exists after the PV is deleted.
2)Manually clean up the data on the associated storage asset accordingly.
3)Manually delete the associated storage asset, or if you want to reuse the
same storage asset, create a new PersistentVolume with the storage asset definition.

For Delete policy, For volume plugins that support the Delete reclaim policy,
deletion removes both the PersistentVolume object from Kubernetes, as well as
the associated storage asset in the external infrastructure, such as an AWS
EBS, GCE PD, Azure Disk, or Cinder volume.

For recycle, If supported by the underlying volume plugin, the Recycle reclaim
policy performs a basic scrub (rm -rf /thevolume/*) on the volume and makes it
available again for a new claim.

Resizing the in-use PersistentVolumeClaim:

In this case, you don’t need to delete and recreate a Pod or deployment that
is using an existing PVC. Any in-use PVC automatically becomes available to
its Pod as soon as its file system has been expanded. This feature has no effect
on PVCs that are not in use by a Pod or deployment. You must create a Pod that
uses the PVC before the expansion can complete.


Note: Currently, only NFS and HostPath support recycling. AWS EBS, GCE PD, Azure Disk, and Cinder volumes support deletion.

The access modes are:

ReadWriteOnce – the volume can be mounted as read-write by a single node
ReadOnlyMany – the volume can be mounted read-only by many nodes
ReadWriteMany – the volume can be mounted as read-write by many nodes

Volume status:
Available – a free resource that is not yet bound to a claim
Bound – the volume is bound to a claim
Released – the claim has been deleted, but the resource is not yet reclaimed by the cluster
Failed – the volume has failed its automatic reclamation

A VolumeSnapshotContent is a snapshot taken from a volume in the cluster that has been provisioned by an administrator. It is a resource in the cluster just like a PersistentVolume is a cluster resource.

A VolumeSnapshot is a request for snapshot of a volume by a user. It is similar to a PersistentVolumeClaim.

VolumeSnapshotClass allows you to specify different attributes belonging to a VolumeSnapshot. These attributes may differ among snapshots taken from the same volume on the storage system and therefore cannot be expressed by using the same StorageClass of a PersistentVolumeClaim.

Files or directories created with HostPath on the host are only writable by root. Which means, you either need to run your container process as root or modify the file permissions on the host to be writable by non-root user, which may lead to security issues

You should NOT use hostPath volume type for StatefulSets

References:
https://docs.openshift.com/container-platform/3.5/install_config/storage_examples/ceph_rbd_dynamic_example.html
https://docs.openshift.com/container-platform/4.4/storage/persistent_storage/persistent-storage-local.html
