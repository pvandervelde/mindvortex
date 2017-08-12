Title: nBuildKit release - V0.10.0
Tags:
  - nBuildKit
---

Version [0.10.0](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.10.0)
and version [0.10.1](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.10.1)
of [nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild)
have been released. The `0.10.0` release is the first release in the stabilization
cycle. There are still a few major changes but the goal is to start stabilizing nBuildKit
in preparation for the 1.0.0 release.

The highlights are

- [Renamed](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/308) `DirTest` to `DirTests`.
  This is a *breaking* change.
- Additional [meta data](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/248) can
  be provided with the build, test and deploy steps to indicate if a step should be inserted
  before or after another step in the sequence. Steps which have no insertion limits, i.e
  those steps that do not have the before or after meta data set, are inserted in document order.
  Steps that do define insertion limits are inserted according to the limits. Note that
  circular limits are not allowed as well as step sequences where there are no steps without
  insertion limits.
- Deploying artefacts to an [HTTP server](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/303)
- Initial implementation of the [ability to verify GPG hash signatures](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/296).
  The current implementation requires that the GPG tooling is allowed through the firewall.

In addition to the major changes some additional build, test and deploy steps have also been defined:

- Addition of properties that indicate [which stage the script is currently executing](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/304). The
  new properties are `IsBuild`, `IsTest` and `IsDeploy`
- Allowing [template variables](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/306) in the
  path and `destination` of the `ArchiveFilesToCopy` item group.
- Migrated the [hash calculation functions](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/297)
  from [Ops-Tools-Build](https://github.com/ops-resource/ops-tools-build).

All the work items that have been closed for this release can be found on
github in the milestone list for releases [0.10.0](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/30?closed=1)
and [0.10.1](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/35?closed=1).
