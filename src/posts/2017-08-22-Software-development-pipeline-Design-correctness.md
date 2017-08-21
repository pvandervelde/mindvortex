Title: Software development pipeline - Design correctness
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

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