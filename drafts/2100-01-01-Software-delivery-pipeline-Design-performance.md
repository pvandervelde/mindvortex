Title: Software delivery pipeline - Design performance
---

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
