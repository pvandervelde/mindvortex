---
title: 'Adding pagination with DocPad'
tags: ['Blog', 'DocPad']
commentIssueId: 45
---

Last year when I started this blog I decided to keep the layout as simple as possible, hence all the posts were just added to the home page and to their own page. Over time as more posts were written the home page got larger and larger making it slower to load and more difficult to navigate. In order to improve this [pagination](https://github.com/pvandervelde/mindvortex/commit/9472ad503725eb42d98e30b6c4452d2b6766b344) of the home page was introduced.

Once again [DocPad](http://docpad.org/) makes this very easy because all you have to do is add the [DocPad-paged](https://github.com/docpad/docpad-plugin-paged) plugin and then update the documents you want to split. In the case of this blog only the index page needed to be split. The new index page now looks like this:

<gist>26f698e7c7099033188f</gist>

In order to make the paged plugin do its work the following 'properties' were added to the header:

* **isPaged** - Indicates that the document should be broken up into multiple pages.
* **pageCollection** - The collection from which the sub-documents that will fill up the current page are taken.
* **pageSize** - The number of sub-documents per page

Finally two buttons were added to the bottom of the page to naviage to he newer and the older posts.