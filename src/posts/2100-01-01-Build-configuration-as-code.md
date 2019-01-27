Title: Build configuration as code
Tags:
  - Building software
  - Build server
  - Configuration-as-code
  - DevOps
---

- Build systems generally allow users to configure their builds through a pretty UI. This makes it
  easy to quickly create a new build or to update the build configuration.
  - Great for small teams or teams with only a few builds
- Build systems store their configurations either in a database (tfs, teamcity) or on the file system
  (jenkins).

Why are manual configurations not cool

- Problem is that the changes aren't necessarily recorded so it's hard to figure out what changes
  were made and why. And even if changes are recorded they normally dont' contain change messages, 
  and even if that is possible users don't normally fill them out because they are annoying
- Other problem is that changes may be related to changes in the way you build your product, but
  it is hard to trace that back. Should you ever need to recreate a build then you don't have a record
  of what your build environment should look like
- In case of a disaster you may lose the configurations thay were manually made
- Manual configurations don't play well with [immutable infrastructure for build systems]() because an update
  can wipe out all the configurations. Automatically generated ones will come back but the manually generated
  ones will not come back that easily
- Changes that need to be made to many build configurations take lots of time if the build configurations
  are manually generated

How to achieve

- Create a DSL that allows creating build configurations from a configuration file, e.g. Jenkins pipeline
- Provide a way to inform the build system that a repository contains said configuration files. Having
  the configuration files is of no use if the build system has to be manually informed that there is a
  repository. One way is to have [generator builds]() which generate the new build configurations
  and have a [bootstrap build]() that can create the generator builds from configurations in a single
  repository