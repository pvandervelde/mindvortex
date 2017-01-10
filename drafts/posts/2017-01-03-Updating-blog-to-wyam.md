Title: Updating my blog to Wyam
Tags:
  - Blog
---
Changing blog to Wyam

Goals is to restart my blog. One issue is that using Docpad is prone to errors when you're on a windows machine. That and I don't like NPM / node very much
because there's too much stuffing around (file path length anyone?). So switching over to a different static generator.

Also want to fully automate the generation and publishing process

## Getting started

* downloaded [wyam](https://wyam.io/)
* Generate a skeleton directory / file structure with `wyam.exe new --recipe Blog`. That generates an input folder which contains all the source files
* Generate pages with

        wyam.exe -r Blog -t CleanBlog

* That generates the output folder which contains the generated blog. Can view it if you add the `-p` command line option to the generation process


## Build kinda stuff

* Create the config file and make it always generate a blog with the specific theme (unlikely to change on the commandline)

        // Preprocessor directives
        #recipe Blog
        #theme CleanBlog

* Now we can generate the blog with `wyam.exe`
* Now change where the inputs and outputs are. I'm a software engineer, `input` and `output` just doesn't quite cut it. So:

        wyam.exe --input src --output build\site

* Then redirect the nuget packages to be stored in the local folder. Builds should always only write to their local folders so that they can be independent, hence

        wyam.exe --input src --output build\site --use-local-packages --packages-path packages



## Moving the existing content

* Move posts to the new structure
* Rename post files to follow the naming convention: `<YEAR>-<MONTH>-<DAY>-<TITLE>.md`
* Update the post front matter to have the correct layout. Wyam would like to see the following format:

        Title: <POST_TITLE_GOES_HERE>
        Tags:
          - <TAG_1>
          - <TAG_2>

* Add the non-blog post pages. If you add them to the `input`/`src` directory they're taken as is and by default will end up in the NavBar. You can add pages
  that shouldn't end up in the NavBar by adding the `ShowInNavBar: false` entry in the page front matter like so:

        Title: My page that shouldn't show up in the NavBar
        ShowInNavBar: false
        ---
        # Content

* Add [overrides](https://wyam.io/recipes/blog/themes) for page footer and post footer
* Add overrides for the post header and footer and the post layout
* Add override for the sidebar

That got most of the pages looking decent, but not quite the same as it was.

## Blog specific changes

I wanted my blog to not look any different than the existing one does (and ideally keep the links if we can) for the time being. That means we'll have to
do quite a bit of work because the processing pipeline in Docpad is different than the one in Wyam.

* Create an override for the layout page (`_Layout.cshtml`). That way you can make the page look the way you want it. For me that meant I could
  re-use the existing CSS
* Updating the sidebar and the page header and footer gave me roughly what I wanted

Then we ran into two 'minor' issues:

1) I wanted the home page to display the first 5 posts completely but couldn't figure out how to do that so I thought I could just use the except and Then
  provide a link to the full page. Unfortunately the way Wyam handles the pipelines means that the exerpt is obtained from the rendered page which contains
  the side bar. And thus all my posts ended up being my side bar picture. Not great
2) I wanted the side bar to display the last 10 or so posts, but when the side bar is generated the list of posts doesn't exist, that leads to exceptions and
  Wyam crashing.

