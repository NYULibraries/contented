# Contented

[![CircleCI](https://circleci.com/gh/NYULibraries/contented.svg?style=svg)](https://circleci.com/gh/NYULibraries/contented)
[![Dependency Status](https://gemnasium.com/NYULibraries/contented.svg)](https://gemnasium.com/NYULibraries/contented)
[![Code Climate](https://codeclimate.com/github/NYULibraries/contented/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/contented)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/contented/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/contented?branch=master)

Contented is a library of auxiliary functionality for the [NYU Division of Libraries website](/NYULibraries/library.nyu.edu).

## What does contented do?

### Automated integration tests

In the [`features`](features) folder we maintain cucumber integration tests to make sure core functionality isn't affected by any changes to either the code or the content.

Read our automated testing page on the wiki for more info.

### Automatic content creation

Content for the Libraries website needs to be delivered to Jekyll in Markdown format, however, there are a number of sources from where we get the data, these include GatherContent, XML Feeds, etc.

Read our content conversion page on the wiki for more info.

### Reindexing of content

When we create the content from external sources and push it to the site, the indexing service ([Swiftype](https://swiftype.com/documentation/overview)) will take up to three days to fully reindex all the content. However, the APIs do allow for manual crawls and when we create pages manually we know which pages need to be recrawled. The tasks for launching that recrawl are also housed in this repository.

Read our reindexing page on the wiki for more info.

## Install

In your Gemfile

```ruby
gem 'contented', github: "NYULibraries/contented"
```

Then run:

```shell
$ bundle install
```

## Running rspec

```shell
$ bundle exec rake
```
