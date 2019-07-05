Title: Calvinverse - Configurations
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---



## Repositories

- Configurations are stored in different repositories
  - General configurations, mostly setting information for the different resources. While the environment
    is running will be stored in the Consul key-value store. The original values are stored in the
    [Calvinverse.Infrastructure]() repository
  - Dashboards
  - Log filters
  - Elasticsearch index templates
- Ideally builds will be configured so that a change to the configuration will be tested and pushed
  to a suitable test environment