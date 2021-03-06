Title: Software development pipeline - Design introduction
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

In order to deliver new or improved software applications within the desired
time span while maintaining or improving quality modern development moves towards
[shorter development and delivery](https://techbeacon.com/doing-continuous-delivery-focus-first-reducing-release-cycle-times)
cycles. This is often achieved through the use of agile processes and a development
workflow including [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration),
[Continuous Delivery](https://en.wikipedia.org/wiki/Continuous_delivery)
or even [Continuous deployment](https://www.agilealliance.org/glossary/continuous-deployment).

One of the consequences of this desire to reduce the development cycle time on the
development process is that more tasks in the development workflow
have to be automated in order to reduce the time taken for the specific task.
One way this automation can be achieved is by creating a
[development pipeline](https://www.informit.com/articles/article.aspx?p=1621865&seqNum=2) which
takes the source code and moves it through a set of largely automatic transformations, e.g. compilation,
testing, packaging and potentially deployment, to obtain a validated, and potentially deployed, application.

In order to configure a development pipeline, whether that is on-prem or in the cloud, for
one or more development teams one will have to understand what the requirements are which
are placed on the pipeline, which tooling is available to create the pipeline, whether the
pipeline will be situated on-prem, in the cloud or a combination and
how the pipeline will be assembled and managed. In this post series some of
these issues will be discussed starting with the requirements or considerations that need
to be given to the characteristics or behaviours of the development pipeline.

Prior to discussing what the considerations are for selecting tooling and infrastructure
for a development pipeline, it is important to decide what elements are part of the pipeline
and which elements are not. For the remainder of this
post series the development pipeline is considered to consist of:

- The scripts that are used during the different parts of the cycle, i.e. the build, test
  and release scripts.
- The continuous integration system which is used to execute the different scripts.
- The tools, like the compiler, test frameworks, etc.

Items like version control, package management, issue tracking, system monitoring,
customer support and others are not included in the discussion. While these systems
are essential in application development and deployment each of these systems spans
a large enough area that it warrants a more thorough discussion than can be given in
this post series.

Additionally, the following terms will be used throughout the series:

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

In order to start the selection of suitable components for a development pipeline
it is important to know what the desirable properties of such a system are. The following
ordered properties are thought to be the most important ones to consider.

- [Accurate](/posts/Software-development-pipeline-Design-accuracy.html): The pipeline must return the right
  outputs for a specific input, i.e it should report errors to the interested parties if there are any
  and report success and produce the desired artefacts if there are no errors.
- [Performance](/posts/Software-development-pipeline-Design-performance.html): The pipeline must push changes
  through the different stages fast in order to get results back to the interested parties as soon
  as possible.
- [Resilience](/posts/Software-development-pipeline-Design-resilience.html): The pipeline must be able to
  cope with environmental changes, both expected and unexpected.
- [Flexibility](/posts/Software-development-pipeline-Design-flexibility.html): The pipeline must be easy to
  adapt to new products and tools so that it can be used without having to replace large parts each
  time a new product or tool needs to be included.

There are of course other desirable properties for a development pipeline like ease-of-use,
maintainability, etc.. It is however considered that the aforementioned properties are the
most critical ones. The linked posts provide additional reasons why each of these properties
are important and how a software development pipeline can be designed to satisfy these important
considerations.

Additional posts about this topic can be found via the
[Software development pipeline](/tags/software-development-pipeline.html) tag.


#### Edits

- August 30th 2017: Replaced the term `correctness` with the term `accuracy` because that
  is a better description of the combined concepts of consistency and correctness.
- September 4th 2017: Added the link to the post providing the high level description on
  how to achieve accuracy for a development pipeline.
- November 5th 2017: Replaced the term `robustness` with the term `resilience` because it
  captures a broader perspective on the ability of the system to handle expected and unexpected
  changes.
