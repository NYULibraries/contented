# Contented

[![NYU](https://github.com/NYULibraries/nyulibraries-assets/blob/master/lib/assets/images/nyu.png)](https://dev.library.nyu.edu)
[![Build Status](https://travis-ci.org/NYULibraries/contented.svg)](https://travis-ci.org/NYULibraries/contented)
[![Dependency Status](https://gemnasium.com/NYULibraries/contented.svg)](https://gemnasium.com/NYULibraries/contented)
[![Code Climate](https://codeclimate.com/github/NYULibraries/contented/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/contented)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/contented/badge.svg?branch=development&service=github)](https://coveralls.io/github/NYULibraries/contented?branch=development)

These are happy little content conversions!

This repository handles all the content gathering from various sources (JSON APIs, Google Spreadsheets, etc.) and the conversion to Jekyll style markdowns which get synced via [library.nyu.edu repos](http://github.com/nyulibraries/library.nyu.edu) to Siteleaf.

## Wiki

[Read our wiki](https://github.com/NYULibraries/contented/wiki), for more information on this project.

## How to feed data into library.nyu.edu _(Needs updating)_

Create a file called `secret_study.yml` in the root folder of this project.

Inside that file add this line ```GOOGLE_SHEET_KEY : '<Sheet_key>'```

Replace ```<Sheet_key>``` with the google sheet key that is found in the URL.

## Siteleaf Authentication _(Needs updating)_

In the above mentioned `secret_study.yml` create 3 different Environment Variables namely :

1. ```api_key```        : Key can be found on siteleaf site in Account
2. ```api_secret```     : Secret can be found on siteleaf site in Account
3. ```site_id```        : Site ID can be found in the URL of a particular site.


## Capistrano Tasks _(Needs updating)_

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


## Rake Tasks for library.nyu.edu-data _(Needs updating)_

    rake rubocop               # Run RuboCop

    rake rubocop:auto_correct  # Auto-correct RuboCop offenses

    rake spec                  # Run Rspec
