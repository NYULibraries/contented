# Contented

[![NYU](https://github.com/NYULibraries/nyulibraries-assets/blob/master/lib/assets/images/nyu.png)](https://dev.library.nyu.edu)
[![Build Status](https://travis-ci.org/NYULibraries/contented.svg)](https://travis-ci.org/NYULibraries/contented)
[![Dependency Status](https://gemnasium.com/NYULibraries/contented.svg)](https://gemnasium.com/NYULibraries/contented)
[![Code Climate](https://codeclimate.com/github/NYULibraries/contented/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/contented)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/contented/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/contented?branch=master)

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

Reindex people in libraries project:

```shell
$ bundle exec rake contented:reindex:people
```

You may specify a base URL with which to generate URLs for indexing, e.g.:

```shell
$ bundle exec rake contented:reindex:people[http://beta.library.nyu.edu/people]
```

The specified base URL must include the protocol (http vs https). The protocol must match the protocol of the URL as originally indexed (if accessible via both protocols). Otherwise, Swiftype apparently processes it as a new document (indicated in the verbose output of the rake task) then identifies it as duplicate, causing it to silently ignore the reindex request. (This is observed not documented behavior.)

### Cucumber tests

These tasks must be executed within the contented project. To run specify a domain:

```
bundle exec rake features DOMAIN=http://localhost:9292
```

To run tests for a specific collection:

```
bundle exec rake features:about DOMAIN=http://localhost:9292
bundle exec rake features:departments DOMAIN=http://localhost:9292
bundle exec rake features:locations DOMAIN=http://localhost:9292
bundle exec rake features:people DOMAIN=http://localhost:9292
bundle exec rake features:services DOMAIN=http://localhost:9292
```
