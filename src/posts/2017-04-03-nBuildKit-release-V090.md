Title: nBuildKit release - V0.9.0
Tags:
  - nBuildKit
---

Version [0.9.0](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.9.0) of [nBuildKit](https://github.com/nbuildkit/nBuildKit.MsBuild)
has been released. The last release I talked about on this blog was [0.5.1](2015-05-23-nBuildKit-release-V051).
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





- The extensibility has got a new layer. It is now possible to create a build / test / deploy library that includes
  the nBuildKit capabilities while providing its own additional capabilities. For an example see the
  [ops-tools-build]() library
  which is being used in the [infrastructure-as-code]() work I'm doing.








A number of new build, test and deploy steps have also been defined:









- New step capabilities
  - Complete a [gitflow]() stage (i.e. finishing the feature, hotfix or release branch) to verify that the merge
    will not break the build. Additionally the results of the merge can be captured (by archiving the `.git` folder)
    and can be used in the deploy process to push the merge to a git remote
  - Copying files from a NuGet package
  - Copying files from the file system
  - ILMerging assemblies
  - Generating a targets file from an assembly containing MsBuild tasks
  - Invoking [Wyam](https://wyam.io). Note that this is a late addition and hasn't been tested properly yet
  - Invoking pester during the test phase
  - Pushing files to a git branch during the deploy stage
  - Pushing an entire repository to a git remote during the deploy stage





Finally the performance of the whole build process has been improved by changing how the template
tokens are generated and loaded. The overall speed up for the nBuildKit build itself is about a
factor two.

All the work items that have been closed can be found on [github](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/26?closed=1).

For the next release the focus is on improving the build and deploy process of nBuildKit itself and
improving the documentation.
