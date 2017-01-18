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
work. At the moment writing is still more of a chore than it is a please so that means that if
I want to publish more I need to make it very easy for me to do so, otherwise the publishing
process gets in the way of producting content.

With me being a build engineer by profession the obvious solution was not to follow the
[sensible path](https://www.troyhunt.com/its-a-new-blog/) of a managed system but to create some
kind of build system to automatically build and publish my blog posts. Troy Hunt is right in
that a managed system is far quicker and easier to use, thereby saving time that you can use for
improvements elsewhere. In my case I feel that there is something additional to be gotten from
setting my blog up to be automatically build and deployed. In this case another learning experience,
some additional knowledge and a new blog post about how I achieved the goal. I guess that almost
makes up for the extra work I have to do in maintaining my own blog.

So the goals for this project where

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

That is where we are now, this blog post was build and published using [AppVeyor](https://www.appveyor.com/)
and [nBuildKit](/projects/nBuildKit).

This was achieved by copying the relevant [sample nBuildKit files](https://github.com/nbuildkit/nBuildKit.MsBuild/tree/master/src/samples)
to the root of the repository.

Then I updated the property files with values that were suitable for this project. In this case I

- Changed the `settings.props` file which contains the general information about the build, test
  and deploy processes.
    * Update the product information

<script src="https://gist.github.com/pvandervelde/88aa8f644148b4cdb9fa909fe3ff8f69.js"></script>

    * Enabled the automatic merging for the [GitFlow]() process. This allows nBuildKit to automatically
      complete feature, hotfix and release branches when running on a build server. That way merges
      are tested each time a build runs. Failures in the merge process will lead to build failures.

<script src="https://gist.github.com/pvandervelde/9853b15889ccf67bafa5fa2e93594ca2.js"></script>

- Updated the `build.settings.props` file to describe what needs to be done during the build process.
    * Selected the steps that should be taken during the build process. In this case we want to
        - Clear the workspace
        - Ensure that the build server has checked out the correct branch. Many build systems
          pull the specific commit but don't attach a branch to the commit. While this is fine
          if you are just compiling code is can cause issues if you are using the state of the
          local workspace to determine version numbers or VCS information. In those cases it is
          better to ensure that the workspace is in the same state as it was on the developers
          machine.
        - Gather VCS information like the current commit ID and the branch name.
        - Merge to target(s): This assumes that the repository use the [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/)
          approach. Merges the active branch to the appropriate target branches and tags if necessary.
          All merge operations are still done on the local workspace. Nothing is pushed to the
          server at this stage.
        - Get version information with [GitVersion](https://github.com/GitTools/GitVersion). This
          is done after the merge process so that we get the version number that the product would
          have as we release it
        - Build the pages with Wyam
        - Zip up the generated pages

<script src="https://gist.github.com/pvandervelde/015611f5355b07e1b3246ae81bf2ea0a.js"></script>

    * Enable the creation of the archive

<script src="https://gist.github.com/pvandervelde/d1ec2c78fc560bd20ef1ef7a375eee30.js"></script>

- Updated the `deploy.settings.props` file to describe what needs to be done during the deploy process.
    * Selected the steps that should be taken during the deploy process. In this case we want to



    FOOBAR



<script src="https://gist.github.com/pvandervelde/8ee5a1dc96d0835bb8b3aa6354896ba7.js"></script>


The build process looks like



Invoke Wyam from nBuildKit

<script src="https://gist.github.com/pvandervelde/813a19ff4861470ba03591a5ecc4b910.js"></script>



The version and GIT commit information is embedded in the footer of each page

The deploy process looks like

- Clone the target repository
- Delete all files except the .git directory
- Expand the zip file into the working directory for the target repository
- commit the changs
- push the changes

The commit message currently comes from a text file in the root of the repository. Ideally there
would be some way to discover a decent commit message (like the name of the most recent post)
but there are cases where no new posts are published but other changes are made. We still need
a commit message in that case.

AppVeyor configuration file:
<script src="https://gist.github.com/pvandervelde/4171a3b81776132e2800a3f9b802fa43.js"></script>

Pushing the changes is done via SSH and a [deploy key](https://github.com/blog/2024-read-only-deploy-keys).
This allows AppVeyor to push to the selected git repository without automatically granting access to
other repositories. And still easy to remove the SSH key in case something is compromised
