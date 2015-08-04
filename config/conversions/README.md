# Sample data for library.nyu.edu

Data should be exported into Markdown format with YAML frontmatter for metadata (Jekyll-compatible format). 

## Data format

An example has been provided for each model:

- [Departments](https://github.com/oakstudios/library.nyu.edu-sampledata/blob/master/_departments/_example.markdown)
- [Locations](https://github.com/oakstudios/library.nyu.edu-sampledata/blob/master/_locations/_example.markdown)
- [People](https://github.com/oakstudios/library.nyu.edu-sampledata/blob/master/_people/_example.markdown)
- [Services](https://github.com/oakstudios/library.nyu.edu-sampledata/blob/master/_services/_example.markdown)
- [Spaces](https://github.com/oakstudios/library.nyu.edu-sampledata/blob/master/_spaces/_example.markdown)

All fields are optional (except `title`).

## Naming files

Data should be exported using a filename relating to its full `title` ([slugified](https://gist.github.com/sskylar/71acc499965d283e4785)) within its appropriate folder (e.g. `_departments`). This filename will be used as the item's `slug`. All files should be in `.markdown` format.

Example:

**_departments/data-services.markdown**
```
---
title: Data Services
---
```

This would result in a slug of: `data-services`

Which would publish with a URL of: `/departments/data-services`

## Relational data

When referencing a related item, use its full `title` name. 

As an example, here's how we can relate "Data Services" (a `service`) to "Elmer Holmes Bobst Library" (a `location`).

**_locations/elmer-holmes-bobst-library.markdown**
```
---
title: Elmer Holmes Bobst Library
---
```

**_services/data-services.markdown**
```
---
title: Data Services
location: Elmer Holmes Bobst Library
---
```

The following relationships can exist:

- Departments:
  - `location` (which building this department is based)
  - `space` (which room this department is located, if applies)
- People:
  - `departments` (which departments they work in)
  - `location` (which building this person works)
  - `space` (which room this person is located, if applies)
- Spaces:
  - `location` (which building this space is in)
- Services:
  - `departments` (which departments they work in)
  - `location` (which building this service is available in)
  - `space` (which room this service is located, if applies)

## Link lists

Links can be defined using the following name/url format on `links`, `buttons`, and `classes`:

```YAML
links:
  Example: "http://example.org"
  Get Help: "http://answers.nyu.edu/search.php?question=sample+service"
```

## Feeds

RSS feeds can be defined using the following format for `blog`, `guides`, and `publications`:

```YAML
blog:
  title: "Latest News" #optional
  rss: "https://en.wikipedia.org/w/index.php?title=Special:NewPages&feed=rss"
  link: "http://example.org" #optional
```

When provided, `link` is used to show a "See more" button.

## Assets

All items can contain an `image` (remote or relative):

```YAML
image: "https://placeimg.com/540/540/any"
```

Any relative images should be saved in this repo.

Recommended size: 270 px x 2 DPR (retina) = **540 px square**

## Notes

- `---` should always be on line 1
- Never use tab character (use 2 spaces instead)
- Special characters like `#` or `:` should be escaped in quotes (you can use quotes everywhere if you want)
  - `address: "Room #511"`
  - `job_title: "Assistant Curator: Life Sciences Librarian"`
- `type` should only contain 1 value (Locations)
- `blog` should only contain 1 value, include additional links under `links`
- `email` and `phone` should only contain 1 value each
- `twitter` and `facebook` should only contain username (only 1 value each). Do not include url or `@`.
- All YAML should validate:
  - manually: http://yaml-online-parser.appspot.com
  - programatically: http://ruby-doc.org/stdlib-2.2.2/libdoc/yaml/rdoc/YAML.html
- Filename should be full `title` slugified (e.g. "Room #511" = "room-511.markdown")
  - sample code: https://gist.github.com/sskylar/71acc499965d283e4785
  - for long Location names, make sure to use `title` (exclude `subtitle`)
- First header in body should genarally be an `<h1>` (single `#`)
- Always use `"straight"` quotes in YAML, never `“curly”` quotes
- Arrays must always have a space after the `-` character (e.g. `- item`)
