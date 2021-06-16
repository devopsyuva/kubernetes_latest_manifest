To secure the connection we use certificates while communicating to the
components like k8s and application deployed on the cluster.

To generate and use our own certificates, instead of repying on default
certificates we can follow the procedure mentioned below.


For example:

we can secure an Ingress by specifying a Secret that contains a TLS private
key and certificate. Currently the Ingress only supports a single TLS port,
443, and assumes TLS termination. If the TLS configuration section in an
Ingress specifies different hosts, they are multiplexed on the same port
according to the hostname specified through the SNI TLS extension (provided
the Ingress controller supports SNI). The TLS secret must contain keys named
tls.crt and tls.key that contain the certificate and private key to use for
TLS.

Example:
++
apiVersion: v1
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
kind: Secret
metadata:
  name: default-ssl-certificate
  namespace: ingress-nginx
type: Opaque
++

or

++
apiVersion: v1
kind: Secret
metadata:
  name: testsecret
  namespace: default
data:
  tls.crt: <base64_encoded_cert>
  tls.key: <base64_encoded_key>
type: Opaque
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: example
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  tls:
  - hosts:
    - example.com
    secretName: testsecret
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: service1
          servicePort: 80
++

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}


References:
https://docs.bitnami.com/kubernetes/how-to/secure-kubernetes-services-with-ingress-tls-letsencrypt/
https://success.docker.com/article/how-to-configure-a-default-tls-certificate-for-the-kubernetes-nginx-ingress-controller
https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/tls.md