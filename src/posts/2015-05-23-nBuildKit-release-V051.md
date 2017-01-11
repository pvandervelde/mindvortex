Title: nBuildKit release - V0.5.1
Tags:
  - nBuildKit
---

Version [V0.5.1](https://github.com/pvandervelde/nBuildKit/releases/tag/0.5.1) of the [nBuildKit](/projects/nbuildkit.html)
build library has been released.

This release adds the following features

- [91](https://github.com/pvandervelde/nBuildKit/issues/91): MsBuild.Projects: Common.props should
  do a more extensive search for settings.props
- [90](https://github.com/pvandervelde/nBuildKit/issues/90): MsBuild: Allow pushing symbols via
  NuGet enhancement
- [89](https://github.com/pvandervelde/nBuildKit/issues/89): MsBuild: Allow assembly versioning to
  be more custom defined.
- [87](https://github.com/pvandervelde/nBuildKit/issues/87): MsBuild: Rename template files to have
  normal extension
- [86](https://github.com/pvandervelde/nBuildKit/issues/86): MsBuild: Rename the DirMsBuildShared,
  DirMsBuildExtensions and DirMsBuildTemplates properties enhancement
- [85](https://github.com/pvandervelde/nBuildKit/issues/85): Unable to build projects which have a
  mixture of target frameworks
- [83](https://github.com/pvandervelde/nBuildKit/issues/83): MsBuild: Allow PreCleanScripts and
  PreCompilationScripts to define their own properties
- [82](https://github.com/pvandervelde/nBuildKit/issues/82): MsBuild: Update the Sample custom
  version files to match the current version gathering capabilities
- [80](https://github.com/pvandervelde/nBuildKit/issues/80): MsBuild: Combine top-level build.msbuild,
  deploy.msbuild and shared.locatenbuildkit.msbuild
- [78](https://github.com/pvandervelde/nBuildKit/issues/78): MsBuild: Automatically include NuGet
  dependencies if nuspec is in same directory as project
- [72](https://github.com/pvandervelde/nBuildKit/issues/72): MsBuild: Define default directory
  paths only in settings.props file
- [68](https://github.com/pvandervelde/nBuildKit/issues/68): Improve inline documentation of
  settings.props file
- [66](https://github.com/pvandervelde/nBuildKit/issues/66): MsBuild: Provide initialization/installation
  scripts for an empty workspace
- [55](https://github.com/pvandervelde/nBuildKit/issues/55): MsBuild: Allow assembly copyright to be
  more custom defined
- [22](https://github.com/pvandervelde/nBuildKit/issues/22): MsBuild: Allow each file to have their
  own base directory when creating ZIP archives
- [19](https://github.com/pvandervelde/nBuildKit/issues/19): MsBuild.Projects: Provide scripts for
  Visual Basic projects

And fixes the following issues:

- [92](https://github.com/pvandervelde/nBuildKit/issues/92): MsBuild.Projects: GetVersion, VcsInfo and
  Generate files also run when they're disabled in the settings.props file
- [88](https://github.com/pvandervelde/nBuildKit/issues/88): MsBuild.Projects: Excessive NuGet
  restore of global packages
- [84](https://github.com/pvandervelde/nBuildKit/issues/84): Not compatible with ncrunch
- [54](https://github.com/pvandervelde/nBuildKit/issues/54): MsBuild: First space trimmed from
  release note content

Finally the following tasks were completed:

- [7](https://github.com/pvandervelde/nBuildKit/issues/7): MsBuild: Set up tests
