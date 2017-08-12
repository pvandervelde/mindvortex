Title: Software delivery pipeline: On-prem or in the cloud?
Tags:
  - Delivering software
  - On-prem
  - Cloud
  - DevOps
---

- Cloud systems:
    - User has no influence on infrastructure of build systems, but doesn't have to
      worry about the infrastructure either
    - Generally scales 'infinitely' (at least what the user is concerned)
    - No control over the infrastructure also means no control over the build controller
      and plugins
    - Generally pay per use
- On-prem systems:
    - Have to provide the infrastructure / resources
    - Have to handle scaling yourself
    - Full control over infrastructure means can build it exactly as required
    - Need to spend time on maintenance
    - Full control and overview on security and locations where source goes
    - Outages are your problem to resolve, but not dependent on other people
    - Pay ahead for hardware and keep paying for the maintenance

Depends on the situation of the 'company' that needs the build system. For smaller
companies it is probably more efficient to use cloud based systems as they don't need
additional personel to maintain the system. Once a company grows additional staff to
maintain an on-prem build system.

Having a on-prem system provides more control over the configuration etc. That might
be important for some companies, for instance if you want to make sure that the code
of the software never leaves the premises, or if you need to have oversight for
certification / ??