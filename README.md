# NYU Division of Libraries Web Presence

[![NYU](https://github.com/NYULibraries/nyulibraries-assets/blob/master/lib/assets/images/nyu.png)](https://dev.library.nyu.edu)
[![Build Status](https://travis-ci.org/NYULibraries/library.nyu.edu.svg)](https://travis-ci.org/NYULibraries/library.nyu.edu)
[![Dependency Status](https://gemnasium.com/NYULibraries/library.nyu.edu.svg)](https://gemnasium.com/NYULibraries/library.nyu.edu)
[![Code Climate](https://codeclimate.com/github/NYULibraries/library.nyu.edu/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/library.nyu.edu)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/library.nyu.edu/badge.svg?branch=development&service=github)](https://coveralls.io/github/NYULibraries/library.nyu.edu?branch=development)

Home for the assets and templates for the NYU Division of Libraries [Siteleaf](http://www.siteleaf.com/) website to replace [http://library.nyu.edu](http://library.nyu.edu).

## Siteleaf

The website uses Siteleaf as its CMS, where access can be controlled, content can be written in Markdown or plain text, and the static pages generated can be hosted in the cloud. Publishing these pages to GitHub allows us to use our established practice of coding in the open and using continuous integration and rapid deployment.

## Templates

We are in the process of developing the [Liquid templates](https://github.com/Shopify/liquid) necessary for translating our style guide into an active design.

### Resources

- http://www.siteleaf.com/help/themes/
- https://gist.github.com/sskylar

## Assets

Before pushing our style and javascript assets up to our Siteleaf theme we can automate the process of precompiling since we use [a custom Compass plugin](https://github.com/NYULibraries/nyulibraries-assets) to manage our global assets.

### Resources

- Style Guide: http://nyulibraries.github.io/library.nyu.edu/

## Wiki

[Read our wiki](https://github.com/NYULibraries/library.nyu.edu/wiki), for more information on this project.

Automates Siteleaf by adding NYU assets after converting them using Microservice-precompiler


## How to feed data into library.nyu.edu

Create a file called `secret_study.yml` in the root folder of this project.

Inside that file add this line ```GOOGLE_SHEET_KEY : '<Sheet_key>'```

Replace ```<Sheet_key>``` with the google sheet key that is found in the URL.

## Siteleaf Authentication

In the above mentioned `secret_study.yml` create 3 different Environment Variables namely :

1. ```api_key```        : Key can be found on siteleaf site in Account
2. ```api_secret```     : Secret can be found on siteleaf site in Account
3. ```site_id```        : Site ID can be found in the URL of a particular site.


## Capistrano Tasks

    cap convert:sheet_to_md:all          # Converts all worksheets to Markdown and places them in their respective directory

    cap convert:sheet_to_md:departments  # Converts departments worksheet to Markdown and places them in their respective directory

    cap convert:sheet_to_md:locations    # Converts locations worksheet to Markdown and places them in their respective directory

    cap convert:sheet_to_md:people       # Converts people worksheet to Markdown and places them in their respective directory

    cap convert:sheet_to_md:services     # Converts services worksheet to Markdown and places them in their respective directory

    cap convert:sheet_to_md:spaces       # Converts spaces worksheet to Markdown and places them in their respective directory

    cap deploy:compile_js_sass           # Compile Javascript and Sass from assets Folder to dist folder

    cap deploy:init                      # Initialize Deploy for library.nyu.edu

    cap siteleaf:auth                    # Authenticate Siteleaf using ENV Variables in .siteleaf.yml files

    cap siteleaf:clean_up                # Cleans up the site directory

    cap siteleaf:push_all                # Push all theme files alongwith Markdown collections to Siteleaf after converting them from worksheet to markdown

    cap siteleaf:push_only_people        # Push only people markdown files


## Rake Tasks for library.nyu.edu-data

    rake rubocop               # Run RuboCop

    rake rubocop:auto_correct  # Auto-correct RuboCop offenses

    rake spec                  # Run Rspec

