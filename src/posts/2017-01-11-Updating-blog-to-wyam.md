Title: Exit Docpad, enter Wyam
Tags:
  - Blog
---
After not having done anything with my blog for over a year I have returned and will once again try
to make this blogging thing happen. Part of my goals for 2017 is to start advancing my career
independent from my job. And one part of that goal is to blog about all the things I'm learning.

For about a year and a half [Docpad](http://docpad.org/) has been very helpful in adding content to
my blog, however as I was trying to automate my blog more and more I came to the conclusion that
being on a Windows operating system doesn't make dealing with node and NPM any easier. So I figured
it might make sense to switch to a [static generator]() which uses technologies that play better on
Windows. Enter [Wyam](https://wyam.io), a static generator written in .NET, a technology stack
I'm very familiar with.


### Getting started

To get started with Wyam I downloaded the latest version and generated a skeleton directory structure
by running the `wyam.exe new --recipe Blog` command. Once the skeleton has been created you can
create the pages by running `wyam.exe -r Blog -t CleanBlog`, and to create and be able to view
the pages you can execute `wyam -r Blog -t CleanBlog -p`. These commands assume that you store
your blog source in the `input` directory and that the website pages should be placed in the
`output` directory. This however is where the build engineer in me started making
disapproving sounds so I changed the input and output folders by specifying the appropriate command line
parameters to make it happy again

    wyam.exe --input src --output build\site -r Blog -t CleanBlog -p

Good that is much more inline with the standard paths used by [nBuildKit](/projects/nbuildkit).
Another change that needs to be made is where Wyam stores the NuGet packages. Normally Wyam stores
those in a global location, however I strongly feel that builds should always only write to their
local workspaces, so lets redirect the packages to a folder that is local to the workspaces

    wyam.exe --input src --output build\site --use-local-packages --packages-path packages -r Blog -t CleanBlog -p

That command line is getting longer but we can make it shorter again by moving some of the
standard items into the [Wyam configuration file](https://wyam.io/docs/usage/configuration), so
I created a `config.wyam` file in the root of the workspace and added the following lines

    // Preprocessor directives
    #recipe Blog
    #theme CleanBlog

And with this the command line to generate the website and start a local webserver is

    wyam.exe --input src --output build\site --use-local-packages --packages-path packages


### Moving the existing content

Moving the existing content from the Docpad generated site to the Wyam generated site required a bit
of work although the initial results were quite easy to achieve. I started off moving the
post files to the `posts` directory and updating all the files to be named so that Wyam is able
to extract the date and time from the file name. In order for that to work Wyam wants the file
name to follow the naming convention `<YEAR>-<MONTH>-<DAY>-<TITLE>.md`.

The next step was to update the front matter in the post files. Wyam would like to see the
following format:

    Title: <POST_TITLE_GOES_HERE>
    Tags:
      - <TAG_1>
      - <TAG_2>

With this done Wyam can generate a website with blog posts with the correct titles and dates. This
is a good start. Next are the non-post pages, like the [home page](/) and the [project pages](/projects).
These can simply be dropped in the desired directory. Wyam will automatically generate HTML pages
from any Markdown file and simply copy the other files (like the favicon etc.). Any non-blog post
pages will show up in the menu bar so for all pages that should not show up in the menu bar you can
add the `ShowInNavBar: false` entry in the page front matter like so:

    Title: My page that shouldn't show up in the NavBar
    ShowInNavBar: false
    ---
    # Content

Once that was done I created [overrides](https://wyam.io/recipes/blog/themes) for

- The page and post footers by creating the `_Footer.cshml` and `_PostFooter.cshtml` files. The page
  footer was straight forward but the post footer required some additional work to get the links
  to the previous and next post to function correctly. Fortunately [Dave Glick](https://daveaglick.com/)
  was very helpful on the [gitter](https://gitter.im/Wyamio/Wyam) page for Wyam and pointed out
  that there are collections that you can iterate over to find out what the previous and
  next posts are.

<script src="https://gist.github.com/pvandervelde/d2825f2c5d67ab30d15ce179ced4b30f.js"></script>

- The sidebar which contains my little 'about me' blurp.
- The navbar which by default orders pages alphabetically and does not contain a link to the home page.
  In my Docpad blog both those things are not true, so I did a bit of Razor coding and generated the
  navbar items myself

<script src="https://gist.github.com/pvandervelde/7645c478ae08c94d3716ca8e8ad41c4c.js"></script>

These changes got most of the pages looking pretty close to what they should be, but yet not quite
the same as it was.


### Tweaking

If you don't have an existing layout for your blog or you don't mind changing the layout then
after the previous steps you should have a very nice looking blog that works just fine. However it
turns out I'm stuborn and specific in the way I want things to look. In this case I wanted my blog
to not look any different than the existing one does, at least for the time being. So that meant
I had to do a fair amount of tweaking.

The first major tweak was to get the sidebar looking like it should. This turned out to be a little
harder than I expected because it required overriding the `_Layout.cshtml` page. While this is a
bigger step than the other overrides it also meant I was able to make the pages look exactly like
I wanted and I was able to re-use my CSS files.

<script src="https://gist.github.com/pvandervelde/5e3520e0f150176f529b1972fc2042a7.js"></script>

One of the more tricky parts was to generate a list of the last 10 posts. Originally I was using
the list of posts, however because this is the layout page that is used for all pages it might
well be that some pages are generated before the full post list is available (say hello to the
[tags](/tags) pages). Once again Dave Glick came through and pointed me to the [RawPosts](https://wyam.io/recipes/blog/pipelines)
collection which is generated right at the beginning of the cycle.

Once the issues with the sidebar were resolved the next step was to show the last five blog posts
on the home page. By default Wyam will place excepts on the home page with a link to the actual post
in the post title. However what I wanted was the full post, excluding the comment section. Once again
the `RawPosts` collection came to the rescue which allowed me to iterate over the last five posts
and get their pre-rendered content.

<script src="https://gist.github.com/pvandervelde/d0d83eb2c636a5d3b63b5bf0cce6029c.js"></script>

Some additional hacking also allowed me to reuse the `_PostHeader.cshtml` file for both the posts
on the home page, for which the title links to the actual post page, and for the post page in which
the title is just a header.

<script src="https://gist.github.com/pvandervelde/465c0a2399f135a25e656b0d15c1866a.js"></script>

With these changes the blog looks (almost) exactly like it used to look except that it is now
being generated by [Wyam](https://wyam.io). All in all I have to say I'm pretty happy with the result
and with how easy it was to move from Docpad to Wyam. And as a bonus I understand much more of
how Wyam works and how my own blog is generated.
