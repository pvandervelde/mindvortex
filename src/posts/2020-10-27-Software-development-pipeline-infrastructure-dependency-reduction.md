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

Once you have decided to reduce coupling between the development pipeline and the infrastructure then
you can take one or more of the following steps to help you achieve your decoupling goals. Even
implementing some of the steps will help you by

- Independence from your CI/CD system because you can can execute your pipeline stages anywhere
- Developers can build the complete package locally allowing them to test what will be shipped
- Build workspace is guaranteed to be clean when you start which means less time spend debugging
  build failures due to file system pollution or package caching failures
- Adding more agents to your CI/CD system is easy as all agents are the same and relatively simple
  in form

With all that said here are some suggestions for steps you can take on your journey to fewer
dependencies.

#### Versions for everybody

Ensure that all code, tools, scripts and resources used in the pipeline are versioned. That way you
know exactly what is required for a specific pipeline execution.

#### Only the workspace is yours

Pipeline actions should work only inside their own workspace. Any code, scripts or tools they require
can be put in the workspace but never outside the workspace. This reduces scattering of data during
the execution of a pipeline.

#### Lean executors

Make your pipeline actions assume they will run on executors with a bare minimum runtime. This will
ensure that your pipelines will obtain their preferred version of the tools they need and
install them in their own workspace. The benefit of doing this that a pipeline can be executed on
any available executor, either in your CI/CD system or on a developer machine, as it will not be
making any assumptions about the capabilities of an executor.

#### Single use executors are cleaner

Configure the CI/CD system to use a clean executor for every job. This will ensure that changes made
by a previous job don't interfere with the current job. Additionally it will enforce the use of
immutable infrastructure for the executors, thus allowing versioning of the executors.

#### Use the CI/CD system as a task executor

Keep the configuration for the jobs in the CI/CD system to a minimum. Ideally the entire configuration
is the execution of a script or tools with a simple set of arguments. By reducing the job of the
CI/CD system to executing a script or tool it is simple to execute the pipeline actions somewhere
else, e.g. on a developer machine or a different CI/CD system.

#### Treat pipeline services as critical

All services used by the pipeline should be treated as mission critical systems. After all a failure
in one of these systems can stop all your pipelines from executing. So reduce the number of services
you use in your pipeline and strengthen the services you have to rely on using the standard
approaches for service resilience.
