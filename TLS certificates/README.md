Find the CA certificate on a pod in your cluster:
kubectl exec busybox -- ls /var/run/secrets/kubernetes.io/serviceaccount

Download the binaries for the cfssl tool:
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

Make the binary files executable:
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

Move the files into your bin directory:
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

Check to see if you have cfssl installed correctly:
cfssl version

Create a CSR file:
cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "my-svc.my-namespace.svc.cluster.local",
    "my-pod.my-namespace.pod.cluster.local",
    "172.168.0.24",
    "10.0.34.2"
  ],
  "CN": "visualpath.my-namespace.pod.cluster.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF

Create a CertificateSigningRequest API object:
cat <<EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: pod-csr.web
spec:
  groups:
  - system:authenticated
  request: $(cat server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

View the CSRs in the cluster:
kubectl get csr

View additional details about the CSR:
kubectl describe csr pod-csr.web

Approve the CSR:
kubectl certificate approve pod-csr.web

View the certificate within your CSR:
kubectl get csr pod-csr.web -o yaml

Extract and decode your certificate to use in a file:
kubectl get csr pod-csr.web -o jsonpath='{.status.certificate}' \
    | base64 --decode > server.crt


Reference: https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/
https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/