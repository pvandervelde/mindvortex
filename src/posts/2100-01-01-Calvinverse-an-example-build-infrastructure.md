Title: Calvinverse - An example build infrastructure
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---

- Introducing: [Calvinverse](http://www.calvinverse.net/). The project where I store the source code
  for my build infrastructure.
- The goals for Calvinverse are two-fold.
  - First to provide me with a way to experiment with build infrastructure, infrastructure-as-code etc. etc.
  - Second to provide an example of how to setup build infrastructure so that it works well and is reliable.

- Different ways to use Calvinverse:
    - For small setups with only a few developers and a few products
        - Only need a jenkins master + one or two slaves, probably ideally a VM (easier to manage) and maybe
          a file share for NuGet packages
    - For medium setups with a larger number of developers or lots of products
        - Need a jenkins master + a number of slaves, possibly use docker containers
    - For large setups with a large number of developers and a lot of products
        - Need both a production and a test environment
        - Teams need to be able to create their own build slaves

- Calvinverse is designed as a self-maintained system. It's not a hosted system. Daily maintenance is
  minimal. OS updates are required on a regular basis. These can either be applied on the existing
  resources or done via replacing the resources with a newer version with all the updates. The latter
  approach can be automated.
- Not a drop-in-and-forget-about-it system. It's a complete build environment but it will most likely need
  tweaking because every company is different and applies different workflows
  - The design has opinions, especially with regards to the different applications that are used, e.g.
    most of the Hashicorp tools are used: [Consul]() for service discovery and as distributed key-value
    store, [Vault]() as secret management system
- Currently have a full system set up on a quad core Hyper-V host. It works but it's not the best
  performance. Minimal hardware requirements are probably 6 core + 64Gb RAM for the host machine

## Characteristics

- Using Consul to provide service discovery and machine discovery via DNS inside an environment.
  Environment is defined as all machines that are part of a [consul datacenter](). It is possible
  to have multiple environments where the machines may all be on the same network but in general
  will not be communicating across environments. This is useful for cases as having a production
  environment and a test environment.
  - The benefit of using Consul as a DNS is that it allows a resource to have a consistent name
    across different environments without the DNS names clashing. For instance if there is a
    production environment and a test environment then it is possible to use the same DNS name
    for a resource, eventhough the actual machine names will be different. This allows using the
    Consul DNS name in tools and scripts without having to keep in mind the environment the tool
    is deployed in.

## Environments

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
