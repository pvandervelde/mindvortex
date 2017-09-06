Title: Software development pipeline - Design accuracy
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

[ISO](https://en.wikipedia.org/wiki/Accuracy_and_precision#ISO_definition_.28ISO_5725.29) defines
accuracy as the combination of [correctness](http://dictionary.cambridge.org/dictionary/english/correct?q=correctness),
in agreement with the true facts, and [consistency](http://dictionary.cambridge.org/dictionary/english/consistency),
always behaving or performing in a similar way.

The reason to value *accuracy* as the number one characteristic of the development pipeline is
because it is important for the development teams to be able to rely on the outputs of the
pipeline, whether they are product artefacts, test results or output logs. Without the accuracy
the development teams will eventually lose their trust in the development pipeline, meaning that
they will start ignoring the results because the teams assume that a failure is one of the system
instead of one caused by the input set. Once the development teams lose the trust in the
pipeline it will take a lot of work to regain their trust.

Once we know that having a development pipeline which delivers correct results is important the
next step is to determine how accuracy can be built into the development pipeline.
In theory this task is a simple one, all one has to do is to ensure that all the parts that form the
pipeline behave correctly for all input sets. However as indicated by
[many](http://wiki.c2.com/?DifferenceBetweenTheoryAndPractice) -

> In theory there is no difference between theory and practice. In practice there is

which means that practically achieving accuracy is a difficult task due to the
many, often complex, interactions between the pipeline components. As a reminder
the [components](Software-development-pipeline-Design-introduction.html) the
development pipeline consists of are:

- The scripts that are used during the different parts of the cycle, i.e. the build, test
  and release scripts.
- The continuous integration system which is used to execute the different scripts.
- The tools, like the compiler, test frameworks, etc.

Based on this categorization of the pipeline parts and the previous statement one possible
way of approaching accuracy for a development pipeline is to first ensure that all the parts
are individually accurate. As a second stage the changes in accuracy due to interaction between
the parts can be dealt with.

For the scripts, tools and continuous integration system this means that each input returns a
correct response and does so consistently for each input set. Fortunately most scripts
and tools do so for the majority of the inputs. In cases where a tool returns an incorrect response
the standard software development process should be followed by recording an issue, scheduling the
issue and implementing, testing and deploying a new version of the tool. In this process
it is important to test thoroughly to ensure that the changes do not negatively impact
tool accuracy. Additionally it is important to execute both (automated) regression testing against known
input sets as well as high level (automated) smoke tests of the entire development pipeline
to validate that the issue has been fixed and no further issues have been introduced.
In order to minimize disruption to the development teams tests should be conducted outside
business hours if no test environment is available, i.e. if the production development
pipeline has to be used for the final tests. It is of course better if a test environment
is available so that testing can take place during business hours without affecting
the development teams. As a side note; having a test environment with a copy of the
development pipeline allows for the development of new features and other changes
while the production pipeline is in use, thus making it easier and quicker to evolve
the pipeline and its capabilities.

With the approach to development and improvement of the tools taken care of the other area that
needs to be carefully controlled is the infrastructure on top of which the development pipeline
executes. For infrastructure the biggest issues are related to outages of different parts of
the infrastructure, e.g. the network or the different services. In most cases
failures on the infrastructure level do not directly influence the correctness of the development
pipeline. It is obviously possible for a failure in the infrastructure to lead
to an incorrect service being used, e.g. the test package manager instead of the
production one. However unless other issues are present, i.e. the test package manager
has packages of the same version but different content, it is unlikely that
a failure in the infrastructure will allow artefacts to pass the development pipeline
while they should not. A more likely result is that failures in the infrastructure
lead to failures in the development pipeline thus affecting the ability of the
pipeline to deliver the correct results consistently.

The types of issues mentioned can mostly be prevented by using the modern approaches
to IT operations like [configuration management](https://en.wikipedia.org/wiki/Software_configuration_management)
and [immutable servers](https://martinfowler.com/bliki/ImmutableServer.html) to ensure
that the state of the infrastructure is known, [monitoring](https://en.wikipedia.org/wiki/System_monitor)
to ensure that those responsible for operations are notified of issues and
standard operating procedures and potentially auto-remediation scripts to
quickly resolve issues that arise.

It should be noted that it is not necessary, though extremely helpful, for the infrastructure
to be robust in order to provide an accurate development pipeline. Tooling can, and
probably should, be adapted to handle and correct for infrastructure failures as
much as possible. However as one expects it is much easier to build a development
pipeline on top of a robust infrastructure.

The final part of the discussion on the accuracy of the development pipeline deals
with the relation between accuracy and the interaction of the tools and infrastructure.
The main issue with interaction issues is that they are often hard to understand
due to the, potentially large, number of components involved. Additionally certain
interaction issues may only occur under specific circumstances like high load or
specific times of the day / month / year, e.g. daylight savings or on leap days.

Because of the complexity it is important when building and maintaining a development pipeline
to following the normal development process, i.e. using version control,
(unit) testing, continuous integration, delivery or deployment, work item tracking
and extensive testing etc. for all changes to the pipeline. This applies to the scripts
and tools as well as the [infrastructure](https://en.wikipedia.org/wiki/Infrastructure_as_Code).
Additionally it is especially important to execute thorough regression testing for any change to the
pipeline to ensure that a change to a single part does not negatively influence the
correctness of the pipeline.

Finally in order to ensure that the correctness of the pipeline can be maintained, and improved
if required, it is sensible to provide monitoring of the pipeline and the underlying infrastructure
as well as ensuring that all parts of the pipeline are versioned, tools and infrastructure alike,
and versions of all the parts are tracked for each input set.
