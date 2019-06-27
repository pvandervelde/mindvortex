Title: Calvinverse - An example build infrastructure
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---

- Introducing: [Calvinverse](https://www.calvinverse.net/). The project where I store the source code
  for my build infrastructure.
- The goals for Calvinverse are two-fold.
  - First to provide me with a way to experiment with build infrastructure, infrastructure-as-code etc. etc.
  - Second to provide an example of how to setup build infrastructure so that it works well and is reliable.
    - Should be able to set it up on both on-prem and in the cloud

## Why would I use this

- Can just use online systems. Don't have to maintain those
  - but also don't get to configure them as you see fit
  - Only get the build outputs, not the ability to modify the system
- Want to keep everything on-prem for what ever reason (maybe you're in an area with crappy network, or there are
  regulatory / legal reasons for keeping everything on-prem)
- Need to have custom build agents, either because you need specific tools / libraries / applications installed
- Need to have control over the agents (eventhough they're not custom) because the contain secrets or because they need
  access to the internal network

## Layouts

- Different ways to use Calvinverse:
    - For small setups with only a few developers and a few products
    - For medium setups with a larger number of developers or lots of products
    - For large setups with a large number of developers and a lot of products
        

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
- Design principles
  - Original code for everything is stored in source control, images, configs etc. etc. Everything should
    be in source control so that it is always possible to see what changes were made and to roll-back / branch etc.
  - Secrets etc. should be handled in a safe way --> vault
  - Should never have to log into any of the VMs. VMs are made and then never 'changed' (immutable infrastructure). Any
    changes will be made to the repository, a new image will be made and once tested it will replace the existing production
    instances. This also allows adding more instances quickly if that becomes necessary
  - Logs and metrics should be collected for everything so that diagnosing issues is possible without logging into the
    VMs
  - Using Consul as local DNS to contain environments. i.e. each 'environment' is determined by the consul master instances
    it connects to. This means you can have multiple environments, e.g. production and test, running on the same hardware
    in the same physical network (or even the same VLAN). Inside the environment the instances can refer to each other based
    on the consul name, e.g. active.build.service.mynetwork (assuming mynetwork is your consul domain name) and calls will only
    got to the instance that is in that environment
    - note that if you need strict separation then you'll need to use vlans etc. to achieve that

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
- Image repositories. Contain code to create the VM images. Work in progress to make them able to go
  to Azure if necessary
  - With some minor changes could also create images for AWS etc. Images are made using [Packer]() so
    anything packer can create can be made