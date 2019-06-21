Title: Software development pipeline - Design performance
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

The [second property](Software-development-pipeline-Design-introduction.html) to consider is
*performance*, which in this case means that the pipeline should provide feedback on the quality of
the current input set as soon as possible in order to reduce the length of the feedback cycle. As is
[known](https://www.richard-banks.org/2013/04/why-short-feedback-cycle-is-good-thing.html)
[having](https://www.ambysoft.com/essays/whyAgileWorksFeedback.html) a short
[feedback](https://continuousdelivery.com/2012/08/why-software-development-methodologies-suck/)
cycle makes it easier for the development teams to make improvements and fix issues.

There are two main components to development pipeline performance:

- How quickly can one specific input set be processed completely by the pipeline. In other words
  how much time does it take to push a single input set through the pipeline from the initial change
  to the delivery of the final artefacts. This depends on the number of steps in the development
  pipeline and how quickly each step can be executed.
- How quickly can a large set of input sets be processed. The maximum number of executors will most
  likely be limited to some maximum value. The pipeline is limited in the number of simultaneous
  input sets it can process by the number of available executors. How quickly the pipeline can
  process large number of input sets depends both on the time necessary to process a single input set
  and the relation between the total number of input sets and the number of executors

Optimizing the combination of these two components will lead to a development pipeline which is
designed for maximum throughput for the development team. One important note to make is that a high
performing pipeline will not not necessarily be the most resource efficient pipeline. For instance
the development pipeline may only be fully loaded a few times a week. From a resource perspective
the pipeline components are more than capable of dealing with the load, in fact the components may
even be oversized. However because one of the main goals of the pipeline is to deliver fast feedback
to the development teams the actual sizing of the pipeline and its components depends more on the
way the pipeline will be loaded over time, e.g. will the jobs come as a constant stream or in
blocks, will the jobs be small or large or will it be a mixture of both. In some cases the loading
pattern can be accurately predicted while in other cases it is completely unpredictable.
In general the pattern will depend on the workflow followed by the development team and the geographical
distribution of the team. For instance when the team follows the Scrum methodology it is
likely, though not necessary, that there will be more builds in the middle of the sprint than at the
start or end. On the other hand when using the Kanban methodology the load on the system should be
fairly consistent. Additionally geographical distribution of the development team influences the
times that the pipeline will be loaded. If all of the team is in a single geographical location then
higher loads can be expected during the day while lighter loads are be expected during the evening
and night. However if the team is distributed across the globe it is more likely that the loading will
be more consistent across the day due to the fact that the different locations have 'office hours' at
different times in the day, as seen from the perspective of the different servers which are part of
the development pipeline. Taking these issues into account when sizing the capacity of the development
pipeline may lead to increasing the capacity of the pipeline because the the current peak loading
during working hours results in wait times which are too large.

With this high level information it is possible to start improving the performance of the development
pipeline. This obviously leads to the question: "What practical steps can we take". As per normal when
dealing with performance improvements it is hard to provide solutions because these depend
on the specific situation. It is however possible to provide some more general advise.

The very first step to take when dealing with performance is always to measure everything. In the case
of the development pipeline it will be useful to gather metrics constantly and to automatically process
these metrics into several key performance indicators, e.g. the number of input sets per time span, which
describes the loading pattern, the waiting times for each input set before it is processed and the
time taken to process each input set. These key performance indicators can then be used to keep
track of performance improvements as changes are made to the pipeline.

One important issue to keep in mind with regards to performance is that unlike with accuracy performance
may change over time even if there are no _changes_ to the system because the performance of the
underlying infrastructure might change, for instance when disks fill up, the network load changes or
the hardware ages. This means it will be important to track performance trends over longer periods of
time to average out the influences of temporary infrastructure changes, e.g. network loading.

With all that out of the way some of the standard steps that can be taken are:

- Each pipeline stage should only perform the necessary steps to achieve the desired goal. This for
  instance means that partial builds are better than full rebuilds, from a performance perspective.
- Only gather data that will be used during the current stage. Gathering data that is not required
  wastes time, thus smaller input sets are quicker to process.
- When pulling data locality matters. Pulling data off the local disk is faster than pulling it off
  the network, pulling data off the local network is faster than pulling it from the WAN or the internet.
  Additionally data that is not local should be cached so that it only needs to be retrieved once.
- Ensure that pipeline stages run on suitable 'hardware', either physical or virtual. Ideally the
  stage is executed on hardware that is optimized for the performance demands of the step, e.g.
  execute I/O bound steps on hardware that has fast I/O etc.


In addition to these improvements it will be important to review and improve the ability of the
pipeline to execute many input sets in parallel.

- Ensure that the pipeline applications which deal with the distribution of input sets are efficient
  at this task. It's not very useful to start processing an input set only to find out that there
  are no executors which can process this given input set (I'm looking at you TFS2013).
- Splitting a single stage into multiple parallel stages will improve throughput for a single input
  set. However it might decrease overall throughput due to the fact that a single input set requires
  the use of multiple executors. Note that splitting a single stage into many parallel stages might
  lead to reductions in performance due to the overhead of transitioning between stages.

The mentioned improvements form a start for improving the performance of the pipeline. Depending on
the specific characteristics of a given pipeline other improvements and design choices may be valid.

Finally it must be mentioned that some performance improvements will have negative influences on the
other [properties](Software-development-pipeline-Design-introduction.html). For instance using partial
builds may influence accuracy. In the end a trade-off will need to be made when it comes to changes
that influence multiple properties.
