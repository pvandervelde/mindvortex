Title: Software delivery pipeline - On-prem or in the cloud?
Tags:
  - Delivering software
  - Software delivery pipeline
  - On-prem
  - Cloud
  - DevOps
---

- Cloud systems:
    - User has no influence on infrastructure of build systems, but doesn't have to
      worry about the infrastructure either
    - Generally scales 'infinitely' (at least what the user is concerned)
    - No control over the infrastructure also means no control over the build controller
      and probably not the plugins / capabilities either
    - Generally pay per use / CPU min. This can get expensive if you have a lot of services
      that need to be running all the time
- On-prem systems:
    - Have to provide the infrastructure / resources
    - Have to handle scaling yourself
    - Full control over infrastructure means can build it exactly as required
    - Need to spend time on maintenance
    - Full control and overview on security and locations where source goes
    - Outages are your problem to resolve, but not dependent on other people
    - Pay ahead for hardware and keep paying for the maintenance

Both approaches have pros and cons. And which system is the most suitable depends
 on the situation of the 'company' that needs the build system.

- Should do a calculation of which costs more. If you use the system relatively little
  cloud systems are cheaper, however if you use the system constantly then it is likely
  that on-prem systems are cheaper. Obviously a cost calculation should also include the
  cost of training and staff maintaining the system. There is no infrastructure maintenance
  for a cloud system, but that doesn't mean there is no maintenance. And depending on how
  well the cloud system fits the local workflow there might be a lot of training / maintenance
  needed.
  Additionally you will always pay for the cloud system,
  while on-prem hardware is written off after a while. Obviously using old hardware means
  you don't get the highest performance so that's another trade-off.
  - Cannot necessarily directly compare. The lift-and-shift approach will probably lead to a
    worse outcome for the cloud system
  - A lot depends on the complexity of the system as well. If it's just a build system (i.e.
    some form of controller with one or more agents / executors) then it's probably easy to compare
    both systems. However most systems will include many other parts, e.g. package repositories,
    test environments, release / deployment systems, source control etc.
- Cloud systems require less effort but don't excuse using crappy approaches. In the end one still
  needs to know that the system provides the accuracy, performance, robustness and flexibility.
- If there are regulations about access to source code and processes maybe an on-prem system
  is required. Some cloud systems might provide the appropriate controls, and some might not.
  An on-prem system should always be able to provide the right controls and logs because you
  control how it is configured. Note however that the latter will obviously cost money
- In case of very specific executor configuration on-prem is ore likely to be the right choice,
  although some cloud systems allow connecting custom executors
- Finally can combine systems. Use on-prem with an overflow to cloud, or have cloud for most
  tasks but have on-prem for some specific ones that require highly configured executors.

For smaller
companies it is probably more efficient to use cloud based systems as they don't need
additional personel to maintain the system. Once a company grows additional staff to
maintain an on-prem build system might be a good investment.

In the end the decision to select a cloud build system or a on-prem build system depends
very strongly on the situation the company is in. As time progresses the best type of system
may change from on-prem to cloud or visa versa.
Both systems have their advantages and disadvantages. In the end all that matters is that
a system that fits the development process is selected, independent of what the different
vendors say is the best thing.
