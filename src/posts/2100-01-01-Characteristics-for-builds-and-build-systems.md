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
  * Allows developers to build locally to dev test the product
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
* Security is a big issue (one I don't know enough about, other than to be weary / scared)
  * Using a flexible build engine like MsBuild, rake, cake etc. is great if
    * Every developer is confident with the engine
    * You implicitly trust every developer (possible in a commercial setting, unlikely in OSS)
  * More likely want a build system that has a trust relation between the engine and the tasks
  * The artefact creation process should be tracable so that you know where the artefacts came from
    * Ideally you need to know exactly what went into the artefact without there being the possiblity
      for unknown additions. Note that this ability is hard to achieve due to the nature of
      build systems.
