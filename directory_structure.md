# Directory Structure

This document is just a readme file to outline the directory structure for github and siteleaf repo. They both have to be in exact sync.

Github is main version control. The siteleaf theme will only be a copy of what's on github. Hence adding a file or folder to github will not guarantee that it'll be ported back to github. Onlu forward integration no reverse integration.

## Basic directory structure on Siteleaf

Folder Structure:
  - _includes:
    - folder/file (Must have .html or .liquid)
  - _styles:
    - folder/file (Must have .css)
  - _javascript:
    - folder/file (Must have .js or even .min.js)
  - images
  - default.html
  - .siteleafignore


## Basic directory structure on Github

Folder Structure:
  - _includes:
    - folder/file (Must have .html or .liquid)
  - _styles:
    - folder/file (Must have .scss)
  - _scripts:
    - folder/file (Must have .coffee)
  - images
  - default.html
  - .gitignore
  - .siteleafignore
