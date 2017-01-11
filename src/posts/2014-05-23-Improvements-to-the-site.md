Title: Improvements to the site
Tags:
  - Blog
---

Over the last few days some changes were made to the structure of this website. Of these changes the
first change that was made is in the move from the standard GitHub pages URL to my own custom domain
provided by the amazingly helpful people at [dnsimple](https://dnsimple.com/). While the URL for this
website has changed it is still being hosted by GitHub pages and so the old URL will continue working
just fine.

The only slight catch is that the project pages for my projects now suddenly redirect through my new
domain as well. Apparently this is due to the way GitHub [handles](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages#overview)
custom domains. For now I will live with this situation but later on my personal projects may be
moved to separate [organisations](https://help.github.com/articles/what-s-the-difference-between-user-and-organization-accounts).

The second change is the addition of pagination for the landing page. As I continued to write more
blog posts this page was getting rather long and slow to load. The new landing page only contains the
last five blog posts and provides a way to navigate to the previous posts at the bottom of the page.
This should make the page much quicker to load. I will share the implementation of the pagination in
a future blog post but for those who are interested the changes necessary to implement pagination in
[DocPad](https://github.com/docpad/docpad-plugin-paged/) are pretty minor and can be seen in a single
[commit](https://github.com/pvandervelde/mindvortex/commit/9472ad503725eb42d98e30b6c4452d2b6766b344).

Besides setting up the pagination of the landing page I also created an [archive](/archive.html)
page which, logically, shows all the blog posts in chronological order. Again a future blog post will
describe the necessary changes to include the archive page.

Last but not least the site has gotten a new [favicon](http://en.wikipedia.org/wiki/Favicon) which is
a little more vortex-y than the last icon.
