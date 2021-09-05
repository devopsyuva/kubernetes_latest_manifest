For headless Services, a cluster IP is not allocated, kube-proxy does not handle these Services, and there is no load balancing or proxying done by the platform for them.

With selectors:
===============
For headless Services that define selectors, the endpoints controller creates Endpoints records in the API, and modifies the DNS configuration to return records (addresses) that point directly to the Pods backing the Service.

Without selectors:
==================
For headless Services that do not define selectors, the endpoints controller does not create Endpoints records. However, the DNS system looks for and configures either:

CNAME records for ExternalName-type Services.
A records for any Endpoints that share a name with the Service, for all other types.

CLI:
https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run