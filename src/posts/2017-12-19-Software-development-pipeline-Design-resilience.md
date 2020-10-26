Title: Software development pipeline - Design resilience
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

The [third property](/posts/Software-development-pipeline-Design-introduction.html) to consider is
*resilience*, which in this case means that the pipeline should be able to cope with
expected and unexpected changes to the environment it executes in and uses.

David Woods defines [four different types of 'resilience'](https://www.researchgate.net/publication/276139783_Four_concepts_for_resilience_and_the_implications_for_the_future_of_resilience_engineering) in a paper in the journal of reliability engineering and system safety. One of the different types
is the generally well known form of robustness, i.e. the ability to absorb perturbations or disturbances.
In order to be robust for given disturbances one has to know in advance where the disturbances will
come from, e.g. in the case of a development pipeline it might be expected that pipeline stages will
fail and will pollute or damage parts or all of the executor it was running on. Robustness in this
case would be defined as the ability of the pipeline to handle this damage, for instance by repairing
or replacing the executor. The other definitions for resilience are:

- Rebound, the ability to recover from trauma: In order to achieve this capacity ahead of time is
  required, i.e. in order to recover from a disturbance one needs to be able to deploy capabilities
  and capacity that was available in excess before the issues occurred.
- Graceful extensibility, the ability to extend adaptive capacity in the face of surprise. This is
  the ability to stretch resources and capabilities in the face of surprises.
- Sustained adaptability, which is the ability to adapt and grow new capabilities in the face of
  unexpected issues. In general this definition applies more to systems / layered networks where
  the loss of sub-systems can be compensated.

Which ever definition of resilience is used in general the goal is to be able to recover from
unexpected changes and return back to the normal state, ideally with minimal intervention. An interesting
side note is that returning back to normal after major trauma can be deceiving because the 'normal' as
experienced before the trauma will be different from the 'normal' experienced after the trauma due
to the lessons learned from the trauma and permanent changed caused by the trauma.

Additionally it is not just the unexpected or traumatic changes that are interesting in the case of a
development pipeline but also the expected ones, e.g. upgrades, maintenance etc., because in general
it is important for the pipeline to continue functioning while those changes are happening.

For a development pipeline resilience can be approached on different levels. For instance the
pipeline should be resilient against:

- Changes in the environment which range from small changes, e.g. additional tools being deployed,
  to big changes, e.g. migration of many of the services, and from expected, i.e. maintenance or
  planned upgrades, to unexpected
- Changes in the inputs and the results of processing those inputs which may range from build and test
  errors to issues with executors
- Invalid or incorrect configurations.

Once it is known what resilience actually means and what type of situations the pipeline is expected
to be able to handle the next question is how the pipeline can handle these situations, both in
terms of what the expected responses are and in terms of how the pipeline should be designed.

There are a myriad of simple steps that can be taken to provide a base level of resilience. None
of these simple steps will guard against major trauma but they will be able to either prevent or
smooth out many of the smaller issues that would otherwise cause the development team to lose faith
in the pipeline outputs. Some examples of simple steps that can be taken to improve resilience in
a development pipeline are:

- For each pipeline step ensure that it is executed in a clean 'workspace', i.e. a directory or drive,
  that will only ever be used by that specific single step. This workspace should be 'private' to the
  specific pipeline step and no other processes should be allowed to execute in this workspace. This
  prevents issues with unexpected changes to the file system. There are still cases where 'unexpected'
  changes to the file system can occur, for instance when running parallel executions within the same
  pipeline step in the same workspace. This type of behaviour should therefore be avoided as much as
  possible
- Do not depend on global, i.e. machine, container or network, state. Global state has a tendency
  to change in random ways at random times.
- Avoid using source which are external to the pipeline infrastructure because these are prone to
  unexpected random changes. If a build step requires data from an external source then the external
  source should be mirrored and mirrors should be carefully controlled for their content. This should
  prevent issues with external packages and inputs changing or disappearing, e.g.[leftpad](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/).
- If external sources are suitably mirrored inside the pipeline infrastructure then it is possible
  to remove the caches for these external sources on the executors. By pulling data in fresh from the
  local data store cache pollution issues can be prevented
- Ensure that each resource is appropriately secured against undesirable access. This is especially
  true for the executor resources. It is important to note that pipeline steps are essentially random
  scripts from an unknown source, even if the scripts are pulled from internal sources, because the
  scripts will not be security verified before being used. This means that the pipeline scripts should
  not be allowed to to make any changes or to obtain secrets that they shouldn't have access to.

As mentioned the aforementioned steps form a decent base for improving resilience and they are
fairly easy to implement, hence they make a good first stage in the improvement of the resilience
of the development pipeline. Once these steps have been implemented more complex steps can be taken
to further improve the state of the development pipeline. These additional steps can be divided into
items that help prevent issues, items that test and verify the current state, items that aid in
recovery and finally items, like logging and metrics, that help during post-mortems of failure cases.

One way prevention of trauma / outages can partially be improved is by ensuring that all parts of the
development pipeline are able to handle different error states which can be achieved by building in
extensive error handling capabilities, both for known cases, e.g. service offline, and general error
handling for unexpected cases. For the tooling / script side of the pipeline this means for instance
adding error handling structures nearly everywhere and providing the ability to retry actions.
For the infrastructure side of the pipeline this could mean providing highly available services and
ensuring that service delivery gracefully degrades if it can no longer be provided at the required
standard.

Even if every possible precaution is taken it is not possible to prevent all modes of failure. Unexpected
failures will always occur no matter what the capabilities of the development pipeline are. This means
that some of the way to improve resilience is to provide capabilities to recover from failures and to
recognise that unexpected conditions exist and to notify the users and administrators of this situation.
It should be noted that providing these capabilities may be much harder to implement due to the
flexible nature of the issues that are being solved for these cases.

By exposing the system continuously to semi-controlled unexpected conditions it is possible to
provide early and controlled feedback to the operators and administrators regarding the resilience
of the development pipeline. One example of this is the
[chaos monkey approach](https://github.com/Netflix/SimianArmy/wiki/Chaos-Monkey) which tests the
resilience of a system by randomly taking down parts of the system. In a well designed system this
should result in a response of the system in order to restore the now missing capabilities.

The actual handling of unexpected conditions requires that the system has some capability to instigate
recovery which can for instance consist of having fall-back options for the different sub-systems,
providing automatic remediation services which monitor the system state and apply different standard
recovery techniques like restarting failing services or machines or creating new resources to replace
missing ones.

From the high level descriptions given above it is hopefully clear that it will not be easy to create
a resilient development pipeline and depending on the demands placed on the pipeline many hours of
work will be consumed by improving the current state and learning from failures. In order to ensure
that this effort is not a wasted effort it is definitely worth applying iterative improvement approaches
and only continuing the improvement process if there is actual demand for improvements.
