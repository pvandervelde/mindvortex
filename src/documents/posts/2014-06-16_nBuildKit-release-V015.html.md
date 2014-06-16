---
title: 'nBuildKit release - V0.1.5'
tags: ['nBuildKit']
commentIssueId: 42
---

Version [V0.1.5](https://github.com/pvandervelde/nBuildKit/releases/tag/0.1.5) of the [nBuildKit](/projects/nbuildkit.html) build library has been released. 

This first release introduces the [MsBuild](https://www.nuget.org/packages/nBuildKit.MsBuild/0.1.5) NuGet package. This package contains build scripts that provide the ability to perform a complete build consisting of workspace preparation, compilation of binaries, execution of unit tests, analysis of source code and binaries and finally packing of the binaries as NuGet packages or ZIP archives.
The `nBuildKit.MsBuild` NuGet package also provides scripts that can be used to tag a release in the version control system (VCS) and deploy the artifacts to a file server, NuGet feed or a GitHub release.

The documentation for this library can be found on the nBuildKit [wiki](https://github.com/pvandervelde/nBuildKit/wiki/MsBuild)