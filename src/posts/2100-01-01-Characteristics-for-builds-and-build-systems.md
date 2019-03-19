Title: Characteristics for builds and build systems
Tags:
  - Building software
  - Build server
  - Configuration-as-code
  - DevOps
---

What are the important characteristics for builds and build systems

* Should be able to run a build on any machine. Ideally no tools need to be installed so you can just
  build on a fresh OS install.
  * This means that you are independent of your build system because you can always build
  * Some steps may be hard when not on a build system, e.g. signing with the proper certificates / keys,
    and some may not be desirable when not on a build system, e.g. making changes to source control
    in the local workspace (i.e. local merges / branching / commits).
  * Requires that you can pull all the tools down. Which probably means you need some kind of entrypoint
    script to pull down the initial tools and scripts. This entrypoint script should be as small as
    possible and able to update itself. That way you can still version all the scripts and tools
    (because they are pulled down) and don't need to add everything to the repository
* Builds should be as independent as possible from the infrastructure with minimal requirements.
  It is better to not rely on the presence of different services because those are points of failure.
  - For those services that are absolutely required it is important that these are highly available
