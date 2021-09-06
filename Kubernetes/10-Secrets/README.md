Secrets are used to store and pass the sensitive information to the
application deployment.
We use multiple ways to do that, lets list all the possibles ways to create
secrets:
1)create a secret through yaml file as below:
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
data:
  username: bXktYXBw
  password: Mzk1MjgkdmRnN0pi  --> encrypted data with base64

2)Lets create secrets from CLI using literal method
kubectl create secret generic backend-user --from-literal=backend-username='backend-admin' --from-literal=mysqldb_root_password='test1234'

3)We can also pass file with out data and create the secrets:
kubectl create secret generic my-secret --from-file=path/to/bar

Help output:
root@kubernetesmaster:~# kubectl create secret
Create a secret using specified subcommand.

Available Commands:
  docker-registry Create a secret for use with a Docker registry
  generic         Create a secret from a local file, directory or literal value
  tls             Create a TLS secret

Usage:
  kubectl create secret [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
root@kubernetesmaster:~#

---
Examples:
  # Create a new secret named my-secret with keys for each file in folder bar
  kubectl create secret generic my-secret --from-file=path/to/bar

  # Create a new secret named my-secret with specified keys instead of names on disk
  kubectl create secret generic my-secret --from-file=ssh-privatekey=path/to/id_rsa --from-file=ssh-publickey=path/to/id_rsa.pub

  # Create a new secret named my-secret with key1=supersecret and key2=topsecret
  kubectl create secret generic my-secret --from-literal=key1=supersecret --from-literal=key2=topsecret

  # Create a new secret named my-secret using a combination of a file and a literal
  kubectl create secret generic my-secret --from-file=ssh-privatekey=path/to/id_rsa --from-literal=passphrase=topsecret

  # Create a new secret named my-secret from an env file
  kubectl create secret generic my-secret --from-env-file=path/to/bar.env

Examples:
# Create a new TLS secret named tls-secret with the given key pair:
kubectl create secret tls tls-secret --cert=path/to/tls.cert --key=path/to/tls.key

or

kubectl create secret tls NAME --cert=path/to/cert/file --key=path/to/key/file [--dry-run]