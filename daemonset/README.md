A DaemonSet ensures that all (or some) Nodes run a copy of a Pod.
As nodes are added to the cluster, Pods are added to them. As nodes
are removed from the cluster, those Pods are garbage collected.
Deleting a DaemonSet will clean up the Pods it created.


Update image of all containers of daemonset abc to 'nginx:1.9.1'
#kubectl set image daemonset abc *=nginx:1.9.1

We can set the labels for different objects as mentioned below:

Examples:
  # Update pod 'foo' with the label 'unhealthy' and the value 'true'.
  kubectl label pods foo unhealthy=true

  # Update pod 'foo' with the label 'status' and the value 'unhealthy', overwriting any existing value.
  kubectl label --overwrite pods foo status=unhealthy

  # Update all pods in the namespace
  kubectl label pods --all status=unhealthy

  # Update a pod identified by the type and name in "pod.json"
  kubectl label -f pod.json status=unhealthy

  # Update pod 'foo' only if the resource is unchanged from version 1.
  kubectl label pods foo status=unhealthy --resource-version=1

  # Update pod 'foo' by removing a label named 'bar' if it exists.
  # Does not require the --overwrite flag.
  kubectl label pods foo bar-

From 1.6 we can do rolling updates.
#kubectl set image ds/frontend webserver=httpd

