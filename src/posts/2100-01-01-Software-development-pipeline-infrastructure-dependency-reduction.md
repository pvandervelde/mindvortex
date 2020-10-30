Title: Software development pipeline - Infrastructure dependency reduction
Tags:
  - Building software
  - Build server
  - Configuration-as-code
  - DevOps
---

The [last post](/posts/Software-development-pipeline-considerations-for-infrastructure-improvements.html)
discussed how to allow improvements and upgrades to the development pipeline infrastructure while
keeping downtime to a minimum. In that post we mentioned that an important consideration for the
[resilience](/posts/Software-development-pipeline-Design-resilience.html) of the
pipeline was to reduce the dependencies between the pipeline and the infrastructure. This post will
discuss how some of this dependency decoupling can be achieved.

Before we discuss how to achieve some level of decoupling we will provide some reasons that a certain
amount of independence between the pipeline procesess and the infrastructure is desirable.

If the pipeline processes are tightly coupled to the infrastructure, e.g. because the development
pipeline is defined completely using the native tasks for the CI/CD system then

- In case of issues with the CI/CD system, e.g. partial or complete outages, then you will not be able
  to execute any of the pipeline steps or stages
- Migration to a different CI/CD solution may be complicated
- Testing changes to the pipeline can be slow because changes need to be send to the CI/CD system
  in order to test them. In general CI/CD systems don't provide easy ways to debug a running pipeline




* Should be able to run a build on any machine. Ideally no tools need to be installed so you can just
  build on a fresh OS install.
  * This means that you are independent of your build system because you can always build
  * Allows developers to build locally to dev test the product
  * Easy to add more agents, just spin up a new clean OS install VM or container
  * Build workspace is guaranteed to be clean when you start. Less time spend debugging build failures
    due to file system pollution or package caching failures

* Testing builds is time consuming if you need a build server to do so
  * You'll probably need a test system because otherwise you are blocking people doing work on your
    actual applications
  * Build debugging usually involves lots of `writeline` statements and digging through logs, which
    is slow on a local machine but slower on a build server
  * Performance testing of builds is tricky because the build server might be doing many different
    things at the same time
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
