Title: Calvinverse - Small setup
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---


- Only need a jenkins master + one or two slaves, probably ideally a VM (easier to manage) and maybe
    a file share for NuGet packages
    - 1 Consul master -> so that the agents can find the master + configurations
    - 1 Vault instance -> for secret management
    - 1 Jenkins master
    - 1 Jenkins agent
    - 1 file share -> nuget and artefact storage
    - 1 proxy instance -> for easy access to jenkins
- Don't have
    - Log storage for system logs and / or build logs
    - Metrics for system and services
    - Redundancy
    - A way to test changes

- Configuration
- Extensions
    - Add RabbitMQ + Elasticsearch for logs
    - Add Influx for metrics
    - Add more agents

- Doesn't have
    - Way to test changes. Everything will be done in live environment

## Hardware

- Can run on a quad core with 32Gb of RAM
- No redundancy, but at this level you probably don't need it