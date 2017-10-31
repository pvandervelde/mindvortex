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

Discussing on-prem systems only. These ideas apply to cloud-based build systems as well
but given that the user doesn't have to worry about the infrastructure it is of less importance
there.

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
