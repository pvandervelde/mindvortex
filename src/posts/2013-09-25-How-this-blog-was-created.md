Title: How this blog was created
Tags:
  - Blog
  - DocPad
  - GitHub
---

A long time ago, in a location far, far, far away there was a hero in search for a quest ...

And he searched ...

And he searched ....

And .. oh never mind, our hero he is not the object of this current post, thus we shall be leaving
him in some weird limbo looking for his quest... oh well. The topic of this post is how this blog /
website was build. It turns out that building anything in HTML, CSS, Node.js and all the other cool
web technologies isn't really my strong suit. However I'm hoping that the description of how I build
this site may be useful to somebody at some point in time, if only to have a good laugh at my lack of
CSS skills.

As much as I love writing code, the idea of writing my content in an angle bracket language didn't
really attract me so the plan was hatched (it came out of a purple egg, by the way) to write (nearly)
all content in [Markdown](https://daringfireball.net/projects/markdown/) by using [Docpad](https://docpad.org).
Given that I've recently started using [GitHub](https://github.com) for my open source projects why
not use it for version control and GitHub pages to serve my website.

I won't bore you with the details on how to install Docpad, the Docpad website has an excellent
introduction to all those things. Once the initial install is done Docpad allows you to create a
skeleton website by executing the following command

``` dos
Docpad run
```

At which point Docpad presents a list of possible skeletons to use. In my case I selected the
[HTML5 boilerplate template](http://html5boilerplate.com/). In order to get a nice layout quickly I
also used the [Open tools](http://www.freecsstemplates.org/previews/opentools/) template.

Once I had the basic site layout sorted it was time to focus creating my own sections. Fortunately
Docpad has a large number of plugins that provide useful additions to the generation process. For
the generation of this site the following plugins are used:

- [datefromfilename](https://github.com/grassator/docpad-plugin-datefromfilename) - Extracts the date
  of a post from the file name.
- [gist](https://docpad.org/plugin/gist/) - Adds [GitHub gists](https://gist.github.com/) to a page.
- [highlightjs](https://docpad.org/plugin/highlightjs/) - Provides syntax highlighting for code samples.
  My current plan is to use this for the smaller samples and use GitHub gists for the larger ones.
- [navlinks](https://github.com/lucor/docpad-plugin-navlinks) - Adds navigation links to the bottom
  of each post, pointing at the previous and next post.
- [related](https://docpad.org/plugin/related/) - Allows you to find all related documents based on a
  given set of tags.
- [tagging](https://github.com/rantecki/docpad-plugin-tagging) - Generates the tag cloud for the sidebar.

With all the toys sorted it was time to integrate them in the templates.


### Menu

The top level menu is based on a collection which contains all pages that have their `isPage` flag
set to `true`. Note that we also assume that these pages have the default layout. One thing to note
is that the docpad.coffee configuration file seems to be sensitive to the type of whitespace you use.
Either use spaces or tabs, but don't mix them, otherwise you may get some weird errors.

<script src="https://gist.github.com/pvandervelde/6375681.js?file=collections.pages.docpad.coffee"></script>

Once the collection has been filled with pages it is used to create an unordered list with an
additional highlight placed on the currently active page

<script src="https://gist.github.com/pvandervelde/6375681.js?file=menu.default.html"></script>


### Sidebar

The sidebar contains three different sections. The first section is the about section which is
nothing special. The _recent_ and _tags_ sections are more interesting from a website construction
perspective. The _recent_ section based on the _frontpage_ collection which grabs all items from the
posts and projects subdirectories and then sorts them by date. The _recent_ section only display the
last 10 items in that collection.

<script src="https://gist.github.com/pvandervelde/6375681.js?file=recent.default.html"></script>

The _tags_ section is based on a collection provided by the tagging plugin. The font-size of the
tag is based on the weight assigned to the tag by the tagging plugin.

<script src="https://gist.github.com/pvandervelde/6375681.js?file=tags.default.html"></script>

Each tag links to a page that contains all the posts that contain that tag.


### Projects, tag indexes and posts

The project pages all have a shared layout which provides them with a title and a section that lists
all the posts tagged with the name of the project

<script src="https://gist.github.com/pvandervelde/6375681.js?file=project-linkedposts.html"></script>

Posts are displayed in three different places:

- The home page
- The tag index page, containing all posts with a given tag
- The post page

All pages use the same partial layout file in order to display the post.

<script src="https://gist.github.com/pvandervelde/6375681.js?file=post-content.html"></script>

The only difference between the post page and the other pages is that the post page will display all
the comments. The comment system is based on
[comments on a GitHub issue](http://ivanzuzak.info/2011/02/18/github-hosted-comments-for-github-hosted-blogs.html)
and uses a small amount of JavaScript to pull the comments across into the comment list.

<script src="https://gist.github.com/pvandervelde/6375681.js?file=post.html"></script>


### Acknowledgements

Finally there some people that have provided some descriptions of how their own blogs were created
with Docpad (or other static generators). Below are the posts that I used to assemble my own blog.
A big thank you to the original posters!

- [Ivan Zuzak](http://ivanzuzak.info/2011/02/18/github-hosted-comments-for-github-hosted-blogs.html)
  for his post describing how to use GitHub issues as a way to provide comments on a blog post.
- [takitapart](http://takitapart.com) provided an [excellent](http://takitapart.com/posts/organizing-docpad/)
  post describing how to organise content in a Docpad website.
- [Luca's forge](http://lucor.github.io) provided a good start to using Docpad in his
  [migration](http://lucor.github.io/post/migrating-from-octopress-to-docpad/) post. This site also
  provides some very nice ideas around the way posts and tags should look.
- [Ben Delarre](http://www.delarre.net) provided a nice
  [summary](http://www.delarre.net/posts/blogging-with-docpad/) of his own Docpad setup.
