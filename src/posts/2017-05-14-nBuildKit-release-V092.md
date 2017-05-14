Title: nBuildKit release - V0.9.2
Tags:
  - nBuildKit
---

Version [0.9.2](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.9.2)
of [nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild) has been released. This release fixes
a number of bugs and adds a few new improvements

All the work items that have been closed for this release can be found on
[github](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/31?closed=1).


### Bugs fixed

- [280](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/280) - The `deploy.pushto.gitbranch`
  script called the `GitCurrentBranch` task with a `WorkingDirectory` property which did not exist,
  thus causing the pushing to a git branch deployment step to fail.
- [281](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/281) - The `deploy.pushto.gitbranch`
  script did not create the directory into which the repository should be cloned. This caused the
  step to fail.
- [286](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/286) - The `GenerateTargetsFile` custom
  task applied a custom assembly resolver which did not resolve references to the MsBuild assemblies.
  This is a problem for MsBuild 15.0 and higher because from that version onwards the MsBuild assemblies,
  e.g. `Microsoft.Build.XX` are no longer located in the GAC and can thus not be found by the standard
  assembly resolver.
- [287](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/287) - The `shared.prepare.copy.files`
  task did not correctly copy the directory hierarchy.
- [290](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/290) - The `build.prepare.generatefiles`
  script only generated the files if they did not exist. This has been changed so that generated
  files are always created and updated.


### Improvements

- [254](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/254) - All warnings and errors have been
  given a proper error code for easier parsing of errors from the log.
- [282](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/282) - The Git, Powershell and NuGet
  base tasks have been moved to the Core targets assembly so that they can be used in third party
  custom tasks as well.
- [284](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/284) - A new task has been added that
  allows extracting files from one or more ZIP archive files.
- [285](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/285) - Additional conditions have been
  added to all `ItemGroup` elements to ensure that these item groups are only loaded when they are
  required. This reduces build times and improves stability.
- [288](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/288) - A new task has been added that
  allows downloading files from a HTTP URL. If the file in question is an archive file it can
  additionally be unzipped before the final copy takes place.

Additionally the first steps to better documentation have been taken. The [readme](https://github.com/nbuildkit/nBuildKit.MsBuild/blob/master/README.md),
the [introduction](http://nbuildkit.github.io/nBuildKit.MsBuild/) and the [contributing](http://nbuildkit.github.io/nBuildKit.MsBuild/docs/contributing)
documents have been updated.
