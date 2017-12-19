Title: Software delivery pipeline - Immutable infrastructure
Tags:
  - Delivering software
  - Software delivery pipeline
  - Immutable infrastructure
  - DevOps
---

- Discussed earlier that it is important for the infrastructure to be stable and consistent. And
  that changes to infrastructure need to be done by following a solid software development process
- The DevOps movement has brought development processes for infrastructure to the general attention
  with ideas like [mixing development and ops](), [infrastructure-as-code]() and
  [immutable infrastructure](https://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/).
- Decent amount of progress on generating the test and productions environments for products
  using these techniques.
- Why immutable infrastructure for the delivery pipeline
  - Standard arguments apply:
    - Easier to reason about infrastructure because the resources only 'change' in known
      increments, i.e. when a new version of the resource is deployed and the old one is
      retired.
    - stability
    - changes can be tested
  - Development pipeline specific
    - ?

This discussion is useful for both on-prem and cloud systems. In a cloud system there is less infrastructure
to worry about but those bits that exist should still follow this approach.

- How can we achieve this
  - Requires [infrastructure-as-code]() as well. Otherwise we still have to make the resources
    by hand which reduces the ease at which they can be build
  - Resources should be on virtual machines or Docker containers. That way it's easy to
    create an instance of the resource which is required in order to test
    - General idea is to have one resource per VM / container instance. One resource may contain
      multiple services / daemons but it always serves a single goal.
  - General workflow:
    - Update the code for the resource
    - (Optionally) validate the sources using the suitable linters. Especially for
      infrastructure resources it is sensible to validate the sources because it potentially
      takes a long time to build a resource. Any errors that can be found sooner in the
      process is a good thing because it reduces the cycle time.
    - (Optionally) execute unit tests against the sources. For the same reasons as with
      the linters
    - Build new resource. For Docker containers this can be done from a [docker file](),
      for a VM this can be done with [Packer](). Building a VM will take longer than building
      a docker file.
      - Note: Building a docker file generally should be done by just grabbing the files
        from the local file system. Any actions taken in the docker file may increase the
        size of the docker file and also increase the time taken to build the container
      - Note: Building resources will in general take longer than building applications,
        especially if the resource needs to be put on a Windows VM.
    - Execute the (integration / regression) tests against the newly created resource
    - Deploy the new instances and retire the existing instance
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
  - One difficult problem to resolve is the deployment and provisioning of resources, the addition,
    replacement or removal of resources and then applying the appropriate configurations so that the
    (essentially generic) resources can be used in the specific environment
    - In many examples configurations etc. are hard-coded into the resource, this means you can not
      use the resource in other environments. Ideally it is possible to use a continuous deployment
      system for the creation and testing of the resources. This means that a resource should essentially
      be free of environment specific configuration. These types of configurations should not be applied
      until a resource is added to the environment
    - Provisioning requires that you can apply all the environment specific information to a resource.
      This is a difficult problem to solve. Several ways are:
      - For VMs you can use DVD / ISO files that are linked on first start-up of the resource
      - Can use systems like [consul-template]() which can generate configurations from a distributed
        key-value store, or resources can be able to pull their own configurations from a shared store.

