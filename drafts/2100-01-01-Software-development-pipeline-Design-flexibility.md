Title: Software development pipeline - Design flexibilty
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

- Why is flexibility important
    - Different stages of the pipeline may require different approaches. e.g. build steps
      will in general be executed by the build system returning the results in a synchronous
      way, however tests might run on a different machine so those results might come back
      in a asynchronous way.
    - Different products may require different approaches
- How do we achieve this
    - Keep majority of the process described in the scripts. They're easier to adapt
    - Provide DSL for describing a pipeline
    - Automatic generation of the pipeline job configuations, so that it is easy to update