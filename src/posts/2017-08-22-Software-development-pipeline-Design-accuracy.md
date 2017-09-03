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
the development teams will eventually lose their trust in the development pipeline which will
lead them to ignore the results because they will assume that a failure is one of the system
instead of one caused by the input set. Once the development teams lose the trust in the
pipeline it will take a lot of work to regain their trust.

Once we know that having a development pipeline which delivers correct results is important the
next step is to determine how accuracy can be build into the development pipeline.
In theory this task is a simple one, all one has to do is to ensure that all the parts that form the the
pipeline behave correctly for all input sets. However as indicated by
[many](http://wiki.c2.com/?DifferenceBetweenTheoryAndPractice) -

> In theory there is no difference between theory and practice. In practice there is

which means that practically achieving accuracy is a difficult task due to the
many, often complex, interactions between the pipeline parts.

As indicated [previously](Software-development-pipeline-Design-introduction.html) the
development pipeline consists of

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
tool accuracy. Additionally it is important that (automated) regression testing against known input sets
should be performed as well as high level (automated) smoke tests of the entire development pipeline
to validate that the issue has been fixed and no further issues have been introduced.

In order to minimize disruption to the development teams tests should be conducted outside
business hours if no test environment is available, i.e. if the production development
pipeline has to be used for the final tests. It is of course better if a test environment
is available so that testing can take place during business hours without affecting
the development teams. Additionally having a test environment with a copy of the
development pipeline allows for the development of new features and other changes
while the production pipeline is in use.

With the approach to development and improvement of the tools taken care of the other area that
needs to be carefully controlled is the infrastructure on top of which the development pipeline
executes. For infrastructure the biggest issues are related to outages of different parts of
the infrastructure, e.g. the network or the different services.

- These types of issues can be resolved with the standard operations approaches
  for highly available infrastructure.


It should be noted that it is not necessary, but extremely helpful, for the infrastructure
to be robust in order to provide an accurate development pipeline. Tooling can, and
probably should, be adapted to handle and correct for infrastructure failures. However
as one expects it is much easier to build a development pipeline on top of a robust
infrastructure.



- Interaction is the final bit. Need to make sure that all the parts connect in
  the correct way

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
