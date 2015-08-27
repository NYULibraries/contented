# library.nyu.edu
NYU Libraries website powered by [Siteleaf](http://www.siteleaf.com) with Jekyll support for offline development.

A build of this site can be previewed at: http://dev.nyu.oakmade.com

## Building JS and watching for changes

Install [Grunt](http://gruntjs.com):

```
npm install -g grunt-cli
```

Install project dependencies:

```
npm install
```

Run Grunt:

```
grunt
```

## Develop offline with Jekyll

Install gems:

```
bundle install
```

Start server:

```
jekyll serve --port 9292
```

Visit in browser:

<http://localhost:9292>

# Stylesheets

## Sass

We're using [Sass](http://sass-lang.com) as our stylesheet language. We're using the SCSS syntax which is closer to CSS and hopefully easier to pickup than most other stylesheet scripting languages.

`.scss` files should be added to the `assets/css/` directory. These will be [compiled by Jekyll](http://jekyllrb.com/docs/assets/) to `.css` and added to the same directory within the generated site. Sass partials should be added to the `_sass/` directory and will be excluded from the built site.

## Naming convention

We're using the [Block, Element, Modifier methodology](https://css-tricks.com/bem-101/) (commonly referred to as BEM)

Example:

```css
/* Block component */
.button {}

/* Element that depends upon the block */
.button__price {}

/* Modifier that changes the style of the block */
.button--orange {}
.button--big {}
```
