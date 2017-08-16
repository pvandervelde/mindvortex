Title: Software delivery pipeline - Considerations
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

#### Correctness

The first property to consider is *correctness*, namely the pipeline must produce results
that are consistent with the inputs, whether that result is a success result, the application was
build and validated without issue, or a failure result, and it must do so the correctly and
repeatably for each input set. This is so that the development
teams can rely on the system to always return a result that reflects the expected state of the
process. Without the correctness the development teams will eventually lose their trust in the
development pipeline which will lead them to ignore the results because they will assume that the
failure is one of the system instead of one with the pipeline inputs.

Once we know that having a development pipeline which delivers correct results is important the
next step is to determine how correctness can be build into the development pipeline. In essence
building this development pipeline is simple, all one
has to do is to ensure that all the parts that form the the pipeline behave correctly for a
given input set.

For the scripts, tools and continuous integration system this means that each input returns a
correct response. Fortunately most scripts and tools do so for the majority of the inputs.
In cases where a tool returns an incorrect response an issue should be logged and corrected.
With the tools taken care of two other areas need to be carefully controlled. The first is
that the infrastructure on top of which the development pipeline executes should be stable
and consistent, and the second is to ensure that the interaction of all the different parts
does not lead to incorrect results.

For infrastructure the biggest issue lies with outages of the network or the different
services. These types of issues can be resolved with the standard operations approaches
for highly available infrastructure.

Interaction issues should only occur when there is a change to one of the components of
the pipeline because the interactions are consistent when the pipeline is in use.
In order to ensure that the pipeline maintains correctness when changes are made to parts of the
pipeline it is important to apply the normal development process, i.e. using version control,
(unit) testing, continuous integration, delivery or deployment, and work item tracking etc.,
for each of the changes. This applies to the scripts and tools as well as the
[infrastructure](https://en.wikipedia.org/wiki/Infrastructure_as_Code). Additionally it
is especially important to execute thorough regression testing for any change to the
pipeline to ensure that a change to a single part does not negatively influence the
correctness of the pipeline.

Finally in order to ensure that the correctness of the pipeline can be maintained, and improved
if required, it is sensible to provide monitoring of the pipeline and the underlying infrastructure
as well as ensuring that all parts of the pipeline are versioned, tools and infrastructure alike,
and versions of all the parts are tracked for each input set.

#### Performance

- Modern software development requires fast feedback. Fast feedback means that it is
  easy to make changes. Both for fixing bugs / issues and for improving new features so
  that they match what the customer needs.
- Need to deliver results back to the stakeholders fast
- Performance needs to be consistent. The same build should take the same time so that
  developers and testers can count on the build system to deliver results

- How do we achieve performance
  - Performance is split over different parts. There's the performance of the continuous
    integration system and the performance of the scripts and tools
  - Additionally there is the performance of being able to process a large number of builds
    - In general some of the performance is related to being able to process large queues as
      fast as possible. This may be done by scale out (more executors) or by processing
      builds really fast
  - Build systems should be able to scale, so that it is possible to execute many builds
    in parallel.
  - The loading pattern of a development pipeline depends on the way the development team
    works. For instance when scrum is used it is likely that there will be more builds in the
    middle of the sprint than at the start or end. When using kanban the load on the system should
    be fairly consistent. Other processes may lead to more spiked load patterns.
    In practise build systems it is wise to design the pipeline for a fairly constant load most
    of the time with the ability to handle high peak loads, if necessary with a reduction in
    performance.
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