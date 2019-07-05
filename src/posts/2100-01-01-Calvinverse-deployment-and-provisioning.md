Title: Calvinverse - Deployment and provisioning
Tags:
  - Delivering software
  - Deployment
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
  - Provisioning
---


- Deployment of resources is done by creating a new VM with the VHD(X) files and sensible settings
  - Exact settings depend on the global infrastructure (e.g. network settings) and the resource (e.g.
    number of disks attached, RAM and CPU etc.)
  - Standard settings
    - For Gen 2:
      - Secure boot enabled. For windows use the MS cert, otherwise use the other one
    - For Gen 1:
      - No secure boot
      - Boot order is from disk first, CD last
- Provisioning: Resources need some information provided on boot to determine which environment they
  belong to. For VMs this is done by attaching a CD / DVD ISO file with some standard configuration
  files for the environment that the resource belongs to.
  - The ISO contains the environment configurations for [Consul](https://consul.io) and [Unbound](). Consul is required
    to allow it to connect to the correct environment and unbound so that we can resolve DNS addresses
    outside the consul environment (i.e. the internet)
  - All other configurations come from the Consul K-V and will be loaded as soon as consul connects.
    Generally done via [Consul-Template]()
  - Some applications need secrets as well as configuration values. In that case Consul-Template will
    have to pull them from Vault. This requires that Consul-Template has access to Vault. This is 
    done by providing it an authentication token. The token is wrapped and stored in the K-V. The 
    wrapper expires after X time (say 1 minute). Consul-Template watches the K-V and grabs the
    wrapper and unwraps the access token. With this access token consul-template can access
    all the secrets it needs for the resource it is linked to (but not other secrets).