Title: Build configuration as code
Tags:
  - Building software
  - Build server
  - Configuration-as-code
  - DevOps
---

- Build systems generally allow users to configure their builds through a pretty UI. This makes it
  easy to quickly create a new build or to update the build configuration.
- Build systems store their configurations either in a database (tfs, teamcity) or on the file system
  (jenkins).
- Problem is that the changes aren't necessarily recorded so it's hard to figure out what changes
  were made and why
- Other problem is that changes may be related to changes in the way you build your product, but
  it is hard to trace that back. Should you ever need to recreate a build then you don't have a record
  of what your build environment should look like

