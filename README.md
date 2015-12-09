# Contented

[![NYU](https://github.com/NYULibraries/nyulibraries-assets/blob/master/lib/assets/images/nyu.png)](https://dev.library.nyu.edu)
[![Build Status](https://travis-ci.org/NYULibraries/contented.svg)](https://travis-ci.org/NYULibraries/contented)
[![Dependency Status](https://gemnasium.com/NYULibraries/contented.svg)](https://gemnasium.com/NYULibraries/contented)
[![Code Climate](https://codeclimate.com/github/NYULibraries/contented/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/contented)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/contented/badge.svg?branch=development&service=github)](https://coveralls.io/github/NYULibraries/contented?branch=development)

These are happy little content conversions!

This repository handles all the content conversions from various sources (JSON APIs, Google Spreadsheets, etc.) and the conversion to Jekyll style markdowns with YAML frontmatter which we then use for Siteleaf.

## Install

In your Gemfile

```ruby
gem 'contented', github: "NYULibraries/contented"
```

Then run:

```shell
$ bundle install
```


## Rake

```shell
$ bundle exec rake
```
