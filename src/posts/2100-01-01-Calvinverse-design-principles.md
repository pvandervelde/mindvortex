Title: Calvinverse - Design principles
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---


- Design principles
  - Original code for everything is stored in source control, images, configs etc. etc. Everything should
    be in source control so that it is always possible to see what changes were made and to roll-back / branch etc.
  - Everything has a version, images, configs etc. Currently the items in the Consul K-V don't have a version but
    they really should
  - Secrets etc. should be handled in a safe way --> vault
    - All resources get their secrets from Vault in some way
    - Details: Some secrets haven't been automated yet. Should do that at some point. e.g. SSH and passwords for the
      admin users
  - Should never have to log into any of the VMs. VMs are made and then never 'changed' (immutable infrastructure). Any
    changes will be made to the repository, a new image will be made and once tested it will replace the existing production instances. This also allows adding more instances quickly if that becomes necessary.
    - Note that you can currently log into the resources through SSH or WinRM but we should really shut that down
  - Logs and metrics should be collected for everything so that diagnosing issues is possible without logging into the
    VMs
  - Using Consul as local DNS to contain environments. i.e. each 'environment' is determined by the consul master instances
    it connects to. This means you can have multiple environments, e.g. production and test, running on the same hardware
    in the same physical network (or even the same VLAN). Inside the environment the instances can refer to each other based
    on the consul name, e.g. active.build.service.mynetwork (assuming mynetwork is your consul domain name) and calls will only
    got to the instance that is in that environment
    - note that if you need strict separation then you'll need to use vlans etc. to achieve that

