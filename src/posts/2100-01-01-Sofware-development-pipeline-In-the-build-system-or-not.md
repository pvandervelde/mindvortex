Title: Software development pipeline - In the build system or not
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

- Many of the modern build systems have the ability to make build pipelines, i.e. the ability to chain builds. Some of
  them only in series, e.g. old jenkins approach and others in parallel, e.g. new jenkins pipeline
  - Makes it easy to quickly create pipelines, one build triggers one or more other builds.
  - In many cases also allows steps that require human interaction, e.g. approval or manual triggers
  - Great because it's build in and easily accessible
  - Works great for static systems, i.e. systems that all behave the same, always run the same steps in the same order
- No so great because
  - Assumes that the core of everything is a 'build'. Most of the time that is not the case. A 'build' is just a way
    to get an artefact and artefacts are what most people care about. Developers write code that turns into artefacts,
    testers test artefacts, artefacts are deployed and the provide the services that serve the customers. So the best
    item to track is the artefact, not a build. But build systems are aimed at builds, not artefacts.
  - Assumes that the build system is the center of everything, which may be true but it might not. Why would the
    build system be the core of everything and not the version control system or the issue tracker or ...
  - Puts knowledge about how to build your product in your build system. It is better if that knowledge is captured in
    scripts / tools that can be executed without needing the build system, otherwise you lock yourself into a specific
    build system and changing over will be hard.
  - In reality all systems are required. There isn't necessarily one system that knows enough to make decisions
    about the state of the pipeline. If we assume that we have to put this capability in the build system then we
    will end up encoding a lot of knowledge in the build scripts. That is fairly straight forward for simple pipelines
    but quite hard for more complex ones
  - Will load up the build system with additional tasks. Tasks that require the system to be up and running constantly
    (which is important most of the time anyway) but also require that it stores persistent data, which build systems
    normally do not do. Having it store state means we now need to treat it as a database (and that it will behave like
    one which seems unlikely because people writing build systems, create build systems, not databases, and people that
    write build systems and have databases might need to reconsider (I'm looking at you Mr
    TFS 'everything-is-a-table-and-json-in-xml-in-a-database-field-is-awesome'))
  - Makes the assumption that some builds might not be repeatable (e.g. deploys). However normally builds should be
    repeatable because that means that the build system can be immutable .
  - Pipelines are specific to the company producing the software because each company has a different development / release
    process. Maybe the overall system is the same (everybody is using agile now right?) but the details differ and for the
    pipeline the details make all the difference
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
- Maybe it is better to have a separate system that tracks the state of the pipeline. That way you can treat it as the
  critical infrastructure that it is, with the appropriate separation of data and business rule processing etc.
  - As far as I'm aware there is no software for this purpose out there
  - Because each pipeline is different, each pipeline tracking application will be different. This sort of means
    that for most companies it is better to custom write this software

In general it will be sensible to use the pipeline capabilities that are build into your build system for small companies
that have a fairly standard pipeline. Often small changes can be made to the pipeline process by using custom scripts.
However once the pipeline gets more complicated it might well be worth it to develop some custom software that tracks
artefacts through the pipeline.
