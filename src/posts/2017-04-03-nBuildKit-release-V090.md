Title: nBuildKit release - V0.9.0
Tags:
  - nBuildKit
---

Version [0.9.0](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.9.0) of [nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild)
has been released. The last release I talked about on this blog was [0.5.1](posts/nBuildKit-release-V051).
Since then a [lot more versions](https://github.com/nbuildkit/nBuildKit.MsBuild/releases) have been
released. The `0.9.0` release was supposed to be a stabilization release but there were many major
improvements which makes this a major change release.

The highlights are

- The settings describing artefacts, e.g. the nuspec and zip archive files to build, have moved to
  a [separate file](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/215) `artefacts.settings.props`.
  This allows each of the different stages, build, test and release, to easily use these settings
  without having to load configuration files from the other stages.
- All user specific configuration files now have a [version number](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/224)
  which indicates for which version of nBuildKit they were created. This will allow nBuildKit to
  transform older configuration files prior to using them.
- The inline tasks have been [moved to a .NET assembly](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/230).
  This simplifies the project includes that need to be made to get all the required tasks loaded.
  Additionally more complex tasks can be created and [unit tests can be written and executed](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/234)
  which should improve the quality of the tasks.
- User [defined location](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/191) and
  [transformation](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/192) of the configuration
  files prior to starting the build. In combination with the version numbers in the configuration
  files this allows nBuildKit to use configuration files from a previous version while still using
  the most recent version of nBuildKit. Note that it is currently not possible to upgrade the old
  (0.8.3 and prior) configurations to 0.9.0 this way.
- Build, test and deploy steps can define [pre- and post-steps](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/196)
  which are executed before and after the execution of the step. Additionally global pre- and post-steps
  can be defined which areo executed before and after each step. These pre- and post-steps can for
  instance be used to [write information to a log file](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/185)
  or to gather post step information.
- The [build server specific code](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/206) was
  moved into separate NuGet packages so that these can be pulled down on the build server only. Three
  different packages have been created for [Jenkins](https://jenkins.io/),
  [TFS2013](https://msdn.microsoft.com/library/ms181709%28v=vs.120%29.aspx?f=255&MSPPError=-2147217396)
  and [TFS2015 / TFS2017](https://www.visualstudio.com/en-us/docs/build/overview).
- The layout of the scripts and NuGet packages has changed so that it is easier to create a
  [new set of build tools based on nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/220).
  With this change it is now possible to create a build / test / deploy library that includes all or
  some of the nBuildKit capabilities while providing its own additional capabilities. An example is
  the [ops-tools-build](https://github.com/ops-resource/ops-tools-build) library which is being used
  in the [infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_Code) work I'm doing.

In addition to the major changes some additional build, test and deploy steps have also been defined:

- Complete a [gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows#gitflow-workflow)
  stage, e.g. finishing the feature, hotfix or release branch, to verify that the pending merge will
  not break the build. Additionally the results of the merge can be captured, by archiving the
  `.git` folder, and can later be used in the deploy process to push the merge to a git remote.
- [Copying files](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/255) from the file system or
  from a NuGet package.
- [ILMerge](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/238) one or more assemblies into a
  target assembly.
- Generating a targets file from an assembly containing MsBuild tasks.
- [Invoking](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/146) [Wyam](https://wyam.io)
  during the build process. Note that this is a late addition and hasn't been tested completely yet
- Invoking [Pester](https://github.com/pester/Pester) during the test phase.
- Pushing files to a git branch during the deploy stage.
- Pushing an entire repository to a git remote during the deploy stage.

Finally the performance of the whole build process has been improved by changing how the template
tokens are [generated and loaded](https://github.com/nbuildkit/nBuildKit.MsBuild/issues/242). The
overall speed up for the nBuildKit build itself is about a factor two.

All the work items that have been closed for this release can be found on
[GitHub](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/26?closed=1).
