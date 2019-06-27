Title: Calvinverse - Medium setup
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---

- Need a jenkins master + a number of slaves, possibly use docker containers
    - 3 consul masters
    - 1 Vault instance
    - 1 Jenkins master
    - Multiple Jenkins agents
    - Rabbitmq
    - logstash
    - Elasticsearch
    - Influx
    - Grafana


## Hardware

- Minimum is 6 core with 64Gb of RAM but probably want more.
- If you need redundancy then it would be wise to have two or three (smaller) machines.
  - In that case use 3 so that each consul host can go on it's own machine. That way
    the cluster can survive a restart of one of the physical hosts. Note that if multiple hosts
    restart all at the same time you might still be in trouble
- 