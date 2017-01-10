Title: Building and delivering nBuildKit with AppVeyor
Tags:
  - AppVeyor
  - Continous integration
  - nBuildKit
  - Software delivery
---

The build server that is being used to build the packages for [nBuildKit](/projects/nbuildkit.html)
is [AppVeyor](http://www.appveyor.com/). AppVeyor is an Continuous Integration system in the cloud.
The way AppVeyor works is that every time a commit occurs in a GitHub project AppVeyor is notified.
AppVeyor then spins up a new clean virtual machine (VM) on which your build scripts are executed.
Once the build is done the VM is terminated and thrown away. This way there is no way that the
changes made to the build environment by a build will influence future builds.

For nBuildKit two builds were configured. The first configuration is the standard
[continuous integration](https://ci.appveyor.com/project/pvandervelde/nbuildkit) build which generates
the version numbers and templates and then creates the NuGet packages. As the final step the build
artefacts are archived for later use by the second build configuration.
For this configuration no special settings are required other then to tell AppVeyor to store the artifacts.

The second build configuration handles the [delivery](https://ci.appveyor.com/project/pvandervelde/nbuildkit-244)
of the artefacts. This configuration gathers the build artefacts from the latest build of the first
build configuration, tags the revision that was build and then pushes the NuGet packages to
[NuGet.org](http://www.nuget.org/packages/nbuildkit.msbuild) and marks the given commit as a release
in [GitHub](https://github.com/pvandervelde/nBuildKit/releases).

For this second configuration a few tweaks need to be made to the environment before the build can be
executed. The first thing to do is to install the [GitHub-release](https://github.com/aktau/github-release)
application which provides an easy way to push release information to github. A simple Powershell
script is used to set-up this part of the environment:

<script src="https://gist.github.com/pvandervelde/77bd834239d9f67c40d7.js"></script>

Once all the required tools are installed the artefacts of the selected continuous integration build
need to be downloaded and placed in the correct directories. For that yet another Powershell script
is used:

<script src="https://gist.github.com/pvandervelde/9cf270ef5266b18a1ac9.js"></script>

Once all the artefacts are restored the delivery process can be executed. For nBuildKit the delivery
process is executed by nBuildKit itself in the standard dogfooding approach that is so well known in
the software business.

