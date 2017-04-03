Title: nBuildKit release - V0.9.0
Tags:
  - nBuildKit
---

Last release I talked about was [0.5.1](2015-05-23-nBuildKit-release-V051). A [lot more releases](https://github.com/nbuildkit/nBuildKit.MsBuild/releases)
have been done since that time. Today I released [0.9.0](https://github.com/nbuildkit/nBuildKit.MsBuild/releases/tag/0.9.0)
which was supposed to be a stabilization release but turned into a major change release.

- Artefact settings have moved to their own file so that each stage can reuse these settings
- Added version numbers to the user configuration files
- The inline tasks are now in a .NET assembly which provides the ability to execute unit tests and code analysis
  while building. Additionally far more complex tasks can be created this way. This also simplifies the include calls
  that need to be made to get all the tasks
- Manipulation of the configuration files prior to starting the build. This allows updating the configuration files prior
  to execution, so that we don't need to upgrade configuration files while still using the most recent version of
  nbuildkit, because nbuildkit can automatically transform the configuration files. Note that it is currently not
  possible to upgrade the old (0.8.3 and prior) configurations to 0.9.0 this way.
- User defined location for the settings files
- Build, test and deploy steps can define pre- and post-steps which should be executed prior to and post execution of the
  step. Additionally globally defined pre- and post-steps can be executed. These can for instance be used to write
  information to a log file or to gather post step information.
  nBuildKit uses this capability to generate a high level overview of the steps that were taken during the build process

- Separated the build server specific code into their own NuGet packages so that you can pull down only the versions
  you need.
- integration tests have gotten their own repositories

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
- Many bug fixes to existing tasks

- The performance of the whole build process has been improved by changes made in how the template tokens are generated
  and loaded. The overall speed up is about a factor 2

- The extensibility has got a new layer. It is now possible to create a build / test / deploy library that includes
  the nBuildKit capabilities while providing its own additional capabilities. For an example see the
  [ops-tools-build]() library
  which is being used in the [infrastructure-as-code]() work I'm doing.

The work items can be found in the  [0.9.0 milestone](https://github.com/nbuildkit/nBuildKit.MsBuild/milestone/26?closed=1)
on github

Will try to write some blog posts on how to work with nBuildKit.

For the next release we're focussing on improving the build of nBuildKit itself and getting a decent start with the
documentation.
