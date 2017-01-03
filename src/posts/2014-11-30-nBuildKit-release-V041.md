Title: nBuildKit release - V0.4.1
Tags:
  - nBuildKit
---

Version [V0.4.1](https://github.com/pvandervelde/nBuildKit/releases/tag/0.4.1) of the [nBuildKit](/projects/nbuildkit.html) build library has been released.

This release introduces the ability to [mix custom build steps](https://github.com/pvandervelde/nBuildKit/issues/44) with the default provided ones in [any order](https://github.com/pvandervelde/nBuildKit/issues/47) that is desired. On top of that additional changes were made that now make it possible to build [multiple Visual Studio solutions](https://github.com/pvandervelde/nBuildKit/issues/46) in a specific order.

Finally the user can provide one or more scripts that will be called if the build or the deploy process [fails](https://github.com/pvandervelde/nBuildKit/issues/48). These scripts can be used to clean-up resources or provide notification on build failure. Do note that any failure in these scripts will lead to the immediate termination of the process.
