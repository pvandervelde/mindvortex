Title: Software development pipeline - Design flexibilty
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

- Why is flexibility important
    - Different stages of the pipeline may require different approaches. e.g. build steps
      will in general be executed by the build system returning the results in a synchronous / serial
      way, however tests might run on a different machine so those results might come back
      in a asynchronous / parallel way.
    - Different products may require different workflows / processes
    - Flexibility is also required when dealing with resilience / robustness. In case of a
      major disruption flexibility may help with quickly restoring services through alternate
      means.
- How do we achieve this
    - Same way we achieve flexibility in other software products. Using modular parts and standard inputs and outputs.
    - Split pipeline into stages that take standard inputs and deliver standard outputs. There might be many different
      types of inputs / outputs but they should be known and easily shared. There can be one or more stages, e.g. build,
      test and deploy. The number of stages should be flexible, i.e. it should be easy to add more stages if so desired.
      Additionaly the steps taken inside a stage should be flexible in number and type.
      - Inputs can be:
        - Source information, e.g. a commit ID
        - Artefacts, e.g. packages installers, zip files etc.
      - Outputs can be:
        - Artefacts, e.g. packages, installers, zip files etc.
        - Meta data, additional information to be attached to an artefact, e.g. test results
    - Split the complete process into smaller parts or stages. Ideally each stage contains only the minimal necessary
      steps to provide value. For instance the proces could be split into the build, test and deploy stages.
      Note that a single stage might appear multiple times in a process. For instance if a product consists of
      multiple smaller components then it is possible to have a build, test and deploy stage for each of the components,
      in addition to having a build, test and deploy stage for the final product
    - By  splitting the process into multiple stages it is p

- Implementation
    - Keep majority of the process described in the scripts. They're easier to adapt. Additionally
      keeping the process in the scripts means that developers can execute the majority of the pipeline
      from their local machines. That allows them to ensure builds / tests work before pushing to the
      pipeline, provides a means of building things if the pipeline is offline etc.
    - Any part of the process that cannot be done by a script, e.g. test systems, items that need services (e.g.
      certificate signing, which require that the certificates are present on the current machine, which is something
      you will probably not want to do on every machine) etc., should have a service that is available to both
      the build system and the developers executing the scripts locally. For any services that should only
      be provided to the build server (e.g. signing) the scripts should allow skipping the steps that
      need the service.
    - Provide DSL for describing a pipeline
    - Automatic generation of the pipeline job configuations, so that it is easy to update when changes occur
