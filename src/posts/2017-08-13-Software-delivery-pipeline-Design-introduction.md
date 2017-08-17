Title: Software delivery pipeline - Design introduction
Tags:
  - Delivering software
  - Software delivery pipeline
  - DevOps
---

In order to deliver new or improved software applications within the desired
time spn while maintaining or improving quality modern development moves towards
[shorter development and delivery](https://techbeacon.com/doing-continuous-delivery-focus-first-reducing-release-cycle-times)
cycles. This is often achieved through the use of agile processes and a development
workflow including [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration),
[Continuous Delivery](https://en.wikipedia.org/wiki/Continuous_delivery)
or even [Continuous deployment](https://www.agilealliance.org/glossary/continuous-deployment).

One of the consequences of this desire to reduce the development cycle time on the
development process is that more parts of the development workflow
have to be automated. One way this automation can be achieved is by creating a
[development pipeline](http://www.informit.com/articles/article.aspx?p=1621865&seqNum=2) which
takes the source code and moves it through a set of largely automatic transformations, e.g. compilation,
testing and packaging, to obtain a validated application that can be deployed.

In order to configure a development pipeline, whether that is on-prem or in the cloud, for
one or more development teams one will have to understand what the requirements are which
are placed on the pipeline, which tooling is available to create the pipeline, where
the pipeline is going to be situated, either on-prem, in the cloud or a combination and
how the pipeline will be assembled and managed. In this post and the following ones some of
these issues will be discussed starting with the requirements or considerations that need
to be given to the characteristics or behaviours of the development pipeline.

### Definitions

Prior to discussing what the considerations are for selecting tooling and infrastructure
for a development pipeline it is important to decide what elements are part of the pipeline
and which elements are not considered to be part of the pipeline. For the remainder of this
post series the development pipeline is considered to consist of:

- The scripts that are used during the different parts of the cycle, i.e. the build, test
  and release scripts.
- The continuous integration system which is used to execute the different scripts.
- The tools, like the compiler, test frameworks, etc.

Items like version control, package management, issue tracking, system monitoring,
customer support and others are not included in the discussion. While these systems
are essential in application development and deployment each of these systems spans
a large enough area that it warrants a more thorough discussion than can be given in
this post.

Additionally the following terms will be used throughout this post:

- Input set - A collection of information that is provided to the pipeline to start
  the process of turning these generating the desired artefacts. An input set may consist
  of source code, e.g. in terms of a given commit to the source control system, files or
  documents, configuration values or any other combination of information which is required
  to create, validate and deploy the product artefacts.
  An input set should contain all the information needed to generate and deploy the product
  artefacts and each time a specific input set is provided to the pipeline exactly the
  same artefacts will be produced.
- Executor - In general the development pipeline will be driven by a continuous integration
  system which itself consists of a controlling unit, which receives the tasks and distributes them,
  and a set of executing units which perform the actual computational tasks. In small systems
  the controlling unit may also perform the computational tasks, however even in this case
  a distinction can be made between the controlling and executing parts.

### Considerations

In order to start the selection of suitable components for a development pipeline
it is important to know what the desirable properties of such a system are. The following
ordered properties are thought to be the most important ones to consider.

- Correctness: The pipeline must return the right outputs for a specific input, i.e it
  should report errors to the interested parties if there are any and report success
  if there are no errors.
- Performance: The pipeline must push changes through the different stages fast
  in order to get results back to the interested parties as soon as possible.
- Robustness: The pipeline must be able to cope with environmental changes, both expected
  and unexpected.
- Flexibility: The pipeline must be easy to adapt to new products and tools so that it can
  be used without having to replace large parts each time a new product or tool needs to
  be included.

There are of course other desirable properties for a development pipeline like ease-of-use,
maintainability, etc.. It is however considered that the aforementioned properties are the
most critical ones.


#### Performance

The second property to consider is *performance*, namely the pipeline must provide feedback on
the quality of the current input set as soon as possible reduce the duration of the feedback cycle.
Having a fast feedback cycle means that it is easier for the development teams to make changes
because they are notified of any issues while the change is still fresh in their minds.

Performance of a development pipeline has two main aspects:

- How quickly can one specific input set be processed completely by the pipeline. In other words
  how much time does it take to push a single input set through the pipeline from the initial change to the
  delivery.
- How quickly can a large set of input sets be processed. The maximum number of executors will most
  likely be limited to some maximum value. The pipeline is limited in the number of simultaneous
  input sets it can process by the number of available executors. How quickly the pipeline can
  process large number of input sets depends

In order to construct a well performing development pipeline there are two main items to
consider. The first item

The second item to pay attention to is how to scale the capacity of the development pipeline.
As indicate previously

- The loading pattern of a development pipeline depends on the way the development team
    works. For instance when scrum is used it is likely that there will be more builds in the
    middle of the sprint than at the start or end. When using kanban the load on the system should
    be fairly consistent. Other processes may lead to more spiked load patterns.
    In practise build systems it is wise to design the pipeline for a fairly constant load most
    of the time with the ability to handle high peak loads, if necessary with a reduction in
    performance.





- How do we achieve performance
  - Performance is split over different parts. There's the performance of the continuous
    integration system, the performance of the scripts and tools and the performance of the
    underlying infrastructure.
  - Unlike with accuracy performance may change over time even if there are no _changes_
    to the system because the performance of the underlying infrastructure might change,
    for instance when disks fill up, the network load changes, the hardware ages etc.
  - Additionally there is the performance of being able to process a large number of builds
    - In general some of the performance is related to being able to process large queues as
      fast as possible. This may be done by scale out (more executors) or by processing
      builds really fast
  - Build systems should be able to scale, so that it is possible to execute many builds
    in parallel.

  - Make sure the scripts and tools don't do any work that is not necessary
  - Can split into stages

#### Robustness

- Has to be able to deal with changes in the environment in a sensible way
- Has to be able to deal with changes in the source code and report the correct
  errors
- Why is robustness important
    - The environment may experience changes, e.g. minor outages, failing services etc. In this
      case the pipeline should be able to deal with these issues and provide a sensible report
      back to the team. If the pipeline just crashes it will be harder to figure out what went wrong
      thus slowing the team down
- How do we achieve robustness
  - Extensive error handling, both for known cases (e.g. service offline) and general error handling
    for unexpected cases
  - Infrastructure: highly available services
  - Scripts: Error handling, retries, proper error messages

#### Flexibility

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

### More

More posts about this topic can be found via the
[Software delivery pipeline](/tags/software-delivery-pipeline.html) tag.