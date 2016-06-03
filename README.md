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

These tasks must be executed within the contented project. To run against an arbitrary domain:

```
bundle exec rake features:all DOMAIN=https://example.com
```

To run tests against the beta site:

```
bundle exec rake features:all:beta
```

To run tests against the local Jekyll server (must be started manually from within the libraries project):

```
bundle exec rake features:all:local
```

To run tests for a specific collection, replace `all` with the collection name, e.g.:

```
bundle exec rake features:locations DOMAIN=https://example.com
bundle exec rake features:people:beta
bundle exec rake features:departments:local
```

To benchmark which step definitions consume the most time:

```
bundle exec rake features:benchmark:beta
bundle exec rake features:benchmark:local
```
