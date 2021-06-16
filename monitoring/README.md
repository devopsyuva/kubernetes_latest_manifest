Reference for EFK stack:
========================
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes

Reference for Prometheus:
=========================
https://prometheus.io/docs/introduction/overview/

Alert manager:
==============
https://devopscube.com/alert-manager-kubernetes-guide/


Prometheus:

Image: https://prometheus.io/assets/architecture.png

Prometheus's main features are:

1)a multi-dimensional data model with time series data identified by metric name and key/value pairs
2)PromQL, a flexible query language to leverage this dimensionality
3)no reliance on distributed storage; single server nodes are autonomous
4)time series collection happens via a pull model over HTTP
5)pushing time series is supported via an intermediary gateway
6)targets are discovered via service discovery or static configuration
7)multiple modes of graphing and dashboarding support

Components
The Prometheus ecosystem consists of multiple components, many of which are optional:

1)the main Prometheus server which scrapes and stores time series data
2)client libraries for instrumenting application code
3)a push gateway for supporting short-lived jobs
4)special-purpose exporters for services like HAProxy, StatsD, Graphite, etc.
https://prometheus.io/docs/instrumenting/exporters/
5)an alertmanager to handle alerts
6)various support tools


Configuration explained: https://prometheus.io/docs/prometheus/latest/configuration/configuration/