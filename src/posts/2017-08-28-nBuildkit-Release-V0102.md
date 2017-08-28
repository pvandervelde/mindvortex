Title: nBuildKit release - V0.10.2
Tags:
  - nBuildKit
---

Version [0.10.2](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.10.2)
of [nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild)
has been released.

This release made the following minor changes

- [Removed](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/316) the custom tasks assembly
  from the `nBuildKit.MsBuild.Actions` NuGet package because those were never used from that package
  as they are also in the `nBuildKit.MsBuild.Tasks` NuGet package
- Added a deployment step to get [VCS information](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/318)
  during the deploy process.
- Fixed [missing bootstrap steps](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/317)
  in the test and deploy stages.

All the work items that have been closed for this release can be found on
github in the milestone list for the [0.10.2](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/36?closed=1) release.
