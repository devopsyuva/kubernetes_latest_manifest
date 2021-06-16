What is elasticsearch?
Elasticsearch is a distributed, open source search and analytics engine
for all types of data, including textual, numerical, geospatial, structured,
and unstructured. Elasticsearch is the central component of the Elastic Stack,
a set of open source tools for data ingestion, enrichment, storage, analysis,
and visualization. Commonly referred to as the ELK Stack (after Elasticsearch,
Logstash, and Kibana), the Elastic Stack now includes a rich collection of
lightweight shipping agents known as Beats for sending data to Elasticsearch.

what is fluentbit?
Fluent Bit is a Fast and Lightweight Log Processor and Forwarder for Linux,
OSX and BSD family operating systems. It has been made with a strong focus
on performance to allow the collection of events from different sources without complexity.

Difference between fluentbit vs fluentd:
https://docs.fluentbit.io/manual/about/fluentd_and_fluentbit

lets create pv for master and client for elasticsearch:
kubectl create -f pv.yaml

Now let us deploy the helm charts:

helm install elasticsearch-client elastic/elasticsearch \
  --set client.replicas=1 \
  --set master.replicas=1 \
  --set cluster.env.MINIMUM_MASTER_NODES=1 \
  --set cluster.env.RECOVER_AFTER_MASTER_NODES=1 \
  --set cluster.env.EXPECTED_MASTER_NODES=1 \
  --set data.replicas=1 \
  --set data.heapSize=300m \
  --set master.persistence.storageClass=elasticsearch-master \
  --set master.persistence.size=5Gi \
  --set data.persistence.storageClass=elasticsearch-data \
  --set data.persistence.size=5Gi

Deploy Fluent bit:

helm install fluent-bit fluent/fluent-bit --set backend.type=es --set backend.es.host=elasticsearch-master

Deploy Kibana with NodePort enabled for the service:

helm install kibana elastic/kibana --set env.ELASTICSEARCH_HOSTS=http://elasticsearch-master:9200 --set service.type=NodePort --set service.nodePort=31000

Now lets generate some random logs by creating the sample POD:
kubectl run random-logger --image=chentex/random-logger --generator=run-pod/v1


Check cluster health:
CLUSTER_IP=$(kubectl get svc | grep '.*-client' | awk '{print $3}') \
 && curl http://$CLUSTER_IP:9200/_cluster/health?pretty



helm charts for kibana, elasticsearch:
https://github.com/elastic/helm-charts/tree/master/elasticsearch
https://github.com/elastic/helm-charts/tree/master/kibana

