Title: nBuildKit release - V0.9.1
Tags:
  - nBuildKit
---

Hot on the heels of the last release version [0.9.1](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.9.1)
of [nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild) has been released. This release fixes
two bugs and adds a few internal improvements.

All the work items that have been closed for this release can be found on
[github](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/29?closed=1).

### Bugs fixed

- [273](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/273) - The `CalculateSemanticVersionWithGitVersion`
  task used the current directory as the working directory. While that is correct in most cases
  there are some cases, especially when running the integration tests, where that is not correct.
  This has been fixed by requiring the specification of the working directory.
- [277](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/277) - In the same way all NuGet tasks
  now need a working directory specified in order to make sure that the correct workspace is used
  when interacting with the NuGet command line.


### Improvements

- [272](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/272) - The
  [TestFunctions.PrepareWorkspace.ps1](https://github.com/nbuildkit/nBuildKit.MsBuild/blob/master/src/tests/TestFunctions.PrepareWorkspace.ps1)
  and the [TestFunctions.Git.ps1](https://github.com/nbuildkit/nBuildKit.MsBuild/blob/master/src/tests/TestFunctions.Git.ps1)
  have been updated with additional functions and checks so that when creating a test workspace the
  existing git flow process is only completed if the specified branch exists on the remote. This changes
  the completion of the git flow process from mandatory to optional.
- Additionally the `IsMasterBranch` and `IsDevelopBranch` properties have been defined in the settings
  file. These two properties indicate whether or not the current branch is the `master` or `develop`
  branch respectively.
- [69](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/69) - The documentation for nBuildKit itself
  is being moved from the wiki to a GitHub pages website. As of this release the build for nBuildKit
  will generate the website using [Wyam](https://wyam.io).
