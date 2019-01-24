Title: Software delivery pipeline - Immutable infrastructure
Tags:
  - Delivering software
  - Software delivery pipeline
  - Immutable infrastructure
  - DevOps
---

In one of the post from a [while ago](Software-development-pipeline-Design-introduction.html) we
discussed what a software development pipeline is and what the [most](Software-development-pipeline-Design-accuracy.html)
[important](Software-development-pipeline-Design-performance.html)
[characteristics](Software-development-pipeline-Design-resilience.html)
[are](Software-development-pipeline-Design-flexibility.html). From those posts one might be able to
draw the conclusion that the pipeline is an important tool for a development team. Given that
the pipeline can be used during the large majority of the development, test and release process
it seems fairly sensible to say that the services and resources in the pipeline are critical to the
ability of the development teams to deliver their software. This means that for a software company the
build and deployment pipeline infrastructure should be considered critical infrastructure because
without it the development team will be more limited in their ability to perform their tasks. Note
that at no stage should any specific tool, including the pipeline, be the single point of failure.
More on how to reduce the dependency on CI systems and the pipeline will follow in another post.

Just like any other piece of infrastructure the development pipeline will need to be updated
and improved on a regular basis, either to fix issues, patch security bugs or to add new features
that will make the development team more productive. Because the pipeline falls in the cricital
infrastructure category it is important to keep disturbances to a minimum while performing these
changes.

There are two main parts to providing (nearly) continuous service while still providing improvements
and updates. The first is to ensure that the changes are tracked and tested properly, the second
is to deploy the exact changes to the production system in a way that no or minimal interuptions
occur. A sensible approach to the first part is to follow a solid software development process so
that the changes are controlled, verified and monitored. This again can be achieved by creating
infrastructure resources completely from information stored in source control, i.e. using
[infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_code), making the resources
as [immutable](https://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/)
as [possible](https://twitter.com/jezhumble/status/970334897544900609) and performing automated tests
on these resources after deploying them in a test environment using the same deployment process that
will be used to deploy the resources to the production environment.

Using this approach should allow the creation of resources that are thoroughly tested and can be
deployed in a sensible fashion. It should be noted that no amount of automated testing will
guarantee that the new resources are free of any issues so it will always be important use deployment
techniques that allow for example [quick roll-back](https://martinfowler.com/bliki/BlueGreenDeployment.html)
or [staged roll-outs](https://martinfowler.com/bliki/CanaryRelease.html). Additionally deployed
resources should be carefully monitored so that issues will be discovered quickly.

It may seem that all of this is a lot of work, especially for a development environment, however as
noted earlier on the development environment is critical for software development companies therefore
it is sensible to apply the afforementioned techniques for the maintenance and improvement of the
development environment.



Once it is decided to app

How can we achieve this


- Requires infrastructure-as-code. Otherwise we still have to make the resources
  by hand which reduces the ease at which they can be build. Also hand created resources
  are not consistent even with checklists etc.

- Resources should be on virtual machines or Docker containers. That way it's easy to
  create an instance of the resource which is required in order to test
  - General idea is to have one resource per VM / container instance. One resource may contain
    multiple services / daemons but it always serves a single goal.
  - Nowadays people will indicate it should be containers but there are still cases where a VM
    works better, e.g. not all builds work in containers and if all the infrastructure is in
    VMs then using VMs will be easier / more consistent. In the end use the approach that makes
    sense for your environment


General workflow:

- Update the code for the resource
- (Optionally) validate the sources using the suitable linters. Especially for
  infrastructure resources it is sensible to validate the sources because it potentially
  takes a long time to build a resource. Any errors that can be found sooner in the
  process is a good thing because it reduces the cycle time.
- (Optionally) execute unit tests against the sources. For the same reasons as with
  the linters
- Build new resource. For Docker containers this can be done from a [docker file](),
  for a VM this can be done with [Packer](https://packer.io). Building a VM will take longer than building
  a docker file in most cases.
  - Note: Building a docker file generally should be done by just grabbing the files
    from the local file system. Any actions taken in the docker file may increase the
    size of the docker file and also increase the time taken to build the container
  - Note: Building resources will in general take longer than building applications,
    especially if the resource needs to be put on a Windows VM.
  - In this case it is sensible to use the build / deployment pipeline to build the resources
    that make up the build / deployment pipeline. By using the pipeline it is possible
    to create the packages / artefacts for the services and then use these artefacts to
    create the resource (VM / docker container)
- Execute the (integration / regression) tests against the newly created resource. Ideally this
  is done in a test environment so that the inputs can be controlled for testing
  - Deploy the new instances and retire the existing instance
  - Monitor the new instances as per normal
- Also requires [configuration-as-code]() because the configuration needs to be recorded somewhere
  so that when you rebuild a resource it will get the most up to date configuration
  - Store the configuration in a version control system and push it to the infrastructure on change
  - Can follow a standard process that allows testing configurations (e.g. in a test environment)
  - The infrastructure should have it's own shared storage for configurations so that the 'build'
    process can push to the shared storage and configurations are distributed from there. That ensures
    that the build process doesn't need to know where to deliver exactly (which can change as the
    infrastructure changes). One option is to use SQL / no-SQL type storage (e.g. elastic search etc.),
    another option is to use a system like [consul](https://consul.io) which has a distributed key-value
    store

One difficult problem to resolve is the deployment and provisioning of resources, the addition,
replacement or removal of resources and then applying the appropriate configurations so that the
(essentially generic) resources can be used in the specific environment

- In many examples configurations etc. are hard-coded into the resource, this means you can not
  use the resource in other environments. Ideally it is possible to use a continuous deployment
  system for the creation and testing of the resources. This means that a resource should essentially
  be free of environment specific configuration. These types of configurations should not be applied
  until a resource is added to the environment
  - Additionally if you want to be able to test new resources then you neeed a test environment which
    means you have to be able to deploy the resouces in multiple environments
  - Provisioning requires that you can apply all the environment specific information to a resource.
    This is a difficult problem to solve especially for the initial set of configurations. Several ways are:
    - For VMs you can use DVD / ISO files that are linked on first start-up of the resource
    - Can use systems like [consul-template]() which can generate configurations from a distributed
      key-value store, or resources can be able to pull their own configurations from a shared store.
    - For containers often environment variables are used. These might be sufficient but note that they
      are not secure, both inside the container and outside the container


- Running applications on a resource that changes all the time means that the software needs to be
    designed for more 'extreme' running conditions. On the other hand if the resource is consistent
    the software can be simplified. Note that the simplification doesn't necessarily make the software
    simple, just makes it less necessary to take into account that the resource changes underneath it
  - Stable infrastructure also makes it easier to troubleshoot because you know what it is supposed to
    look like
  - Easier to deploy because it is known in advance what it is supposed to look like which means you
    can test it prior to deployment
- The DevOps movement has brought development processes for infrastructure to the general attention
  with ideas like [mixing development and ops](https://en.wikipedia.org/wiki/DevOps),

- Decent amount of progress on generating the test and productions environments for products
  using these techniques.


This discussion is useful for both on-prem and cloud systems. In a cloud system there is less infrastructure
to worry about but those bits that exist should still follow this approach. If you are fully cloud operated
then somebody else worries about this stuff, but somebody probably does think about it.