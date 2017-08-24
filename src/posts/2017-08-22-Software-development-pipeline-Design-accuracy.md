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



It must do so for both success results, i.e. the application was build and validated without issue, and failure results.


The reason to value *accuracy* as the number one characteristic of the development pipeline is
because it is important for the development teams to be able to rely on the outputs of the
pipeline, whether they are product artefacts, test results or output logs. Without the correctness
the development teams will eventually lose their trust in the development pipeline which will
lead them to ignore the results because they will assume that a failure is one of the system
instead of one caused by the input set. Once the development teams lose the trust in the
pipeline it will take a lot of work to regain their trust.

Once we know that having a development pipeline which delivers correct results is important the
next step is to determine how correctness can be build into the development pipeline. In essence
this task is a simple one, all one has to do is to ensure that all the parts that form the the
pipeline behave correctly for all input sets. Obviously practically this is a lot more difficult
than the previous statement makes it seem.




However it does point out that




For the scripts, tools and continuous integration system this means that each input returns a
correct response. Fortunately most scripts and tools do so for the majority of the inputs.
In cases where a tool returns an incorrect response an issue should be logged and corrected.

- Any higher level tools / scripts should be able to handle errors from the lower level tools / scripts
  and process them. Note that this doesn't mean that the higher level tool / script should fix the issue,
  more that it should respond consistently
- How do we deal with errors etc.?


With the tools taken care of two other areas need to be carefully controlled. The first is
that the infrastructure on top of which the development pipeline executes should be stable
and consistent, and the second is to ensure that the interaction of all the different parts
does not lead to incorrect results.





For infrastructure the biggest issue lies with outages of the network or the different
services. These types of issues can be resolved with the standard operations approaches
for highly available infrastructure.

- Robustness isn't correctness. Technically the infrastructure can fall over all the time as long as it
  delivers correct results. However outages make it hard to be correct because running one input set multiple
  times may return different results each time due to infrastructure issues. So in essence robustness is
  important for correctness too. More information about robustness will be provided in a future post





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