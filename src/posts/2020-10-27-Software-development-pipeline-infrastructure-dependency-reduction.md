Title: Software development pipeline - Infrastructure dependency reduction
Tags:
  - Delivering software
  - Software development pipeline
  - Build configuration as code
  - DevOps
---

The [last post](/posts/Software-development-pipeline-considerations-for-infrastructure-improvements.html)
I explained one way to improve the development pipeline infrastructure while
keeping downtime minimal. One important consideration for the
[resilience](/posts/Software-development-pipeline-Design-resilience.html) of the
pipeline is to reduce the dependencies between the pipeline and the infrastructure.

So what does unwanted coupling between the pipeline and the
infrastructure mean? After all the pipeline code makes assumptions about the capabilities
of the infrastructure it runs on, just like every other piece of code.
Examples of unwanted dependencies are:

- The pipeline is created by using tasks specific to a CI/CD system which means that the artefacts
  can only be created on the infrastructure
- A pipeline task assumes that certain tools have been installed on the executors
- A pipeline task assumes that it has specific permissions on an executor
- Pipeline stages expect the outputs from previous stages to be available on the executor,
  or worse, they expect the outputs from other pipelines to be on the executor

The first item mentioned impacts the velocity at which development can take place. By relying
completely on the CI/CD system for artefact creation cycle times increases. Additionally
making changes to the pipeline often requires executing it multiple times to debug it.

The second set of items are related to the ease of switching tooling, e.g. when changing vendors
or during disaster recovery. These may or may not be of concern depending on the direction of
development and technology. In my experience vendor lock-in is something to keep in mind if for no
other reason then that switching vendors can be prohibitively complicated if pipeline processes are
too tightly coupled to the CI/CD system.

If any of the issues mentioned are concerning to you then partially or completely decoupling
the development pipeline from the infrastructure will be a worth while exercise. This
can be achieved with some of the following steps.

#### Versions for everybody

Ensure that all code, tools, scripts and resources used in the pipeline are versioned. That way you
know exactly what is required for a specific pipeline execution. Which make executions repeatable
in the future when newer versions of tools and resources have been released.

#### Only the workspace is yours

Pipeline actions should work only in their own workspace. Any code, scripts or tools they require
are put in the workspace. This reduces scattering of data during the execution of a pipeline and
reduces pollution of the executors.

#### Lean executors

Make your pipeline actions assume they will run on a bare minimum runtime. This will
ensure that your pipelines will obtain their preferred version of tools they need and
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
you use in your pipeline and improve the resilience the services you have to rely on using the standard
approaches.
