---
title: 'Blog archives by DocPad'
tags: ['Blog', 'DocPad']
commentIssueId: 44
---

A while ago I decided that it was time to add an [archive](/archives.html) page to the website so that there would be a place to get a quick overview of all the posts that I have written. Fortunately setting up an archive page with [DocPad](http://docpad.org/) is relatively simple.  

The first step to take was to add a new layout for the archive page.

<gist>b7434bc8a1b7eb240da9</gist>

The layout gets the list of all posts and iterates over them in chronological order. All the posts for one year are grouped together under a header titled after the year. In keeping with the layout of the rest of the site each post gets a title, the day and month and the tags that belong to that post. In order for this specific layout to work you will need to add the `moment` node.js package

The layout and the CSS for the archive page is heavily based on the layout created by [John Ptacek](http://www.jptacek.com/).