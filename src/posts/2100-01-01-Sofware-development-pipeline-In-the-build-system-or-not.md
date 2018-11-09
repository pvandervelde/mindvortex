Title: Software development pipeline - In the build system or not
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

Over the last few years the use of build pipelines has been gaining traction backed by the ever growing
use of Continuous Integration (CI) and Continuous Delivery and Deployment (CD) processes. By using a
build pipeline development teams get benefits like being able to execute parts of the build, test,
release and deployment processes in parallel, being able to restart the process part way through
in case environmental issues, and vastly improved feedback cycles which improve the velocity
at which features can be delivered to the customer.

Most modern build systems have the ability to create a build pipelines in one form or another, e.g.
[VSTS / Azure Devops builds](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?toc=/azure/devops/pipelines/toc.json&bc=/azure/devops/boards/pipelines/breadcrumb/toc.json&view=vsts),
[Jenkins pipeline](https://jenkins.io/solutions/pipeline/),
[GitLab](https://docs.gitlab.com/ee/ci/pipelines.html), [BitBucket](https://bitbucket.org/product/features/pipelines)
and [TeamCity](https://confluence.jetbrains.com/display/TCD18/Build+Chain). With these capabilities build into
the build system it is easy for developers to quickly create a new pipeline from scratch. While this is
quick and easy often the pipeline for a product is created by the development team without considering if
this is the best way to achieve their goal, to deliver their product faster with higher quality.
Before using the built in pipeline capability in the build system the second question a development team should
ask is when should one use this ability and when should one not use this ability? Obviously the first question
is, do we need a pipeline at all.



Advantages
  - Makes it easy to quickly create pipelines, one build triggers one or more other builds.
  - In many cases also allows steps that require human interaction, e.g. approval or manual triggers
  - Great because it's build in and easily accessible
  - Works great for static systems, i.e. systems that all behave the same, always run the same steps in the same order
  - Description of the pipeline in source control

From the advantages it seems pretty easy. Always use it but there are disadvantages as well.

  - Assumes that the core of everything is a 'build'. Most of the time that is not the case. A 'build' is just a way
    to get an artefact and artefacts are what most people care about. Developers write code that turns into artefacts,
    testers test artefacts, artefacts are deployed and the provide the services that serve the customers. So the best
    item to track is the artefact, not a build. But build systems are aimed at builds, not artefacts.
  - Assumes that the build system is the center of everything, which may be true but it might not. Why would the
    build system be the core of everything and not the version control system or the issue tracker or ...
  - In reality all systems are required. There isn't necessarily one system that knows enough to make decisions
    about the state of the pipeline. If we assume that we have to put this capability in the build system then we
    will end up encoding a lot of knowledge in the build scripts or the build configurations. That
    is fairly straight forward for simple pipelines
    but quite hard for more complex ones
  - Will load up the build system with additional tasks. Tasks that require the system to be up and running constantly
    (which is important most of the time anyway) but also require that it stores persistent data, which build systems
    normally do not do. Having it store state means we now need to treat it as a database (and that it will behave like
    one which seems unlikely because people writing build systems, create build systems, not databases, and people that
    write build systems and have databases might need to reconsider (I'm looking at you Mr
    TFS 'everything-is-a-table-and-json-in-xml-in-a-database-field-is-awesome'))
  - Makes the assumption that we can just run every task through the build system, but builds and deploys
    are fundamentally different things. One should be repeatable (builds) and can just be stopped on failure
    and the other is often not exactly repeatable (because artefacts can only be moved from a location once etc.)
    and should often not just be stopped (but rolled-back or not 'committed').
  - Pipelines are specific to the company producing the software because each company has a different development / release
    process. Maybe the overall system is the same (everybody is using agile now right?) but the details differ and for the
    pipeline the details make all the difference. Build system driven pipelines have a large amount of flexibilty but
    they are still limited to having a standard approach, i.e. the standard approach deemed sensible by the
    vendor
  - If the build system has all the knowledge about the pipeline then it needs to be easily accessible and changable. It
    should be possible to add additional information, e.g. the versions / names of artefacts created by a build. The status
    of the artefact as it progresses through the pipeline etc.. All this information is important either during the
    pipeline process or in hindsight when the developers or customer support needs to know when a certain artefact was
    in the pipeline etc.. Often build systems don't have this capability, they store just enough information that they
    can do what they need to do, once again they are not database systems (and if they are it is recommended that you
    don't tinker with them)
  - History is a thing. At some stage development or support will want to know where a specific artefact comes from. This
    historic data needs to be accessible for much longer than build information needs to be accessible for.
  - Dynamic systems are harder. These can happen if you have multiple component stages, e.g. one artefact is build and
    tested which then triggers the pipeline for one or more artefacts which consume the new artefact, e.g. building
    a VM image with the binaries for a web service (or something like that)
  - Build system enabled systems often work from one repository, what if you need multiple components each of which lives
    in their own repository
  - Build systems work much better if they are immutable, i.e. created from standard components (e.g. controller and agents)
    with automatically generated build jobs. This allows a build system to be expanded or replaced really
    easily (cattle not pets even for build systems). That is much harder if the build system is the core of
    your pipeline and stores all the data for it.
- Maybe it is better to have a separate system that tracks the state of the pipeline. That way you can treat it as the
  critical infrastructure that it is, with the appropriate separation of data and business rule processing etc.
  - As far as I'm aware there is no software for this purpose out there
  - Because each pipeline is different, each pipeline tracking application will be different. This sort of means
    that for most companies it is better to custom write this software

When to use:


- In general it will be sensible to use the pipeline capabilities that are build into your build system for small companies
  that have a fairly standard pipeline. Often small changes can be made to the pipeline process by using custom scripts.

When not to use:

- However once the pipeline gets more complicated it might well be worth it to develop some custom software that tracks
  artefacts through the pipeline.
- Need to track artefacts past the build stage of the pipeline
- Want to use the information generated by the pipeline in other systems (e.g. metrics or decision making)

