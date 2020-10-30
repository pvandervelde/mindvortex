Title: Software development pipeline - Infrastructure dependency reduction
Tags:
  - Delivering software
  - Software development pipeline
  - Build configuration as code
  - DevOps
---

The [last post](/posts/Software-development-pipeline-considerations-for-infrastructure-improvements.html)
I explained one way to improve the development pipeline infrastructure while
keeping downtime to a minimum. In that post I mentioned that an important consideration for the
[resilience](/posts/Software-development-pipeline-Design-resilience.html) of the
pipeline was to reduce the dependencies between the pipeline and the infrastructure. Now I will
discuss how some dependency decoupling can be achieved. However before that happens lets provide
a few reasons that a certain amount of independence between the pipeline processes and the
infrastructure is desirable.

If the pipeline processes is tightly coupled to the infrastructure, e.g. because the development
pipeline is defined completely using the native tasks for the CI/CD system then

- Building the artefacts requires the CI/CD system, meaning that developers cannot build a complete
  artefact on their own machines, which increases the feedback time. If not enough executors are
  available in the CI/CD system then it is quite possible that the feedback time increases extensively
- Testing changes to the pipeline can be slow because changes need to be send to the CI/CD system
  in order to test them. In general CI/CD systems don't provide easy ways to debug a running pipeline
  which means developers are limited to general debug statements and log parsing
- In case of issues with the CI/CD system, e.g. partial or complete outages, then you will not be able
  to execute any of the pipeline steps or stages
- Migration to a different CI/CD solution may be complicated

The first two items mentioned above impact the velocity at which development can take place. By relying
completely on the CI/CD system for artefact generation cycle times seem to increase.
The second set of items are related to disaster recovery and vendor lock-in. These may or may not be
of concern depending on the direction of development and technology. In my experience vendor lock-in
is something to keep in mind if for no other reason then that switching vendors can be prohibitively
complicated if pipeline processes are too tightly coupled to the CI/CD system.

If any of the issues mentioned above are of concern to you then partially or completely decoupling
the development pipeline from the infrastructure will be a worth while exercise.

How to achieve

- No tools need to be installed on any of the executors by default (ideally). Use a bare minimum executor.
- Never re-use executors. Don't allow developers to do so because that trains them to think that
  some resources / tools / files will be available
- Version everything - Tools, scripts etc.. That way you can reproduce the process on any executor
- Pipeline pulls down all tools required. Which probably means you need some kind of entrypoint
  script to pull down the initial tools and scripts. This entrypoint script should be as small as
  possible and able to update itself. That way you can still version all the scripts and tools
  (because they are pulled down) and don't need to add everything to the repository
- Don't create a pipeline in the CI/CD system. Consider it to be just a task execution system. Define
  the task through scripts / tools with a standard 'entrypoint' for all your jobs
- It is better to not rely on the presence of different services because those are points of failure.
  - For those services that are absolutely required it is important that these are highly available


Benefits

- This means that you are independent of your build system because you can always build
- Allows developers to build locally to dev test the product
- Easy to add more agents, just spin up a new clean OS install VM or container
- Build workspace is guaranteed to be clean when you start. Less time spend debugging build failures
  due to file system pollution or package caching failures



NOTE:
Some steps may be hard when not on a build system, e.g. signing with the proper certificates / keys,
and some may not be desirable when not on a build system, e.g. making changes to source control
in the local workspace (i.e. local merges / branching / commits).


As a side note. I have noticed that if the build time for an artefact exceeds a certain amount of time
(somewhere between 5 - 10 minutes) it is highly likely that developers will exclusively use the CI/CD
system to execute builds. This in turn will cause build times to increase further over time, most likely
due to the fact that developers are no longer actively waiting for their builds.
