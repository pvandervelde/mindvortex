Title: Blog publishing with AppVeyor
Tags:
  - AppVeyor
  - Blog
  - Build
  - Deploy
  - nBuildKit
---

One part of [improving my career and increasing my professional reach](/posts/Goals-for-2017) is to
post more to this blog about the work that I am doing and the code and skills that come from this
work. Unfortunately at the moment writing is still more of a chore than it is a pleasure so that
means that if I want to publish more I need to make it very easy for me to do so, otherwise the publishing
process will just add yet another obstacle that I need to get past while producing content.

With me being a build engineer by profession the obvious solution was not to follow the
[sensible path](https://www.troyhunt.com/its-a-new-blog/) of a managed system but to create some
kind of build system to automatically build and publish my blog posts. Troy Hunt is right in
that a managed system is far quicker and easier to use, thereby saving time that you can use for
improvements elsewhere. In my case however I feel that there is something additional to be gotten from
setting my blog up to be automatically build and deployed. To be specific additional learning experiences,
 more knowledge and a new blog post about how I achieved the goal. I hope that those things will
make up for the extra work I have to do in maintaining my own blog.

So the goals for this project were

- Build every time I push to the [source repository](https://github.com/pvandervelde/mindvortex) on
  an independent environment so that I can be sure that I can always build my blog and nothing is
  dependent on my machine being available.
- Publishing should involve a minimal amount of work done from my side. Ideally all I would have to
  do is commit my changes, merge them to the [master branch](https://github.com/pvandervelde/mindvortex)
  of the source repository and then sit back and see the new post appear online.
- No maintenance is necessary for what ever system I use to achive this goal. When I build new versions
  of one of my libraries, applications or infrastructure resources I want full control over the
  build, test and deployment environments. For building my blog that is far less important because
  it is a simple process which does not require many different steps.
- Finally it would be nice to make it interesting enough to get a blog post out of it.

After a few hours of tinkering that is where we are now, this blog post was build and published
using a combination of [AppVeyor](https://www.appveyor.com/) as the build server and
[nBuildKit](/projects/nBuildKit) for the build and deploy scripts.

In order to achieve this the first step that I took was to set up the build scripts so that I could
build on my local machine. Having a build that executes in the same way on a developer machine
and the build server has many benefits.

- Familiarity: developers understand what the build server does because it works exactly as on their
  machine.
- Ease of debugging: it is easier to discover the source of any errors if you can execute the scripts
  on a developers machine because then you have have full access to the workspace which may not be
  the case on a build machine.
- Ease of testing: even build scripts need to be tested. If this is done on a developer machine then
  the testing will most likely be able to be executed much quicker because there is less need to
  commit every change, push it to the server and wait for the build server to execute the build.

Configuring `nBuildKit` means copying the [sample files](https://github.com/nbuildkit/nBuildKit.MsBuild/tree/master/src/samples)
to the root of the workspace and updating them with values relevant to the project.

In this case I updated the `settings.props` file, which contains the general information about the
build, test and deploy processes, with [product information](https://gist.github.com/pvandervelde/88aa8f644148b4cdb9fa909fe3ff8f69).

I also [enabled the automatic merging](https://gist.github.com/pvandervelde/9853b15889ccf67bafa5fa2e93594ca2)
for the [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/) process. This allows
nBuildKit to automatically complete feature, hotfix and release branches when running on a build
server so that each build also verifies that the final merge will be successful and the changes will
not break anything after the merge.

The next file to update was the `build.settings.props` file, which describes what needs to be done
during the build process, was updated. The first part of that was to define which [steps should be
taken during the build process](https://gist.github.com/pvandervelde/015611f5355b07e1b3246ae81bf2ea0a).

- Clear the workspace. While this is not necessary on a build server, after all a fresh workspace
  is used for each build, it is necessary on a developer machine because old artefacts may still
  be present.
- Ensure that the build server has configured the workspace with the correct source control information.
  Many build systems do not perform a full clone at the start of a build but rather get only the
  minimal source control information in addition to the source files. This reduces time and IO
  demands, especially for repositories with extensive history. Different build systems have a
  different approach to what steps exactly are taken. The lack of source control information, e.g.
  the state of different branches, or the branch that the current commit is part of, is not a
  problem if the only step is to compiling code however issues can occur if the state of the local
  workspace is used to determine version numbers or VCS information. In those cases it is better to
  ensure that the workspace is in the same state as it was on the developers machine.
- Gather VCS information like the current commit ID and the branch name. For my blog this information
  is embedded in the footer of every page to indicate which commit was build and what version
  of the blog you are looking at.
- Complete the active `GitFlow` branch, if there is one, by merging the active branch to the
  appropriate target branches and adding tags if necessary.
- Get version information with [GitVersion](https://github.com/GitTools/GitVersion). This
  is done after the merge process so that the version number is the release version.
- [Build the pages](https://gist.github.com/pvandervelde/813a19ff4861470ba03591a5ecc4b910) with Wyam.
- Zip up the generated pages

The final change to the `build.settings.props` file was to enable the generation of the archive
files by [uncommenting the `ArchivePackageSpecs` section](https://gist.github.com/pvandervelde/d1ec2c78fc560bd20ef1ef7a375eee30).

The last file to be changed was the `deploy.settings.props` file which describes what needs to be
done during the deploy process. As with the `build.settings.props` file the first step here was
to select the [steps that should be taken during the deploy process](https://gist.github.com/pvandervelde/8ee5a1dc96d0835bb8b3aa6354896ba7).

- Once again ensure that the build server workspace is configured with the correct source control
  information.
- Gather version information in the same way as was done during the build process.
- [Push the archive files](https://gist.github.com/pvandervelde/c6490e33fd73d0f7afc15677a4bf2e8b)
  to AppVeyor.
- Push the files contained in the archive file to the [repository](https://github.com/pvandervelde/pvandervelde.github.io)
  that contains the generated pages. This was simply done by enabling the `DeployStepsPushToGitBranch`
  deploy step and [providing information about the repository and branch](https://gist.github.com/pvandervelde/9a2dd811faf4d0e56ef3b5069d2e7d3c)
  that the files should be pushed to. The commit message for this process currently comes from a text
  file in the root of the repository. Ideally there would be some way to discover a decent commit
  message, e.g. the name of the most recent post, however many different changes are pushed to the
  source repository so selecting the correct commit message is somewhat difficult.

By updating these three files we have provided `nBuildKit` with enough information to execute both
the build and deploy processes.

Once the build scripts were complete and tested the only thing that remained was to configure
AppVeyor. This can either be done through the [UI or a YAML file](https://www.appveyor.com/docs/build-configuration/).
In this case I elected to use the [YAML file](https://gist.github.com/pvandervelde/4171a3b81776132e2800a3f9b802fa43)
so that all information describing my build and deployment process would exist in the repository.

In order to create the configuration file I copied the [reference file](https://www.appveyor.com/docs/appveyor-yml/)
and then removed all the bits I didn't need. The only tricky bit was setting up the AppVeyor
environment so that the deploy process could push the final results back to GitHub. For that I
added a [deploy key](https://github.com/blog/2024-read-only-deploy-keys) to the target repository.
The private part of this key was then encrypted and placed in the YAML file. Some `before_deploy`
[script magic](https://www.appveyor.com/docs/how-to/private-git-sub-modules/) allows the decryption
of the key so that git can push the changes to the repository via SSH.
