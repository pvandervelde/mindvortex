Title: Calvinverse - Large setup
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---

- Need both a production and a test environment
- Teams need to be able to create their own build slaves
- High availability to ensure that outages of individual instances don't affect the development team
- Prod environment should have at least
  - 3 Consul masters
  - 2 or more Vault instances
  - 3 RabbitMQ instances
  - 3 Elasticsearch instances (or more if you process more logs)
  - 2 or more Logstash instances
  - 1 or more Kibana instances
  - 1 Jenkins master (active)
  - 1 or more Jenkins masters (standby)
  - Multiple Jenkins agents
  - 2 or more proxy instances for people to use as interaction entrypoint
  - 1 or more Influx masters
  - 1 or more Grafana instances
  - 1 or more artefact storage
  - 1 or more backup / sync instances
  - Alerting 



## Addtional

- Might want additional services that integrate with the development process
  - E.g. at work we have services that process notifications from all kinds of sources, e.g. source control notifications etc.

## Hardware

- Ideally 3 hosts, so that you can distribute the VMs in a redundant fashion
- Amount of CPU and RAM depends on how many agents end up being made
- Need to keep in mind that a test environment is a sensible thing to have so that changes can be tested
  - Note that the test environment doesn't need to be as large as the production environment but it should
    be a match in that it has all the same components. Ideally it'll have redundant instances so that
    cut-over etc. can be tested as well
