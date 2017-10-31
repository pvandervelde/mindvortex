Title: Software development pipeline - Design performance
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

The second property to consider is *performance*, namely the pipeline must provide feedback on
the quality of the current input set as soon as possible reduce the duration of the feedback cycle.
Having a fast feedback cycle means that it is easier for the development teams to make changes
because they are notified of any issues while the change is still fresh in their minds.

Performance of a development pipeline has two main aspects:

- How quickly can one specific input set be processed completely by the pipeline. In other words
  how much time does it take to push a single input set through the pipeline from the initial change
  to the delivery of the final artefacts.
- How quickly can a large set of input sets be processed. The maximum number of executors will most
  likely be limited to some maximum value. The pipeline is limited in the number of simultaneous
  input sets it can process by the number of available executors. How quickly the pipeline can
  process large number of input sets depends both on the time necessary to process a single input set
  and the relation between the total number of input sets and the number of executors

A closer look at these two aspects will allow us to get a high level idea on how to construct a well
performing development pipeline.

How quickly a single input set can be processed depends on how many steps there are in the development
pipeline for a given input set and how quickly each of those steps can be executed.

- Depends on what each step does. Some general (probably obvious things)
  - Only perform the necessary steps, code that is not executed is faster than code that is executed
    - This means that partial builds are better than full rebuilds, from a performance perspective
  - Only gather the necessary data. Gathering data that is not required wastes time, thus smaller
    builds are better
  - Pulling data off the local disk is faster than pulling it off the network,
    pulling data off the local network is faster than pulling it from the WAN / internet etc.. Locality
    still matters
    - Only grab 'remote' data once and cache it locally
- Ensure that pipeline steps run on suitable 'hardware' (either physical or virtual). Ideally the
  step is executed on hardware that is optimized for the performance demands of the step, e.g.
  execute I/O bound steps on hardware that has fast I/O etc.

The second item to pay attention to is how to scale the capacity of the development pipeline.
As indicated previously XXXXXXXXXX

- How many executors are there and how powerful are the executors (i.e. how quickly can an executor
  process a standard input set)
- How efficiently does the system distribute jobs. It's not very useful to 'start' a job
  only to find out that there are no executors for the job (I'm looking at you TFS2013)


Another issue that needs to be taken into account is the loading pattern of a development pipeline
which depends on the way the development team works. For instance when scrum is used it is likely
that there will be more builds in the middle of the sprint than at the start or end. When using
kanban the load on the system should be fairly consistent. Other processes may lead to more spiked
load patterns. In practise with build systems it is wise to design the pipeline for a fairly constant
load most of the time with the ability to handle high peak loads, if necessary with a reduction in
performance.

Note that one of the performance goals is to process as many input sets in as short a time as possible,
in other words the development pipeline, both the tools and the associated infrastructure, should
be designed for maximum throughput for the development team, not necessarily for resource efficiency.
For instance the development pipeline may only be 100% loaded a few times a week. In this case depending
on when the maximum load takes place it may be necessary to increase the capacity of the pipeline.
For instance if the peak loading only occurs during the night, for instance while running nightly
builds or tests, then the pipeline capacity will be large enough as long as the nighly activities
finish before the development team arrives in the morning. On the other hand if the peak loading
occurs during working hours then it might be necessary to increase the capacity if the wait times
get too large.





- How do we achieve performance (Hard to put in general terms)
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

  - The standard performance advice applies:
    - Make sure the scripts and tools don't do any work that is not necessary. Don't generate
      information that is not used, do work only once and use a cached version if possible,
      don't talk to services over the network any more than required,
      get artefacts from a local store if possible (e.g. packages), push artefacts to a local
      store if possible.
  - Reduce the number of steps. Each transition has a certain overhead. However
    by having multiple steps it may be possible to execute several steps in parallel. This
    will reduce the wall clock time for processing a single input set. Note however that the
    total resource use (i.e. CPU time) will not be reduced (the same amount of work still needs
    to be done), and by splitting the development pipline for a single input set into multiple steps
    that execute in parallel the throughput of the pipeline is reduced (i.e. fewer input sets
    can be processed at the same time)

  - Can split into stages, each stage will be smaller which provides potential for running
    stages in parallel. Note however that splitting in too many stages might be a disadvantage
    because each stage has overhead
  - Measure everything and constantly monitor for performance changes.

In general it seems sensible to keep build stages to under 10 minutes (ideally under 5) and create a
pipeline that combines the required stages. From a performance perspective it is better to have
multiple stages run in parallel than in sequence, however this requires that the infrastructure is
available to handle this.

Note that some measures taken for performance may negatively affect any of the other characteristics.
