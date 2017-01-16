Title: Blog publishing with AppVeyor
Tags:
  - AppVeyor
  - Blog
  - Build
  - Deploy
  - nBuildKit
---

One part of wanting to improve carreer and professional reach is to post more to this blog about
what I'm doing. This does mean however that publishing should be super easy otherwise the
publishing process becomes an excuse to not publish.

So being a build engineer the obvious solution was not to go to a
[managed system](https://www.troyhunt.com/its-a-new-blog/) to create some kind of build system to
automatically build and publish my blog posts. While Troy Hunt is probably right in that a managed
system is far quicker and easier to use (and thus saves time that you can use for something else),
setting my blog up to be automatically build and deployed means that I have another bit of experience,
and a new blog post about how to do this. I guess that almost makes up for the extra work I have
to do.

So the goals were

- Build every commit on an independent environment so that I can be sure that I can always build
  my blog and nothing is dependent on software installed on my machine.
- Minimal work done from my side to publish, i.e. automatically deploy the generated pages to my
  github pages when I merge my changes to the [master branch](https://github.com/pvandervelde/mindvortex)
  of the source repository
- Use a hosted build system so that I don't have to maintain the build system, and additionally
  can get some experience with that hosted build system
- Make it interesting enough to get a blog post out of it

And that is where we are now. This blog post was build and published using [AppVeyor](https://www.appveyor.com/).
The processes are controlled by [nBuildKit](/projects/nBuildKit).

The build process looks like

- Clear the workspace
- Get VCS information
- Merge to target(s): This assumes that the repository use the [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/)
  approach. Merges the active branch to the appropriate target branches and tags if necessary. All
  done just locally.
- Get version information with [GitVersion](https://github.com/GitTools/GitVersion)
- Build the pages with Wyam
- Zip up the generated pages

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

Pushing the changes is done via SSH and a [deploy key](https://github.com/blog/2024-read-only-deploy-keys).
This allows AppVeyor to push to the selected git repository without automatically granting access to
other repositories




