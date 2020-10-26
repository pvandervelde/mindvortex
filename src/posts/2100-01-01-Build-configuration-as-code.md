Title: Build configuration as code
Tags:
  - Building software
  - Build server
  - Configuration-as-code
  - DevOps
---

- Build systems generally allow users to configure their builds through a UI. This makes it
  easy to quickly create a new build or to update the build configuration.
  - Great for cases where a limited number of builds need to be configured
  - If there are many builds to be configured it's annoying / time consuming
- Build systems store their configurations either in a database (tfs, teamcity) or on the file system
  (Jenkins). Making sure these are safe requires backups.

Why are manual configurations not cool

- Traceability
  - The changes aren't necessarily recorded so it's potentially hard to figure out what changes
    were made and why. And even if changes are recorded they normally don't' contain change messages,
    and even if that is possible users don't normally fill them out because they are annoying which
    means that even if you can trace who made the changes, it's hard to figure out why.
  - In some cases changes may be related to changes in the way you build your product, but
    it is hard to trace that back. Should you ever need to recreate a build then you don't have a record
    of what your build environment should look like
- Recovery
  - In case of a disaster you may lose the configurations that were manually made
  - Manual configurations don't play well with
    [immutable infrastructure for build systems](/posts/Software-development-pipeline-considerations-for-infrastructure-improvements.html)
    because an update can wipe out all the configurations. Automatically generated ones will come
    back but the manually generated ones will not come back that easily unless there were backups.
- Ease of use
  - Changes that need to be made to many build configurations take lots of time if the build configurations
    are manually generated
  - Creating new builds can be a problem if build have to be created often. For instance with manually
    created builds it is unlikely that you will create a build for each (git) branch in source control
    because branches are created quickly and destroyed quickly, requiring that you make builds often

How to achieve

- Create a DSL that allows creating build configurations from a configuration file, e.g. Jenkins pipeline,
  TFS YAML configuration files. Most build systems have a system that allows this
- Provide a way to inform the build system that a repository contains said configuration files. Having
  the configuration files is of no use if the build system has to be manually informed that there is a
  repository that needs to be watched. One way is to have [generator builds]() which generate the
  new build configurations and have a [bootstrap build]() that can create the generator builds from
  configurations in a single repository
  - In many build systems that can handle configuration files in source control there is no way to
    discover the presences of these files. In other words, the build system still needs to be told
    that the configuration files exist in a given repository. This is normally done by manually
    adding a configuration.
  - Store information about all the repositories that should be watched in other repository. Then
    create one build that watches this repository. When there are changes in this repository new
    builds can be generated pointing to the new build configurations. This changes the problem from
    watching a lot of repositories to watching a single repository.
  - Benefit of doing this is that there is only one manually configured build. This one can be
    'hard-coded' in the build system image. When the build server starts it can just execute the
    one build which will then create all the other builds
