Title: Build system design: important bits
Tags:
  - Building software
  - DevOps
---

- Consistency: Building the same commit multiple times creates the same results
- Performance: Build as fast as possible, more specifically get results back to the interested parties as fast as possible
- Robustness: The build system should be able to cope with environmental change, be it desired or undesired.
  Ideally the build system would only report errors in the build process when there is an actual issue with
  the build artefacts, e.g. compiler issues, test failures etc.. Environmental issues should ideally be handled without
  it impacting the build.
- Flexibility: The ability to change the build process when needed, ideally without too much effort

## Consistency

- Why is it important that builds are consistent, i.e. building the same code commit creates the same
  output?
- How do we achieve consistency
