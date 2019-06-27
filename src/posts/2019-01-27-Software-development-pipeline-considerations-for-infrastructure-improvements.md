Title: Software development pipeline - Considerations for infrastructure improvements
Tags:
  - Delivering software
  - Software development pipeline
  - Immutable infrastructure
  - Infrastructure as code
  - DevOps
---

In one of the post from a [while ago](Software-development-pipeline-Design-introduction.html) we
discussed what a software development pipeline is and what the [most](Software-development-pipeline-Design-accuracy.html)
[important](Software-development-pipeline-Design-performance.html)
[characteristics](Software-development-pipeline-Design-resilience.html)
[are](Software-development-pipeline-Design-flexibility.html). Given that the pipeline is used
during the large majority of the development, test and release process it is fair to say that for
a software company the build and deployment pipeline infrastructure should be considered critical
infrastructure because without it the development team will be more limited in their ability to
perform their tasks. Note that at no stage should any specific tool, including the pipeline, be the
single point of failure. More on how to reduce the dependency on CI systems and the pipeline will
follow in another post.

Just like any other piece of infrastructure the development pipeline will need to be updated
and improved on a regular basis, either to fix bugs, patch security issues or to add new features
that will make the development team more productive. Because the pipeline falls in the cricital
infrastructure category it is important to keep disturbances to a minimum while performing these
changes. There are two main parts to providing (nearly) continuous service while still providing
improvements and updates. The first is to ensure that the changes are tracked and tested properly,
the second is to deploy the exact changes that were tested to the production system in a way that no
or minimal interruptions occur. A sensible approach to the first part is to follow a solid software
development process so that the changes are controlled, verified and monitored which can be achieved
by creating infrastructure resources completely from information stored in source control, i.e. using
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

To achieve the goal of being able to deploy updates and improvements to the development
infrastructure the following steps can be taken

- Using infrastructure-as-code to create new resource images each time a resource needs to be updated.
  Trying to create resources by hand will drastically reduce the ease at which they can be build and
  be made consistently. Resources that are deployed into an environment should never be changed. If
  bugs need to be fixed or new features need to be added then a new version of the resource image
  should be created, tested and deployed. That way changes can be tested before deployment and
  the configuration of the deployed resources will be known.
- Resources should be placed on virtual machines or in (Docker) containers. Both technologies provide
  an easy way to create one or more instances of the resource which is required in order to test or
  scale a service. The general idea is to have one resource per VM / container instance. One resource
  may contain multiple services or daemons but it always serves a single goal. Note that in some cases
  people will state that you should only use containers and not VMs but there are still cases where
  a VM works better, e.g. in some cases executing software builds works better in a VM or running
  a service that stores large quantities of data. Additionally if all or a large part of the
  infrastructure is running on VMs then using VMs might make more sense. In all cases the correct
  approach, container or VMs, is the one that makes sense for the environment the resources will
  be deployed into.
- Some way of getting configurations into the resource. Some configurations can be hard-coded into
  the resource, if they are never expected to be changed. The draw-back of encoding a configuration
  into a resource is that this configuration cannot be changed if the resource is used in different
  environments, e.g. a test environment and a production environment. Configurations which are
  different between environments should not be encoded in the resource since that may prevent the
  resource from being deployed in a test environment for testing. Provisioning a resource requires
  that you can apply all the environment specific information to a resource which is a difficult
  problem to solve especially for the initial set of configurations, e.g. the configurations which
  determine where to get the remaining configurations. Several options are:
  - For VMs you can use DVD / ISO files that are linked on first start-up of the resource.
  - Systems like [consul-template](https://github.com/hashicorp/consul-template) can generate
    configurations from a distributed key-value store.
  - Resources can be pull their own configurations from a shared store.
  - For containers often environment variables are used. These might be sufficient but note that they
    are not secure, both inside the container and outside the container.
- Configurations that should be provided when a resource is provisioned should be stored
  in source control, just like the resource code is, in order to be able to automate the verification
  and delivery of the configuration values.
  - The infrastructure should have it's own shared storage for configurations so that the 'build'
    process can push to the shared storage and configurations are distributed from there. That ensures
    that the build process doesn't need to know where to deliver exactly (which can change as the
    infrastructure changes). One option is to use SQL / no-SQL type storage (e.g. Elasticsearch),
    another option is to use a system like [consul](https://consul.io) which has a distributed key-value
    store
- Automatic testing of a resource once it is deployed into an environment. For the very least the
  smoke tests should be run automatically when the resource is deployed to a test environment.
- Automatic deployments when a new resource becomes available or approved for an environment, for
  the very least to the test environment but ideally to all environments. Using the same deployment
  system for all environments is highly recommended because this allows testing the deployment
  process as well as the resource.

A general workflow for the creation of a new resource or to update a resource could be

- Update the code for the resource. This code can consist of Docker files, [Chef](https://www.chef.io/)
  or [Puppet](https://puppet.com/), scripts etc.. The most important thing is that the files are
  stored in source control and a sensible source control strategy is used.
- Once the changes are made a new resource can be created from the code.
  - It is sensible to validate the sources using one or more suitable linters. Especially for infrastructure
    resources it is sensible to validate the sources before trying to create the resource because it
    potentially takes a long time to build a resource. Any errors that can be found sooner in the
    process will reduce the cycle time.
  - Execute unit tests, e.g. [ChefSpec](https://docs.chef.io/chefspec.html), against the sources.
    Again, building a resource can take a long time so validation before trying to create the resource
    will reduce the cycle time.
  - Actually create the new resource. For Docker containers this can be done from a
    [docker file](https://docs.docker.com/engine/reference/builder/). For a VM this can be done with
    [Packer](https://packer.io). Building a VM will take longer than building a docker container in
    most cases. Note that building resources will in general take longer than building applications
    it is sensible to use the build / deployment pipeline to build the resources that make up the
    build / deployment pipeline. By using the pipeline it is possible to create the artefacts for
    the services and then use these artefacts to create the resource.
- Deploy the resource to a (small) test environment and execute the tests against the newly created
  resource.
- Once the tests have passed the newly made image can be 'promoted', i.e. approved for use in the
  production environment.

Using the approaches mentioned above it is possible to improve the development pipeline without
causing unnecessary disturbances for the development team.

Edit: Changed the title from `software delivery pipeline` to `software development pipeline` to match
the other posts.
