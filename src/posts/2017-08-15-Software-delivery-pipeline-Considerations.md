Title: Software delivery pipeline - Considerations
Tags:
  - Delivering software
  - DevOps
---

In order to deliver new or improved software applications inside the desired
time limits while maintaining or improving quality modern development moves towards
[shorter development and delivery](https://techbeacon.com/doing-continuous-delivery-focus-first-reducing-release-cycle-times)
cycles. This is often achieved through the use of agile processes and a development
workflow including [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration),
[Continuous Delivery](https://en.wikipedia.org/wiki/Continuous_delivery)
or even [Continuous deployment](https://www.agilealliance.org/glossary/continuous-deployment).
A reduction in development time requires that more parts of the development workflow
are automated. In general this automation is achieved with the help of scripts,
tools and the supporting infrastructure.

For the remainder of this post the build, test and release automation system is considered
to consist of:

- The scripts that are used during the different parts of the cycle, i.e. the build, test
  and release scripts.
- The continuous integration system which is used to execute the different scripts.

Items like version control, package management, issue tracking, system monitoring,
customer support and others are not included in the discussion to keep the scope small.

In order to be able to select or create a suitable build, test and release automation
system we need to know what desirable properties of such a system are.

Some of the most important
properties are:

- Consistency: The system must behave consistently. When a specific commit is pushed into

Building the same commit multiple times creates the same results
- Performance: Build as fast as possible, more specifically get results back to the
  interested parties as fast as possible
- Robustness: The build system should be able to cope with environmental change, be it
  desired or undesired. Ideally the build system would only report errors in the build
  process when there is an actual issue with the build artefacts, e.g. compiler issues,
  test failures etc.. Environmental issues should ideally be handled without
  it impacting the build.
- Flexibility: The ability to change the build process when needed, ideally without too
  much effort

In the next sections we'll discuss these properties.

## Consistency

- Why is it important that builds are consistent, i.e. building the same code commit creates the same
  output?
- How do we achieve consistency


## Performance

- Modern software development requires fast feedback. Fast feedback means that it is
  easy to make changes. Both for fixing bugs / issues and for improving new features so
  that they match what the customer needs.
- Need to deliver results back to the stakeholders fast
- Performance needs to be consistent. The same build should take the same time so that
  developers and testers can count on the build system to deliver results
- Build systems should be able to scale, so that it is possible to execute many builds
  in parallel.
- In practise build systems generally deal with a fairly constant load most of the time
  with high peak loads.

## Robustness

- Has to be able to deal with changes in the environment
- Has to be able to deal with changes in the source code and report the correct
  errors

## Flexibility


- Stuff