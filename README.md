# NYU Division of Libraries Web Presence

_[A work in progress]_

[![Build Status](https://travis-ci.org/NYULibraries/library.nyu.edu.svg)](https://travis-ci.org/NYULibraries/library.nyu.edu)
[![Dependency Status](https://gemnasium.com/NYULibraries/library.nyu.edu.svg)](https://gemnasium.com/NYULibraries/library.nyu.edu)
[![Code Climate](https://codeclimate.com/github/NYULibraries/library.nyu.edu/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/library.nyu.edu)
[![Issues](http://img.shields.io/github/issues/NYULibraries/library.nyu.edu.svg?style=flat-square)](http://github.com/NYULibraries/library.nyu.edu/issues)

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

# Running

First authenticate yourself on siteleaf

  siteleaf auth

second change the name of your website on siteleaf config <name> command

## Run all

  cap siteleaf:deploy        # Runs all tasks to setup the webbsite

## Capistrano tasks


    cap compile:all           # Compilation and coversion of the code (css to sass conversion , coffee to js conversion and liquid compilation )

    cap siteleaf:empty_theme  # Empty out siteleaf theme completely

    cap siteleaf:setup        # sets up the config.ru which contains site id required for siteleaf commands it is equivalent to siteleaf config.

    cap siteleaf:push_theme   # pushes the entire theme i.e. application.js , application.css and liquid html files to siteleaf.

    cap siteleaf:clean_up     # cleans up the working directory of all the js and css files pushed to siteleaf.