# Emcee

Emcee is an extension to the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).
It allows you to import and package [web components](http://www.w3.org/TR/components-intro/) exactly as
you would Javascript or CSS.

## Table of contents

* [Installation](#installation)
* [Usage](#usage)
* [Bower](#bower)
* [Sass](#sass)
* [Concatenation](#concatenation)
* [Testing](#testing)
* [Contributing](#contributing)
* [Special thanks](#special-thanks)

## Installation

Add Emcee to your Gemfile:

    gem 'emcee'

and then execute:

    $ bundle install

Finally, run:

    $ rails generate emcee:install

This will insert `<%= html_import_tag "application" %>` into your application layout. Also,
it will create 'components' directories under '/assets' and '/vendor/assets'.

## Usage

Once installed, you will have a manifest file located at `/assets/components/application.html`.
Use [sprockets directives](https://github.com/sstephenson/sprockets#sprockets-directives) to
include web components located in one of the assets directories.

When referencing web components, you must point to an html file, not a directory. For example,
if you have a sub-directory like this:
```
vendor
|- assets
  |- components
    |- ui-tabs
       |- ui-tabs.html
```
You must reference this in the manifest file as:
```
*= require ui-tabs/ui-tabs
```

## Bower

When installed, Emcee configures [Bower](http://bower.io/) to install components
to `vendor/assets/components`. Anything installed with bower can be referenced
directly in your `application.js`, `application.css`, or `application.html` manifest
files.

## Sass

Emcee can use [Sass](http://sass-lang.com/) to precompile references to external
stylesheets. To do this, reference the stylesheet with the regular `.css` extension
in your web component:

```html
<link rel="stylesheet" href="path/to/example.css">
```

If you have an `example.css.scss` at that path, it will be compiled before being
used by your web component.

## Concatenation

In a development environment, all web components referenced in the manifest will be included
in the application as seperate html imports. Importing web components `a.html`, `b.html`, and
`c.html` will result in:
```html
<link rel="import" href="a.html">
<link rel="import" href="b.html">
<link rel="import" href="c.html">
```

In production, they will be concatenated into one import, and will have comments and blank lines
removed.
```html
<link rel="import" href="application-908e25f4bf641868d8683022a5b62f54.html">
```
Notice the fingerprint hash appended to the file name. This depends on the contents of the included
web components, and allows proper caching and cache-busting.

## Testing

To run the tests, simply run `rake test`.

## Contributing

1. Fork it
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## Special Thanks

Special thanks to the [Polymer Project](http://www.polymer-project.org/), which Emcee
was designed to work with. They've designed an amazing piece of technology that
will change how web apps are made.
