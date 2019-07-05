Title: Calvinverse - An example build infrastructure
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---

This post introduces the [Calvinverse](https://www.calvinverse.net/)
[project](https://github.com/Calvinverse) which provides the source code for the different resources
required to create the infrastructure for a build pipeline. The Calvinverse resources have been
developed for two main reasons:

- To provide me with a way to experiment with and learn more about
  [immutable](https://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/) [infrastructure](https://twitter.com/jezhumble/status/970334897544900609) and
  [infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_code) as applied to build infrastructure.
- To provide resources that can be used to set up the infrastructure for a complete
  [on-prem](/posts/On-prem-vs-cloud-build-systems) build system. The system should provide a build
  controller with build agents, artefact storage and all the necessary tools to monitor the different
  services and diagnose issues.

The Calvinverse resources can be configured and deployed for different sizes of infrastructure, from
small setups only used by a few developers to a large setup used by many developers for the development
of many products. How to configure the resources for small, medium or large environments and their
hardware requirements will be discussed in future posts.

The resources in the Calvinverse project are designed to be run as a self-contained system. While
daily maintenance is minimal it is not a hosted system so some maintenance is required. For instance
OS updates will be required on a regular basis. These can either be applied to existing resources,
through the automatic updates, or by applying the new updates to the templates and then replacing
the existing resources with a new instance. The latter approach case can be automated, however there
is no code in any of the Calvinverse repositories to do this automatically.

The different resources in the Calvinverse project contain a set of tools and applications which
provide all the necessary capabilities to create the infrastructure for a build pipeline. Amongst these
capabilities are service discovery, build execution, artefact storage, metrics, alerting and
log processing.

The following applications and approaches are used for service discovery and configuration storage:

- Using [Consul](https://www.consul.io) to provide service discovery and machine discovery via
  [DNS](https://www.consul.io/docs/agent/dns.html) inside an environment. An environment is defined
  as all machines that are part of a [consul datacenter](https://www.consul.io/docs/internals/architecture.html).
  It is possible to have multiple environments where the machines may all be on the same network but
  in general will not be communicating across environments. This is useful for cases where having
  multiple environments makes sense, for instance when having a production environment and a test
  environment. The benefit of using Consul as a DNS is that it allows a resource to have a consistent
  name across different environments without the DNS names clashing. For instance if there is a
  production environment and a test environment then it is possible to use the same DNS name
  for a resource, even though the actual machine names will be different. This allows using the
  Consul DNS name in tools and scripts without having to keep in mind the environment the tool
  is deployed in.
  Finally Consul is also used for the distributed key-value store that all applications can obtain
  configuration information from thereby centralizing the configuration information.
- Using one or more [Vault](https://vaultproject.io) instance to handle all the secrets required
  for the environment. Vault provides authenticated access for resources to securely access secrets,
  login credentials and other information that should be kept secure. This allows centralizing the
  storage and distribution of secrets

For the build work Calvinverse uses the following applications:

- [Jenkins](https://jenkins.io) is used as the
  [build controller](https://github.com/Calvinverse/resource.build.master).
- Build executors connect to jenkins using the [swarm plugin](https://plugins.jenkins.io/swarm) so
  that agents can connect when it starts. In the Calvinverse project there are currently only
  [Windows](https://github.com/Calvinverse/resource.build.agent.windows) based executors.

For [artefact storage](https://github.com/Calvinverse/resource.artefacts) Calvin verse uses the
[Nexus](https://www.sonatype.com/nexus-repository-oss) application. The image is configured such that
a new instance of the image will create artefact repositories for [NuGet](https://www.nuget.org),
[Npm](https://www.npmjs.com/), [Docker](https://www.docker.com/) and general ZIP artefacts.

For [message distribution](https://github.com/Calvinverse/resource.queue) Calvinverse uses the [RabbitMQ](https://www.rabbitmq.com/) application. The image is configured such that a new instance of the image will
try to connect to the existing cluster in the environment. If no cluster exists then the first
instance of the image will form the start of the cluster in the environment.

Metrics, monitoring and alerting capabilities are provided by the
[Influx](https://www.influxdata.com/) stack, consisting of:

- [InfluxDB](https://www.influxdata.com/time-series-platform/) for
  [metrics collection](https://github.com/Calvinverse/resource.metrics.storage).
- [Grafana](https://grafana.com/) for [dashboards](https://github.com/Calvinverse/resource.metrics.dashboard).
- [Telegraf](https://www.rabbitmq.com/) is installed on each resource to collect metrics and send
  them to InfluxDb.
- [Chronograf](https://www.influxdata.com/time-series-platform/chronograf/) for
  [alert configurations](https://github.com/Calvinverse/resource.metrics.monitoring).
- [Kapacitor](https://www.influxdata.com/time-series-platform/kapacitor/) for
  [alerting](https://github.com/Calvinverse/resource.metrics.monitoring).

Build and system logs are processed by the [Elastic](https://www.elastic.co/) stack consisting off:

- [Elasticsearch](https://www.elastic.co/products/elasticsearch) for
  [log storage](https://github.com/Calvinverse/resource.documents.storage), both system logs
  and build logs
- [Kibana](https://www.elastic.co/products/kibana) for
  [log dashboards](https://github.com/Calvinverse/resource.documents.dashboard).
- Logs collected via [syslog-ng](https://www.syslog-ng.com/products/open-source-log-management/) on
  linux and a modified version of [filebeat](https://github.com/pvandervelde/filebeat.mqtt) on windows.
  Logs are sent to rabbitmq to ensure that the unprocessed logs aren't lost when something any part
  of the log stack goes offline.
- [Logstash](https://www.elastic.co/products/logstash) for
  [processing logs](https://github.com/Calvinverse/resource.logs.processor) from RabbitMQ to
  Elasticsearch using [filters](https://github.com/Calvinverse/calvinverse.logs.filters)

It should be noted that while the Calvinverse resources combine to create a complete build environment
the resources might need some alterations to fit in with the work flow and processes that are being
followed. After all each company is different and applies different workflows. Additionally users
might want to replace some of the resources with versions of their own, e.g. to replace Influx with
[Prometheus](https://prometheus.io/).
