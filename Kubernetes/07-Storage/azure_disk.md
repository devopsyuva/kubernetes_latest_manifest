# Azure Storage
## Azure Disks
**Traditional volumes are created as Kubernetes resources backed by Azure Storage. You can manually create data volumes to be assigned to pods directly, or have Kubernetes automatically create them. Data volumes can use Azure Disks or Azure Files.**
- Use Azure Disks to create a Kubernetes DataDisk resource. Disks can use:
  - Azure Premium storage, backed by high-performance SSDs, or
  - Azure Standard storage, backed by regular HDDs.
  - Note: **For most production and development workloads, use Premium storage.**
- Since Azure Disks are mounted as ReadWriteOnce, they're only available to a single pod. For storage volumes that can be accessed by multiple pods simultaneously, use Azure Files.
- For static volume using Azure Disks[https://docs.microsoft.com/en-us/azure/aks/azure-disk-volume]
- For dynamic volume using Azure Disks[https://docs.microsoft.com/en-us/azure/aks/azure-disks-dynamic-pv]
- Some of SKU names for Dynamic Disk StorageClass:
  - The default storage class provisions a standard SSD Azure disk.
    - Standard storage is backed by Standard SSDs and delivers cost-effective storage while still delivering reliable performance.
  - The managed-premium storage class provisions a premium Azure disk.
    - Premium disks are backed by SSD-based high-performance, low-latency disk. Perfect for VMs running production workload. If the AKS nodes in your cluster use premium storage, select the managed-premium class.
- **Important Note:** If you use one of the default storage classes, you can't update the volume size after the storage class is created. To be able to update the volume size after a storage class is created, add the line allowVolumeExpansion: true to one of the default storage classes, or you can create you own custom storage class. Note that it's not supported to reduce the size of a PVC (to prevent data loss). You can edit an existing storage class by using the kubectl edit sc command.
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: managed-premium-retain
provisioner: kubernetes.io/azure-disk
reclaimPolicy: Retain
volumeBindingMode: WaitFirstConsumer
allowVolumeExpansion: true
parameters:
  storageaccounttype: Premium_LRS
  kind: Managed
```

## Azure Files
**Use Azure Files to mount an SMB 3.0 share backed by an Azure Storage account to pods. Files let you share data across multiple nodes and pods and can use:**
- Azure Premium storage, backed by high-performance SSDs, or
- Azure Standard storage backed by regular HDDs.
- For static volume using Azure Files[https://docs.microsoft.com/en-us/azure/aks/azure-files-volume]
- For synamic volume using Azure Files[https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv]
- Some of SKU names for Dynamic File StorageClass:
  - Standard_LRS - standard locally redundant storage (LRS)
  - Standard_GRS - standard geo-redundant storage (GRS)
  - Standard_ZRS - standard zone redundant storage (ZRS)
  - Standard_RAGRS - standard read-access geo-redundant storage (RA-GRS)
  - Premium_LRS - premium locally redundant storage (LRS)
  - Premium_ZRS - premium zone redundant storage (ZRS)
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: my-azurefile
provisioner: kubernetes.io/azure-file
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=0
  - gid=0
  - mfsymlinks
  - cache=strict
  - actimeo=30
parameters:
  skuName: Standard_LRS
```

## [Storage types and capabilities](../src/images/aks-storage.PNG)

### References:
- [Azure Storage](https://docs.microsoft.com/en-us/azure/aks/concepts-storage)